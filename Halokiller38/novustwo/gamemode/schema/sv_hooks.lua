--[[
Name: "sh_hooks.lua".
Product: "Novus Two".
--]]

-- Called when an NPC is killed.
function SCHEMA:OnNPCKilled(entity, attacker, weapon)
	local class = entity:GetClass();
	
	if (class == "npc_pigeon" or class == "npc_crow" or class == "npc_seagull") then
		nexus.entity.CreateItem( nil, "bird_meat", entity:GetPos() + Vector(0, 0, 8) );
	end;
end;

-- Called when a player attempts to lock an entity.
function SCHEMA:PlayerCanLockEntity(player, entity)
	if (nexus.entity.GetDoorName(entity) == "Civilian Insurgency") then
		if (player:Team() == CLASS_INSURGENCY) then
			return true;
		end;
	elseif (nexus.entity.GetDoorName(entity) == "National Guard") then
		if (player:Team() == CLASS_GUARD) then
			return true;
		end;
	end;
end;

-- Called when a player attempts to unlock an entity.
function SCHEMA:PlayerCanUnlockEntity(player, entity)
	if (nexus.entity.GetDoorName(entity) == "Civilian Insurgency") then
		if (player:Team() == CLASS_INSURGENCY) then
			return true;
		end;
	elseif (nexus.entity.GetDoorName(entity) == "National Guard") then
		if (player:Team() == CLASS_GUARD) then
			return true;
		end;
	end;
end;

-- Called when a player uses an unknown item function.
function SCHEMA:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (itemFunction == "Cash" and itemTable.cost) then
		if ( nexus.player.HasFlags(player, "T") ) then
			local useSounds = {"buttons/button5.wav", "buttons/button4.wav"};
			
			player:UpdateInventory(itemTable.uniqueID, -1, true);
			player:EmitSound( useSounds[ math.random(1, #useSounds) ] );
			
			nexus.player.GiveCash(player, math.Round(itemTable.cost / 2), "scrapped an item");
		end;
	end;
end;

-- Called when a player attempts to use a door.
function SCHEMA:PlayerCanUseDoor(player, door)
	if (player:GetSharedVar("sh_Tied") != 0) then
		return false;
	end;
end;

-- Called when a player's character data should be restored.
function SCHEMA:PlayerRestoreCharacterData(player, data)
	local unixTime = os.time();
	
	if ( data["tempkilled"] and os.time() >= data["tempkilled"] ) then
		data["tempkilled"] = nil;
	end;
end;

-- Called when a player's character has loaded.
function SCHEMA:PlayerCharacterLoaded(player)
	player:SetSharedVar("sh_PermaKilled", false);
	player:SetSharedVar("sh_TempKilled", false);
	player:SetSharedVar("sh_Tied", 0);
end;

-- Called when a player attempts to switch to a character.
function SCHEMA:PlayerCanSwitchCharacter(player, character)
	if ( player:GetCharacterData("permakilled")
	or player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called each frame that a player is dead.
function SCHEMA:PlayerDeathThink(player)
	if ( player:GetCharacterData("permakilled")
	or player:GetCharacterData("tempkilled") ) then
		return true;
	end;
end;

-- Called when a player's death info should be adjusted.
function SCHEMA:PlayerAdjustDeathInfo(player, info)
	if ( player:GetCharacterData("permakilled")
	or player:GetCharacterData("tempkilled") ) then
		info.spawnTime = 0;
	end;
end;

-- Called when a player attempts to use a lowered weapon.
function SCHEMA:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if ( secondary and (weapon.SilenceTime or weapon.PistolBurst) ) then
		return true;
	end;
end;

-- Called when a player's default inventory is needed.
function SCHEMA:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_INSURGENCY) then
		local smgs = {
			{"weapon_remington", "ammo_buckshot"},
			{"weapon_ak47", "ammo_smg1"},
			{"weapon_mp5", "ammo_pistol"},
			{"rcs_ump", "ammo_pistol"},
			{"rcs_p90", "ammo_xbowbolt"}
		};
		
		local pistols = {
			{"weapon_fiveseven", "ammo_xbowbolt"},
			{"weapon_mac10", "ammo_pistol"},
			{"weapon_glock", "ammo_pistol"},
			{"rcs_p228", "ammo_pistol"}
		};
		
		local smg = smgs[ math.random(1, #smgs) ];
		
		if (smg) then
			inventory[ smg[2] ] = 3;
			inventory[ smg[1] ] = 1;
		end;
		
		local pistol = pistols[ math.random(1, #pistols) ];
		
		if (pistol) then
			inventory[ pistol[2] ] = 3;
			inventory[ pistol[1] ] = 1;
		end;
		
		inventory["handheld_radio"] = 1;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;
	elseif (character.faction == FACTION_GUARD) then
		inventory["handheld_radio"] = 1;
		inventory["rcs_uspmatch"] = 1;
		inventory["weapon_m4a1"] = 1;
		inventory["ammo_pistol"] = 3;
		inventory["ammo_smg1"] = 3;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;
	end;
end;

-- Called when nexus has initialized.
function SCHEMA:NexusInitialized()
	self.trashItems = {};
	
	for k, v in pairs( nexus.item.GetAll() ) do
		if (v.category == "Junk" and !v.isBaseItem) then
			self.trashItems[#self.trashItems + 1] = v;
		end;
	end;
end;

-- Called each frame.
function SCHEMA:Tick()
	local curTime = CurTime();
	local totalItems = #ents.FindByClass("nx_item");
	
	if (!self.nextTrashSpawns) then
		self.nextTrashSpawns = curTime + math.random(1800, 3600);
	end;
	
	if (curTime >= self.nextTrashSpawns and #self.trashSpawns > 0
	and totalItems < 40) then
		self.nextTrashSpawns = nil;
		
		math.randomseed(curTime);
		
		local totalWorth = 0;
		local targetWorth = (40 - totalItems);
		
		while (totalWorth < targetWorth) do
			local trashItem = self:GetRandomTrashItem();
			local position = self:GetRandomTrashSpawn();
				totalWorth = totalWorth + trashItem.worth;
			nexus.entity.CreateItem(nil, trashItem.uniqueID, position);
		end;
	end;
end;

-- Called when nexus has loaded all of the entities.
function SCHEMA:NexusInitPostEntity()
	self:LoadStaticProps();
	self:LoadTrashSpawns();
	self:LoadBelongings();
	self:LoadRadios();
end;

-- Called just after data should be saved.
function SCHEMA:PostSaveData()
	self:SaveStaticProps();
	self:SaveBelongings();
	self:SaveRadios();
end;

-- Called when a player switches their flashlight on or off.
function SCHEMA:PlayerSwitchFlashlight(player, on)
	if (on and player:GetSharedVar("sh_Tied") != 0) then
		return false;
	end;
end;

-- Called when a player's storage should close.
function SCHEMA:PlayerStorageShouldClose(player, storage)
	local entity = player:GetStorageEntity();
	
	if (player.searching and entity:IsPlayer() and entity:GetSharedVar("sh_Tied") == 0) then
		return true;
	end;
end;

-- Called when a player attempts to spray their tag.
function SCHEMA:PlayerSpray(player)
	if (!player:HasItem("spray_can") or player:GetSharedVar("sh_Tied") != 0) then
		return true;
	end;
end;

-- Called when a player presses F3.
function SCHEMA:ShowSpare1(player)
	nexus.player.RunNexusCommand(player, "InvAction", "zip_tie", "use");
end;

-- Called when a player presses F4.
function SCHEMA:ShowSpare2(player)
	nexus.player.RunNexusCommand(player, "CharSearch");
end;

-- Called when a player's drop weapon info should be adjusted.
function SCHEMA:PlayerAdjustDropWeaponInfo(player, info)
	if (nexus.player.GetWeaponClass(player) == info.itemTable.weaponClass) then
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
function SCHEMA:PlayerGivenWeapon(player, class, uniqueID, forceReturn)
	local itemTable = nexus.item.GetWeapon(class, uniqueID);
	
	if (nexus.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
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

-- Called when a player spawns an object.
function SCHEMA:PlayerSpawnObject(player)
	if (player:GetSharedVar("sh_Tied") != 0) then
		nexus.player.Notify(player, "You don't have permission to do this right now!");
		
		return false;
	end;
end;

-- Called when a player attempts to breach an entity.
function SCHEMA:PlayerCanBreachEntity(player, entity)
	if ( nexus.entity.IsDoor(entity) ) then
		if ( !nexus.entity.IsDoorFalse(entity) ) then
			return true;
		end;
	end;
end;

-- Called when a player attempts to use the radio.
function SCHEMA:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if ( player:HasItem("handheld_radio") ) then
		if ( !player:GetCharacterData("frequency") ) then
			nexus.player.Notify(player, "You need to set the radio frequency first!");
			
			return false;
		end;
	else
		nexus.player.Notify(player, "You do not own a radio!");
		
		return false;
	end;
end;

-- Called when a player attempts to use an entity in a vehicle.
function SCHEMA:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if ( entity:IsPlayer() or nexus.entity.IsPlayerRagdoll(entity) ) then
		return true;
	end;
end;

-- Called when a player presses a key.
function SCHEMA:KeyPress(player, key)
	if (key == IN_USE) then
		local untieTime = SCHEMA:GetDexterityTime(player);
		local eyeTrace = player:GetEyeTraceNoCursor();
		local target = eyeTrace.Entity;
		local entity = target;
		
		if ( IsValid(target) ) then
			target = nexus.entity.GetPlayer(target);
			
			if (target and player:GetSharedVar("sh_Tied") == 0) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					if ( target:GetSharedVar("sh_Tied") != 0 and target:Alive() ) then
						nexus.player.SetAction(player, "untie", untieTime);
						
						nexus.player.EntityConditionTimer(player, target, entity, untieTime, 192, function()
							return player:Alive() and target:Alive() and !player:IsRagdolled() and player:GetSharedVar("sh_Tied") == 0;
						end, function(success)
							if (success) then
								self:TiePlayer(target, false);
								
								player:ProgressAttribute(ATB_DEXTERITY, 15, true);
							end;
							
							nexus.player.SetAction(player, "untie", false);
						end);
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function SCHEMA:PlayerAdjustCharacterScreenInfo(player, character, info)
	if ( character.data["permakilled"] ) then
		info.details = "This character is permanently killed.";
	elseif ( character.data["tempkilled"] ) then
		info.details = "This character is temporarily killed";
	end;
end;

-- Called when a player has been healed.
function SCHEMA:PlayerHealed(player, healer, itemTable)
	local action = nexus.player.GetAction(player);
	
	if (itemTable.uniqueID == "antibiotics") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 2, 600);
		healer:ProgressAttribute(ATB_MEDICAL, 15, true);
	elseif (itemTable.uniqueID == "bandage") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 1, 600);
		healer:ProgressAttribute(ATB_MEDICAL, 5, true);
	end;
end;

-- Called when a player's shared variables should be set.
function SCHEMA:PlayerSetSharedVars(player, curTime)
	local position = player:GetPos();
	local health = player:Health();
	
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		local inventoryWeight = nexus.inventory.GetWeight(player);
		
		if (inventoryWeight >= nexus.inventory.GetMaximumWeight(player) / 4) then
			player:ProgressAttribute(ATB_STRENGTH, inventoryWeight / 400, true);
		end;
	end;
end;

-- Called when a player has been unragdolled.
function SCHEMA:PlayerUnragdolled(player, state, ragdoll)
	nexus.player.SetAction(player, "die", false);
end;

-- Called when a player has been ragdolled.
function SCHEMA:PlayerRagdolled(player, state, ragdoll)
	nexus.player.SetAction(player, "die", false);
end;

-- Called at an interval while a player is connected.
function SCHEMA:PlayerThink(player, curTime, infoTable)
	local tempKilled = player:GetCharacterData("tempkilled");
	local ragdolled = player:IsRagdolled();
	local unixTime = os.time();
	local alive = player:Alive();
	
	if (alive and !ragdolled) then
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
	
	if (tempKilled and unixTime >= tempKilled) then
		player:SetCharacterData("tempkilled", nil);
		player:SetSharedVar("sh_TempKilled", false);
	end;
	
	if ( nexus.player.HasFlags(player, "T") ) then
		infoTable.inventoryWeight = infoTable.inventoryWeight * 2;
	end;
	
	local acrobatics = nexus.attributes.Fraction(player, ATB_ACROBATICS, 100, 50);
	local strength = nexus.attributes.Fraction(player, ATB_STRENGTH, 2, 1);
	local agility = nexus.attributes.Fraction(player, ATB_AGILITY, 50, 25);
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = infoTable.jumpPower + acrobatics;
	infoTable.runSpeed = infoTable.runSpeed + agility;
end;

-- Called when a player attempts to delete a character.
function SCHEMA:PlayerCanDeleteCharacter(player, character)
	if ( character.data["tempkilled"] and character.data["tempkilled"] > os.time() ) then
		return "You cannot delete this character while it is temporarily killed!";
	end;
	
	if ( character.data["permakilled"] ) then
		return true;
	end;
end;

-- Called when a player attempts to use a character.
function SCHEMA:PlayerCanUseCharacter(player, character)
	local unixTime = os.time();
	
	if ( character.data["tempkilled"] ) then
		if ( unixTime < character.data["tempkilled"] ) then
			return "You cannot use this character for another "..math.ceil(character.data["tempkilled"] - unixTime).." second(s)!";
		end;
	end;
	
	if ( character.data["permakilled"] ) then
		return character.name.." is permanently killed and cannot be used!";
	end;
end;

-- Called when attempts to use a command.
function SCHEMA:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetSharedVar("sh_Tied") != 0) then
		local blacklisted = {
			"OrderShipment",
			"Radio"
		};
		
		if ( table.HasValue(blacklisted, commandTable.name) ) then
			nexus.player.Notify(player, "You cannot use this command when you are tied!");
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to change class.
function SCHEMA:PlayerCanChangeClass(player, class)
	if (player:GetSharedVar("sh_Tied") != 0) then
		nexus.player.Notify(player, "You cannot change classes when you are tied!");
		
		return false;
	end;
end;

-- Called when death attempts to clear a player's recognised names.
function SCHEMA:PlayerCanDeathClearRecognisedNames(player, attacker, damageInfo) return false; end;

-- Called when death attempts to clear a player's name.
function SCHEMA:PlayerCanDeathClearName(player, attacker, damageInfo) return false; end;

-- Called when a player attempts to use an entity.
function SCHEMA:PlayerUse(player, entity)
	local curTime = CurTime();
	
	if (entity.bustedDown) then
		return false;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		if ( entity:IsVehicle() ) then
			return;
		end;
		
		if ( !player.nextTieNotify or player.nextTieNotify < CurTime() ) then
			nexus.player.Notify(player, "You cannot use that when you are tied!");
			
			player.nextTieNotify = CurTime() + 2;
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to destroy an item.
function SCHEMA:PlayerCanDestroyItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			nexus.player.Notify(player, "You cannot destroy items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function SCHEMA:PlayerCanDropItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			nexus.player.Notify(player, "You cannot drop items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function SCHEMA:PlayerCanUseItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			nexus.player.Notify(player, "You cannot use items when you are tied!");
		end;
		
		return false;
	end;
	
	if (nexus.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
		local throwableWeapon = nil;
		local secondaryWeapon = nil;
		local primaryWeapon = nil;
		local meleeWeapon = nil;
		local fault = nil;
		
		for k, v in ipairs( player:GetWeapons() ) do
			local weaponTable = nexus.item.GetWeapon(v);
			
			if (weaponTable and !weaponTable.fakeWeapon) then
				if ( !weaponTable:IsMeleeWeapon() and !weaponTable:IsThrowableWeapon() ) then
					if (weaponTable.weight <= 2) then
						secondaryWeapon = true;
					else
						primaryWeapon = true;
					end;
				elseif ( weaponTable:IsThrowableWeapon() ) then
					throwableWeapon = true;
				else
					meleeWeapon = true;
				end;
			end;
		end;
		
		if ( !itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon() ) then
			if (itemTable.weight <= 2) then
				if (secondaryWeapon) then
					fault = "You cannot use another secondary weapon!";
				end;
			elseif (primaryWeapon) then
				fault = "You cannot use another secondary weapon!";
			end;
		elseif ( itemTable:IsThrowableWeapon() ) then
			if (throwableWeapon) then
				fault = "You cannot use another throwable weapon!";
			end;
		elseif (meleeWeapon) then
			fault = "You cannot use another melee weapon!";
		end;
		
		if (fault) then
			if (!noMessage) then
				nexus.player.Notify(player, fault);
			end;
			
			return false;
		end;
	end;
end;

-- Called when chat box info should be adjusted.
function SCHEMA:ChatBoxAdjustInfo(info)
	if ( IsValid(info.speaker) and info.speaker:HasInitialized() ) then
		if (info.class != "ooc" and info.class != "looc") then
			if ( IsValid(info.speaker) and info.speaker:HasInitialized() ) then
				if (string.sub(info.text, 1, 1) == "?") then
					info.text = string.sub(info.text, 2);
					info.data.anon = true;
				end;
			end;
		end;
	end;
end;

-- Called when a chat box message has been added.
function SCHEMA:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = nexus.config.Get("talk_radius"):Get();
		local listeners = {};
		local players = g_Player.GetAll();
		local radios = ents.FindByClass("nx_radio");
		local data = {};
		
		for k, v in ipairs(radios) do
			if (!v:IsOff() and info.speaker:GetPos():Distance( v:GetPos() ) <= 64) then
				if (info.speaker:GetEyeTraceNoCursor().Entity == v) then
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
				if (data.entity != v) then
					local radioPosition = v:GetPos();
					local radioFrequency = v:GetSharedVar("sh_Frequency");
					
					if (!v:IsOff() and radioFrequency == data.frequency) then
						for k2, v2 in ipairs(players) do
							if ( v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2] ) then
								if ( v2:GetPos():Distance(radioPosition) <= (talkRadius * 2) ) then
									eavesdroppers[v2] = v2;
								end;
							end;
						end;
					end;
				end;
			end;
			
			if (table.Count(listeners) > 0) then
				nexus.chatBox.Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				nexus.chatBox.Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			end;
		end;
	end;
end;

-- Called when a player has used their radio.
function SCHEMA:PlayerRadioUsed(player, text, listeners, eavesdroppers)
	local newEavesdroppers = {};
	local talkRadius = nexus.config.Get("talk_radius"):Get() * 2;
	local frequency = player:GetCharacterData("frequency");
	
	for k, v in ipairs( ents.FindByClass("nx_radio") ) do
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
		nexus.chatBox.Add(newEavesdroppers, player, "radio_eavesdrop", text);
	end;
end;

-- Called when a player's radio info should be adjusted.
function SCHEMA:PlayerAdjustRadioInfo(player, info)
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

-- Called when a player destroys generator.
function SCHEMA:PlayerDestroyGenerator(player, entity, generator)
	nexus.player.GiveCash( player, generator.cash / 4, "destroying a "..string.lower(generator.name) );
end;

-- Called when an entity's menu option should be handled.
function SCHEMA:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "prop_ragdoll") then
		if (arguments == "nx_corpseLoot") then
			if (!entity.inventory) then entity.inventory = {}; end;
			if (!entity.cash) then entity.cash = 0; end;
			
			local entityPlayer = nexus.entity.GetPlayer(entity);
			
			if ( !entityPlayer or !entityPlayer:Alive() ) then
				player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				
				nexus.player.OpenStorage( player, {
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
		elseif (arguments == "nx_corpseMutilate") then
			local entityPlayer = nexus.entity.GetPlayer(entity);
			local trace = player:GetEyeTraceNoCursor();
			
			if ( !entityPlayer or !entityPlayer:Alive() ) then
				if (!entity.mutilated or entity.mutilated < 3) then
					entity.mutilated = (entity.mutilated or 0) + 1;
						player:UpdateInventory("human_meat", 1, true);
						player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
					NEXUS:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
				end;
			end;
		end;
	elseif (entity:GetClass() == "nx_belongings" and arguments == "nx_belongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		nexus.player.OpenStorage( player, {
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
	elseif (entity:GetClass() == "nx_breach") then
		entity:CreateDummyBreach();
		entity:BreachEntity(player);
	elseif (entity:GetClass() == "nx_radio") then
		if (option == "Set Frequency" and type(arguments) == "string") then
			if ( string.find(arguments, "^%d%d%d%.%d$") ) then
				local start, finish, decimal = string.match(arguments, "(%d)%d(%d)%.(%d)");
				
				start = tonumber(start);
				finish = tonumber(finish);
				decimal = tonumber(decimal);
				
				if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
					entity:SetFrequency(arguments);
					
					nexus.player.Notify(player, "You have set this stationary radio's arguments to "..arguments..".");
				else
					nexus.player.Notify(player, "The radio arguments must be between 101.1 and 199.9!");
				end;
			else
				nexus.player.Notify(player, "The radio arguments must look like xxx.x!");
			end;
		elseif (arguments == "nx_radioToggle") then
			entity:Toggle();
		elseif (arguments == "nx_radioTake") then
			local success, fault = player:UpdateInventory("stationary_radio", 1);
			
			if (!success) then
				nexus.player.Notify(entity, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when an entity is removed.
function SCHEMA:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		if (entity.areBelongings) then
			if (table.Count(entity.inventory) > 0 or entity.cash > 0) then
				local belongings = ents.Create("nx_belongings");
				
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

-- Called when a player dies.
function SCHEMA:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (damageInfo) then
		local miscellaneousDamage = damageInfo:IsBulletDamage() or damageInfo:IsExplosionDamage();
		local meleeDamage = damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
		
		if (miscellaneousDamage or meleeDamage) then
			self:PlayerDropBelongings( player, player:GetRagdollEntity() );
		end;
	end;
end;

-- Called just before a player dies.
function SCHEMA:DoPlayerDeath(player, attacker, damageInfo)
	if (damageInfo) then
		local miscellaneousDamage = damageInfo:IsBulletDamage() or damageInfo:IsExplosionDamage();
		local meleeDamage = damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
		
		if (miscellaneousDamage or meleeDamage) then
			player:SetCharacterData("tempkilled", os.time() + 3600);
			player:SetSharedVar("sh_TempKilled", true);
		end;
	end;
	
	player.beingSearched = nil;
	player.searching = nil;
	
	self:TiePlayer(player, false, true);
end;

-- Called when a player's class has been set.
function SCHEMA:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange)
	if (newClass.index == CLASS_GUARD or newClass.index == CLASS_INSURGENCY) then
		player:SetArmor(200);
	end;
end;

-- Called just after a player spawns.
function SCHEMA:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		umsg.Start("nx_ClearEffects", player);
		umsg.End();
		
		player.beingSearched = nil;
		player.searching = nil;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		self:TiePlayer(player, true);
	end;
end;

-- Called when a player throws a punch.
function SCHEMA:PlayerPunchThrown(player)
	player:ProgressAttribute(ATB_STRENGTH, 0.25, true);
end;

-- Called when a player punches an entity.
function SCHEMA:PlayerPunchEntity(player, entity)
	if ( entity:IsPlayer() or entity:IsNPC() ) then
		player:ProgressAttribute(ATB_STRENGTH, 1, true);
	else
		player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	end;
end;

-- Called when an entity has been breached.
function SCHEMA:EntityBreached(entity, activator)
	if ( nexus.entity.IsDoor(entity) ) then
		if (entity:GetClass() != "prop_door_rotating") then
			nexus.entity.OpenDoor(entity, 0, true, true);
		else
			self:BustDownDoor(activator, entity);
		end;
	end;
end;

-- Called when a player takes damage.
function SCHEMA:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if ( damageInfo:IsBulletDamage() ) then
		player:SetDSP(math.random(35, 37), false);
	
		if (player:Armor() > 0) then
			umsg.Start("nx_Stunned", player);
				umsg.Float(0.1);
			umsg.End();
		else
			umsg.Start("nx_Stunned", player);
				umsg.Float(0.3);
			umsg.End();
		end;
	end;
	
	if (player:Health() <= 10 and math.random() <= 0.75) then
		if (nexus.player.GetAction(player) != "die") then
			nexus.player.SetRagdollState( player, RAGDOLL_FALLENOVER, nil, nil, NEXUS:ConvertForce(damageInfo:GetDamageForce() * 32) );
			
			nexus.player.SetAction(player, "die", 60, 1, function()
				if ( IsValid(player) and player:Alive() ) then
					player:TakeDamage(player:Health() * 2, attacker, inflictor);
				end;
			end);
		end;
	end;
	
	if (damageInfo:IsBulletDamage() and hitGroup) then
		local curTime = CurTime();
		
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
function SCHEMA:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local endurance = nexus.attributes.Fraction(player, ATB_ENDURANCE, 0.5, 0.5);
	
	damageInfo:ScaleDamage(1.25 - endurance);
end;

-- Called when an entity takes damage.
function SCHEMA:EntityTakeDamage(entity, inflictor, attacker, amount, damageInfo)
	local curTime = CurTime();
	local player = nexus.entity.GetPlayer(entity);
	
	if (player) then
		if (!player.nextEnduranceTime or CurTime() > player.nextEnduranceTime) then
			player:ProgressAttribute(ATB_ENDURANCE, math.Clamp(damageInfo:GetDamage(), 0, 75) / 10, true);
			player.nextEnduranceTime = CurTime() + 2;
		end;
	end;
	
	if ( attacker:IsPlayer() ) then
		local strength = nexus.attributes.Fraction(attacker, ATB_STRENGTH, 1, 0.5);
		local weapon = nexus.player.GetWeaponClass(attacker);
		
		if ( damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH) ) then
			damageInfo:ScaleDamage(1 + strength);
		end;
		
		if (weapon == "weapon_crowbar") then
			if ( entity:IsPlayer() ) then
				damageInfo:ScaleDamage(0.1);
			else
				damageInfo:ScaleDamage(0.8);
			end;
		end;
	end;
end;