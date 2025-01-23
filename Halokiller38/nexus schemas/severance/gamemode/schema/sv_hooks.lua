--[[
Name: "sh_hooks.lua".
Product: "Severance".
--]]

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

-- Called when a player attempts to switch to a character.
function SCHEMA:PlayerCanSwitchCharacter(player, character)
	if ( player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called when a player's character has loaded.
function SCHEMA:PlayerCharacterLoaded(player)
	player:SetSharedVar("sh_PermaKilled", false);
	player:SetSharedVar("sh_Tied", 0);
end;

-- Called when a player's default inventory is needed.
function SCHEMA:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_CEDA) then
		inventory["kevlar"] = 1;
		inventory["backpack"] = 1;
		inventory["rcs_p228"] = 1;
		inventory["ammo_smg1"] = 4;
		inventory["rcs_sg552"] = 1;
		inventory["ammo_pistol"] = 3;
		inventory["ceda_uniform"] = 1;
		inventory["storage_jacket"] = 1;
		inventory["handheld_radio"] = 1;
	end;
end;

-- Called each frame that a player is dead.
function SCHEMA:PlayerDeathThink(player)
	if ( player:GetCharacterData("permakilled") ) then
		return true;
	end;
end;

-- Called when a player's death info should be adjusted.
function SCHEMA:PlayerAdjustDeathInfo(player, info)
	if ( player:GetCharacterData("permakilled") ) then
		info.spawnTime = 0;
	end;
end;

-- Called when a player attempts to use a lowered weapon.
function SCHEMA:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if ( secondary and (weapon.SilenceTime or weapon.PistolBurst) ) then
		return true;
	end;
end;

-- Called when nexus has loaded all of the entities.
function SCHEMA:NexusInitPostEntity()
	self:LoadBelongings();
	self:LoadRadios();
end;

-- Called just after data should be saved.
function SCHEMA:PostSaveData()
	self:SaveBelongings();
	self:SaveRadios();
end;

-- Called when a player's inventory item has been updated.
function SCHEMA:PlayerInventoryItemUpdated(player, itemTable, amount, force)
	local clothes = player:GetCharacterData("clothes");
	
	if (clothes and itemTable.index == clothes) then
		if ( !player:HasItem(itemTable.uniqueID) ) then
			itemTable:OnChangeClothes(player, false);
			
			player:SetCharacterData("clothes", nil);
		end;
	end;
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

-- Called when a player has been healed.
function SCHEMA:PlayerHealed(player, healer, itemTable)
	local action = nexus.player.GetAction(player);
	
	if (itemTable.uniqueID == "health_vial") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 2, 600);
		healer:ProgressAttribute(ATB_MEDICAL, 15, true);
	elseif (itemTable.uniqueID == "health_kit") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 3, 600);
		healer:ProgressAttribute(ATB_MEDICAL, 25, true);
	elseif (itemTable.uniqueID == "bandage") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 1, 600);
		healer:ProgressAttribute(ATB_MEDICAL, 5, true);
	end;
end;

-- Called when a player's shared variables should be set.
function SCHEMA:PlayerSetSharedVars(player, curTime)
	local clothesTable = nexus.item.Get( player:GetCharacterData("clothes", "") );
	local position = player:GetPos();
	
	if (clothesTable) then
		player:SetSharedVar("sh_Clothes", clothesTable.index);
	else
		player:SetSharedVar("sh_Clothes", 0);
	end;
	
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
	local ragdolled = player:IsRagdolled();
	local clothes = player:GetCharacterData("clothes");
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
	
	if (player:WaterLevel() >= 2) then
		player:TakeDamageInfo( NEXUS:FakeDamageInfo(2, GetWorldEntity(), GetWorldEntity(), player:GetShootPos(), DMG_RADIATION, 1) );
	end;
	
	local acrobatics = nexus.attributes.Fraction(player, ATB_ACROBATICS, 100, 50);
	local strength = nexus.attributes.Fraction(player, ATB_STRENGTH, 8, 4);
	local agility = nexus.attributes.Fraction(player, ATB_AGILITY, 50, 25);
	
	if (clothes != "") then
		local itemTable = nexus.item.Get(clothes);
		
		if (itemTable and itemTable.pocketSpace) then
			infoTable.inventoryWeight = infoTable.inventoryWeight + itemTable.pocketSpace;
		end;
	end;
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = infoTable.jumpPower + acrobatics;
	infoTable.runSpeed = infoTable.runSpeed + agility;
end;

-- Called when a player attempts to delete a character.
function SCHEMA:PlayerCanDeleteCharacter(player, character)
	if ( character.data["permakilled"] ) then
		return true;
	end;
end;

-- Called when a player attempts to use a character.
function SCHEMA:PlayerCanUseCharacter(player, character)
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
		local secondaryWeapon;
		local primaryWeapon;
		local sideWeapon;
		local fault;
		
		for k, v in ipairs( player:GetWeapons() ) do
			local weaponTable = nexus.item.GetWeapon(v);
			
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

-- Called when a player destroys generator.
function SCHEMA:PlayerDestroyGenerator(player, entity, generator)
	nexus.player.GiveCash( player, generator.cash / 4, "destroying a "..string.lower(generator.name) );
end;

-- Called when an entity's menu option should be handled.
function SCHEMA:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "prop_ragdoll" and arguments == "nx_corpseLoot") then
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
		if (entity.areBelongings and entity.inventory and entity.cash) then
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

-- Called just before a player dies.
function SCHEMA:DoPlayerDeath(player, attacker, damageInfo)
	local action = nexus.player.GetAction(player);
	
	self:TiePlayer(player, false, true);
	
	player.beingSearched = nil;
	player.searching = nil;
end;

-- Called just after a player spawns.
function SCHEMA:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local clothes = player:GetCharacterData("clothes");
	
	if (!lightSpawn) then
		umsg.Start("nx_ClearEffects", player);
		umsg.End();
		
		player.beingSearched = nil;
		player.searching = nil;
	end;
	
	if (player:GetSharedVar("sh_Tied") != 0) then
		self:TiePlayer(player, true);
	end;
	
	if (clothes) then
		local itemTable = nexus.item.Get(clothes);
		
		if ( itemTable and player:HasItem(itemTable.uniqueID) ) then
			self:PlayerWearClothes(player, itemTable);
		else
			player:SetCharacterData("clothes", nil);
		end;
	end;
end;

-- Called when a player's footstep sound should be played.
function SCHEMA:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local clothes = player:GetCharacterData("clothes");
	
	if (clothes) then
		local itemTable = nexus.item.Get(clothes);
		
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
	
	player:EmitSound(sound);
	
	return true;
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
		if ( !IsValid(activator) ) then
			nexus.entity.OpenDoor(entity, 0, true, true);
		else
			self:BustDownDoor(activator, entity);
		end;
	end;
end;

-- Called when a player takes damage.
function SCHEMA:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local curTime = CurTime();
	
	if (player:Armor() <= 0) then
		umsg.Start("nx_Stunned", player);
			umsg.Float(0.5);
		umsg.End();
	else
		umsg.Start("nx_Stunned", player);
			umsg.Float(1);
		umsg.End();
	end;
	
	if (player:Health() <= 10 and math.random() <= 0.75) then
		if (nexus.player.GetAction(player) != "die") then
			nexus.player.SetRagdollState( player, RAGDOLL_FALLENOVER, nil, nil, NEXUS:ConvertForce( damageInfo:GetDamageForce() ) );
			
			nexus.player.SetAction(player, "die", 60, 1, function()
				if ( IsValid(player) and player:Alive() ) then
					player:TakeDamage(99999, attacker, inflictor);
				end;
			end);
		end;
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
function SCHEMA:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local endurance = nexus.attributes.Fraction(player, ATB_ENDURANCE, 0.75, 0.75);
	local clothes = player:GetCharacterData("clothes");
	
	damageInfo:ScaleDamage(1.5 - endurance);
	
	if (clothes) then
		local itemTable = nexus.item.Get(clothes);
		
		if (itemTable and itemTable.protection) then
			if ( damageInfo:IsBulletDamage() or (damageInfo:IsFallDamage() and itemTable.protection >= 0.8) ) then
				damageInfo:ScaleDamage(1 - itemTable.protection);
			end;
		end;
	end;
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