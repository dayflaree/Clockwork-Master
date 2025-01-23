--[[
Name: "cl_hooks.lua".
Product: "Severance".
--]]

function SCHEMA:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	return true;
end;

-- Called when the menu's items should be destroyed.
function SCHEMA:MenuItemsDestroy(menuItems)
	if ( !nexus.player.HasFlags(g_LocalPlayer, "y") ) then
		menuItems:Destroy( nexus.schema.GetOption("name_business") );
	end;
end;

-- Called when a Derma skin should be forced.
function SCHEMA:ForceDermaSkin()
	return "blackskin";
end;

-- Called each tick.
function SCHEMA:Tick()
	local frameTime = FrameTime();
	local curTime = CurTime();
	
	if ( IsValid(g_LocalPlayer) ) then
		if ( NEXUS:IsCharacterScreenOpen(true) ) then
			if (!self.musicSound) then
				self.musicSound = CreateSound(g_LocalPlayer, "music/hl1_song21.mp3");
				self.musicSound:PlayEx(1, 100);
				
				timer.Simple(SoundDuration("music/hl1_song21.mp3"), function()
					self.musicSound = nil;
				end);
			end;
		elseif (self.musicSound) then
			self.musicSound:FadeOut(8);
			
			timer.Simple(8, function()
				self.musicSound = nil;
			end);
		end;
	end;
end;

-- Called each frame.
function SCHEMA:Think()
	local currentMap = game.GetMap();
	local validMaps = {
		["md_venetianredux_b2"] = Vector(-3985.6904, 1397.9601, 604.0056),
		["rp_necro_urban_v3b"] = Vector(3813.7615, 172.4379, 443.5957),
		["rp_necro_urban_v2"] = Vector(3813.7615, 172.4379, 443.5957),
		["rp_necro_urban_v1"] = Vector(3813.7615, 172.4379, 443.5957)
	};
	
	if ( validMaps[currentMap] and NEXUS:IsChoosingCharacter() ) then
		local curTime = CurTime();
		
		if (!self.nextDynamicLight or curTime >= self.nextDynamicLight) then
			self.nextDynamicLight = curTime + math.Rand(0, 1);
			
			local dynamicLight = DynamicLight(1337);
			
			if (dynamicLight) then
				dynamicLight.Brightness = 4;
				dynamicLight.DieTime = curTime + 0.1;
				dynamicLight.Decay = 512;
				dynamicLight.Size = 512;
				dynamicLight.Pos = validMaps[currentMap];
				dynamicLight.r = 255;
				dynamicLight.g = 255;
				dynamicLight.b = 255;
			end;
		end;
	end;
end;

-- Called when nexus has initialized.
function SCHEMA:NexusInitialized()
	for k, v in pairs( nexus.item.GetAll() ) do
		if (!v.isBaseItem and !v.isRareItem) then
			v.business = true;
			v.access = "y";
			v.batch = 1;
		end;
	end;
end;

-- Called when the local player's character screen faction is needed.
function SCHEMA:GetPlayerCharacterScreenFaction(character)
	if (character.customClass and character.customClass != "") then
		return character.customClass;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function SCHEMA:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		local physDesc = entity:GetNetworkedString("sh_PhysDesc");
		
		if (physDesc != "") then
			info.y = NEXUS:DrawInfo(physDesc, info.x, info.y, colorWhite, info.alpha);
		end;
	end;
end;

-- Called when a text entry has gotten focus.
function SCHEMA:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function SCHEMA:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when screen space effects should be rendered.
function SCHEMA:RenderScreenspaceEffects()
	local modify = {};
	
	if ( !NEXUS:IsScreenFadedBlack() ) then
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
function SCHEMA:PlayerAdjustMotionBlurs(motionBlurs)
	if ( !NEXUS:IsScreenFadedBlack() ) then
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
function SCHEMA:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self.author..".",
		title = nexus.config.Get("intro_text_big"):Get(),
		text = nexus.config.Get("intro_text_small"):Get()
	};
end;

-- Called when the character background blur should be drawn.
function SCHEMA:ShouldDrawCharacterBackgroundBlur()
	return false;
end;

-- Called when the local player's color modify should be adjusted.
function SCHEMA:PlayerAdjustColorModify(colorModify)
	local choosingCharacter = NEXUS:IsChoosingCharacter();
	local frameTime = FrameTime();
	local interval = frameTime * 0.05;
	
	if (!self.colorModify) then
		self.colorModify = {
			brightness = -0.2,
			contrast = 2,
			color = 0
		};
	end;
	
	if ( choosingCharacter or nexus.menu.GetOpen() ) then
		if (choosingCharacter) then
			interval = frameTime * 0.25;
		end;
		
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, -0.2,interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, 2, interval);
		self.colorModify.color = math.Approach(self.colorModify.color, 0, interval);
	else
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, -0.03, interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, 1.1, interval);
		self.colorModify.color = math.Approach(self.colorModify.color, 0.4, interval);
	end;
	
	colorModify["$pp_colour_brightness"] = self.colorModify.brightness;
	colorModify["$pp_colour_contrast"] = self.colorModify.contrast;
	colorModify["$pp_colour_colour"] = self.colorModify.color;
end;

-- Called when an entity's menu options are needed.
function SCHEMA:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "prop_ragdoll") then
		local player = nexus.entity.GetPlayer(entity);
		
		if ( !player or !player:Alive() ) then
			options["Loot"] = "nx_corpseLoot";
		end;
	elseif (entity:GetClass() == "nx_belongings") then
		options["Open"] = "nx_belongingsOpen";
	elseif (entity:GetClass() == "nx_breach") then
		options["Charge"] = "nx_breachCharge";
	elseif (entity:GetClass() == "nx_radio") then
		if ( !entity:GetSharedVar("sh_Off") ) then
			options["Turn Off"] = "nx_radioToggle";
		else
			options["Turn On"] = "nx_radioToggle";
		end;
		
		options["Set Frequency"] = function()
			Derma_StringRequest("Frequency", "What would you like to set the frequency to?", frequency, function(text)
				if ( IsValid(entity) ) then
					nexus.entity.ForceMenuOption(entity, "Set Frequency", text);
				end;
			end);
		end;
		
		options["Take"] = "nx_radioTake";
	end;
end;

-- Called when a player's scoreboard options are needed.
function SCHEMA:GetPlayerScoreboardOptions(player, options, menu)
	if ( nexus.command.Get("CharPermaKill") ) then
		if ( nexus.player.HasFlags(g_LocalPlayer, nexus.command.Get("CharPermaKill").access) ) then
			options["Perma-Kill"] = function()
				RunConsoleCommand( "nx", "CharPermaKill", player:Name() );
			end;
		end;
	end;
end;

-- Called when the target's status should be drawn.
function SCHEMA:DrawTargetPlayerStatus(target, alpha, x, y)
	local colorInformation = nexus.schema.GetColor("information");
	local thirdPerson = "him";
	local mainStatus;
	local untieText;
	local gender = "He";
	local action = nexus.player.GetAction(target);
	
	if (nexus.player.GetGender(target) == GENDER_FEMALE) then
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
			if (nexus.player.GetAction(g_LocalPlayer) == "untie") then
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
		elseif (nexus.player.GetAction(g_LocalPlayer) == "tie") then
			mainStatus = gender.." is being tied up.";
		end;
		
		if (mainStatus) then
			y = NEXUS:DrawInfo(mainStatus, x, y, colorInformation, alpha);
		end;
		
		return y;
	end;
end;

-- Called when the foreground HUD should be painted.
function SCHEMA:HUDPaintForeground()
	local curTime = CurTime();
	local y = (ScrH() / 2) - 128;
	local x = ScrW() / 2;
	
	if (g_LocalPlayer:Alive() and g_LocalPlayer:GetRagdollState() != RAGDOLL_KNOCKEDOUT) then
		if (self.stunEffects) then
			for k, v in pairs(self.stunEffects) do
				local alpha = math.Clamp( ( 255 / v[2] ) * (v[1] - curTime), 0, 255 );
				
				if (alpha == 0) then
					self.stunEffects[k] = nil;
				elseif ( !v[3] ) then
					draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, alpha) );
				else
					v[3](alpha);
				end;
			end;
		end;
	end;
end;

-- Called to get the screen text info.
function SCHEMA:GetScreenTextInfo()
	local blackFadeAlpha = NEXUS:GetBlackFadeAlpha();
	
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

-- Called when the local player is created.
function SCHEMA:LocalPlayerCreated()
	g_LocalPlayer:SetNetworkedVarProxy("sh_Clothes", function(entity, name, oldValue, newValue)
		if (oldValue != newValue) then
			nexus.inventory.Rebuild();
		end;
	end);
end;

-- Called just before a bar is drawn.
function SCHEMA:PreDrawBar(barInfo)
	surface.SetDrawColor(255, 255, 255, 150);
	surface.SetTexture(self.scratchTexture);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.width, barInfo.height);
	
	barInfo.drawBackground = false;
	barInfo.drawProgress = false;
	
	if (barInfo.text) then
		barInfo.text = string.upper(barInfo.text);
	end;
end;

-- Called just after a bar is drawn.
function SCHEMA:PostDrawBar(barInfo)
	surface.SetDrawColor(barInfo.color.r, barInfo.color.g, barInfo.color.b, barInfo.color.a);
	surface.SetTexture(self.scratchTexture);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.progressWidth, barInfo.height);
end;

-- Called just before the local player's information is drawn.
function SCHEMA:PreDrawPlayerInfo(boxInfo, information, subInformation)
	surface.SetDrawColor(255, 255, 255, 200);
	surface.SetTexture(self.scratchTexture);
	surface.DrawTexturedRect(boxInfo.x, boxInfo.y, boxInfo.width, boxInfo.height);
	
	boxInfo.drawBackground = false;
end;

-- Called when the player info text should be destroyed.
function SCHEMA:DestroyPlayerInfoText(playerInfoText)
	playerInfoText:DestroySub("NAME");
end;

-- Called when the chat box info should be adjusted.
function SCHEMA:ChatBoxAdjustInfo(info)
	if ( IsValid(info.speaker) ) then
		if (info.data.anon) then
			info.name = "Somebody";
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function SCHEMA:GetPostProgressBarInfo()
	if ( g_LocalPlayer:Alive() ) then
		local action, percentage = nexus.player.GetAction(g_LocalPlayer, true);
		
		if (action == "die") then
			return {text = "You are slowly dying.", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;