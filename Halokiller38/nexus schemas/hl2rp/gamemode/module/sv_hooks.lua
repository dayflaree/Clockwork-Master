--[[
Name: "sh_hooks.lua".
Product: "Half-Life 2".
--]]

MODULE.defaultWeapons = {
	["weapon_357"] = 7,
	["weapon_ar2"] = 7,
	["weapon_smg1"] = 6,
	["weapon_pistol"] = 5,
	["weapon_shotgun"] = 8,
	["weapon_crossbow"] = 8
};

-- Called when resistance has loaded all of the entities.
function MODULE:ResistanceInitPostEntity()
	self:LoadRationDispensers();
	self:LoadCombineLocks();
	self:LoadObjectives();
	self:LoadRadios();
	self:LoadNPCs();
end;

-- Called when data should be saved.
function MODULE:SaveData()
	if (self.combineObjectives) then
		RESISTANCE:SaveModuleData("objectives", self.combineObjectives);
	end;
end;

-- Called just after data should be saved.
function MODULE:PostSaveData()
	self:SaveRationDispensers();
	self:SaveCombineLocks();
	self:SaveRadios();
	self:SaveNPCs();
end;

-- Called when a player's default model is needed.
function MODULE:GetPlayerDefaultModel(player)
	if ( self:IsPlayerCombineRank(player, "GHOST") ) then
		return "models/eliteghostcp.mdl";
	elseif ( self:IsPlayerCombineRank(player, "OfC") ) then
		return "models/policetrench.mdl";
	elseif ( self:IsPlayerCombineRank(player, "DvL") ) then
		return "models/eliteshockcp.mdl";
	elseif ( self:IsPlayerCombineRank(player, "SeC") ) then
		return "models/sect_police2.mdl";
	end;
end;

-- Called when an entity's menu option should be handled.
function MODULE:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "prop_ragdoll" and arguments == "roleplay_corpseLoot") then
		if (!entity.inventory) then entity.inventory = {}; end;
		if (!entity.cash) then entity.cash = 0; end;
		
		local entityPlayer = resistance.entity.GetPlayer(entity);
		
		if ( !entityPlayer or !entityPlayer:Alive() ) then
			player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
			
			resistance.player.OpenStorage( player, {
				name = "Corpse",
				weight = 8,
				entity = entity,
				distance = 192,
				cash = entity.cash,
				inventory = entity.inventory,
				OnGiveCash = function(player, storageTable, cash)
					entity.cash = storageTable.cash;
				end,
				OnTakeCash = function(player, storageTable, cash)
					entity.cash = storageTable.cash;
				end
			} );
		end;
	elseif (entity:GetClass() == "roleplay_belongings" and arguments == "roleplay_belongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		resistance.player.OpenStorage( player, {
			name = "Belongings",
			weight = 100,
			entity = entity,
			distance = 192,
			cash = entity.cash,
			inventory = entity.inventory,
			OnGiveCash = function(player, storageTable, cash)
				entity.cash = storageTable.cash;
			end,
			OnTakeCash = function(player, storageTable, cash)
				entity.cash = storageTable.cash;
			end,
			OnClose = function(player, storageTable, entity)
				if ( IsValid(entity) ) then
					if ( (!entity.inventory and !entity.cash) or (table.Count(entity.inventory) == 0 and entity.cash == 0) ) then
						entity:Explode(entity:BoundingRadius() * 2);
						entity:Remove();
					end;
				end;
			end,
			CanGive = function(player, storageTable, itemTable)
				return false;
			end
		} );
	elseif (entity:GetClass() == "roleplay_breach") then
		entity:CreateDummyBreach();
		entity:BreachEntity(player);
	elseif (entity:GetClass() == "roleplay_radio") then
		if (option == "Set Frequency" and type(arguments) == "string") then
			if ( string.find(arguments, "^%d%d%d%.%d$") ) then
				local start, finish, decimal = string.match(arguments, "(%d)%d(%d)%.(%d)");
				
				start = tonumber(start);
				finish = tonumber(finish);
				decimal = tonumber(decimal);
				
				if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
					entity:SetFrequency(arguments);
					
					resistance.player.Notify(player, "You have set this stationary radio's arguments to "..arguments..".");
				else
					resistance.player.Notify(player, "The radio arguments must be between 101.1 and 199.9!");
				end;
			else
				resistance.player.Notify(player, "The radio arguments must look like xxx.x!");
			end;
		elseif (arguments == "roleplay_radioToggle") then
			entity:Toggle();
		elseif (arguments == "roleplay_radioTake") then
			local success, fault = player:UpdateInventory("stationary_radio", 1);
			
			if (!success) then
				resistance.player.Notify(entity, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when an NPC has been killed.
function MODULE:OnNPCKilled(npc, attacker, inflictor)
	for k, v in pairs(self.scanners) do
		local scanner = v[1];
		local player = k;
		
		if (IsValid(player) and IsValid(scanner) and scanner == npc) then
			RESISTANCE:CalculateSpawnTime(player, inflictor, attacker);
			
			npc:EmitSound("npc/scanner/scanner_explode_crash2.wav");
			
			self:PlayerDeath(player, inflictor, attacker, true);
			self:ResetPlayerScanner(player);
		end;
	end;
end;

-- Called when a player's visibility should be set up.
function MODULE:SetupPlayerVisibility(player)
	if ( self.scanners[player] ) then
		local scanner = self.scanners[player][1];
		
		if ( IsValid(scanner) ) then
			AddOriginToPVS( scanner:GetPos() );
		end;
	end;
end;

-- Called when a player's drop weapon info should be adjusted.
function MODULE:PlayerAdjustDropWeaponInfo(player, info)
	if (resistance.player.GetWeaponClass(player) == info.itemTable.weaponClass) then
		info.position = player:GetShootPos();
		info.angles = player:GetAimVector():Angle();
	else
		local gearTable = {
			self:GetPlayerGear(player, "Throwable"),
			self:GetPlayerGear(player, "Secondary"),
			self:GetPlayerGear(player, "Primary"),
			self:GetPlayerGear(player, "Melee")
		};
		
		for k, v in pairs(gearTable) do
			if ( IsValid(v) ) then
				local gearItemTable = v:GetItem();
				
				if (gearItemTable and gearItemTable.weaponClass == info.itemTable.weaponClass) then
					local position, angles = v:GetRealPosition();
					
					if (position and angles) then
						info.position = position;
						info.angles = angles;
						
						break;
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player has been given a weapon.
function MODULE:PlayerGivenWeapon(player, class, uniqueID, forceReturn)
	local itemTable = resistance.item.GetWeapon(class, uniqueID);
	
	if (resistance.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
		if ( !itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon() ) then
			if (itemTable.weight <= 2) then
				self:CreatePlayerGear(player, "Secondary", itemTable);
			else
				self:CreatePlayerGear(player, "Primary", itemTable);
			end;
		elseif ( itemTable:IsThrowableWeapon() ) then
			self:CreatePlayerGear(player, "Throwable", itemTable);
		else
			self:CreatePlayerGear(player, "Melee", itemTable);
		end;
	end;
end;

-- Called when a player uses a door.
function MODULE:PlayerUseDoor(player, door)
	if (string.lower( game.GetMap() ) == "rp_c18_v1") then
		local name = string.lower( door:GetName() );
		
		if (name == "nxs_brnroom" or name == "nxs_brnroom2" or name == "resistance_al_door1"
		or name == "resistance_al_door2" or name == "nxs_brnbcroom") then
			local curTime = CurTime();
			
			if (!door.nextAutoClose or curTime >= door.nextAutoClose) then
				door:Fire("Close", "", 10);
				door.nextAutoClose = curTime + 10;
			end;
		end;
	end;
end;

-- Called when a player has an unknown inventory item.
function MODULE:PlayerHasUnknownInventoryItem(player, inventory, item, amount)
	if (item == "radio") then
		inventory["handheld_radio"] = amount;
	end;
end;

-- Called when a player's default inventory is needed.
function MODULE:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_ADMIN) then
		inventory["handheld_radio"] = 1;
	elseif (character.faction == FACTION_MPF) then
		inventory["handheld_radio"] = 1;
		inventory["weapon_pistol"] = 1;
		inventory["ammo_pistol"] = 2;
	elseif (character.faction == FACTION_OTA) then
		inventory["handheld_radio"] = 1;
		inventory["weapon_pistol"] = 1;
		inventory["ammo_pistol"] = 1;
		inventory["weapon_ar2"] = 1;
		inventory["ammo_ar2"] = 1;
	else
		inventory["suitcase"] = 1;
	end;
end;

-- Called when a player's typing display has started.
function MODULE:PlayerStartTypingDisplay(player, code)
	if ( MODULE:PlayerIsCombine(player) ) then
		if (code == "n" or code == "y" or code == "w" or code == "r") then
			if (!player.typingBeep) then
				player.typingBeep = true;
				
				player:EmitSound("npc/overwatch/radiovoice/on1.wav");
			end;
		end;
	end;
end;

-- Called when a player's typing display has finished.
function MODULE:PlayerFinishTypingDisplay(player, textTyped)
	if (MODULE:PlayerIsCombine(player) and textTyped) then
		if (player.typingBeep) then
			player:EmitSound("npc/overwatch/radiovoice/off4.wav");
		end;
	end;
	
	player.typingBeep = nil;
end;

-- Called when a player stuns an entity.
function MODULE:PlayerStunEntity(player, entity)
	local target = resistance.entity.GetPlayer(entity);
	local strength = resistance.attributes.Fraction(player, ATB_STRENGTH, 12, 6);
	
	player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	
	if ( target and target:Alive() ) then
		local curTime = CurTime();
		
		if ( target.nextStunInfo and curTime <= target.nextStunInfo[2] ) then
			target.nextStunInfo[1] = target.nextStunInfo[1] + 1;
			target.nextStunInfo[2] = curTime + 2;
			
			if (target.nextStunInfo[1] == 3) then
				resistance.player.SetRagdollState( target, RAGDOLL_KNOCKEDOUT, resistance.config.Get("knockout_time"):Get() );
			end;
		else
			target.nextStunInfo = {0, curTime + 2};
		end;
		
		target:ViewPunch( Angle(12 + strength, 0, 0) );
		
		umsg.Start("roleplay_Stunned", target);
			umsg.Float(0.5);
		umsg.End();
	end;
end;

-- Called when a player's weapons should be given.
function MODULE:PlayerGiveWeapons(player)
	if (player:QueryCharacter("faction") == FACTION_MPF) then
		resistance.player.GiveSpawnWeapon(player, "roleplay_stunstick");
	end;
end;

-- Called when a player's inventory item has been updated.
function MODULE:PlayerInventoryItemUpdated(player, itemTable, amount, force)
	local clothes = player:GetCharacterData("clothes");
	
	if (clothes == itemTable.index) then
		if ( !player:HasItem(itemTable.uniqueID) ) then
			itemTable:OnChangeClothes(player, false);
			
			player:SetCharacterData("clothes", nil);
		end;
	end;
end;

-- Called when a player switches their flashlight on or off.
function MODULE:PlayerSwitchFlashlight(player, on)
	if ( on and (self.scanners[player] or player:GetSharedVar("sh_Tied") != 0) ) then
		return false;
	end;
end;

-- Called when a player's storage should close.
function MODULE:PlayerStorageShouldClose(player, storage)
	local entity = player:GetStorageEntity();
	
	if (player.searching and entity:IsPlayer() and entity:GetSharedVar("sh_Tied") == 0) then
		return true;
	end;
end;

-- Called when a player attempts to spray their tag.
function MODULE:PlayerSpray(player)
	if (!player:HasItem("spray_can") or player:GetSharedVar("sh_Tied") != 0) then
		return true;
	end;
end;

-- Called when a player presses F3.
function MODULE:ShowSpare1(player)
	resistance.player.RunResistanceCommand(player, "InvAction", "zip_tie", "use");
end;

-- Called when a player presses F4.
function MODULE:ShowSpare2(player)
	resistance.player.RunResistanceCommand(player, "CharSearch");
end;

-- Called when a player's footstep sound should be played.
function MODULE:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local running = nil;
	local clothes = player:GetCharacterData("clothes");
	local model = string.lower( player:GetModel() );
	
	if (clothes) then
		local itemTable = resistance.item.Get(clothes);
		
		if (itemTable) then
			if ( player:IsRunning() or player:IsJogging() ) then
				if (itemTable.runSound) then
					if (type(itemTable.runSound) == "table") then
						sound = itemTable.runSound[ math.random(1, #itemTable.runSound) ];
					else
						sound = itemTable.runSound;
					end;
				end;
			elseif (itemTable.walkSound) then
				if (type(itemTable.walkSound) == "table") then
					sound = itemTable.walkSound[ math.random(1, #itemTable.walkSound) ];
				else
					sound = itemTable.walkSound;
				end;
			end;
		end;
	end;
	
	if ( player:IsRunning() or player:IsJogging() ) then
		running = true;
	end;
	
	if (running) then
		if ( string.find(model, "metrocop") or string.find(model, "shockcp") or string.find(model, "ghostcp") or string.find(model, "police") ) then
			if (foot == 0) then
				local randomSounds = {1, 3, 5};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/metropolice/gear"..randomSounds[randomNumber]..".wav";
			else
				local randomSounds = {2, 4, 6};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/metropolice/gear"..randomSounds[randomNumber]..".wav";
			end;
		elseif ( string.find(model, "combine") ) then
			if (foot == 0) then
				local randomSounds = {1, 3, 5};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/combine_soldier/gear"..randomSounds[randomNumber]..".wav";
			else
				local randomSounds = {2, 4, 6};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/combine_soldier/gear"..randomSounds[randomNumber]..".wav";
			end;
		end;
	end;
	
	player:EmitSound(sound);
	
	return true;
end;

-- Called when a player attempts to spawn a prop.
function MODULE:PlayerSpawnProp(player, model)
	if ( !player:IsAdmin() and resistance.config.Get("cwu_props"):Get() ) then
		if (player:QueryCharacter("faction") == FACTION_CITIZEN) then
			
			if (player:GetCharacterData("customclass") != "Civil Worker's Union") then
				model = string.Replace(model, "\\", "/");
				model = string.Replace(model, "//", "/");
				model = string.lower(model);
				
				if ( string.find(model, "bed") ) then
					resistance.player.Notify(player, "You are not in the Civil Worker's Union!");
					
					return false;
				end;
				
				for k, v in pairs(self.cwuProps) do
					if (string.lower(v) == model) then
						resistance.player.Notify(player, "You are not in the Civil Worker's Union!");
						
						return false;
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player spawns an object.
function MODULE:PlayerSpawnObject(player)
	if ( player:GetSharedVar("sh_Tied") != 0 or self.scanners[player] ) then
		resistance.player.Notify(player, "You don't have permission to do this right now!");
		
		return false;
	end;
end;

-- Called when a player's character data should be restored.
function MODULE:PlayerRestoreCharacterData(player, data)
	if (!self:PlayerIsCombine(player) and player:QueryCharacter("faction") != FACTION_ADMIN) then
		if (!data["citizenid"] or string.len( tostring( data["citizenid"] ) ) == 4) then
			data["citizenid"] = RESISTANCE:ZeroNumberToDigits(math.random(1, 99999), 5);
		end;
	end;
end;

-- Called when a player attempts to breach an entity.
function MODULE:PlayerCanBreachEntity(player, entity)
	if ( resistance.entity.IsDoor(entity) ) then
		if ( !resistance.entity.IsDoorFalse(entity) ) then
			return true;
		end;
	end;
end;

-- Called when a player attempts to restore a recognised name.
function MODULE:PlayerCanRestoreRecognisedName(player, target)
	if ( self:PlayerIsCombine(target) ) then
		return false;
	end;
end;

-- Called when a player attempts to save a recognised name.
function MODULE:PlayerCanSaveRecognisedName(player, target)
	if ( self:PlayerIsCombine(target) ) then
		return false;
	end;
end;

-- Called when a player attempts to use the radio.
function MODULE:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if ( player:HasItem("handheld_radio") or self.scanners[player] ) then
		if ( !player:GetCharacterData("frequency") ) then
			resistance.player.Notify(player, "You need to set the radio frequency first!");
			
			return false;
		end;
	else
		resistance.player.Notify(player, "You do not own a radio!");
		
		return false;
	end;
end;

-- Called when a player's character has initialized.
function MODULE:PlayerCharacterInitialized(player)
	local faction = player:QueryCharacter("faction");
	
	if ( self:PlayerIsCombine(player) ) then
		
		for k, v in pairs(resistance.class.stored) do
			if ( v.factions and table.HasValue(v.factions, faction) ) then
				if ( #g_Team.GetPlayers(v.index) < resistance.class.GetLimit(v.name) ) then
					if ( v.index == CLASS_MPS and self:IsPlayerCombineRank(player, "SCN") ) then
						resistance.class.Set(player, v.index); break;
					elseif ( v.index == CLASS_MPR and self:IsPlayerCombineRank(player, "RCT") ) then
						resistance.class.Set(player, v.index); break;
					elseif ( v.index == CLASS_EMP and self:IsPlayerCombineRank(player, "EpU") ) then
						resistance.class.Set(player, v.index); break;
					elseif ( v.index == CLASS_EOW and self:IsPlayerCombineRank(player, "EOW") ) then
						resistance.class.Set(player, v.index); break;
					end;
				end;
			end;
		end;
	elseif (faction == FACTION_CITIZEN) then
		self:AddCombineDisplayLine( "Rebuilding citizen manifest...", Color(255, 100, 255, 255) );
	end;
end;

-- Called when a player's name has changed.
function MODULE:PlayerNameChanged(player, previousName, newName)
	if ( self:PlayerIsCombine(player) ) then
		local faction = player:QueryCharacter("faction");
		
		if (faction == FACTION_OTA) then
			if ( !self:IsStringCombineRank(previousName, "OWS") and self:IsStringCombineRank(newName, "OWS") ) then
				resistance.class.Set(player, CLASS_OWS);
			elseif ( !self:IsStringCombineRank(previousName, "EOW") and self:IsStringCombineRank(newName, "EOW") ) then
				resistance.class.Set(player, CLASS_EOW);
			end;
		elseif (faction == FACTION_MPF) then
			if ( !self:IsStringCombineRank(previousName, "SCN") and self:IsStringCombineRank(newName, "SCN") ) then
				resistance.class.Set(player, CLASS_MPS, true);
				
				self:MakePlayerScanner(player, true);
			elseif ( !self:IsStringCombineRank(previousName, "RCT") and self:IsStringCombineRank(newName, "RCT") ) then
				resistance.class.Set(player, CLASS_MPR);
			elseif ( !self:IsStringCombineRank(previousName, "EpU") and self:IsStringCombineRank(newName, "EpU") ) then
				resistance.class.Set(player, CLASS_EMP);
			elseif ( !self:IsStringCombineRank(previousName, "OfC") and self:IsStringCombineRank(newName, "OfC") ) then
				player:SetModel("models/policetrench.mdl");
			elseif ( !self:IsStringCombineRank(previousName, "DvL") and self:IsStringCombineRank(newName, "DvL") ) then
				player:SetModel("models/eliteshockcp.mdl");
			elseif ( !self:IsStringCombineRank(previousName, "SeC") and self:IsStringCombineRank(newName, "SeC") ) then
				player:SetModel("models/sect_police2.mdl");
			elseif ( !self:IsStringCombineRank(newName, "RCT") ) then
				if (player:Team() != CLASS_MPU) then
					resistance.class.Set(player, CLASS_MPU);
				end;
			end;
			
			if ( !self:IsStringCombineRank(previousName, "GHOST") and self:IsStringCombineRank(newName, "GHOST") ) then
				player:SetModel("models/eliteghostcp.mdl");
			end;
		end;
	end;
end;

-- Called when a player attempts to use an entity in a vehicle.
function MODULE:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if ( entity:IsPlayer() or resistance.entity.IsPlayerRagdoll(entity) ) then
		return true;
	end;
end;

-- Called when a player presses a key.
function MODULE:KeyPress(player, key)
	if (key == IN_USE) then
		if ( !self.scanners[player] ) then
			local untieTime = MODULE:GetDexterityTime(player);
			local target = player:GetEyeTraceNoCursor().Entity;
			local entity = target;
			
			if ( IsValid(target) ) then
				target = resistance.entity.GetPlayer(target);
				
				if (target and player:GetSharedVar("sh_Tied") == 0) then
					if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
						if (target:GetSharedVar("sh_Tied") != 0) then
							resistance.player.SetAction(player, "untie", untieTime);
							
							resistance.player.EntityConditionTimer(player, target, entity, untieTime, 192, function()
								return player:Alive() and !player:IsRagdolled() and player:GetSharedVar("sh_Tied") == 0;
							end, function(success)
								if (success) then
									self:TiePlayer(target, false);
									
									player:ProgressAttribute(ATB_DEXTERITY, 15, true);
								end;
								
								resistance.player.SetAction(player, "untie", false);
							end);
						end;
					end;
				end;
			end;
		end;
	elseif (key == IN_ATTACK or key == IN_ATTACK2) then
		if ( self.scanners[player] ) then
			local scanner = self.scanners[player][1];
			
			if ( IsValid(scanner) ) then
				player.nextScannerSound = CurTime() + math.random(8, 48);
				
				scanner:EmitSound( self.scannerSounds[ math.random(1, #self.scannerSounds) ] );
			end;
		end;
	elseif (key == IN_RELOAD) then
		if ( self.scanners[player] ) then
			local scanner = self.scanners[player][1];
			local curTime = CurTime();
			local marker = self.scanners[player][2];
			
			if ( IsValid(scanner) ) then
				local position = scanner:GetPos();
				
				for k, v in ipairs( ents.FindInSphere(position, 384) ) do
					if ( v:IsPlayer() and v:HasInitialized() and !self:PlayerIsCombine(v) ) then
						local playerPosition = v:GetPos();
						local scannerDot = scanner:GetAimVector():Dot( (playerPosition - position):Normalize() );
						local playerDot = v:GetAimVector():Dot( (position - playerPosition):Normalize() );
						local threshold = 0.2 + math.Clamp( (0.6 / 384) * playerPosition:Distance(position), 0, 0.6 );
						
						if (resistance.player.CanSeeEntity( v, scanner, 0.9, {marker} ) and playerDot >= threshold and scannerDot >= threshold) then
							if (player != v) then
								if (v:QueryCharacter("faction") == FACTION_CITIZEN) then
									if ( !v:GetForcedAnimation() ) then
										v:SetForcedAnimation("photo_react_blind", 2, function(player)
											player:Freeze(true);
										end, function(player)
											player:Freeze(false);
										end);
									end;
								end;
								
								umsg.Start("roleplay_Stunned", v);
									umsg.Float(3);
								umsg.End();
							end;
						end;
					end;
				end;
				
				scanner:EmitSound("npc/scanner/scanner_photo1.wav");
			end;
		end;
	elseif (key == IN_WALK) then
		if ( self.scanners[player] ) then
			resistance.player.RunResistanceCommand(player, "CharFollow");
		end;
	end;
end;

-- Called each tick.
function MODULE:Tick()
	for k, v in pairs(self.scanners) do
		local scanner = v[1];
		local marker = v[2];
		
		if ( IsValid(k) ) then
			if ( IsValid(scanner) and IsValid(marker) ) then
				if ( k:KeyDown(IN_FORWARD) ) then
					local position = scanner:GetPos() + (scanner:GetForward() * 25) + (scanner:GetUp() * -64);
					
					if ( k:KeyDown(IN_SPEED) ) then
						marker:SetPos( position + (k:GetAimVector() * 64) );
					else
						marker:SetPos( position + (k:GetAimVector() * 128) );
					end;
					
					scanner.followTarget = nil;
				end;
				
				if ( IsValid(scanner.followTarget) ) then
					scanner:Input("SetFollowTarget", scanner.followTarget, scanner.followTarget, "!activator");
				else
					scanner:Fire("SetFollowTarget", "marker_"..k:UniqueID(), 0);
				end;
				
				if ( scannerClass == "npc_cscanner" and self:IsPlayerCombineRank(k, "SYNTH") ) then
					self:MakePlayerScanner(k, true);
				elseif ( scannerClass == "npc_clawscanner" and !self:IsPlayerCombineRank(k, "SYNTH") ) then
					self:MakePlayerScanner(k, true);
				end;
			else
				self:ResetPlayerScanner(k);
			end;
		else
			if ( IsValid(scanner) ) then
				scanner:Remove();
			end;
			
			if ( IsValid(marker) ) then
				marker:Remove();
			end;
			
			self.scanners[k] = nil;
		end;
	end;
end;

-- Called when a player's health is set.
function MODULE:PlayerHealthSet(player, health)
	if ( self.scanners[player] ) then
		if ( IsValid( self.scanners[player][1] ) ) then
			self.scanners[player][1]:SetHealth(health);
		end;
	end;
end;

-- Called when a player attempts to be given a weapon.
function MODULE:PlayerCanBeGivenWeapon(player, class, uniqueID, forceReturn)
	if ( self.scanners[player] ) then
		return false;
	end;
end;

-- Called each frame that a player is dead.
function MODULE:PlayerDeathThink(player)
	if ( player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called when a player attempts to switch to a character.
function MODULE:PlayerCanSwitchCharacter(player, character)
	if ( player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called when a player's death info should be adjusted.
function MODULE:PlayerAdjustDeathInfo(player, info)
	if ( player:GetCharacterData("permakilled") ) then
		info.spawnTime = 0;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function MODULE:PlayerAdjustCharacterScreenInfo(player, character, info)
	if ( character.data["permakilled"] ) then
		info.details = "This character is permanently killed.";
	end;
	
	if (info.faction == FACTION_OTA) then
		if ( self:IsStringCombineRank(info.name, "EOW") ) then
			info.model = "models/combine_super_soldier.mdl";
		end;
	elseif ( self:IsCombineFaction(info.faction) ) then
		if ( self:IsStringCombineRank(info.name, "SCN") ) then
			if ( self:IsStringCombineRank(info.name, "SYNTH") ) then
				info.model = "models/shield_scanner.mdl";
			else
				info.model = "models/combine_scanner.mdl";
			end;
		elseif ( self:IsStringCombineRank(info.name, "SeC") ) then
			info.model = "models/sect_police2.mdl";
		elseif ( self:IsStringCombineRank(info.name, "DvL") ) then
			info.model = "models/eliteshockcp.mdl";
		elseif ( self:IsStringCombineRank(info.name, "EpU") ) then
			info.model = "models/leet_police2.mdl";
		elseif ( self:IsStringCombineRank(info.name, "OfC") ) then
			info.model = "models/policetrench.mdl";
		end;
		
		if ( self:IsStringCombineRank(info.name, "GHOST") ) then
			info.model = "models/eliteghostcp.mdl";
		end;
	end;
	
	if ( character.data["customclass"] ) then
		info.customClass = character.data["customclass"];
	end;
end;

-- Called when a chat box message has been added.
function MODULE:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = resistance.config.Get("talk_radius"):Get();
		local listeners = {};
		local players = g_Player.GetAll();
		local radios = ents.FindByClass("roleplay_radio");
		local data = {};
		
		for k, v in ipairs(radios) do
			if (!v:IsOff() and info.speaker:GetPos():Distance( v:GetPos() ) <= 80) then
				local frequency = v:GetSharedVar("sh_Frequency");
				
				if (frequency != "") then
					info.shouldSend = false;
					info.listeners = {};
					data.frequency = frequency;
					data.position = v:GetPos();
					data.entity = v;
					
					break;
				end;
			end;
		end;
		
		if (IsValid(data.entity) and data.frequency != "") then
			for k, v in ipairs(players) do
				if ( v:HasInitialized() and v:Alive() and !v:IsRagdolled(RAGDOLL_FALLENOVER) ) then
					if ( ( v:GetCharacterData("frequency") == data.frequency and v:GetSharedVar("sh_Tied") == 0
					and v:HasItem("handheld_radio") ) or info.speaker == v ) then
						listeners[v] = v;
					elseif (v:GetPos():Distance(data.position) <= talkRadius) then
						eavesdroppers[v] = v;
					end;
				end;
			end;
			
			for k, v in ipairs(radios) do
				local radioPosition = v:GetPos();
				local radioFrequency = v:GetSharedVar("sh_Frequency");
				
				if (!v:IsOff() and radioFrequency == data.frequency) then
					for k2, v2 in ipairs(players) do
						if ( v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2] ) then
							if ( v2:GetPos():Distance(radioPosition) <= (talkRadius * 2) ) then
								eavesdroppers[v2] = v2;
							end;
						end;
						
						break;
					end;
				end;
			end;
			
			if (table.Count(listeners) > 0) then
				resistance.chatBox.Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				resistance.chatBox.Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			end;
			
			table.Merge(info.listeners, listeners);
			table.Merge(info.listeners, eavesdroppers);
		end;
	end;
	
	if (info.voice) then
		if ( IsValid(info.speaker) and info.speaker:HasInitialized() ) then
			info.speaker:EmitSound(info.voice.sound, info.voice.volume);
		end;
		
		if (info.voice.global) then
			for k, v in pairs(info.listeners) do
				if (v != info.speaker) then
					resistance.player.PlaySound(v, info.voice.sound);
				end;
			end;
		end;
	end;
end;

-- Called when a player has used their radio.
function MODULE:PlayerRadioUsed(player, text, listeners, eavesdroppers)
	local newEavesdroppers = {};
	local talkRadius = resistance.config.Get("talk_radius"):Get() * 2;
	local frequency = player:GetCharacterData("frequency");
	
	for k, v in ipairs( ents.FindByClass("roleplay_radio") ) do
		local radioPosition = v:GetPos();
		local radioFrequency = v:GetSharedVar("sh_Frequency");
		
		if (!v:IsOff() and radioFrequency == frequency) then
			for k2, v2 in ipairs( g_Player.GetAll() ) do
				if ( v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2] ) then
					if (v2:GetPos():Distance(radioPosition) <= talkRadius) then
						newEavesdroppers[v2] = v2;
					end;
				end;
				
				break;
			end;
		end;
	end;
	
	if (table.Count(newEavesdroppers) > 0) then
		resistance.chatBox.Add(newEavesdroppers, player, "radio_eavesdrop", text);
	end;
end;

-- Called when a player's radio info should be adjusted.
function MODULE:PlayerAdjustRadioInfo(player, info)
	for k, v in ipairs( g_Player.GetAll() ) do
		if ( v:HasInitialized() and v:HasItem("handheld_radio") ) then
			if ( v:GetCharacterData("frequency") == player:GetCharacterData("frequency") ) then
				if (v:GetSharedVar("sh_Tied") == 0) then
					info.listeners[v] = v;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to use a tool.
function MODULE:CanTool(player, trace, tool)
	if ( !resistance.player.HasFlags(player, "w") ) then
		if (string.sub(tool, 1, 5) == "wire_" or string.sub(tool, 1, 6) == "wire2_") then
			player:RunCommand("gmod_toolmode \"\"");
			
			return false;
		end;
	end;
end;

-- Called when a player has been healed.
function MODULE:PlayerHealed(player, healer, itemTable)
	if (itemTable.uniqueID == "health_vial") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 2, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 15, true);
	elseif (itemTable.uniqueID == "health_kit") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 3, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 25, true);
	elseif (itemTable.uniqueID == "bandage") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 1, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 5, true);
	end;
end;

-- Called when a player's shared variables should be set.
function MODULE:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "sh_CustomClass", player:GetCharacterData("customclass", "") );
	player:SetSharedVar( "sh_CitizenID", player:GetCharacterData("citizenid", "") );
	player:SetSharedVar( "sh_Clothes", player:GetCharacterData("clothes", 0) );
	player:SetSharedVar( "sh_Icon", player:GetCharacterData("icon", "") );
	
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		local inventoryWeight = resistance.inventory.GetWeight(player);
		
		if (inventoryWeight >= resistance.inventory.GetMaximumWeight(player) / 4) then
			player:ProgressAttribute(ATB_STRENGTH, inventoryWeight / 400, true);
		end;
	end;
end;

-- Called at an interval while a player is connected.
function MODULE:PlayerThink(player, curTime, infoTable)
	if ( player:Alive() and !player:IsRagdolled() ) then
		if (!player:InVehicle() and player:GetMoveType() == MOVETYPE_WALK) then
			if ( player:IsInWorld() ) then
				if ( !player:IsOnGround() ) then
					player:ProgressAttribute(ATB_ACROBATICS, 0.25, true);
				elseif (infoTable.running) then
					player:ProgressAttribute(ATB_AGILITY, 0.125, true);
				elseif (infoTable.jogging) then
					player:ProgressAttribute(ATB_AGILITY, 0.0625, true);
				end;
			end;
		end;
	end;
	
	if ( resistance.player.HasAnyFlags(player, "vV") ) then
		if (infoTable.wages == 0) then
			infoTable.wages = 20;
		end;
	end;
	
	if ( self.scanners[player] ) then
		self:CalculateScannerThink(player, curTime);
	end;
	
	local acrobatics = resistance.attributes.Fraction(player, ATB_ACROBATICS, 100, 50);
	local strength = resistance.attributes.Fraction(player, ATB_STRENGTH, 8, 4);
	local agility = resistance.attributes.Fraction(player, ATB_AGILITY, 50, 25);
	
	if ( self:PlayerIsCombine(player) ) then
		infoTable.inventoryWeight = infoTable.inventoryWeight + 8;
	end;
	
	if (clothes != "") then
		local itemTable = resistance.item.Get(clothes);
		
		if (itemTable and itemTable.pocketSpace) then
			infoTable.inventoryWeight = infoTable.inventoryWeight + itemTable.pocketSpace;
		end;
	end;
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = infoTable.jumpPower + acrobatics;
	infoTable.runSpeed = infoTable.runSpeed + agility;
end;

-- Called when an entity is removed.
function MODULE:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		if (entity.areBelongings and entity.inventory and entity.cash) then
			if (table.Count(entity.inventory) > 0 or entity.cash > 0) then
				local belongings = ents.Create("roleplay_belongings");
				
				belongings:SetAngles( Angle(0, 0, -90) );
				belongings:SetData(entity.inventory, entity.cash);
				belongings:SetPos( entity:GetPos() + Vector(0, 0, 32) );
				belongings:Spawn();
				
				entity.inventory = nil;
				entity.cash = nil;
			end;
		end;
	end;
end;

-- Called when the player attempts to be ragdolled.
function MODULE:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	if ( self.scanners[player] ) then
		return false;
	end;
end;

-- Called when a player attempts to NoClip.
function MODULE:PlayerNoClip(player)
	if ( self.scanners[player] ) then
		return false;
	end;
end;

-- Called when a player's data should be saved.
function MODULE:PlayerSaveData(player, data)
	if (data["serverwhitelist"] and table.Count( data["serverwhitelist"] ) == 0) then
		data["serverwhitelist"] = nil;
	end;
end;

-- Called when a player's data should be restored.
function MODULE:PlayerRestoreData(player, data)
	if ( !data["serverwhitelist"] ) then
		data["serverwhitelist"] = {};
	end;
	
	local serverWhitelistIdentity = resistance.config.Get("server_whitelist_identity"):Get();
	
	if (serverWhitelistIdentity != "") then
		if ( !data["serverwhitelist"][serverWhitelistIdentity] ) then
			player:Kick("You aren't whitelisted");
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

-- Called when a player's attribute has been updated.
function MODULE:PlayerAttributeUpdated(player, attributeTable, amount)
	if (self:PlayerIsCombine(player) and amount and amount > 0) then
		self:AddCombineDisplayLine("Updating external "..resistance.module.GetOption("name_attributes", true).."...", Color(255, 125, 0, 255), player);
	end;
end;

-- Called to check if a player does recognise another player.
function MODULE:PlayerDoesRecognisePlayer(player, target, status, simple, default)
	if (self:PlayerIsCombine(target) or target:QueryCharacter("faction") == FACTION_ADMIN) then
		return true;
	end;
end;

-- Called when a player attempts to delete a character.
function MODULE:PlayerCanDeleteCharacter(player, character)
	if ( character.data["permakilled"] ) then
		return true;
	end;
end;

-- Called when a player attempts to use a character.
function MODULE:PlayerCanUseCharacter(player, character)
	if ( character.data["permakilled"] ) then
		return character.name.." is permanently killed and cannot be used!";
	elseif (character.faction == FACTION_MPF) then
		if ( self:IsStringCombineRank(character.name, "SCN") ) then
			local amount = 0;
			
			for k, v in ipairs( g_Player.GetAll() ) do
				if ( v:HasInitialized() and self:PlayerIsCombine(v) ) then
					if ( self:IsPlayerCombineRank(v, "SCN") ) then
						amount = amount + 1;
					end;
				end;
			end;
			
			if (amount >= 3) then
				return "There are too many scanners online!";
			end;
		end;
	end;
end;

-- Called when attempts to use a command.
function MODULE:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetSharedVar("sh_Tied") != 0) then
		local blacklisted = {
			"OrderShipment",
			"Broadcast",
			"Dispatch",
			"Request",
			"Radio"
		};
		
		if ( table.HasValue(blacklisted, commandTable.name) ) then
			resistance.player.Notify(player, "You cannot use this command when you are tied!");
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to use a door.
function MODULE:PlayerCanUseDoor(player, door)
	if ( player:GetSharedVar("sh_Tied") != 0 or (!self:PlayerIsCombine(player) and player:QueryCharacter("faction") != FACTION_ADMIN) ) then
		return false;
	end;
end;

-- Called when a player attempts to lock an entity.
function MODULE:PlayerCanLockEntity(player, entity)
	if ( resistance.entity.IsDoor(entity) and IsValid(entity.combineLock) ) then
		if ( resistance.config.Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked() ) then
			return false;
		end;
	end;
end;

-- Called when a player attempts to unlock an entity.
function MODULE:PlayerCanUnlockEntity(player, entity)
	if ( resistance.entity.IsDoor(entity) and IsValid(entity.combineLock) ) then
		if ( resistance.config.Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked() ) then
			return false;
		end;
	end;
end;

-- Called when a player's character has unloaded.
function MODULE:PlayerCharacterUnloaded(player)
	self:ResetPlayerScanner(player);
end;

-- Called when a player attempts to change class.
function MODULE:PlayerCanChangeClass(player, class)
	if (player:GetSharedVar("sh_Tied") != 0) then
		resistance.player.Notify(player, "You cannot change classes when you are tied!");
		
		return false;
	elseif ( self:PlayerIsCombine(player) ) then
		if ( class == CLASS_MPS and !self:IsPlayerCombineRank(player, "SCN") ) then
			resistance.player.Notify(player, "You are not ranked high enough for this class!");
			
			return false;
		elseif ( class == CLASS_MPR and !self:IsPlayerCombineRank(player, "RCT") ) then
			resistance.player.Notify(player, "You are not ranked high enough for this class!");
			
			return false;
		elseif ( class == CLASS_EMP and !self:IsPlayerCombineRank(player, "EpU") ) then
			resistance.player.Notify(player, "You are not ranked high enough for this class!");
			
			return false;
		elseif ( class == CLASS_OWS and !self:IsPlayerCombineRank(player, "OWS") ) then
			resistance.player.Notify(player, "You are not ranked high enough for this class!");
			
			return false;
		elseif ( class == CLASS_EOW and !self:IsPlayerCombineRank(player, "EOW") ) then
			resistance.player.Notify(player, "You are not ranked high enough for this class!");
			
			return false;
		elseif (class == CLASS_MPU) then
			if ( self:IsPlayerCombineRank(player, "EpU") ) then
				resistance.player.Notify(player, "You are ranked too high for this class!");
				
				return false;
			elseif ( self:IsPlayerCombineRank(player, "RCT") ) then
				resistance.player.Notify(player, "You are not ranked high enough for this class!");
				
				return false;
			end;
		end;
	end;
end;

-- Called when a player attempts to use an entity.
function MODULE:PlayerUse(player, entity)
	local overlayText = entity:GetNetworkedString("GModOverlayText");
	local curTime = CurTime();
	local faction = player:QueryCharacter("faction");
	
	if ( string.find(overlayText, "CA") ) then
		if (faction != FACTION_ADMIN) then
			return false;
		end;
	elseif ( string.find(overlayText, "OTA") ) then
		if (faction != FACTION_ADMIN and faction != FACTION_OTA) then
			return false;
		end;
	elseif ( string.find(overlayText, "MPF") ) then
		if (faction != FACTION_ADMIN and faction != FACTION_OTA and faction != FACTION_MPF) then
			return false;
		end;
	elseif ( string.find(overlayText, "CWU") ) then
		if (faction != FACTION_ADMIN and faction != FACTION_OTA and faction != FACTION_MPF) then
			if (player:GetCharacterData("customclass") != "Civil Worker's Union") then
				return false;
			end;
		end;
	end;
	
	if ( self.scanners[player] ) then
		return false;
	end;
	
	if (entity.bustedDown) then
		return false;
	end;
	
	if ( player:KeyDown(IN_SPEED) and resistance.entity.IsDoor(entity) ) then
		if ( (self:PlayerIsCombine(player) or player:QueryCharacter("faction") == FACTION_ADMIN) and IsValid(entity.combineLock) ) then
			if (!player.nextCombineLock or curTime >= player.nextCombineLock) then
				entity.combineLock:ToggleWithChecks(player);
				
				player.nextCombineLock = curTime + 3;
			end;
			
			return false;
		end;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		if ( entity:IsVehicle() ) then
			if ( resistance.entity.IsChairEntity(entity) or resistance.entity.IsPodEntity(entity) ) then
				return;
			end;
		end;
		
		if ( !player.nextTieNotify or player.nextTieNotify < CurTime() ) then
			resistance.player.Notify(player, "You cannot use that when you are tied!");
			
			player.nextTieNotify = CurTime() + 2;
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to destroy an item.
function MODULE:PlayerCanDestroyItem(player, itemTable, noMessage)
	if ( self.scanners[player] ) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot destroy items when you are a scanner!");
		end;
		
		return false;
	elseif (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot destroy items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function MODULE:PlayerCanDropItem(player, itemTable, noMessage)
	if ( self.scanners[player] ) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot drop items when you are a scanner!");
		end;
		
		return false;
	elseif (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot drop items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function MODULE:PlayerCanUseItem(player, itemTable, noMessage)
	if ( self.scanners[player] ) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot use items when you are a scanner!");
		end;
		
		return false;
	elseif (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			resistance.player.Notify(player, "You cannot use items when you are tied!");
		end;
		
		return false;
	end;
	
	if (resistance.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
		local secondaryWeapon;
		local primaryWeapon;
		local sideWeapon;
		local fault;
		
		for k, v in ipairs( player:GetWeapons() ) do
			local weaponTable = resistance.item.GetWeapon(v);
			
			if (weaponTable and !weaponTable.fakeWeapon) then
				if (weaponTable.weight >= 1) then
					if (weaponTable.weight <= 2) then
						secondaryWeapon = true;
					else
						primaryWeapon = true;
					end;
				else
					sideWeapon = true;
				end;
			end;
		end;
		
		if (itemTable.weight >= 1) then
			if (itemTable.weight <= 2) then
				if (secondaryWeapon) then
					fault = "You cannot use another secondary weapon!";
				end;
			elseif (primaryWeapon) then
				fault = "You cannot use another secondary weapon!";
			end;
		elseif (sideWeapon) then
			fault = "You cannot use another melee weapon!";
		end;
		
		if (fault) then
			if (!noMessage) then
				resistance.player.Notify(player, fault);
			end;
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to earn generator cash.
function MODULE:PlayerCanEarnGeneratorCash(player, info, cash)
	if ( self:PlayerIsCombine(player) ) then
		return false;
	end;
end;

-- Called when a player's death sound should be played.
function MODULE:PlayerPlayDeathSound(player, gender)
	if ( self:PlayerIsCombine(player) ) then
		local sound = "npc/metropolice/die"..math.random(1, 4)..".wav";
		
		for k, v in ipairs( g_Player.GetAll() ) do
			if ( v:HasInitialized() ) then
				if ( self:PlayerIsCombine(v) ) then
					v:EmitSound(sound);
				end;
			end;
		end;
		
		return sound;
	end;
end;

-- Called when a player's pain sound should be played.
function MODULE:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if ( self:PlayerIsCombine(player) ) then
		return "npc/metropolice/pain"..math.random(1, 4)..".wav";
	end;
end;
-- Called when chat box info should be adjusted.
function MODULE:ChatBoxAdjustInfo(info)
	if (info.class != "ooc" and info.class != "looc") then
		if ( IsValid(info.speaker) and info.speaker:HasInitialized() ) then
			if (string.sub(info.text, 1, 1) == "?") then
				info.text = string.sub(info.text, 2);
				info.data.anon = true;
			end;
		end;
	end;
	
	if (info.class == "ic" or info.class == "yell" or info.class == "radio" or info.class == "whisper" or info.class == "request") then
		if ( IsValid(info.speaker) and info.speaker:HasInitialized() ) then
			local playerIsCombine = self:PlayerIsCombine(info.speaker);
			
			if ( playerIsCombine and self:IsPlayerCombineRank(info.speaker, "SCN") ) then
				for k, v in pairs(self.dispatchVoices) do
					if ( string.lower(info.text) == string.lower(v.command) ) then
						local voice = {
							global = false,
							volume = 90,
							sound = v.sound
						};
						
						if (info.class == "request" or info.class == "radio") then
							voice.global = true;
						elseif (info.class == "whisper") then
							voice.volume = 80;
						elseif (info.class == "yell") then
							voice.volume = 100;
						end;
						
						info.text = "<:: "..v.phrase;
						info.voice = voice;
						
						return true;
					end;
				end;
			else
				for k, v in pairs(self.voices) do
					if ( (v.faction == "Combine" and playerIsCombine) or (v.faction == "Human" and !playerIsCombine) ) then
						if ( string.lower(info.text) == string.lower(v.command) ) then
							local voice = {
								global = false,
								volume = 80,
								sound = v.sound
							};
							
							if (v.female and info.speaker:QueryCharacter("gender") == GENDER_FEMALE) then
								voice.sound = string.Replace(voice.sound, "/male", "/female");
							end;
							
							if (info.class == "request" or info.class == "radio") then
								voice.global = true;
							elseif (info.class == "whisper") then
								voice.volume = 60;
							elseif (info.class == "yell") then
								voice.volume = 100;
							end;
							
							if (playerIsCombine) then
								info.text = "<:: "..v.phrase;
							else
								info.text = v.phrase;
							end;
							
							info.voice = voice;
							
							return true;
						end;
					end;
				end;
			end;
			
			if (playerIsCombine) then
				if (string.sub(info.text, 1, 4) != "<:: ") then
					info.text = "<:: "..info.text;
				end;
			end;
		end;
	elseif (info.class == "dispatch") then
		for k, v in pairs(self.dispatchVoices) do
			if ( string.lower(info.text) == string.lower(v.command) ) then
				resistance.player.PlaySound(nil, v.sound);
				
				info.text = v.phrase;
				
				return true;
			end;
		end;
	end;
end;

-- Called when a player destroys generator.
function MODULE:PlayerDestroyGenerator(player, entity, generator)
	if ( self:PlayerIsCombine(player) ) then
		local players = {};
		
		for k, v in ipairs( g_Player.GetAll() ) do
			if ( v:HasInitialized() ) then
				if ( self:PlayerIsCombine(v) ) then
					players[#players + 1] = v;
				end;
			end;
		end;
		
		for k, v in pairs(players) do
			resistance.player.GiveCash( v, generator.cash / 4, "destroying a "..string.lower(generator.name) );
		end;
	else
		resistance.player.GiveCash( v, generator.cash / 4, "destroying a "..string.lower(generator.name) );
	end;
end;

-- Called just before a player dies.
function MODULE:DoPlayerDeath(player, attacker, damageInfo)
	local clothes = player:GetCharacterData("clothes");
	
	if (clothes) then
		player:UpdateInventory(clothes);
		player:SetCharacterData("clothes", nil);
	end;
	
	player.beingSearched = nil;
	player.searching = nil;
	
	self:TiePlayer(player, false, true);
end;

-- Called when a player dies.
function MODULE:PlayerDeath(player, inflictor, attacker, damageInfo)
	if ( self:PlayerIsCombine(player) ) then
		local location = self:PlayerGetLocation(player);
		
		self:AddCombineDisplayLine("Downloading lost biosignal...", Color(255, 255, 255, 255), nil, player);
		self:AddCombineDisplayLine("WARNING! Biosignal lost for protection team unit at "..location.."...", Color(255, 0, 0, 255), nil, player);
		
		if ( self.scanners[player] ) then
			if ( IsValid( self.scanners[player][1] ) ) then
				if (damageInfo != true) then
					self.scanners[player][1]:TakeDamage(self.scanners[player][1]:Health() + 100);
				end;
			end;
		end;
		
		for k, v in ipairs( g_Player.GetAll() ) do
			if ( self:PlayerIsCombine(v) ) then
				v:EmitSound("npc/overwatch/radiovoice/on1.wav");
				v:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav");
			end;
		end;
		
		timer.Simple(1.5, function()
			for k, v in ipairs( g_Player.GetAll() ) do
				if ( self:PlayerIsCombine(v) ) then
					v:EmitSound("npc/overwatch/radiovoice/off4.wav");
				end;
			end;
		end);
	end;
	
	if ( !player:GetCharacterData("permakilled") ) then
		if ( ( attacker:IsPlayer() or attacker:IsNPC() ) and damageInfo ) then
			local miscellaneousDamage = damageInfo:IsBulletDamage() or damageInfo:IsFallDamage() or damageInfo:IsExplosionDamage();
			local meleeDamage = damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
			
			if (miscellaneousDamage or meleeDamage) then
				if (RESISTANCE:GetSharedVar("sh_PKMode") == 1) then
					self:PermaKillPlayer( player, player:GetRagdollEntity() );
				end;
			end;
		end;
	end;
end;

-- Called when a player's character has loaded.
function MODULE:PlayerCharacterLoaded(player)
	player:SetSharedVar("sh_PermaKilled", false);
	player:SetSharedVar("sh_Tied", 0);
end;

-- Called when a player attempts to switch to a character.
function MODULE:PlayerCanSwitchCharacter(player, character)
	if (player:GetSharedVar("sh_Tied") != 0) then
		return false, "You cannot switch to this character while tied!";
	end;
end;

-- Called just after a player spawns.
function MODULE:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local clothes = player:GetCharacterData("clothes");
	
	if (!lightSpawn) then
		player:SetSharedVar("sh_Antidepressants", 0);
		
		umsg.Start("roleplay_ClearEffects", player);
		umsg.End();
		
		player.beingSearched = nil;
		player.searching = nil;
		
		if (self:PlayerIsCombine(player) or player:QueryCharacter("faction") == FACTION_ADMIN) then
			if (player:QueryCharacter("faction") == FACTION_OTA) then
				player:SetMaxHealth(150);
				player:SetMaxArmor(150);
				player:SetHealth(150);
				player:SetArmor(150);
			elseif ( !self:IsPlayerCombineRank(player, "RCT") ) then
				player:SetArmor(100);
			else
				player:SetArmor(50);
			end;
		end;
		
		if (self:PlayerIsCombine(player) and player:GetAmmoCount("pistol") == 0) then
			if ( !player:HasItem("ammo_pistol") ) then
				player:UpdateInventory("ammo_pistol", 1, true, true);
			end;
		end;
	end;
	
	if ( self:IsPlayerCombineRank(player, "SCN") ) then
		self:MakePlayerScanner(player, true, lightSpawn);
	else
		self:ResetPlayerScanner(player);
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		self:TiePlayer(player, true);
	end;
	
	if (clothes) then
		local itemTable = resistance.item.Get(clothes);
		
		if ( itemTable and player:HasItem(itemTable.uniqueID) ) then
			self:PlayerWearClothes(player, itemTable);
		else
			player:SetCharacterData("clothes", nil);
		end;
	end;
end;

-- Called when a player spawns lightly.
function MODULE:PostPlayerLightSpawn(player, weapons, ammo, special)
	local clothes = player:GetCharacterData("clothes");
	
	if (clothes) then
		local itemTable = resistance.item.Get(clothes);
		
		if (itemTable) then
			itemTable:OnChangeClothes(player, true);
		end;
	end;
end;

-- Called when a player throws a punch.
function MODULE:PlayerPunchThrown(player)
	player:ProgressAttribute(ATB_STRENGTH, 0.25, true);
end;

-- Called when a player punches an entity.
function MODULE:PlayerPunchEntity(player, entity)
	if ( entity:IsPlayer() or entity:IsNPC() ) then
		player:ProgressAttribute(ATB_STRENGTH, 1, true);
	else
		player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	end;
end;

-- Called when an entity has been breached.
function MODULE:EntityBreached(entity, activator)
	if ( resistance.entity.IsDoor(entity) ) then
		if ( !IsValid(entity.combineLock) ) then
			if (!IsValid(activator) or string.lower( entity:GetClass() ) == "prop_door_rotating") then
				resistance.entity.OpenDoor(entity, 0, true, true);
			else
				self:BustDownDoor(activator, entity);
			end;
		elseif ( IsValid(activator) and activator:IsPlayer() and self:PlayerIsCombine(activator) ) then
			if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
				entity.combineLock:ActivateSmokeCharge( (entity:GetPos() - activator:GetPos() ):Normalize() * 10000 );
			else
				entity.combineLock:SetFlashDuration(2);
			end;
		else
			entity.combineLock:SetFlashDuration(2);
		end;
	end;
end;

-- Called when a player takes damage.
function MODULE:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local curTime = CurTime();
	
	if (player:Armor() <= 0) then
		umsg.Start("roleplay_Stunned", player);
			umsg.Float(0.5);
		umsg.End();
	else
		umsg.Start("roleplay_Stunned", player);
			umsg.Float(1);
		umsg.End();
	end;
	
	if (damageInfo:IsBulletDamage() and hitGroup) then
		if (!player.nextAttributeLoss or curTime >= player.nextAttributeLoss) then
			player.nextAttributeLoss = curTime + 5;
			
			if (hitGroup == HITGROUP_HEAD) then
				player:BoostAttribute("Body Damage", ATB_MEDICAL, -25, 600, true);
				player:BoostAttribute("Body Damage", ATB_AGILITY, -25, 600, true);
			elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
				player:BoostAttribute("Body Damage", ATB_ENDURANCE, -25, 600, true);
			elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
				player:BoostAttribute("Body Damage", ATB_ACROBATICS, -25, 600, true);
				player:BoostAttribute("Body Damage", ATB_STAMINA, -25, 600, true);
				player:BoostAttribute("Body Damage", ATB_AGILITY, -25, 600, true);
			elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
				player:BoostAttribute("Body Damage", ATB_DEXTERITY, -25, 600, true);
				player:BoostAttribute("Body Damage", ATB_STRENGTH, -25, 600, true);
				player:BoostAttribute("Body Damage", ATB_MEDICAL, -25, 600, true);
			end;
		end;
	end;
end;

-- A function to scale damage by hit group.
function MODULE:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local endurance = resistance.attributes.Fraction(player, ATB_ENDURANCE, 0.75, 0.75);
	local clothes = player:GetCharacterData("clothes");
	
	damageInfo:ScaleDamage(1.5 - endurance);
	
	if ( damageInfo:IsBulletDamage() ) then
		if ( clothes and damageInfo:IsBulletDamage() ) then
			local itemTable = resistance.item.Get(clothes);
			
			if (itemTable and itemTable.protection) then
				damageInfo:ScaleDamage(1 - itemTable.protection);
			end;
		end;
	end;
end;

-- Called when an entity takes damage.
function MODULE:EntityTakeDamage(entity, inflictor, attacker, amount, damageInfo)
	local player = resistance.entity.GetPlayer(entity);
	local curTime = CurTime();
	local doDoorDamage;
	
	if (player) then
		if (!player.nextEnduranceTime or CurTime() > player.nextEnduranceTime) then
			player:ProgressAttribute(ATB_ENDURANCE, math.Clamp(damageInfo:GetDamage(), 0, 75) / 10, true);
			player.nextEnduranceTime = CurTime() + 2;
		end;
		
		if ( self.scanners[player] ) then
			entity:EmitSound("npc/scanner/scanner_pain"..math.random(1, 2)..".wav");
			
			if (entity:Health() > 50 and entity:Health() - damageInfo:GetDamage() <= 50) then
				entity:EmitSound("npc/scanner/scanner_siren1.wav");
			elseif (entity:Health() > 25 and entity:Health() - damageInfo:GetDamage() <= 25) then
				entity:EmitSound("npc/scanner/scanner_siren2.wav");
			end;
		end;
		
		if ( attacker:IsPlayer() and self:PlayerIsCombine(player) ) then
			if (attacker != player) then
				local location = MODULE:PlayerGetLocation(player);
				
				if (!player.nextUnderFire or curTime >= player.nextUnderFire) then
					player.nextUnderFire = curTime + 15;
					
					MODULE:AddCombineDisplayLine("Downloading trauma packet...", Color(255, 255, 255, 255), nil, player);
					MODULE:AddCombineDisplayLine("WARNING! Protection team unit enduring physical bodily trauma at "..location.."...", Color(255, 0, 0, 255), nil, player);
				end;
			end;
		end;
	end;
	
	if ( attacker:IsPlayer() ) then
		local strength = resistance.attributes.Fraction(attacker, ATB_STRENGTH, 1, 0.5);
		local weapon = resistance.player.GetWeaponClass(attacker);
		
		if ( damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH) ) then
			damageInfo:ScaleDamage(1 + strength);
		end;
		
		if (weapon == "weapon_357") then
			damageInfo:ScaleDamage(0.25);
		elseif (weapon == "weapon_crossbow") then
			damageInfo:ScaleDamage(2);
		elseif (weapon == "weapon_shotgun") then
			damageInfo:ScaleDamage(3);
			
			doDoorDamage = true;
		elseif (weapon == "weapon_crowbar") then
			damageInfo:ScaleDamage(0.25);
		elseif (weapon == "roleplay_stunstick") then
			if (player) then
				if (player:Health() <= 10) then
					damageInfo:ScaleDamage(0.5);
				end;
			end;
		end;
		
		if (damageInfo:IsBulletDamage() and weapon != "weapon_shotgun") then
			if ( !IsValid(entity.combineLock) and !IsValid(entity.breach) ) then
				if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
					if ( !resistance.entity.IsDoorFalse(entity) ) then
						local damagePosition = damageInfo:GetDamagePosition();
						
						if (entity:WorldToLocal(damagePosition):Distance( Vector(-1.0313, 41.8047, -8.1611) ) <= 8) then
							entity.doorHealth = math.min( (entity.doorHealth or 50) - damageInfo:GetDamage(), 0 );
							
							local effectData = EffectData();
							
							effectData:SetStart(damagePosition);
							effectData:SetOrigin(damagePosition);
							effectData:SetScale(8);
							
							util.Effect("GlassImpact", effectData, true, true);
							
							if (entity.doorHealth <= 0) then
								resistance.entity.OpenDoor( entity, 0, true, true, attacker:GetPos() );
								
								entity.doorHealth = 50;
							else
								RESISTANCE:CreateTimer("Reset Door Health: "..entity:EntIndex(), 60, 1, function()
									if ( IsValid(entity) ) then
										entity.doorHealth = 50;
									end;
								end);
							end;
						end;
					end;
				end;
			end;
		end;
		
		if ( damageInfo:IsExplosionDamage() ) then
			damageInfo:ScaleDamage(2);
		end;
	elseif ( attacker:IsNPC() ) then
		damageInfo:ScaleDamage(0.5);
	end;
	
	if (damageInfo:IsExplosionDamage() or doDoorDamage) then
		if ( !IsValid(entity.combineLock) and !IsValid(entity.breach) ) then
			if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
				if ( !resistance.entity.IsDoorFalse(entity) ) then
					if (attacker:GetPos():Distance( entity:GetPos() ) <= 96) then
						entity.doorHealth = math.min( (entity.doorHealth or 50) - damageInfo:GetDamage(), 0 );
						
						local damagePosition = damageInfo:GetDamagePosition();
						local effectData = EffectData();
						
						effectData:SetStart(damagePosition);
						effectData:SetOrigin(damagePosition);
						effectData:SetScale(8);
						
						util.Effect("GlassImpact", effectData, true, true);
						
						if (entity.doorHealth <= 0) then
							self:BustDownDoor(attacker, entity);
							
							entity.doorHealth = 50;
						else
							RESISTANCE:CreateTimer("Reset Door Health: "..entity:EntIndex(), 60, 1, function()
								if ( IsValid(entity) ) then
									entity.doorHealth = 50;
								end;
							end);
						end;
					end;
				end;
			end;
		end;
	end;
end;