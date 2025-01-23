--[[
Name: "cl_hooks.lua".
Product: "Half-Life 2".
--]]

-- Called when the resistance date and time has been drawn.
function MODULE:ResistanceDateTimeDrawn(info)
	local colorWhite = resistance.module.GetColor("white");
	local curTime = CurTime();
	
	if ( self:PlayerIsCombine(g_LocalPlayer) ) then
		if (self.combineDisplayLines) then
			local height = draw.GetFontHeight("BudgetLabel");
			
			for k, v in ipairs(self.combineDisplayLines) do
				if ( curTime >= v[2] ) then
					table.remove(self.combineDisplayLines, k);
				else
					draw.SimpleText(string.sub( v[1], 1, v[3] ), "BudgetLabel", info.x, info.y, v[4] or colorWhite);
					
					if ( v[3] < string.len( v[1] ) ) then
						v[3] = v[3] + 1;
					end;
					
					info.y = info.y + height;
				end;
			end;
		end;
	end;
end;

-- Called when the local player's business is rebuilt.
function MODULE:PlayerBusinessRebuilt(panel, categories)
	local business_name = resistance.module.GetOption("name_business", true);
	
	if (!self.businessPanel) then
		self.businessPanel = panel;
	end;
	
	if (resistance.config.Get("permits"):Get() and resistance.player.GetFaction(g_LocalPlayer) == FACTION_CITIZEN) then
		local permits = {};
		
		for k, v in pairs( resistance.item.GetAll() ) do
			if ( v.cost and v.access and !RESISTANCE:HasObjectAccess(g_LocalPlayer, v) ) then
				if ( string.find(v.access, "1") ) then
					permits.generalGoods = (permits.generalGoods or 0) + (v.cost * v.batch);
				else
					for k2, v2 in pairs(MODULE.customPermits) do
						if ( string.find(v.access, v2.flag) ) then
							permits[v2.key] = (permits[v2.key] or 0) + (v.cost * v.batch);
							
							break;
						end;
					end;
				end;
			end;
		end;
		
		if (table.Count(permits) > 0) then
			local panelList = vgui.Create("DPanelList", panel);
			
			panel.permitsForm = vgui.Create("DForm");
			panel.permitsForm:SetName("Permits");
			panel.permitsForm:SetPadding(4);
			
			panelList:SetAutoSize(true);
			panelList:SetPadding(4);
			panelList:SetSpacing(4);
			
			if ( resistance.player.HasFlags(g_LocalPlayer, "x") ) then
				for k, v in pairs(permits) do
					panel.customData = {information = v};
					
					if (k == "generalGoods") then
						panel.customData.description = "Purchase a permit to add general goods to your "..business_name..".";
						panel.customData.Callback = function()
							RESISTANCE:RunCommand("PermitBuy", "generalgoods");
						end;
						panel.customData.model = "models/props_junk/cardboard_box004a.mdl";
						panel.customData.name = "General Goods";
					else
						for k2, v2 in pairs(MODULE.customPermits) do
							if (v2.key == k) then
								panel.customData.description = "Purchase a permit to add "..string.lower(v2.name).." to your "..business_name..".";
								panel.customData.Callback = function()
									RESISTANCE:RunCommand("PermitBuy", k2);
								end;
								panel.customData.model = v2.model;
								panel.customData.name = v2.name;
								
								break;
							end;
						end;
					end;
					
					panelList:AddItem( vgui.Create("roleplay_BusinessCustom", panel) );
				end;
			else
				panel.customData = {
					description = "Create a "..business_name.." which allows you to purchase permits.",
					information = resistance.config.Get("business_cost"):Get(),
					Callback = function()
						RESISTANCE:RunCommand("PermitBuy", "business");
					end,
					model = "models/props_c17/briefcase001a.mdl",
					name = "Create "..resistance.module.GetOption("name_business")
				};
				
				panelList:AddItem( vgui.Create("roleplay_BusinessCustom", panel) );
			end;
			
			panel.permitsForm:AddItem(panelList);
			panel.panelList:AddItem(panel.permitsForm);
		end;
	end;
end;

-- Called when the local player is created.
function MODULE:LocalPlayerCreated()
	g_LocalPlayer:SetNetworkedVarProxy("sh_Clothes", function(entity, name, oldValue, newValue)
		if (oldValue != newValue) then
			resistance.inventory.Rebuild();
		end;
	end);
end;

-- Called when the target player's fade distance is needed.
function MODULE:GetTargetPlayerFadeDistance(player)
	if ( IsValid( self:GetScannerEntity(g_LocalPlayer) ) ) then
		return 512;
	end;
end;

-- Called when an entity's menu options are needed.
function MODULE:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "prop_ragdoll") then
		local player = resistance.entity.GetPlayer(entity);
		
		if ( !player or !player:Alive() ) then
			options["Loot"] = "roleplay_corpseLoot";
		end;
	elseif (entity:GetClass() == "roleplay_belongings") then
		options["Open"] = "roleplay_belongingsOpen";
	elseif (entity:GetClass() == "roleplay_breach") then
		options["Charge"] = "roleplay_breachCharge";
	elseif (entity:GetClass() == "roleplay_radio") then
		if ( !entity:GetSharedVar("sh_Off") ) then
			options["Turn Off"] = "roleplay_radioToggle";
		else
			options["Turn On"] = "roleplay_radioToggle";
		end;
		
		options["Set Frequency"] = function()
			Derma_StringRequest("Frequency", "What would you like to set the frequency to?", frequency, function(text)
				if ( IsValid(entity) ) then
					resistance.entity.ForceMenuOption(entity, "Set Frequency", text);
				end;
			end);
		end;
		
		options["Take"] = "roleplay_radioTake";
	end;
end;

-- Called when a player's typing display position is needed.
function MODULE:GetPlayerTypingDisplayPosition(player)
	local scannerEntity = self:GetScannerEntity(player);
	
	if ( IsValid(scannerEntity) ) then
		local position = scannerEntity:GetBonePosition( scannerEntity:LookupBone("Scanner.Body") );
		local curTime = CurTime();
		
		if (!position) then
			return scannerEntity:GetPos() + Vector(0, 0, 8);
		else
			return position;
		end;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function MODULE:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = resistance.module.GetColor("target_id");
	local colorWhite = resistance.module.GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		local physDesc = entity:GetNetworkedString("sh_PhysDesc");
		
		if (physDesc != "") then
			info.y = RESISTANCE:DrawInfo(physDesc, info.x, info.y, colorWhite, info.alpha);
		end;
	elseif ( entity:IsNPC() ) then
		local name = entity:GetNetworkedString("roleplay_Name");
		local title = entity:GetNetworkedString("roleplay_Title");
		
		if (name != "" and title != "") then
			info.y = RESISTANCE:DrawInfo(name, info.x, info.y, Color(255, 255, 100, 255), info.alpha);
			info.y = RESISTANCE:DrawInfo(title, info.x, info.y, Color(255, 255, 255, 255), info.alpha);
		end;
	end;
end;

-- Called when a Derma skin should be forced.
function MODULE:ForceDermaSkin()
	return "blackskin";
end;

-- Called when a text entry has gotten focus.
function MODULE:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function MODULE:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when screen space effects should be rendered.
function MODULE:RenderScreenspaceEffects()
	if ( !RESISTANCE:IsScreenFadedBlack() ) then
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
		
		if ( self:PlayerIsCombine(g_LocalPlayer) ) then
			render.UpdateScreenEffectTexture();
			
			self.combineOverlay:SetMaterialFloat("$refractamount", 0.3);
			self.combineOverlay:SetMaterialFloat("$envmaptint", 0);
			self.combineOverlay:SetMaterialFloat("$envmap", 0);
			self.combineOverlay:SetMaterialFloat("$alpha", 0.8);
			self.combineOverlay:SetMaterialInt("$ignorez", 1);
			
			render.SetMaterial(self.combineOverlay);
			render.DrawScreenQuad();
		end;
	end;
end;

-- Called when the local player's motion blurs should be adjusted.
function MODULE:PlayerAdjustMotionBlurs(motionBlurs)
	if ( !RESISTANCE:IsScreenFadedBlack() ) then
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
function MODULE:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self.author..".",
		title = resistance.config.Get("intro_text_big"):Get(),
		text = resistance.config.Get("intro_text_small"):Get()
	};
end;

-- Called when the scoreboard's class players should be sorted.
function MODULE:ScoreboardSortClassPlayers(class, a, b)
	if (class == "Civil Protection" or class == "Overwatch Transhuman Arm") then
		local rankA = self:GetPlayerCombineRank(a);
		local rankB = self:GetPlayerCombineRank(b);
		
		if (rankA == rankB) then
			return a:Name() < b:Name();
		else
			return rankA > rankB;
		end;
	end;
end;

-- Called when a player's scoreboard class is needed.
function MODULE:GetPlayerScoreboardClass(player)
	local customClass = player:GetSharedVar("sh_CustomClass");
	local faction = resistance.player.GetFaction(player);
	
	if (customClass != "") then
		return customClass;
	end;
	
	if (faction == FACTION_MPF) then
		return "Civil Protection";
	elseif (faction == FACTION_OTA) then
		return "Overwatch Transhuman Arm";
	end;
end;

-- Called when the local player's character screen faction is needed.
function MODULE:GetPlayerCharacterScreenFaction(character)
	if (character.customClass and character.customClass != "") then
		return character.customClass;
	end;
end;

-- Called when the local player attempts to zoom.
function MODULE:PlayerCanZoom()
	if ( !self:PlayerIsCombine(g_LocalPlayer) ) then
		return false;
	end;
end;

-- Called when a player's scoreboard options are needed.
function MODULE:GetPlayerScoreboardOptions(player, options, menu)
	if ( resistance.command.Get("serverwhitelist") ) then
		if ( resistance.player.HasFlags(g_LocalPlayer, resistance.command.Get("serverwhitelist").access) ) then
			options["Server Whitelist"] = {};
			
			options["Server Whitelist"]["Add"] = function()
				Derma_StringRequest(player:Name(), "What server whitelist would you like to add them to?", "", function(text)
					RESISTANCE:RunCommand("PlyAddServerWhitelist", player:Name(), text);
				end);
			end;
			
			options["Server Whitelist"]["Remove"] = function()
				Derma_StringRequest(player:Name(), "What server whitelist would you like to remove them from?", "", function(text)
					RESISTANCE:RunCommand("PlyRemoveServerWhitelist", player:Name(), text);
				end);
			end;
		end;
	end;
	
	if ( resistance.command.Get("setcustomclass") ) then
		if ( resistance.player.HasFlags(g_LocalPlayer, resistance.command.Get("setcustomclass").access) ) then
			options["Custom Class"] = {};
			options["Custom Class"]["Set"] = function()
				Derma_StringRequest(player:Name(), "What would you like to set their custom class to?", player:GetSharedVar("sh_CustomClass"), function(text)
					RESISTANCE:RunCommand("CharSetCustomClass", player:Name(), text);
				end);
			end;
			
			if (player:GetSharedVar("sh_CustomClass") != "") then
				options["Custom Class"]["Take"] = function()
					RESISTANCE:RunCommand( "CharTakeCustomClass", player:Name() );
				end;
			end;
		end;
	end;
	
	if ( resistance.command.Get("CharPermaKill") ) then
		if ( resistance.player.HasFlags(g_LocalPlayer, resistance.command.Get("CharPermaKill").access) ) then
			options["Perma-Kill"] = function()
				RunConsoleCommand( "roleplay", "CharPermaKill", player:Name() );
			end;
		end;
	end;
end;

-- Called when the scoreboard's player info should be adjusted.
function MODULE:ScoreboardAdjustPlayerInfo(info)
	if ( self:IsPlayerCombineRank(info.player, "SCN") ) then
		if ( self:IsPlayerCombineRank(info.player, "SYNTH") ) then
			info.model = "models/shield_scanner.mdl";
		else
			info.model = "models/combine_scanner.mdl";
		end;
	end;
end;

-- Called when the local player's class model info should be adjusted.
function MODULE:PlayerAdjustClassModelInfo(class, info)
	if (class == CLASS_MPS) then
		if ( self:IsPlayerCombineRank(g_LocalPlayer, "SCN")
		and self:IsPlayerCombineRank(g_LocalPlayer, "SYNTH") ) then
			info.model = "models/shield_scanner.mdl";
		else
			info.model = "models/combine_scanner.mdl";
		end;
	end;
end;

-- Called when the local player's color modify should be adjusted.
function MODULE:PlayerAdjustColorModify(colorModify)
	local antiDepressants = g_LocalPlayer:GetSharedVar("sh_Antidepressants");
	local brightness = -0.03;
	local contrast = 1.2;
	local color = 0.4;
	
	if (string.lower( game.GetMap() ) != "rp_c18_v1") then
		color = 0.7;
	end;
	
	self.currentBrightness = self.currentBrightness or brightness;
	self.currentContrast = self.currentContrast or contrast;
	self.currentColor = self.currentColor or color;
	
	local frameTime = FrameTime() / 10;
	local curTime = CurTime();
	
	if (antiDepressants > curTime) then
		self.currentBrightness = math.Approach(self.currentBrightness, 0, frameTime);
		self.currentContrast = math.Approach(self.currentContrast, 1, frameTime);
		self.currentColor = math.Approach(self.currentColor, 1, frameTime);
	else
		self.currentBrightness = math.Approach(self.currentBrightness, brightness, frameTime);
		self.currentContrast = math.Approach(self.currentContrast, contrast, frameTime);
		self.currentColor = math.Approach(self.currentColor, color, frameTime);
	end;
	
	if (self.currentBrightness != 0) then
		colorModify["$pp_colour_brightness"] = self.currentBrightness;
	end;
	
	if (self.currentContrast != 1) then
		colorModify["$pp_colour_contrast"] = self.currentContrast;
	end;
	
	if (self.currentColor != 1) then
		colorModify["$pp_colour_colour"] = self.currentColor;
	end;
end;

-- Called when the local player attempts to see a class.
function MODULE:PlayerCanSeeClass(class)
	if ( class.index == CLASS_MPS and !self:IsPlayerCombineRank(g_LocalPlayer, "SCN") ) then
		return false;
	elseif ( class.index == CLASS_MPR and !self:IsPlayerCombineRank(g_LocalPlayer, "RCT") ) then
		return false;
	elseif ( class.index == CLASS_EMP and !self:IsPlayerCombineRank(g_LocalPlayer, "EpU") ) then
		return false;
	elseif ( class.index == CLASS_OWS and !self:IsPlayerCombineRank(g_LocalPlayer, "OWS") ) then
		return false;
	elseif ( class.index == CLASS_EOW and !self:IsPlayerCombineRank(g_LocalPlayer, "EOW") ) then
		return false;
	elseif (class.index == CLASS_MPU) then
		if ( self:IsPlayerCombineRank(g_LocalPlayer, "SCN") or self:IsPlayerCombineRank(g_LocalPlayer, "EpU")
		or self:IsPlayerCombineRank(g_LocalPlayer, "RCT") ) then
			return false;
		end;
	end;
end;

-- Called when a player's footstep sound should be played.
function MODULE:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	return true;
end;

-- Called when the target's status should be drawn.
function MODULE:DrawTargetPlayerStatus(target, alpha, x, y)
	local informationColor = resistance.module.GetColor("information");
	local thirdPerson = "him";
	local mainStatus;
	local untieText;
	local gender = "He";
	local action = resistance.player.GetAction(target);
	
	if (resistance.player.GetGender(target) == GENDER_FEMALE) then
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
			if (resistance.player.GetAction(g_LocalPlayer) == "untie") then
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
		elseif (resistance.player.GetAction(g_LocalPlayer) == "tie") then
			mainStatus = gender.." is being tied up.";
		end;
		
		if (mainStatus) then
			y = RESISTANCE:DrawInfo(mainStatus, x, y, informationColor, alpha);
		end;
		
		return y;
	end;
end;

-- Called when the player info text is needed.
function MODULE:GetPlayerInfoText(playerInfoText)
	local citizenID = g_LocalPlayer:GetSharedVar("sh_CitizenID");
	
	if (citizenID) then
		if (resistance.player.GetFaction(g_LocalPlayer) == FACTION_CITIZEN) then
			playerInfoText:Add("CITIZEN_ID", "Citizen ID: #"..citizenID);
		end;
	end;
end;

-- Called to check if a player does have an flag.
function MODULE:PlayerDoesHaveFlag(player, flag)
	if ( !resistance.config.Get("permits"):Get() ) then
		if (flag == "x" or flag == "1") then
			return false;
		end;
		
		for k, v in pairs(self.customPermits) do
			if (v.flag == flag) then
				return false;
			end;
		end;
	end;
end;

-- Called to check if a player does recognise another player.
function MODULE:PlayerDoesRecognisePlayer(player, status, simple, default)
	if (self:PlayerIsCombine(player) or resistance.player.GetFaction(player) == FACTION_ADMIN) then
		return true;
	end;
end;

-- Called each tick.
function MODULE:Tick()
	if ( IsValid(g_LocalPlayer) ) then
		if ( RESISTANCE:IsCharacterScreenOpen(true) ) then
			if (!self.musicSound) then
				self.musicSound = CreateSound(g_LocalPlayer, "music/hl2_song19.mp3");
				self.musicSound:PlayEx(1, 100);
				
				timer.Simple(SoundDuration("music/hl2_song19.mp3"), function()
					self.musicSound = nil;
				end);
			end;
		elseif (self.musicSound) then
			self.musicSound:FadeOut(8);
			
			timer.Simple(8, function()
				self.musicSound = nil;
			end);
		end;
		
		if ( self:PlayerIsCombine(g_LocalPlayer) ) then
			local curTime = CurTime();
			local health = g_LocalPlayer:Health();
			local armor = g_LocalPlayer:Armor();

			if (!self.nextHealthWarning or curTime >= self.nextHealthWarning) then
				if (self.lastHealth) then
					if (health < self.lastHealth) then
						if (health == 0) then
							self:AddCombineDisplayLine( "ERROR! Shutting down...", Color(255, 0, 0, 255) );
						else
							self:AddCombineDisplayLine( "WARNING! Physical bodily trauma detected...", Color(255, 0, 0, 255) );
						end;
						
						self.nextHealthWarning = curTime + 2;
					elseif (health > self.lastHealth) then
						if (health == 100) then
							self:AddCombineDisplayLine( "Physical body systems restored...", Color(0, 255, 0, 255) );
						else
							self:AddCombineDisplayLine( "Physical body systems regenerating...", Color(0, 0, 255, 255) );
						end;
						
						self.nextHealthWarning = curTime + 2;
					end;
				end;
				
				if (self.lastArmor) then
					if (armor < self.lastArmor) then
						if (armor == 0) then
							self:AddCombineDisplayLine( "WARNING! External protection exhausted...", Color(255, 0, 0, 255) );
						else
							self:AddCombineDisplayLine( "WARNING! External protection damaged...", Color(255, 0, 0, 255) );
						end;
						
						self.nextHealthWarning = curTime + 2;
					elseif (armor > self.lastArmor) then
						if (armor == 100) then
							self:AddCombineDisplayLine( "External protection systems restored...", Color(0, 255, 0, 255) );
						else
							self:AddCombineDisplayLine( "External protection systems regenerating...", Color(0, 0, 255, 255) );
						end;
						
						self.nextHealthWarning = curTime + 2;
					end;
				end;
			end;
			
			if (!self.nextRandomLine or curTime >= self.nextRandomLine) then
				local text = self.randomDisplayLines[ math.random(1, #self.randomDisplayLines) ];
				
				if (text and self.lastRandomDisplayLine != text) then
					self:AddCombineDisplayLine(text);
					
					self.lastRandomDisplayLine = text;
				end;
				
				self.nextRandomLine = curTime + 3;
			end;
			
			self.lastHealth = health;
			self.lastArmor = armor;
		end;
	end;
end;

-- Called when the foreground HUD should be painted.
function MODULE:HUDPaintForeground()
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
function MODULE:GetScreenTextInfo()
	local blackFadeAlpha = RESISTANCE:GetBlackFadeAlpha();
	
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

-- Called when the chat box info should be adjusted.
function MODULE:ChatBoxAdjustInfo(info)
	if ( IsValid(info.speaker) ) then
		if (info.data.anon) then
			info.name = "Somebody";
		end;
		
		if ( self:PlayerIsCombine(info.speaker) ) then
			if ( self:IsPlayerCombineRank(info.speaker, "SCN") ) then
				if (info.class == "radio" or info.class == "radio_eavesdrop") then
					info.name = "Dispatch";
				end;
			end;
		end;
	end;
end;