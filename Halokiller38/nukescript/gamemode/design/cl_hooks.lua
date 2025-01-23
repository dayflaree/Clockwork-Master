--[[
Name: "cl_hooks.lua".
Product: "Day One".
--]]

-- Called when the menu's items should be destroyed.
function DESIGN:MenuItemsDestroy(menuItems)
	if ( !blueprint.player.HasFlags(g_LocalPlayer, "T") ) then
		menuItems:Destroy( blueprint.design.GetOption("name_business") );
	end;
end;

-- Called when the local player's item functions should be adjusted.
function DESIGN:PlayerAdjustItemFunctions(itemTable, itemFunctions)
	if ( blueprint.player.HasFlags(g_LocalPlayer, "T") ) then
		if (itemTable.cost) then
			itemFunctions[#itemFunctions + 1] = "Cash";
		end;
	end;
end;

-- Called when the local player's character screen faction is needed.
function DESIGN:GetPlayerCharacterScreenFaction(character)
	if (character.customClass and character.customClass != "") then
		return character.customClass;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function DESIGN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = blueprint.design.GetColor("target_id");
	local colorWhite = blueprint.design.GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		local physDesc = entity:GetNetworkedString("sh_PhysDesc");
		
		if (physDesc != "") then
			info.y = BLUEPRINT:DrawInfo(physDesc, info.x, info.y, colorWhite, info.alpha);
		end;
	end;
end;

-- Called when a text entry has gotten focus.
function DESIGN:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function DESIGN:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when screen space effects should be rendered.
function DESIGN:RenderScreenspaceEffects()
	local modify = {};
	
	if ( !BLUEPRINT:IsScreenFadedBlack() ) then
		local curTime = CurTime();
		
		if (self.flashEffect) then
			local timeLeft = math.Clamp( self.flashEffect[1] - curTime, 0, self.flashEffect[2] );
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				modify = {};
				
				modify["$pp_colour_brightness"] = 0;
				modify["$pp_colour_contrast"] = 1 + (timeLeft * incrementer);
				modify["$pp_colour_colour"] = 1 - (incrementer * timeLeft);
				modify["$pp_colour_addr"] = incrementer * timeLeft;
				modify["$pp_colour_addg"] = 0;
				modify["$pp_colour_addb"] = 0;
				modify["$pp_colour_mulr"] = 1;
				modify["$pp_colour_mulg"] = 0;
				modify["$pp_colour_mulb"] = 0;
				
				DrawColorModify(modify);
				
				if ( !self.flashEffect[3] ) then
					DrawMotionBlur( 1 - (incrementer * timeLeft), incrementer * timeLeft, self.flashEffect[2] );
				end;
			end;
		end;
	end;
end;

-- Called when the local player's motion blurs should be adjusted.
function DESIGN:PlayerAdjustMotionBlurs(motionBlurs)
	if ( !BLUEPRINT:IsScreenFadedBlack() ) then
		local curTime = CurTime();
		
		if ( self.flashEffect and self.flashEffect[3] ) then
			local timeLeft = math.Clamp( self.flashEffect[1] - curTime, 0, self.flashEffect[2] );
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				motionBlurs.blurTable["flash"] = 1 - (incrementer * timeLeft);
			end;
		end;
	end;
end;

-- Called when the cinematic intro info is needed.
function DESIGN:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self.author..".",
		title = blueprint.config.Get("intro_text_big"):Get(),
		text = blueprint.config.Get("intro_text_small"):Get(),
	};
end;

-- Called when the character background blur should be drawn.
function DESIGN:ShouldDrawCharacterBackgroundBlur()
	return false;
end;

-- Called when an entity's menu options are needed.
function DESIGN:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "prop_ragdoll") then
		local player = blueprint.entity.GetPlayer(entity);
		
		if ( !player or !player:Alive() ) then
			options["Mutilate"] = "bp_corpseMutilate";
			options["Loot"] = "bp_corpseLoot";
		end;
	elseif (entity:GetClass() == "bp_belongings") then
		options["Open"] = "bp_belongingsOpen";
	elseif (entity:GetClass() == "bp_breach") then
		options["Charge"] = "bp_breachCharge";
	elseif (entity:GetClass() == "bp_radio") then
		if ( !entity:IsOff() ) then
			options["Turn Off"] = "bp_radioToggle";
		else
			options["Turn On"] = "bp_radioToggle";
		end;
		
		options["Set Frequency"] = function()
			Derma_StringRequest("Frequency", "What would you like to set the frequency to?", frequency, function(text)
				if ( IsValid(entity) ) then
					blueprint.entity.ForceMenuOption(entity, "Set Frequency", text);
				end;
			end);
		end;
		
		options["Take"] = "bp_radioTake";
	end;
end;

-- Called when a player's scoreboard options are needed.
function DESIGN:GetPlayerScoreboardOptions(player, options, menu)
	if ( blueprint.command.Get("CharPermaKill") ) then
		if ( blueprint.player.HasFlags(g_LocalPlayer, blueprint.command.Get("CharPermaKill").access) ) then
			options["Perma-Kill"] = function()
				RunConsoleCommand( "bp", "CharPermaKill", player:Name() );
			end;
		end;
	end;
end;

-- Called when the target's status should be drawn.
function DESIGN:DrawTargetPlayerStatus(target, alpha, x, y)
	local colorInformation = blueprint.design.GetColor("information");
	local thirdPerson = "him";
	local mainStatus;
	local untieText;
	local gender = "He";
	local action = blueprint.player.GetAction(target);
	
	if (blueprint.player.GetGender(target) == GENDER_FEMALE) then
		thirdPerson = "her";
		gender = "She";
	end;
	
	if ( target:Alive() ) then
		if (action == "die") then
			mainStatus = gender.." is in critical condition.";
		end;
		
		if (target:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
			mainStatus = gender.." is clearly unconscious.";
		end;
		
		if (target:GetSharedVar("sh_Tied") != 0) then
			if (blueprint.player.GetAction(g_LocalPlayer) == "untie") then
				mainStatus = gender.. " is being untied.";
			else
				local untieText;
				
				if (target:GetShootPos():Distance( g_LocalPlayer:GetShootPos() ) <= 192) then
					if (g_LocalPlayer:GetSharedVar("sh_Tied") == 0) then
						mainStatus = "Press 'use' to untie "..thirdPerson..".";
						
						untieText = true;
					end;
				end;
				
				if (!untieText) then
					mainStatus = gender.." has been tied up.";
				end;
			end;
		elseif (blueprint.player.GetAction(g_LocalPlayer) == "tie") then
			mainStatus = gender.." is being tied up.";
		end;
		
		if (mainStatus) then
			y = BLUEPRINT:DrawInfo(mainStatus, x, y, colorInformation, alpha);
		end;
		
		return y;
	end;
end;

-- Called when the foreground HUD should be painted.
function DESIGN:HUDPaintForeground()
	local curTime = CurTime();
	local team = g_LocalPlayer:Team();
	local y = (ScrH() / 2) - 128;
	local x = ScrW() / 2;
	
	if ( g_LocalPlayer:Alive() ) then
		if (self.stunEffects) then
			for k, v in pairs(self.stunEffects) do
				local alpha = math.Clamp( ( 255 / v[2] ) * (v[1] - curTime), 0, 255 );
				
				if (alpha != 0) then
					draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, alpha) );
				else
					table.remove(self.stunEffects, k);
				end;
			end;
		end;
	end;
end;

-- Called to get the screen text info.
function DESIGN:GetScreenTextInfo()
	local blackFadeAlpha = BLUEPRINT:GetBlackFadeAlpha();
	
	if ( g_LocalPlayer:GetSharedVar("sh_PermaKilled") ) then
		return {
			alpha = blackFadeAlpha,
			title = "THIS CHARACTER IS PERMANENTLY KILLED",
			text = "Go to the character menu to make a new one."
		};
	elseif ( g_LocalPlayer:GetSharedVar("sh_BeingTied") ) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU ARE BEING TIED UP"
		};
	elseif (g_LocalPlayer:GetSharedVar("sh_Tied") != 0) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU HAVE BEEN TIED UP"
		};
	end;
end;

-- Called just before a bar is drawn.
function DESIGN:PreDrawBar(barInfo)
	surface.SetDrawColor(0, 0, 0, 150);
	surface.SetTexture(self.scratchTexture);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.width, barInfo.height);
	
	barInfo.drawBackground = false;
	barInfo.drawProgress = false;
	
	if (barInfo.text) then
		barInfo.text = string.upper(barInfo.text);
	end;
end;

-- Called just after a bar is drawn.
function DESIGN:PostDrawBar(barInfo)
	surface.SetDrawColor(barInfo.color.r, barInfo.color.g, barInfo.color.b, barInfo.color.a);
	surface.SetTexture(self.scratchTexture);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.progressWidth, barInfo.height);
end;

-- Called just before the weapon selection info is drawn.
function DESIGN:PreDrawWeaponSelectionInfo(info)
	surface.SetDrawColor( 255, 255, 255, math.min(200, info.alpha) );
	surface.SetTexture(self.dirtyTexture);
	surface.DrawTexturedRect(info.x, info.y, info.width, info.height);
	
	info.drawBackground = false;
end;

-- Called just before the local player's information is drawn.
function DESIGN:PreDrawPlayerInfo(boxInfo, information, subInformation)
	surface.SetDrawColor(255, 255, 255, 100);
	surface.SetTexture(self.dirtyTexture);
	surface.DrawTexturedRect(boxInfo.x, boxInfo.y, boxInfo.width, boxInfo.height);
	
	boxInfo.drawBackground = false;
	boxInfo.drawGradient = false;
end;

-- Called when the chat box info should be adjusted.
function DESIGN:ChatBoxAdjustInfo(info)
	if ( IsValid(info.speaker) ) then
		if (info.data.anon) then
			info.name = "Somebody";
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function DESIGN:GetPostProgressBarInfo()
	if ( g_LocalPlayer:Alive() ) then
		local action, percentage = blueprint.player.GetAction(g_LocalPlayer, true);
		
		if (action == "die") then
			return {text = "You are slowly dying.", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;