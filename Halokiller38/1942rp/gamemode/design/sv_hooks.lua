--[[
Name: "sh_hooks.lua".
Product: "Day One".
--]]

-- Called when an NPC is killed.
function DESIGN:OnNPCKilled(entity, attacker, weapon)
	local class = entity:GetClass();
	
	if (class == "npc_pigeon" or class == "npc_crow" or class == "npc_seagull") then
		blueprint.entity.CreateItem( nil, "bird_meat", entity:GetPos() + Vector(0, 0, 8) );
	end;
end;

-- Called when a player uses an unknown item function.
function DESIGN:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (itemFunction == "Cash" and itemTable.cost) then
		if ( blueprint.player.HasFlags(player, "T") ) then
			local useSounds = {"buttons/button5.wav", "buttons/button4.wav"};
			
			player:UpdateInventory(itemTable.uniqueID, -1, true);
			player:EmitSound( useSounds[ math.random(1, #useSounds) ] );
			
			blueprint.player.GiveCash(player, math.Round(itemTable.cost / 2), "scrapped an item");
		end;
	end;
end;

-- Called when a player attempts to use a door.
function DESIGN:PlayerCanUseDoor(player, door)
	if (player:GetSharedVar("sh_Tied") != 0) then
		return false;
	end;
end;

-- Called when a player's character has loaded.
function DESIGN:PlayerCharacterLoaded(player)
	player:SetSharedVar("sh_PermaKilled", false);
	player:SetSharedVar("sh_Tied", 0);
end;

-- Called when a player attempts to switch to a character.
function DESIGN:PlayerCanSwitchCharacter(player, character)
	if ( player:GetCharacterData("permakilled")
	or player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called each frame that a player is dead.
function DESIGN:PlayerDeathThink(player)
	if ( player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called when a player's death info should be adjusted.
function DESIGN:PlayerAdjustDeathInfo(player, info)
	if ( player:GetCharacterData("permakilled") ) then
		info.spawnTime = 0;
	end;
end;

-- Called when a player attempts to use a lowered weapon.
function DESIGN:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if ( secondary and (weapon.SilenceTime or weapon.PistolBurst) ) then
		return true;
	end;
end;

-- Called when a player's default inventory is needed.
function DESIGN:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_WEHR) then
		inventory["weapon_sim_kar98k"] = 1;
		inventory["sim_fas_ammo_792mm"] = 1;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;
	elseif (character.faction == FACTION_RA) then
		inventory["weapon_sim_tokarevsvt-40"] = 1;
		inventory["sim_fas_ammo_762mm"] = 1;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;
	elseif (character.faction == FACTION_US) then
		inventory["weapon_sim_m1garand"] = 1;
		inventory["sim_fas_ammo_3006"] = 1;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;	
	elseif (character.faction == FACTION_FALL) then
		inventory["weapon_sim_fg42"] = 1;
		inventory["sim_fas_ammo_792mm"] = 2;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;	
	elseif (character.faction == FACTION_FUE) then
		inventory["weapon_sim_p38"] = 1;
		inventory["ammo_pistol"] = 2;
		inventory["backpack"] = 1;
		inventory["jacket"] = 1;	
	end;
end;

-- Called when Blueprint has initialized.
function DESIGN:BlueprintInitialized()
	self.trashItems = {};
	
	for k, v in pairs( blueprint.item.GetAll() ) do
		if (v.category == "Junk" and !v.isBaseItem) then
			self.trashItems[#self.trashItems + 1] = v;
		end;
	end;
end;

-- Called each frame.
function DESIGN:Tick()
	local curTime = CurTime();
	local totalItems = #ents.FindByClass("bp_item");
	local maximumSpawns = #g_Player.GetAll();
	
	if (!self.nextTrashSpawns) then
		self.nextTrashSpawns = curTime + math.random(1800, 3600);
	end;
	
	if (curTime >= self.nextTrashSpawns and #self.trashSpawns > 0) then
		if (totalItems < maximumSpawns) then
			self.nextTrashSpawns = nil;
			
			math.randomseed(curTime);
			
			local totalWorth = 0;
			local targetWorth = (maximumSpawns - totalItems);
			
			while (totalWorth < targetWorth) do
				local trashItem = self:GetRandomTrashItem();
				local position = self:GetRandomTrashSpawn();
					totalWorth = totalWorth + trashItem.worth;
				blueprint.entity.CreateItem(nil, trashItem.uniqueID, position);
			end;
		end;
	end;
end;

-- Called when Blueprint has loaded all of the entities.
function DESIGN:BlueprintInitPostEntity()
	self:LoadTrashSpawns();
	self:LoadBelongings();
	self:LoadRadios();
end;

-- Called just after data should be saved.
function DESIGN:PostSaveData()
	self:SaveBelongings();
	self:SaveRadios();
end;

-- Called when a player switches their flashlight on or off.
function DESIGN:PlayerSwitchFlashlight(player, on)
	if (on and player:GetSharedVar("sh_Tied") != 0) then
		return false;
	end;
end;

-- Called when a player's storage should close.
function DESIGN:PlayerStorageShouldClose(player, storage)
	local entity = player:GetStorageEntity();
	
	if (player.searching and entity:IsPlayer() and entity:GetSharedVar("sh_Tied") == 0) then
		return true;
	end;
end;

-- Called when a player attempts to spray their tag.
function DESIGN:PlayerSpray(player)
	if (!player:HasItem("spray_can") or player:GetSharedVar("sh_Tied") != 0) then
		return true;
	end;
end;

-- Called when a player presses F3.
function DESIGN:ShowSpare1(player)
	blueprint.player.RunBlueprintCommand(player, "InvAction", "zip_tie", "use");
end;

-- Called when a player presses F4.
function DESIGN:ShowSpare2(player)
	blueprint.player.RunBlueprintCommand(player, "CharSearch");
end;

-- Called when a player's drop weapon info should be adjusted.
function DESIGN:PlayerAdjustDropWeaponInfo(player, info)
	if (blueprint.player.GetWeaponClass(player) == info.itemTable.weaponClass) then
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
function DESIGN:PlayerGivenWeapon(player, class, uniqueID, forceReturn)
	local itemTable = blueprint.item.GetWeapon(class, uniqueID);
	
	if (blueprint.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
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
function DESIGN:PlayerSpawnObject(player)
	if (player:GetSharedVar("sh_Tied") != 0) then
		blueprint.player.Notify(player, "You don't have permission to do this right now!");
		
		return false;
	end;
end;

-- Called when a player attempts to breach an entity.
function DESIGN:PlayerCanBreachEntity(player, entity)
	if ( blueprint.entity.IsDoor(entity) ) then
		if ( !blueprint.entity.IsDoorFalse(entity) ) then
			return true;
		end;
	end;
end;

-- Called when a player attempts to use the radio.
function DESIGN:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if ( player:HasItem("handheld_radio") ) then
		if ( !player:GetCharacterData("frequency") ) then
			blueprint.player.Notify(player, "You need to set the radio frequency first!");
			
			return false;
		end;
	else
		blueprint.player.Notify(player, "You do not own a radio!");
		
		return false;
	end;
end;

-- Called when a player attempts to use an entity in a vehicle.
function DESIGN:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if ( entity:IsPlayer() or blueprint.entity.IsPlayerRagdoll(entity) ) then
		return true;
	end;
end;

-- Called when a player presses a key.
function DESIGN:KeyPress(player, key)
	if (key == IN_USE) then
		local untieTime = DESIGN:GetDexterityTime(player);
		local eyeTrace = player:GetEyeTraceNoCursor();
		local target = eyeTrace.Entity;
		local entity = target;
		
		if ( IsValid(target) ) then
			target = blueprint.entity.GetPlayer(target);
			
			if (target and player:GetSharedVar("sh_Tied") == 0) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					if ( target:GetSharedVar("sh_Tied") != 0 and target:Alive() ) then
						blueprint.player.SetAction(player, "untie", untieTime);
						
						blueprint.player.EntityConditionTimer(player, target, entity, untieTime, 192, function()
							return player:Alive() and target:Alive() and !player:IsRagdolled() and player:GetSharedVar("sh_Tied") == 0;
						end, function(success)
							if (success) then
								self:TiePlayer(target, false);
								
								player:ProgressAttribute(ATB_DEXTERITY, 15, true);
							end;
							
							blueprint.player.SetAction(player, "untie", false);
						end);
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function DESIGN:PlayerAdjustCharacterScreenInfo(player, character, info)
	if ( character.data["permakilled"] ) then
		info.details = "This character is permanently killed.";
	end;
end;

-- Called when a player has been healed.
function DESIGN:PlayerHealed(player, healer, itemTable)
	local action = blueprint.player.GetAction(player);
	
	if (itemTable.uniqueID == "antibiotics") then
		healer:ProgressAttribute(ATB_DEXTERITY, 15, true);
	elseif (itemTable.uniqueID == "bandage") then
		healer:ProgressAttribute(ATB_DEXTERITY, 5, true);
	end;
end;

-- Called when a player's shared variables should be set.
function DESIGN:PlayerSetSharedVars(player, curTime)
	local position = player:GetPos();
	local health = player:Health();
	
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		local inventoryWeight = blueprint.inventory.GetWeight(player);
		
		if (inventoryWeight >= blueprint.inventory.GetMaximumWeight(player) / 4) then
			player:ProgressAttribute(ATB_STRENGTH, inventoryWeight / 400, true);
		end;
	end;
end;

-- Called when a player has been unragdolled.
function DESIGN:PlayerUnragdolled(player, state, ragdoll)
	blueprint.player.SetAction(player, "die", false);
end;

-- Called when a player has been ragdolled.
function DESIGN:PlayerRagdolled(player, state, ragdoll)
	blueprint.player.SetAction(player, "die", false);
end;

-- Called at an interval while a player is connected.
function DESIGN:PlayerThink(player, curTime, infoTable)
	local ragdolled = player:IsRagdolled();
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
	
	if ( blueprint.player.HasFlags(player, "T") ) then
		infoTable.inventoryWeight = infoTable.inventoryWeight * 2;
	end;
	
	local acrobatics = blueprint.attributes.Fraction(player, ATB_ACROBATICS, 100, 50);
	local strength = blueprint.attributes.Fraction(player, ATB_STRENGTH, 2, 1);
	local agility = blueprint.attributes.Fraction(player, ATB_AGILITY, 50, 25);
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = infoTable.jumpPower + acrobatics;
	infoTable.runSpeed = infoTable.runSpeed + agility;
end;

-- Called when a player attempts to delete a character.
function DESIGN:PlayerCanDeleteCharacter(player, character)
	if ( character.data["permakilled"] ) then
		return true;
	end;
end;

-- Called when a player attempts to use a character.
function DESIGN:PlayerCanUseCharacter(player, character)
	if ( character.data["permakilled"] ) then
		return character.name.." is permanently killed and cannot be used!";
	end;
end;

-- Called when attempts to use a command.
function DESIGN:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetSharedVar("sh_Tied") != 0) then
		local blacklisted = {
			"OrderShipment",
			"Radio"
		};
		
		if ( table.HasValue(blacklisted, commandTable.name) ) then
			blueprint.player.Notify(player, "You cannot use this command when you are tied!");
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to change class.
function DESIGN:PlayerCanChangeClass(player, class)
	if (player:GetSharedVar("sh_Tied") != 0) then
		blueprint.player.Notify(player, "You cannot change classes when you are tied!");
		
		return false;
	end;
end;

-- Called when death attempts to clear a player's recognised names.
function DESIGN:PlayerCanDeathClearRecognisedNames(player, attacker, damageInfo) return false; end;

-- Called when death attempts to clear a player's name.
function DESIGN:PlayerCanDeathClearName(player, attacker, damageInfo) return false; end;

-- Called when a player attempts to use an entity.
function DESIGN:PlayerUse(player, entity)
	local curTime = CurTime();
	
	if (entity.bustedDown) then
		return false;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		if ( entity:IsVehicle() ) then
			return;
		end;
		
		if ( !player.nextTieNotify or player.nextTieNotify < CurTime() ) then
			blueprint.player.Notify(player, "You cannot use that when you are tied!");
			
			player.nextTieNotify = CurTime() + 2;
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to destroy an item.
function DESIGN:PlayerCanDestroyItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			blueprint.player.Notify(player, "You cannot destroy items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function DESIGN:PlayerCanDropItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			blueprint.player.Notify(player, "You cannot drop items when you are tied!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function DESIGN:PlayerCanUseItem(player, itemTable, noMessage)
	if (player:GetSharedVar("sh_Tied") != 0) then
		if (!noMessage) then
			blueprint.player.Notify(player, "You cannot use items when you are tied!");
		end;
		
		return false;
	end;
	
	if (blueprint.item.IsWeapon(itemTable) and !itemTable.fakeWeapon) then
		local throwableWeapon = nil;
		local secondaryWeapon = nil;
		local primaryWeapon = nil;
		local meleeWeapon = nil;
		local fault = nil;
		
		for k, v in ipairs( player:GetWeapons() ) do
			local weaponTable = blueprint.item.GetWeapon(v);
			
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
				blueprint.player.Notify(player, fault);
			end;
			
			return false;
		end;
	end;
end;

-- Called when chat box info should be adjusted.
function DESIGN:ChatBoxAdjustInfo(info)
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
function DESIGN:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = blueprint.config.Get("talk_radius"):Get();
		local listeners = {};
		local players = g_Player.GetAll();
		local radios = ents.FindByClass("bp_radio");
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
				blueprint.chatBox.Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				blueprint.chatBox.Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			end;
		end;
	end;
end;

-- Called when a player has used their radio.
function DESIGN:PlayerRadioUsed(player, text, listeners, eavesdroppers)
	local newEavesdroppers = {};
	local talkRadius = blueprint.config.Get("talk_radius"):Get() * 2;
	local frequency = player:GetCharacterData("frequency");
	
	for k, v in ipairs( ents.FindByClass("bp_radio") ) do
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
		blueprint.chatBox.Add(newEavesdroppers, player, "radio_eavesdrop", text);
	end;
end;

-- Called when a player's radio info should be adjusted.
function DESIGN:PlayerAdjustRadioInfo(player, info)
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
function DESIGN:PlayerDestroyGenerator(player, entity, generator)
	blueprint.player.GiveCash( player, generator.cash / 4, "destroying a "..string.lower(generator.name) );
end;

-- Called when an entity's menu option should be handled.
function DESIGN:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "prop_ragdoll") then
		if (arguments == "bp_corpseLoot") then
			if (!entity.inventory) then entity.inventory = {}; end;
			if (!entity.cash) then entity.cash = 0; end;
			
			local entityPlayer = blueprint.entity.GetPlayer(entity);
			
			if ( !entityPlayer or !entityPlayer:Alive() ) then
				player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				
				blueprint.player.OpenStorage( player, {
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
		elseif (arguments == "bp_corpseMutilate") then
			local entityPlayer = blueprint.entity.GetPlayer(entity);
			local trace = player:GetEyeTraceNoCursor();
			
			if ( !entityPlayer or !entityPlayer:Alive() ) then
				if (!entity.mutilated or entity.mutilated < 3) then
					entity.mutilated = (entity.mutilated or 0) + 1;
						player:UpdateInventory("human_meat", 1, true);
						player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
					BLUEPRINT:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
				end;
			end;
		end;
	elseif (entity:GetClass() == "bp_belongings" and arguments == "bp_belongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		blueprint.player.OpenStorage( player, {
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
	elseif (entity:GetClass() == "bp_breach") then
		entity:CreateDummyBreach();
		entity:BreachEntity(player);
	elseif (entity:GetClass() == "bp_radio") then
		if (option == "Set Frequency" and type(arguments) == "string") then
			if ( string.find(arguments, "^%d%d%d%.%d$") ) then
				local start, finish, decimal = string.match(arguments, "(%d)%d(%d)%.(%d)");
				
				start = tonumber(start);
				finish = tonumber(finish);
				decimal = tonumber(decimal);
				
				if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
					entity:SetFrequency(arguments);
					
					blueprint.player.Notify(player, "You have set this stationary radio's arguments to "..arguments..".");
				else
					blueprint.player.Notify(player, "The radio arguments must be between 101.1 and 199.9!");
				end;
			else
				blueprint.player.Notify(player, "The radio arguments must look like xxx.x!");
			end;
		elseif (arguments == "bp_radioToggle") then
			entity:Toggle();
		elseif (arguments == "bp_radioTake") then
			local success, fault = player:UpdateInventory("stationary_radio", 1);
			
			if (!success) then
				blueprint.player.Notify(entity, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when an entity is removed.
function DESIGN:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		if (entity.areBelongings) then
			if (table.Count(entity.inventory) > 0 or entity.cash > 0) then
				local belongings = ents.Create("bp_belongings");
				
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
function DESIGN:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (damageInfo) then
		local miscellaneousDamage = damageInfo:IsBulletDamage() or damageInfo:IsExplosionDamage();
		local meleeDamage = damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
		
		if (miscellaneousDamage or meleeDamage) then
			self:PlayerDropBelongings( player, player:GetRagdollEntity() );
		end;
	end;
end;

-- Called just before a player dies.
function DESIGN:DoPlayerDeath(player, attacker, damageInfo)
	player.beingSearched = nil;
	player.searching = nil;
	
	self:TiePlayer(player, false, true);
end;

-- Called when a player's class has been set.
function DESIGN:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange)
	if (newClass.index == CLASS_GUARD) then
		player:SetArmor(200);
	end;
end;

-- Called just after a player spawns.
function DESIGN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		umsg.Start("bp_ClearEffects", player);
		umsg.End();
		
		player.beingSearched = nil;
		player.searching = nil;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		self:TiePlayer(player, true);
	end;
end;

-- Called when a player throws a punch.
function DESIGN:PlayerPunchThrown(player)
	player:ProgressAttribute(ATB_STRENGTH, 0.25, true);
end;

-- Called when a player punches an entity.
function DESIGN:PlayerPunchEntity(player, entity)
	if ( entity:IsPlayer() or entity:IsNPC() ) then
		player:ProgressAttribute(ATB_STRENGTH, 1, true);
	else
		player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	end;
end;

-- Called when an entity has been breached.
function DESIGN:EntityBreached(entity, activator)
	if ( blueprint.entity.IsDoor(entity) ) then
		if (entity:GetClass() != "prop_door_rotating") then
			blueprint.entity.OpenDoor(entity, 0, true, true);
		else
			self:BustDownDoor(activator, entity);
		end;
	end;
end;

-- Called when a player takes damage.
function DESIGN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if ( damageInfo:IsBulletDamage() ) then
		if (player:Armor() > 0) then
			umsg.Start("bp_Stunned", player);
				umsg.Float(0.1);
			umsg.End();
		else
			umsg.Start("bp_Stunned", player);
				umsg.Float(0.3);
			umsg.End();
		end;
	end;
	
	if (player:Health() <= 10 and math.random() <= 0.75) then
		if (blueprint.player.GetAction(player) != "die") then
			blueprint.player.SetRagdollState( player, RAGDOLL_FALLENOVER, nil, nil, BLUEPRINT:ConvertForce(damageInfo:GetDamageForce() * 32) );
			
			blueprint.player.SetAction(player, "die", 120, 1, function()
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
				player:BoostAttribute("Body Damage", ATB_DEXTERITY, -25, 600, true);
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
			end;
		end;
	end;
end;

-- A function to scale damage by hit group.
function DESIGN:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	damageInfo:ScaleDamage( 1.25 - blueprint.attributes.Fraction(player, ATB_ENDURANCE, 0.5, 0.5) );
end;

-- Called when an entity takes damage.
function DESIGN:EntityTakeDamage(entity, inflictor, attacker, amount, damageInfo)
	local curTime = CurTime();
	local player = blueprint.entity.GetPlayer(entity);
	
	if (player) then
		if (!player.nextEnduranceTime or CurTime() > player.nextEnduranceTime) then
			player:ProgressAttribute(ATB_ENDURANCE, math.Clamp(damageInfo:GetDamage(), 0, 75) / 10, true);
			player.nextEnduranceTime = CurTime() + 2;
		end;
	end;
	
	if ( attacker:IsPlayer() ) then
		local strength = blueprint.attributes.Fraction(attacker, ATB_STRENGTH, 1, 0.5);
		local weapon = blueprint.player.GetWeaponClass(attacker);
		
		if ( damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH) ) then
			damageInfo:ScaleDamage(1 + strength);
		end;
	end;
end;