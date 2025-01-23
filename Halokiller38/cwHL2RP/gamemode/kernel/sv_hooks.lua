--[[
	Free Clockwork!
--]]


-- Called when a player's default model is needed.
function Clockwork.schema:GetPlayerDefaultModel(player)
	if ( self:IsPlayerCombineRank(player, "OfC") ) then
		return "models/policetrench.mdl";
	elseif ( self:IsPlayerCombineRank(player, "DvL") ) then
		return "models/eliteshockcp.mdl";
	elseif ( self:IsPlayerCombineRank(player, "SeC") ) then
		return "models/sect_police2.mdl";
	elseif (self:IsPlayerCombineRank(player, {"RCT", "UNIT"})) then
		return "models/police.mdl";
	elseif (self:IsPlayerCombineRank(player, "EOW")) then
		return "models/combine_super_soldier.mdl";
	end;
end;

-- Called when a player's character has initialized.
function Clockwork.schema:PlayerCharacterInitialized(player)
	local faction = player:QueryCharacter("faction");
	if ( self:PlayerIsCombine(player) ) then
		for k, v in pairs(Clockwork.class.stored) do
			if ( v.factions and table.HasValue(v.factions, faction) ) then
				if ( v.index == CLASS_MPF_SCN and self:IsPlayerCombineRank(player, "SCN") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_RCT and self:IsPlayerCombineRank(player, "RCT") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_UNIT and self:IsPlayerCombineRank(player, "UNIT") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_EPU and self:IsPlayerCombineRank(player, "EpU") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_OFC and self:IsPlayerCombineRank(player, "OfC") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_DVL and self:IsPlayerCombineRank(player, "DvL") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_MPF_SEC and self:IsPlayerCombineRank(player, "SeC") ) then
					Clockwork.class:Set(player, v.index); break;
				elseif ( v.index == CLASS_OTA and self:IsPlayerCombineRank(player, "EOW") ) then
					Clockwork.class:Set(player, v.index); break;
				end;
			end;
		end;
	elseif (faction == FACTION_CITIZEN) then
		local citizenid = player:GetCharacterData("citizenid") or "";
		if (string.len(citizenid) != 5) then
			for i = 1, 5 do
				citizenid = citizenid..math.random(0, 9);
			end;
			player:SetCharacterData("citizenid", citizenid);
		end;
		player:SetSharedVar("citizenid", citizenid);
	end;
end;

-- Called when a player's name has changed.
function Clockwork.schema:PlayerNameChanged(player, previousName, newName)
	if ( self:PlayerIsCombine(player) ) then
		local faction = player:QueryCharacter("faction");
		
		if (faction == FACTION_OTA) then
			if ( !self:IsStringCombineRank(previousName, "OWS") and self:IsStringCombineRank(newName, "OWS") ) then
				Clockwork.class:Set(player, CLASS_OTA);
			elseif ( !self:IsStringCombineRank(previousName, "EOW") and self:IsStringCombineRank(newName, "EOW") ) then
				Clockwork.class:Set(player, CLASS_OTA_ELITE);
			end;
		elseif (faction == FACTION_MPF) then
			if ( !self:IsStringCombineRank(previousName, "SCN") and self:IsStringCombineRank(newName, "SCN") ) then
				Clockwork.class:Set(player, CLASS_MPF_SCN, true);
				self:MakePlayerScanner(player, true);
			elseif ( !self:IsStringCombineRank(previousName, "RCT") and self:IsStringCombineRank(newName, "RCT") ) then
				Clockwork.class:Set(player, CLASS_MPF_RCT);
			elseif ( !self:IsStringCombineRank(previousName, "EpU") and self:IsStringCombineRank(newName, "EpU") ) then
				Clockwork.class:Set(player, CLASS_MPF_EPU);
				player:SetModel("models/eliteghostcp.mdl")
			elseif ( !self:IsStringCombineRank(previousName, "OfC") and self:IsStringCombineRank(newName, "OfC") ) then
				player:SetModel("models/policetrench.mdl");
				Clockwork.class:Set(player, CLASS_MPF_OFC);
			elseif ( !self:IsStringCombineRank(previousName, "DvL") and self:IsStringCombineRank(newName, "DvL") ) then
				player:SetModel("models/leet_police2.mdl");
				Clockwork.class:Set(player, CLASS_MPF_DVL);
			elseif ( !self:IsStringCombineRank(previousName, "SeC") and self:IsStringCombineRank(newName, "SeC") ) then
				player:SetModel("models/sect_police2.mdl");
				Clockwork.class:Set(player, CLASS_MPF_SEC);
			elseif ( !self:IsStringCombineRank(newName, "RCT") ) then
				if (player:Team() != CLASS_MPU) then
					Clockwork.class:Set(player, CLASS_MPF_UNIT);
				end;
			end;

		end;
	end;
end;

-- Called when a player attempts to use a lowered weapon.
function Clockwork.schema:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if (secondary and (weapon.SilenceTime or weapon.PistolBurst)) then
		return true;
	end;
end;

-- Called when a player switches their flashlight on or off.
function Clockwork.schema:PlayerSwitchFlashlight(player, on)
	if (on and !self:PlayerIsCombine(player)) then
		return false;
	end;
end;

-- Called when an item entity has taken damage.
function Clockwork.schema:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	if (itemTable:GetData("Rarity") == 2 or itemTable:GetData("Rarity") == 3) then
		damageInfo:ScaleDamage(0.25);
	end;
end;

-- Called when an entity fires some bullets.
function Clockwork.schema:EntityFireBullets(entity, bulletInfo)
	if (entity:IsPlayer()) then
		local weaponItemTable = Clockwork.item:GetByWeapon(entity:GetActiveWeapon());
		if (weaponItemTable and weaponItemTable:IsBasedFrom("custom_weapon")) then
			weaponItemTable:SetData(
				"Durability", math.Clamp(weaponItemTable:GetData("Durability") - 0.08, 0, 100) 
			);
		end;
	end;
	
	if (!bulletInfo.Tracer or bulletInfo.Tracer < 1) then
		return;
	end;
	
	local curTime = CurTime();
	local filter = {entity};
	
	if (entity:IsPlayer()) then
		table.insert(filter, entity:GetActiveWeapon());
	end;
	
	local traceLine = util.TraceLine({
		endpos = bulletInfo.Src + (bulletInfo.Dir * 4096),
		start = bulletInfo.Src,
		filter = filter
	});
	
end;

-- Called when an item entity has been destroyed.
function Clockwork.schema:ItemEntityDestroyed(itemEntity, itemTable)
	if (itemTable:GetData("Rarity") == 3) then
		Clockwork.player:PlaySound(nil, "sad_trombone.mp3");
			Clockwork.item:SendToPlayer(nil, itemTable);
		Clockwork.chatBox:Add(nil, nil, "destroyed_item", tostring(itemTable("itemID")));
	end;
end;

-- Called when a player is given an item.
function Clockwork.schema:PlayerItemGiven(player, itemTable, bForce)
	if (itemTable:GetData("Name") != "" and itemTable:GetData("Found") != nil
	and itemTable:GetData("Found") != true) then
		itemTable:SetData("Found", true);
		
		--[[ Only play the Zelda fanfare sound with legendary or unique items. --]]
		if (itemTable:GetData("Rarity") < 2) then return; end;
		
		if (!player.cwNextFoundItem or CurTime() >= player.cwNextFoundItem
		or itemTable:GetData("Rarity") == 3) then
			player.cwNextFoundItem = CurTime() + 16;
			
			if (itemTable:GetData("Rarity") == 3) then
				Clockwork.player:PlaySound(nil, "item_found.mp3");
			else
				Clockwork.player:PlaySound(nil, "buttons/button6.wav");
			end;
			
			Clockwork.item:SendToPlayer(nil, itemTable);
			Clockwork.chatBox:Add(nil, player, "found_item", tostring(itemTable("itemID")));
		end;
	end; 
end;

-- Called each tick.
function Clockwork.schema:Tick()
	local curTime = CurTime();
	
	if (!self.nextCleanDecals or curTime >= self.nextCleanDecals) then
		self.nextCleanDecals = curTime + 60;
		
		for k, v in ipairs(_player.GetAll()) do
			v:RunCommand("r_cleardecals");
		end;
	end;
	
	if (!self.nextDoorCheck or curTime >= self.nextDoorCheck) then
		self.nextDoorCheck = curTime + 10;
		
		if (string.lower(game.GetMap()) == "rp_c18_v1") then
			for k, v in ipairs(ents.GetAll()) do
				if (IsValid(v) and Clockwork.entity:IsDoor(v)) then
					local name = string.lower(v:GetName());
					
					if (name == "nxs_brnroom" or name == "nxs_brnroom2" or name == "nxs_al_door1"
					or name == "nxs_al_door2" or name == "nxs_brnbcroom") then
						if (!v.cwNextAutoClose or curTime >= v.cwNextAutoClose) then
							v:Fire("Close", "", 10);
							v.cwNextAutoClose = curTime + 10;
						end;
					end;
				end;
			end;
		end;
	end;
	
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

-- Called when a player's weapons should be given.
function Clockwork.schema:PlayerGiveWeapons(player)
	if (player:QueryCharacter("faction") == FACTION_MPF) then
		Clockwork.player:GiveSpawnWeapon(player, "cw_stunstick");
	end;
end;

-- Called when a player attempts to spawn a prop.
function Clockwork.schema:PlayerSpawnProp(player, model)
	model = string.Replace(model, "\\", "/");
	model = string.Replace(model, "//", "/");
	model = string.lower(model);
	
	if (player.cwNextCanSpawnProp and CurTime() < player.cwNextCanSpawnProp) then
		Clockwork.player:Notify(player, "You cannot spawn another prop for another "..math.ceil(player.cwNextCanSpawnProp - CurTime()).." second(s)!");
		return false;
	end;
end;

-- Called when a player has been given a weapon.
function Clockwork.schema:PlayerGivenWeapon(player, class, itemTable)
	if (Clockwork.item:IsWeapon(itemTable) and !itemTable:IsFakeWeapon()) then
		if (!itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon()) then
			if (itemTable("weight") <= 2) then
				Clockwork.player:CreateGear(player, "Secondary", itemTable);
			else
				Clockwork.player:CreateGear(player, "Primary", itemTable);
			end;
		-- elseif (itemTable:IsThrowableWeapon()) then
			-- Clockwork.player:CreateGear(player, "Throwable", itemTable);
		else
			Clockwork.player:CreateGear(player, "Melee", itemTable);
		end;
	end;
end;

-- Called when a player's drop weapon info should be adjusted.
function Clockwork.schema:PlayerAdjustDropWeaponInfo(player, info)
	if (Clockwork.player:GetWeaponClass(player) == info.itemTable("weaponClass")) then
		info.position = player:GetShootPos();
		info.angles = player:GetAimVector():Angle();
	else
		local gearTable = {
			Clockwork.player:GetGear(player, "Throwable"),
			Clockwork.player:GetGear(player, "Secondary"),
			Clockwork.player:GetGear(player, "Primary"),
			Clockwork.player:GetGear(player, "Melee")
		};
		
		for k, v in pairs(gearTable) do
			if (IsValid(v)) then
				if (v:GetItemTable():IsTheSameAs(info.itemTable)) then
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

-- Called when an entity is removed.
function Clockwork.schema:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll"
	and entity.cwIsBelongings and entity.cwInventory and entity.cwCash) then
		if (table.Count(entity.cwInventory) > 0 or entity.cwCash > 0) then
			local belongings = ents.Create("cw_belongings");
				belongings:SetAngles(Angle(0, 0, -90));
				belongings:SetData(entity.cwInventory, entity.cwCash);
				belongings:SetPos(entity:GetPos() + Vector(0, 0, 32));
				belongings:Spawn();
			entity.cwInventory = nil;
			entity.cwCash = nil;
		end;
	end;
	
	if (IsValid(entity) and !entity.cwIsBelongings) then
		Clockwork.entity:DropItemsAndCash(entity.cwInventory, entity.cwCash, entity:GetPos(), entity);
		entity.cwInventory = nil;
		entity.cwCash = nil;
	end;
end;

-- Called when a player's prop cost info should be adjusted.
function Clockwork.schema:PlayerAdjustPropCostInfo(player, entity, info)
	local model = string.lower(entity:GetModel());
	
	if (self.containers[model]) then
		info.name = self.containers[model][2];
	end;
end;

-- Called when an entity's menu option should be handled.
function Clockwork.schema:EntityHandleMenuOption(player, entity, option, arguments)
	local mineTypes = {"cw_firemine", "cw_freezemine", "cw_explomine"};
	
	if (entity:GetClass() == "cw_item" and option == "Customize"
	and Clockwork.player:HasFlags(player, "s")) then
		local itemTable = entity:GetItemTable();
		
		if (itemTable:IsBasedFrom("custom_weapon")) then
			itemTable:SetData("Rarity", arguments.rarity);
			itemTable:SetData("Damage", arguments.damage);
			itemTable:SetData("Desc", arguments.desc);
			itemTable:SetData("Name", arguments.name);
			player.cwItemCreateTime = CurTime() + 30;
		elseif (itemTable:IsBasedFrom("custom_clothes")) then
			itemTable:SetData("Rarity", arguments.rarity);
			itemTable:SetData("Armor", arguments.armor);
			itemTable:SetData("Desc", arguments.desc);
			itemTable:SetData("Name", arguments.name);
			player.cwItemCreateTime = CurTime() + 30;
		elseif (itemTable:IsBasedFrom("custom_storage")) then
			itemTable:SetData("Rarity", arguments.rarity);
			itemTable:SetData("Weight", arguments.weight);
			itemTable:SetData("Desc", arguments.desc);
			itemTable:SetData("Name", arguments.name);
			player.cwItemCreateTime = CurTime() + 30;
		elseif (itemTable("uniqueID") == "custom_script") then
			itemTable:SetData("Category", arguments.category);
			itemTable:SetData("Reusable", arguments.reusable);
			itemTable:SetData("UseText", arguments.useText);
			itemTable:SetData("Rarity", arguments.rarity);
			itemTable:SetData("Weight", arguments.weight);
			itemTable:SetData("Script", arguments.script);
			itemTable:SetData("Model", arguments.model);
			itemTable:SetData("Desc", arguments.desc);
			itemTable:SetData("Name", arguments.name);
			player.cwItemCreateTime = CurTime() + 30;
			
			entity:SetModel(arguments.model);
			entity:PhysicsInit(SOLID_VPHYSICS);
			
			--[[
				Save this custom item script. This could all be converted
				to MySQL for cross-server support.
			--]]
			
			itemTable:SaveToScripts();
		end;
	end;
	
	if (table.HasValue(mineTypes, entity:GetClass())) then
		if (arguments == "cwMineDefuse" and !player:GetSharedVar("IsTied")) then
			local defuseTime = Clockwork.schema:GetDexterityTime(player) * 2;
			
			Clockwork.player:SetAction(player, "defuse", defuseTime);
			
			Clockwork.player:EntityConditionTimer(player, entity, entity, defuseTime, 80, function()
				return player:Alive() and !player:IsRagdolled() and !player:GetSharedVar("IsTied");
			end, function(success)
				Clockwork.player:SetAction(player, "defuse", false);
				
				if (success) then
					entity:Defuse();
					entity:Remove();
				end;
			end);
		end;
	-- elseif (entity:GetClass() == "prop_ragdoll") then
		-- if (arguments == "cwCorpseLoot") then		
			-- if (!entity.cwInventory) then entity.cwInventory = {}; end;
			-- if (!entity.cwCash) then entity.cwCash = 0; end;
			
			-- local entityPlayer = Clockwork.entity:GetPlayer(entity);
			
			-- if (!entityPlayer or !entityPlayer:Alive()) then
				-- player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				
				-- Clockwork.storage:Open(player, {
					-- name = "Corpse",
					-- weight = 8,
					-- entity = entity,
					-- distance = 192,
					-- cash = entity.cwCash,
					-- inventory = entity.cwInventory,
					-- OnTakeItem = function(player, storageTable, itemTable)
						-- if (entity.cwClothesData and itemTable("itemID") == entity.cwClothesData[1]) then
							-- entity:SetModel(entity.cwClothesData[2]);
							-- entity:SetSkin(entity.cwClothesData[3]);
						-- end;
					-- end,
					-- OnGiveCash = function(player, storageTable, cash)
						-- entity.cwCash = storageTable.cash;
					-- end,
					-- OnTakeCash = function(player, storageTable, cash)
						-- entity.cwCash = storageTable.cash;
					-- end
				-- });
			-- end;
		-- end;
	elseif (entity:GetClass() == "cw_belongings" and arguments == "cwBelongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		Clockwork.storage:Open(player, {
			name = "Belongings",
			weight = 100,
			entity = entity,
			distance = 192,
			cash = entity.cwCash,
			inventory = entity.cwInventory,
			OnGiveCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash;
			end,
			OnTakeCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash;
			end,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity) and Clockwork.inventory:IsEmpty(entity.cwInventory)) then
					entity:Explode(entity:BoundingRadius() * 2);
					entity:Remove();
				end;
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false;
			end
		});
	elseif (entity:GetClass() == "cw_breach") then
		entity:CreateDummyBreach();
		entity:BreachEntity(player);
	elseif (entity:GetClass() == "cw_locker" and arguments == "cwContainerOpen") then
		self:OpenContainer(player, entity);
	elseif (arguments == "cwContainerOpen") then
		if (Clockwork.entity:IsPhysicsEntity(entity)) then
			local model = string.lower(entity:GetModel());
			
			if (self.containers[model]) then
				local containerWeight = self.containers[model][1];
				
				if (!entity.cwPassword or entity.cwIsBreached) then
					self:OpenContainer(player, entity, containerWeight);
				else
					umsg.Start("cwContainerPassword", player);
						umsg.Entity(entity);
					umsg.End();
				end;
			end;
		end;
	end;
end;

-- Called when a player's pain sound should be played.
function Clockwork.schema:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if ( self:PlayerIsCombine(player) ) then
		return "npc/metropolice/pain"..math.random(1, 4)..".wav";
	end;
end;


-- Called when Clockwork has loaded all of the entities.
function Clockwork.schema:ClockworkInitPostEntity()
	self:LoadLockerList();
	self:LoadRandomItems();
	self:LoadBelongings();
	self:LoadStorage();
	self:LoadRationDispensers();
	self:LoadCombineLocks();
end;

-- Called just after data should be saved.
function Clockwork.schema:PostSaveData()
	self:SaveBelongings();

end;

-- Called when data should be saved.
function Clockwork.schema:SaveData()
	self:SaveStorage();
	self:SaveRationDispensers();
	self:SaveCombineLocks();	
end;

-- Called when a player attempts to spray their tag.
function Clockwork.schema:PlayerSpray(player)
	if (!player:HasItemByID("spray_can") or player:GetSharedVar("IsTied")) then
		return true;
	end;
end;

-- Called when a player presses F3.
function Clockwork.schema:ShowSpare1(player)
	local traceLine = player:GetEyeTraceNoCursor();
	local target = Clockwork.entity:GetPlayer(traceLine.Entity);

	if (target and target:Alive()) then
		if (!target:GetSharedVar("IsTied")) then
			Clockwork.player:RunClockworkCommand(player, "InvAction", "use", "zip_tie");
		else
			Clockwork.player:RunClockworkCommand(player, "CharSearch");
		end;
	end;
end;

-- Called when a player spawns an object.
function Clockwork.schema:PlayerSpawnObject(player)
	if (player:GetSharedVar("IsTied")) then
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
		return false;
	end;
end;

-- Called when an entity attempts to be auto-removed.
function Clockwork.schema:EntityCanAutoRemove(entity)
	if (self.storage[entity] or entity:GetNetworkedString("Name") != "") then
		return false;
	end;
end;

-- Called when a player attempts to breach an entity.
function Clockwork.schema:PlayerCanBreachEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity)) then
		if (!Clockwork.entity:IsDoorHidden(entity)) then
			return true;
		end;
	end;
	
	if (entity.cwInventory and entity.cwPassword) then
		return true;
	end;
end;

-- Called when a player attempts to use the radio.
function Clockwork.schema:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if (player:HasItemByID("handheld_radio")) then
		if (self:PlayerIsCombine(player)) then
			player:SetCharacterData("Frequency", "911.9");
		end;
		if (!player:GetCharacterData("Frequency")) then
			Clockwork.player:Notify(player, "You need to set the radio frequency first!");
			return false;
		end;
	else
		Clockwork.player:Notify(player, "You do not own a radio!");
		return false;
	end;
end;

-- Called when a player attempts to use an entity in a vehicle.
function Clockwork.schema:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if (entity:IsPlayer() or Clockwork.entity:IsPlayerRagdoll(entity)) then
		return true;
	end;
end;

-- Called when a player attempts to use a door.
function Clockwork.schema:PlayerCanUseDoor(player, door)
	if (player:GetSharedVar("IsTied")) then
		return false;
	end;
	-- local name = string.lower(door:GetName());
	-- if (string.find(name, "nxs_") or string.find(name, "nexus_")) then
	if (!self:PlayerIsCombine(player)) then
		return false;
	end;
	-- end;
end;

-- Called when a player uses a door.
function Clockwork.schema:PlayerUseDoor(player, door)
	if (string.lower(game.GetMap()) == "rp_c18_v1") then
		local name = string.lower(door:GetName());
		
		if (string.find(name, "nxs_") or string.find(name, "nexus_")) then
			local curTime = CurTime();
			
			if (!door.cwNextAutoClose or curTime >= door.cwNextAutoClose) then
				door:Fire("Close", "", 10);
				door.cwNextAutoClose = curTime + 10;
			end;
		end;
	end;
end;

-- Called when a player's radio info should be adjusted.
function Clockwork.schema:PlayerAdjustRadioInfo(player, info)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and v:HasItemByID("handheld_radio")) then
			if (v:GetCharacterData("Frequency") == player:GetCharacterData("Frequency")) then
				if (!v:GetSharedVar("IsTied")) then
					info.listeners[v] = v;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to use a tool.
function Clockwork.schema:CanTool(player, traceLine, tool)
	if (!Clockwork.player:HasFlags(player, "w")) then
		if (string.sub(tool, 1, 5) == "wire_" or string.sub(tool, 1, 6) == "wire2_") then
			player:RunCommand("gmod_toolmode \"\"");
			return false;
		end;
	end;
end;

-- Called when a player's character data should be saved.
function Clockwork.schema:PlayerSaveCharacterData(player, data)
	if (data["LockerItems"]) then
		data["LockerItems"] = Clockwork.inventory:ToSaveable(data["LockerItems"]);
	end;
end;

-- Called when a player's character data should be restored.
function Clockwork.schema:PlayerRestoreCharacterData(player, data)
	if (!data["Notepad"]) then data["Notepad"] = ""; end;
	if (!data["Stamina"]) then data["Stamina"] = 100; end;
	if (!data["GroupInfo"]) then data["GroupInfo"] = {}; end;
	
	data["LockerItems"] = Clockwork.inventory:ToLoadable(data["LockerItems"] or {});
	data["LockerCash"] = data["LockerCash"] or 0;
end;

-- Called when a player has been bIsHealed.
function Clockwork.schema:PlayerHealed(player, healer, itemTable)
	
end;

-- Called when a player's shared variables should be set.
function Clockwork.schema:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("Group", player:GetCharacterData("GroupInfo").name);
	player:SetSharedVar("Stamina", player:GetCharacterData("Stamina"));
	player:SetSharedVar("NextQuit", player.cwNextCanDisconnect or 0);
	player:SetSharedVar("customclass", player:GetCharacterData("customclass"));
end;

-- Called when a player has been unragdolled.
function Clockwork.schema:PlayerUnragdolled(player, state, ragdoll)
	Clockwork.player:SetAction(player, "die", false);
end;

-- Called when a player has been ragdolled.
function Clockwork.schema:PlayerRagdolled(player, state, ragdoll)
	Clockwork.player:SetAction(player, "die", false);
end;

-- Called at an interval while a player is connected.
function Clockwork.schema:PlayerThink(player, curTime, infoTable)
	if (player:Alive() and !player:IsRagdolled()) then
		if (!player:InVehicle() and player:GetMoveType() == MOVETYPE_WALK) then
			if (player:IsInWorld()) then
				if (!player:IsOnGround() and player:GetGroundEntity() != GetWorldEntity()) then
					player:ProgressAttribute(ATB_ACROBATICS, 0.25, true);
				elseif (infoTable.isRunning) then
					player:ProgressAttribute(ATB_AGILITY, 0.125, true);
				elseif (infoTable.isJogging) then
					player:ProgressAttribute(ATB_AGILITY, 0.0625, true);
				end;
			end;
		end;
	end;
	
	if (Clockwork.player:HasAnyFlags(player, "vV")) then
		if (infoTable.wages == 0) then
			infoTable.wages = 5;
		end;
	end;
	
	
	local regeneration = 0;
	local acrobatics = Clockwork.attributes:Fraction(player, ATB_ACROBATICS, 175, 50);
	local aimVector = tostring(player:GetAimVector());
	local strength = Clockwork.attributes:Fraction(player, ATB_STRENGTH, 8, 4);
	local agility = Clockwork.attributes:Fraction(player, ATB_AGILITY, 50, 25);
	local velocity = player:GetVelocity():Length();
	local armor = player:Armor();
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = math.Clamp(infoTable.jumpPower + acrobatics, 0, infoTable.jumpPower);
	infoTable.runSpeed = infoTable.runSpeed + agility;
	
	local mediumKevlar = Clockwork.item:FindByID("medium_kevlar");
	local heavyKevlar = Clockwork.item:FindByID("heavy_kevlar");
	local lightKevlar = Clockwork.item:FindByID("kevlar_vest");
	local playerGear = Clockwork.player:GetGear(player, "KevlarVest");
	
	if (armor > 100) then
		if (!playerGear or playerGear:GetItemTable()("uniqueID") != "heavy_kevlar") then
			Clockwork.player:CreateGear(player, "KevlarVest", heavyKevlar);
		end;
	elseif (armor > 50) then
		if (!playerGear or playerGear:GetItemTable()("uniqueID") != "medium_kevlar") then
			Clockwork.player:CreateGear(player, "KevlarVest", mediumKevlar);
		end;
	elseif (armor > 0) then
		if (!playerGear or playerGear:GetItemTable()("uniqueID")!= "kevlar_vest") then
			Clockwork.player:CreateGear(player, "KevlarVest", lightKevlar);
		end;
	end;
	
	if (!player:IsRunning()) then
		if (player:GetVelocity():Length() == 0) then
			if (player:Crouching()) then
				regeneration = 1;
			else
				regeneration = 0.5;
			end;
		else
			regeneration = 0.25;
		end;
	else
		player:ProgressAttribute(ATB_STAMINA, 0.125, true);
		player:SetCharacterData(
			"Stamina", math.Clamp(player:GetCharacterData("Stamina") - 1, 0, 100)
		);
	end;
	
	if (regeneration > 0) then
		player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") + regeneration, 0, 100));
	end;
	
	if ( self.scanners[player] ) then
		self:CalculateScannerThink(player, curTime);
	end;
	
	local newRunSpeed = infoTable.runSpeed;
	local diffRunSpeed = newRunSpeed - infoTable.walkSpeed;
	
	infoTable.runSpeed = newRunSpeed - (diffRunSpeed - ((diffRunSpeed / 100) * player:GetCharacterData("Stamina")));
end;

-- Called when a player uses an item.
function Clockwork.schema:PlayerUseItem(player, itemTable)
	if (itemTable("category") == "Consumables"
	or itemTable("category") == "Alcohol") then
		player:SetCharacterData("Stamina", 100);
	end;
end;

-- Called when attempts to use a command.
function Clockwork.schema:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetSharedVar("IsTied")) then
		local blacklisted = {
			"OrderShipment",
			"Radio"
		};
		
		if (table.HasValue(blacklisted, commandTable.name)) then
			Clockwork.player:Notify(player, "You cannot use this command when you are tied!");
			return false;
		end;
	end;
end;

-- Called when a player attempts to use an entity.
function Clockwork.schema:PlayerUse(player, entity)
	local curTime = CurTime();
	
	if (entity.cwIsBustedDown) then
		return false;
	end;
	
	if (player:GetSharedVar("IsTied")) then
		if (entity:IsVehicle()) then
			if (Clockwork.entity:IsChairEntity(entity) or Clockwork.entity:IsPodEntity(entity)) then
				return;
			end;
		end;
		
		if (!player.cwNextTieNotice or player.cwNextTieNotice < CurTime()) then
			Clockwork.player:Notify(player, "You cannot use that when you are tied!");
			player.cwNextTieNotice = CurTime() + 2;
		end;
		return false;
	end;
end;

-- Called when a player attempts to destroy an item.
function Clockwork.schema:PlayerCanDestroyItem(player, itemTable, bNoMsg)
	if (player:GetSharedVar("IsTied")) then
		if (!bNoMsg) then
			Clockwork.player:Notify(player, "You cannot destroy items when you are tied!");
		end;
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function Clockwork.schema:PlayerCanDropItem(player, itemTable, bNoMsg)
	if (player:GetSharedVar("IsTied")) then
		if (!bNoMsg) then
			Clockwork.player:Notify(player, "You cannot drop items when you are tied!");
		end;
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function Clockwork.schema:PlayerCanUseItem(player, itemTable, bNoMsg)
	if (player:GetSharedVar("IsTied")) then
		if (!bNoMsg) then
			Clockwork.player:Notify(player, "You cannot use items when you are tied!");
		end;
		return false;
	end;
	
	if (Clockwork.item:IsWeapon(itemTable) and !itemTable:IsFakeWeapon()) then
		local isThrowableWeapon = nil;
		local secondaryWeapon = nil;
		local primaryWeapon = nil;
		local isMeleeWeapon = nil;
		local fault = nil;
		
		for k, v in ipairs(player:GetWeapons()) do
			local itemTable = Clockwork.item:GetByWeapon(v);
			
			if (itemTable and !itemTable:IsFakeWeapon()) then
				if (!itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon()) then
					if (itemTable("weight") <= 2) then
						secondaryWeapon = true;
					else
						primaryWeapon = true;
					end;
				elseif (itemTable:IsThrowableWeapon()) then
					isThrowableWeapon = true;
				else
					isMeleeWeapon = true;
				end;
			end;
		end;
		
		if (!itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon()) then
			if (itemTable("weight") <= 2) then
				if (secondaryWeapon) then
					fault = "You cannot use another secondary weapon!";
				end;
			elseif (primaryWeapon) then
				fault = "You cannot use another secondary weapon!";
			end;
		elseif (itemTable:IsThrowableWeapon()) then
			if (isThrowableWeapon) then
				fault = "You cannot use another throwable weapon!";
			end;
		elseif (isMeleeWeapon) then
			fault = "You cannot use another melee weapon!";
		end;
		
		if (fault) then
			if (!bNoMsg) then
				Clockwork.player:Notify(player, fault);
			end;
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to say something out-of-character.
function Clockwork.schema:PlayerCanSayOOC(player, text)
	return true;
end;

-- Called when a player attempts to say something locally out-of-character.
function Clockwork.schema:PlayerCanSayLOOC(player, text)
	if (!player:Alive()) then
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
	end;
end;

-- Called when chat box info should be adjusted.
function Clockwork.schema:ChatBoxAdjustInfo(info)
	if (IsValid(info.speaker) and info.speaker:HasInitialized()) then
		if (info.class != "ooc" and info.class != "looc") then
			if (IsValid(info.speaker) and info.speaker:HasInitialized()) then
				if (string.sub(info.text, 1, 1) == "?") then
					info.text = string.sub(info.text, 2);
					info.data.anon = true;
				end;
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
				Clockwork.player:PlaySound(nil, v.sound);
				
				info.text = v.phrase;
				
				return true;
			end;
		end;
	end;	
	
end;


-- Called when a chat box message has been added.
function Clockwork.schema:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = Clockwork.config:Get("talk_radius"):Get();
		local listeners = {};
		local players = _player.GetAll();
		local data = {};
		
		if (IsValid(data.entity) and data.frequency != "") then
			for k, v in ipairs(players) do
				if ( v:HasInitialized() and v:Alive() and !v:IsRagdolled(RAGDOLL_FALLENOVER) ) then
					if ( ( v:GetCharacterData("frequency") == data.frequency and v:GetSharedVar("IsTied") == 0
					and v:HasItem("handheld_radio") ) or info.speaker == v ) then
						listeners[v] = v;
					elseif (v:GetPos():Distance(data.position) <= talkRadius) then
						eavesdroppers[v] = v;
					end;
				end;
			end;

			
			if (table.Count(listeners) > 0) then
				Clockwork.chatBox:Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				Clockwork.chatBox:Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
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
					Clockwork.player:PlaySound(v, info.voice.sound);
				end;
			end;
		end;
	end;
end;

-- Called when a player dies.
function Clockwork.schema:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (attacker:IsPlayer()) then
		if (IsValid(weapon)) then
			umsg.Start("cwDeath", player);
				umsg.Entity(weapon);
			umsg.End();
		else
			umsg.Start("cwDeath", player);
			umsg.End();
		end;
	else
		umsg.Start("cwDeath", player);
		umsg.End();
	end;

end;

-- Called just before a player dies.
function Clockwork.schema:DoPlayerDeath(player, attacker, damageInfo)
	self:TiePlayer(player, false, true);
	player.cwIsBeingSearched = nil;
	player.cwIsSearchingChar = nil;
end;

-- Called when a player's storage should close.
function Clockwork.schema:PlayerStorageShouldClose(player, storage)
	local entity = player:GetStorageEntity();
	
	if (player.cwIsSearchingChar and entity:IsPlayer()
	and !entity:GetSharedVar("IsTied")) then
		return true;
	end;
end;


-- Called when a player presses a key.
function Clockwork.schema:KeyPress(player, key)
	if (key == IN_USE) then
		if ( !self.scanners[player] ) then
			local untieTime = Clockwork.schema:GetDexterityTime(player);
			local target = player:GetEyeTraceNoCursor().Entity;
			local entity = target;
			
			if ( IsValid(target) ) then
				target = Clockwork.entity:GetPlayer(target);
				
				if (target and player:GetSharedVar("IsTied") == 0) then
					if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
						if (target:GetSharedVar("IsTied") != 0) then
							Clockwork.player:SetAction(player, "untie", untieTime);
							
							Clockwork.player:EntityConditionTimer(player, target, entity, untieTime, 192, function()
								return player:Alive() and !player:IsRagdolled() and player:GetSharedVar("IsTied") == 0;
							end, function(success)
								if (success) then
									self:TiePlayer(target, false);
								end;
								
								Clockwork.player:SetAction(player, "untie", false);
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
						
						if (Clockwork.player:CanSeeEntity( v, scanner, 0.9, {marker} ) and playerDot >= threshold and scannerDot >= threshold) then
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
								
								umsg.Start("cwStunned", v);
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
			Clockwork.player:RunClockworkCommand(player, "CharFollow");
		end;
	end;
end;

-- Called when a player attempts to fire a weapon.
function Clockwork.schema:PlayerCanFireWeapon(player, bIsRaised, weapon, bIsSecondary)
	if (bIsRaised and weapon:GetClass() != "cw_stealthcamo") then
		local stealthCamo = player:GetWeapon("cw_stealthcamo");
		local usingStealth = (ValidEntity(stealthCamo) and stealthCamo:IsActivated());
		
		if (usingStealth and player:GetVelocity():Length() <= 1) then
			return false;
		end;
	end;
end;

-- Called just after a player spawns.
function Clockwork.schema:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local team = player:Team();
	
	if (!lightSpawn) then
		player:SetCharacterData("Stamina", 100);
		
		umsg.Start("cwClearEffects", player);
		umsg.End();
		
		if (self:PlayerIsCombine(player) or player:QueryCharacter("faction") == FACTION_CITYADMIN) then
			if (player:QueryCharacter("faction") == FACTION_OTA) then
				player:SetMaxHealth(150);
				player:SetMaxArmor(150);
				player:SetHealth(150);
				player:SetArmor(150);
			else
				player:SetArmor(80);
			end;
		end;
		
		-- if (self:PlayerIsCombine(player) and player:GetAmmoCount("pistol") == 0) then
			-- if (!player:HasItemByID("ammo_pistol")) then
				-- player:GiveItem(Clockwork.item:CreateInstance("ammo_pistol"), true);
			-- end;
		-- end;
		
		player.cwIsBeingSearched = nil;
		player.cwIsSearchingChar = nil;
	end;
	
	if (player:GetSharedVar("IsTied")) then
		self:TiePlayer(player, true);
	end;
	
	if ( self:IsPlayerCombineRank(player, "SCN") ) then
		self:MakePlayerScanner(player, true, lightSpawn);
	else
		self:ResetPlayerScanner(player);
	end;
	
	if (self:PlayerIsCombine(player)) then
		if (!player:HasItemByID("handheld_radio")) then
			player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"));
		end;
		if (!player:HasItemByID("id_locked_usp-m")) then
			player:GiveItem(Clockwork.item:CreateInstance("id_locked_usp-m"));
		end;
	end;
end;

-- Called when a player's footstep sound should be played.
function Clockwork.schema:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local clothesItem = player:GetClothesItem();
	
	if (clothesItem) then
		if (player:IsRunning() or player:IsJogging()) then
			if (clothesItem.runSound) then
				if (type(clothesItem.runSound) == "table") then
					sound = clothesItem.runSound[math.random(1, #clothesItem.runSound)];
				else
					sound = clothesItem.runSound;
				end;
			end;
		elseif (clothesItem.walkSound) then
			if (type(clothesItem.walkSound) == "table") then
				sound = clothesItem.walkSound[math.random(1, #clothesItem.walkSound)];
			else
				sound = clothesItem.walkSound;
			end;
		end;
	end;
	
	local model = string.lower(player:GetModel());
	local running = false;
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
end;

-- Called when a player throws a punch.
function Clockwork.schema:PlayerPunchThrown(player)
	player:ProgressAttribute(ATB_STRENGTH, 0.25, true);
end;

-- Called when a player punches an entity.
function Clockwork.schema:PlayerPunchEntity(player, entity)
	if (entity:IsPlayer() or entity:IsNPC()) then
		player:ProgressAttribute(ATB_STRENGTH, 1, true);
	else
		player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	end;
end;

-- Called when an entity has been breached.
function Clockwork.schema:EntityBreached(entity, activator)
	local curTime = CurTime();
	
	if (Clockwork.entity:IsDoor(entity)) then
		Clockwork.entity:OpenDoor(entity, 0, true, true);
	end;
	
	if (entity.cwInventory and entity.cwPassword) then
		entity.cwIsBreached = true;
		Clockwork:CreateTimer("ResetBreach"..entity:EntIndex(), 120, 1, function()
			if (IsValid(entity)) then entity.cwIsBreached = nil; end;
		end);
	end;
	
	for k, v in ipairs(ents.FindByClass("cw_door_guarder")) do
		if (entity:GetPos():Distance(v:GetPos()) < 256) then
			local owner = Clockwork.entity:GetOwner(v);
			
			if (IsValid(owner) and (!owner.cwNextDoorAlert
			or curTime >= owner.cwNextDoorAlert)) then
				Clockwork.chatBox:Add(owner, nil, "alert",
					"Your door guarder has detected that a door is under attack!"
				);
				owner.cwNextDoorAlert = curTime + 60;
			end;
		end;
	end;
end;

-- Called when a player takes damage.
function Clockwork.schema:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local curTime = CurTime();
	
	if (damageInfo:IsBulletDamage()) then
		if (player:Armor() > 0) then
			umsg.Start("cwShotEffect", player);
				umsg.Float(0.25);
			umsg.End();
		else
			umsg.Start("cwShotEffect", player);
				umsg.Float(0.5);
			umsg.End();
		end;
	end;
	
	if (player:Health() <= 10 and math.random() <= 0.75) then
		if (Clockwork.player:GetAction(player) != "die") then
			Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil, nil, Clockwork:ConvertForce(damageInfo:GetDamageForce() * 32));
			Clockwork.player:SetAction(player, "die", 60, 1, function()
				if (IsValid(player) and player:Alive()) then
					player:TakeDamage(player:Health() * 2, attacker, inflictor);
				end;
			end);
			
			player.cwNextCanDisconnect = curTime +90;
		end;
	end;
	
	if (attacker:IsPlayer()) then
		umsg.Start("cwTakeDmg", player);
			umsg.Entity(attacker);
			umsg.Short(damageInfo:GetDamage());
		umsg.End();
		
		umsg.Start("cwDealDmg", attacker);
			umsg.Entity(player);
			umsg.Short(damageInfo:GetDamage());
		umsg.End();
	end;
	
	if (!player.cwNextCanDisconnect or curTime > player.cwNextCanDisconnect + 60) then
		player.cwNextCanDisconnect = curTime + 60;
	end;
	
	local clothesItem = player:GetClothesItem();
	
	if (clothesItem) then
		clothesItem:SetData(
			"Durability", math.Clamp(
				clothesItem:GetData("Durability") - (damageInfo:GetDamage() / 50), 0, 100
			)
		);
	end;
end;

-- Called when a player's limb damage is bIsHealed.
function Clockwork.schema:PlayerLimbDamageHealed(player, hitGroup, amount)
	if (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH) then
		player:BoostAttribute("Limb Damage", ATB_ENDURANCE, false);
	elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
		player:BoostAttribute("Limb Damage", ATB_ACROBATICS, false);
		player:BoostAttribute("Limb Damage", ATB_AGILITY, false);
	elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
		player:BoostAttribute("Limb Damage", ATB_STRENGTH, false);
	end;
end;

-- Called when a player's limb damage is reset.
function Clockwork.schema:PlayerLimbDamageReset(player)
	player:BoostAttribute("Limb Damage", nil, false);
end;

-- Called when a player's limb takes damage.
function Clockwork.schema:PlayerLimbTakeDamage(player, hitGroup, damage)
	local limbDamage = Clockwork.limb:GetDamage(player, hitGroup);
	
	if (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH) then
		player:BoostAttribute("Limb Damage", ATB_ENDURANCE, -limbDamage);
	elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
		player:BoostAttribute("Limb Damage", ATB_ACROBATICS, -limbDamage);
		player:BoostAttribute("Limb Damage", ATB_AGILITY, -limbDamage);
	elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
		player:BoostAttribute("Limb Damage", ATB_STRENGTH, -limbDamage);
	end;
end;

-- A function to scale damage by hit group.
function Clockwork.schema:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local clothesItem = player:GetClothesItem();
	local endurance = Clockwork.attributes:Fraction(player, ATB_ENDURANCE, 0.4, 0.5);
	local curTime = CurTime();
	
	if (attacker:GetClass() == "entityflame") then
		if (!player.cwNextTakeBurnDmg or curTime >= player.cwNextTakeBurnDmg) then
			player.cwNextTakeBurnDmg = curTime + 0.1;
			damageInfo:SetDamage(1);
		else
			damageInfo:SetDamage(0);
		end;
	end;
	
	if (!damageInfo:IsFallDamage()) then
		damageInfo:ScaleDamage(1.25 - endurance);
	end;
	
	if (clothesItem and clothesItem:IsBasedFrom("custom_clothes")) then
		local armorScale = (clothesItem("armorScale") / 100) * clothesItem:GetData("Durability");
		damageInfo:ScaleDamage(1 - (armorScale * 0.75));
	end;
end;

-- Called when an entity takes damage.
function Clockwork.schema:EntityTakeDamage(entity, inflictor, attacker, amount, damageInfo)
	local curTime = CurTime();
	local player = Clockwork.entity:GetPlayer(entity);
	
	if (player and (!player.cwNextEnduranceTime or CurTime() > player.cwNextEnduranceTime)) then
		player:ProgressAttribute(ATB_ENDURANCE, math.Clamp(damageInfo:GetDamage(), 0, 75) / 10, true);
		player.cwNextEnduranceTime = CurTime() + 2;
	end;
	
	if (attacker:IsPlayer()) then
		local weaponItemTable = Clockwork.item:GetByWeapon(
			attacker:GetActiveWeapon()
		);
		
		if (!damageInfo:IsBulletDamage() and weaponItemTable
		and weaponItemTable:IsBasedFrom("custom_weapon")) then
			weaponItemTable:SetData(
				"Durability", math.Clamp(
					weaponItemTable:GetData("Durability") - 2, 0, 100
				)
			);
		end;
		
		local weaponItemTable = Clockwork.item:GetByWeapon(attacker:GetActiveWeapon());
		
		if (weaponItemTable and weaponItemTable:IsBasedFrom("custom_weapon")) then
			local damageScale = ((weaponItemTable("damageScale") / 100) / 100) * weaponItemTable:GetData("Durability");
			damageInfo:ScaleDamage(damageScale);
		end;
		
		damageInfo:ScaleDamage(0.5);
		
		local bDoorGuarder = false;
		
		if (damageInfo:IsBulletDamage() and !IsValid(entity.cwBreachEnt)) then
			if (string.lower(entity:GetClass()) == "prop_door_rotating") then
				if (!Clockwork.entity:IsDoorFalse(entity) and !bDoorGuarder) then
					local damagePosition = damageInfo:GetDamagePosition();
					
					if (entity:WorldToLocal(damagePosition):Distance(Vector(-1.0313, 41.8047, -8.1611)) <= 8) then
						local effectData = EffectData();
							effectData:SetStart(damagePosition);
							effectData:SetOrigin(damagePosition);
							effectData:SetScale(8);
						util.Effect("GlassImpact", effectData, true, true);
						
						Clockwork.entity:OpenDoor(entity, 0, true, true, attacker:GetPos());
					end;
				end;
			end;
		end;
	end;
end;