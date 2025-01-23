--[[
	Free Clockwork!
--]]

--[[
	This process must be performed in every schema's init.lua
	to initialize Clockwork properly and derive from sub-gamemodes
	effectively.
--]]
Clockwork = GM; DeriveGamemode("Clockwork");

--[[ Add and include the shared schema file. --]]
AddCSLuaFile("shared.lua"); AddCSLuaFile("cl_init.lua");
include("shared.lua");

--[[ Define some member variables for the schema. --]]
Clockwork.schema.randomItemInfo = {};
Clockwork.schema.lockerList = {};
Clockwork.schema.highestCost = 0;
Clockwork.schema.storage = {};

-- A function to check if a player is Combine.
function Clockwork.schema:PlayerIsCombine(player, bHuman)
	if ( IsValid(player) and player:GetCharacter() ) then
		local faction = player:QueryCharacter("faction");
		
		if ( self:IsCombineFaction(faction) ) then
			if (bHuman) then
				if (faction == FACTION_MPF) then
					return true;
				end;
			elseif (bHuman == false) then
				if (faction == FACTION_MPF) then
					return false;
				else
					return true;
				end;
			else
				return true;
			end;
		end;
	end;
end;

-- A function to load the random items.
function Clockwork.schema:LoadRandomItems()
	for k, v in pairs(Clockwork.item:GetAll()) do
		if (v("business") and !v("isRareItem") and !v("isBaseItem")) then
			if (v("cost") > self.highestCost) then
				self.highestCost = v.cost;
			end;
			
			self.randomItemInfo[#self.randomItemInfo + 1] = {
				v("uniqueID"), v("weight"), v("cost")
			};
		end;
	end;
end;

-- A function to get some random item info.
function Clockwork.schema:GetRandomItemInfo()
	if (#self.randomItemInfo <= 0) then
		return;
	end;
	
	local randomItemInfo = self.randomItemInfo[
		math.random(1, #self.randomItemInfo)
	];
	
	if (!randomItemInfo) then
		return;
	end;
	
	if (randomItemInfo[3]) then
		local iChance = (1 / self.highestCost) * math.min(randomItemInfo[3], self.highestCost * 0.99);
		
		if (math.random() < iChance) then
			return self:GetRandomItemInfo();
		else
			return randomItemInfo;
		end;
	else
		return randomItemInfo;
	end;
end;

-- A function to save the storage.
function Clockwork.schema:SaveStorage()
	local storage = {};
	
	for k, v in pairs(self.storage) do
		if (IsValid(v) and v.cwInventory and v.cwCash and (table.Count(v.cwInventory) > 0
		or v.cwCash > 0 or v:GetNetworkedString("Name") != "")) then
			local startPos = v:GetStartPosition();
			local physicsObject = v:GetPhysicsObject();
			local bMoveable = nil;
			local model = v:GetModel();
			
			if (v:IsMapEntity() and startPos) then
				model = nil;
			end;
			
			if (IsValid(physicsObject)) then
				bMoveable = physicsObject:IsMoveable();
			end;
			
			storage[#storage + 1] = {
				name = v:GetNetworkedString("Name"),
				cash = v.cwCash,
				model = model,
				color = { v:GetColor() },
				angles = v:GetAngles(),
				position = v:GetPos(),
				message = v.cwMessage,
				password = v.cwPassword,
				startPos = startPos,
				inventory = Clockwork.inventory:ToSaveable(v.cwInventory),
				isMoveable = bMoveable
			};
		end;
	end;
	
	Clockwork:SaveSchemaData("plugins/storage/"..game.GetMap(), storage);
end;

-- A function to load the storage.
function Clockwork.schema:LoadStorage()
	local storage = Clockwork:RestoreSchemaData("plugins/storage/"..game.GetMap());
	
	for k, v in pairs(storage) do
		if (!v.model) then
			local entity = ents.FindInSphere(v.startPos or v.position, 16)[1];
			
			if (IsValid(entity) and entity:IsMapEntity()) then
				self.storage[entity] = entity;
				
				entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
				entity.cwPassword = v.password;
				entity.cwMessage = v.message;
				entity.cwCash = v.cash;
				
				if (IsValid(entity:GetPhysicsObject())) then
					if (!v.isMoveable) then
						entity:GetPhysicsObject():EnableMotion(false);
					else
						entity:GetPhysicsObject():EnableMotion(true);
					end;
				end;
				
				if (v.angles) then
					entity:SetAngles(v.angles);
					entity:SetPos(v.position);
				end;
				
				if (v.color) then
					entity:SetColor(unpack(v.color));
				end;
				
				if (v.name != "") then
					entity:SetNetworkedString("Name", v.name);
				end;
			end;
		else
			local entity = ents.Create("prop_physics");
			
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (IsValid(entity:GetPhysicsObject())) then
				if (!v.isMoveable) then
					entity:GetPhysicsObject():EnableMotion(false);
				end;
			end;
			
			if (v.color) then
				entity:SetColor(unpack(v.color));
			end;
			
			if (v.name != "") then
				entity:SetNetworkedString("Name", v.name);
			end;
			
			self.storage[entity] = entity;
			
			entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
			entity.password = v.cwPassword;
			entity.message = v.cwMessage;
			entity.cwCash = v.cwCash;
		end;
	end;
end;

-- A function to save the locker list.
function Clockwork.schema:SaveLockerList()
	local lockerList = {};
	
	for k, v in pairs(ents.FindByClass("cw_locker")) do
		lockerList[#lockerList + 1] = {
			position = v:GetPos(),
			angles = v:GetAngles()
		};
	end;
	
	Clockwork:SaveSchemaData("plugins/personal/"..game.GetMap(), lockerList);
end;

-- A function to load the locker list.
function Clockwork.schema:LoadLockerList()
	local lockerList = Clockwork:RestoreSchemaData("plugins/personal/"..game.GetMap());
	
	for k, v in pairs(lockerList) do
		
		local locker = ents.Create("cw_locker");
		locker:SetAngles(v.angles);
		locker:SetPos(v.position);
		locker:Spawn();
		locker:GetPhysicsObject():EnableMotion(false);
	end;
end;



-- A function to save the ration dispensers.
function Clockwork.schema:SaveRationDispensers()
	local dispensers = {};
	
	for k, v in pairs( ents.FindByClass("cw_rationdispenser") ) do
		dispensers[#dispensers + 1] = {
			locked = v:IsLocked(),
			angles = v:GetAngles(),
			position = v:GetPos()
		};
	end;
	Clockwork:SaveSchemaData("plugins/dispensers/"..game.GetMap(), dispensers);
end;


-- A function to load the ration dispensers.
function Clockwork.schema:LoadRationDispensers()
	local dispensers = Clockwork:RestoreSchemaData( "plugins/dispensers/"..game.GetMap() );
	
	for k, v in pairs(dispensers) do
		local entity = ents.Create("cw_rationdispenser");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetAngles(v.angles);
			
			if (!v.locked) then
				entity:Unlock();
			else
				entity:Lock();
			end;
		end;
	end;
end;



-- A function to load the Combine locks.
function Clockwork.schema:LoadCombineLocks()
	local combineLocks = Clockwork:RestoreSchemaData( "plugins/locks/"..game.GetMap() );
	
	for k, v in pairs(combineLocks) do
		local entity = ents.FindInSphere(v.doorPosition, 16)[1];
		
		if ( IsValid(entity) ) then
			local combineLock = self:ApplyCombineLock(entity);
			
			if (combineLock) then
				Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
				
				combineLock:SetLocalAngles(v.angles);
				combineLock:SetLocalPos(v.position);
				
				if (!v.locked) then
					combineLock:Unlock();
				else
					combineLock:Lock();
				end;
			end;
		end;
	end;
end;

-- A function to save the Combine locks.
function Clockwork.schema:SaveCombineLocks()
	local combineLocks = {};
	
	for k, v in pairs( ents.FindByClass("cw_combinelock") ) do
		if ( IsValid(v.entity) ) then
			combineLocks[#combineLocks + 1] = {
				key = Clockwork.entity:QueryProperty(v, "key"),
				locked = v:IsLocked(),
				angles = v:GetLocalAngles(),
				position = v:GetLocalPos(),
				uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
				doorPosition = v.entity:GetPos()
			};
		end;
	end;
	
	Clockwork:SaveSchemaData("plugins/locks/"..game.GetMap(), combineLocks);
end;


-- A function to open a container for a player.
function Clockwork.schema:OpenContainer(player, entity, weight)
	local inventory = nil;
	local cash = 0;
	local name = "Locker";
	
	if (entity:GetClass() != "cw_locker") then
		local model = string.lower(entity:GetModel());
		
		if (!entity.cwInventory) then
			self.storage[entity] = entity;
			entity.cwInventory = {};
		end;
		
		if (!entity.cwCash) then
			entity.cwCash = 0;
		end;
		
		if (self.containers[model]) then
			name = self.containers[model][2];
		else
			name = "Container";
		end;
		
		inventory = entity.cwInventory;
		cash = entity.cwCash;
		
		if (!weight) then
			weight = 8;
		end;
	else
		inventory = player:GetCharacterData("LockerItems");
		weight = Clockwork.config:Get("max_locker_weight"):Get();
		cash = player:GetCharacterData("LockerCash");
	end;
	
	if (entity:GetNetworkedString("Name") != "") then
		name = entity:GetNetworkedString("Name");
	end;
	
	if (entity.cwMessage) then
		umsg.Start("cwStorageMessage", player);
			umsg.Entity(entity);
			umsg.String(entity.cwMessage);
		umsg.End();
	end;
	
	Clockwork.storage:Open(player, {
		name = name,
		cash = cash,
		weight = weight,
		entity = entity,
		distance = 192,
		inventory = inventory,
		OnGiveItem = function(player, storageTable, itemTable)
			if (player:IsWearingItem(itemTable)) then
				player:RemoveClothes();
			end;
		end,
		OnGiveCash = function(player, storageTable, cash)
			if (storageTable.entity:GetClass() == "cw_locker") then
				player:SetCharacterData("LockerCash", storageTable.cash);
			else
				storageTable.entity.cwCash = storageTable.cash;
			end;
		end,
		OnTakeCash = function(player, storageTable, cash)
			if (storageTable.entity:GetClass() == "cw_locker") then
				player:SetCharacterData("LockerCash", storageTable.cash);
			else
				storageTable.entity.cwCash = storageTable.cash;
			end;
		end
	});
end;

-- A function to make an explosion.
function Clockwork.schema:MakeExplosion(position, scale)
	local explosionEffect = EffectData();
	local smokeEffect = EffectData();
		explosionEffect:SetOrigin(position);
		explosionEffect:SetScale(scale);
		smokeEffect:SetOrigin(position);
		smokeEffect:SetScale(scale);
	util.Effect("explosion", explosionEffect, true, true);
	util.Effect("cw_smoke_effect", smokeEffect, true, true);
end;

-- A function to spawn a flash.
function Clockwork.schema:SpawnFlash(position)
	local curTime = CurTime();
	
	local effectData = EffectData();
		effectData:SetStart(position);
		effectData:SetOrigin(position);
		effectData:SetScale(16);
	util.Effect("Explosion", effectData, true, true);
	
	local effectData = EffectData();
		effectData:SetOrigin(position);
		effectData:SetScale(2);
	util.Effect("cw_smoke_effect", effectData, true, true);
	
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and v:GetPos():Distance(position) <= 768) then
			if (Clockwork.player:CanSeePosition(v, position, 0.9, true)) then
				umsg.Start("cwFlashed", v);
				umsg.End();
			end;
		end;
	end;
end;

-- A function to spawn tear gas.
function Clockwork.schema:SpawnTearGas(position)
	local curTime = CurTime();
	
	local effectData = EffectData();
		effectData:SetStart(position);
		effectData:SetOrigin(position);
		effectData:SetScale(16);
	util.Effect("Explosion", effectData, true, true);
	
	local effectData = EffectData();
		effectData:SetOrigin(position);
		effectData:SetScale(2);
	util.Effect("cw_smoke_effect", effectData, true, true);
	
	for k, v in ipairs(ents.FindInSphere(position, 512)) do
		if (v:IsPlayer() and v:HasInitialized()) then
			if (Clockwork.player:CanSeePosition(v, position, 0.9, true)) then
				local clothesItem = v:GetClothesItem();
				
				if (!clothesItem or !clothesItem("tearGasProtection")) then
					if (!v.nextTearGas or curTime >= v.nextTearGas) then
						v.nextTearGas = curTime + 30;
						
						umsg.Start("cwTearGas", v);
						umsg.End();
					end;
				end;
			end;
		end;
	end;
end;

-- A function to get a player's heal amount.
function Clockwork.schema:GetHealAmount(player, scale)
	return 15 * (scale or 1);
end;

-- A function to get a player's dexterity time.
function Clockwork.schema:GetDexterityTime(player)
	return 2;
end;

-- A function to bust down a door.
function Clockwork.schema:BustDownDoor(player, door, force)
	door.cwIsBustedDown = true;
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door:SetNoDraw(true);
	door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
	door:Fire("Unlock", "", 0);
	
	local fakeDoor = ents.Create("prop_physics");
	
	fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD);
	fakeDoor:SetAngles(door:GetAngles());
	fakeDoor:SetModel(door:GetModel());
	fakeDoor:SetSkin(door:GetSkin());
	fakeDoor:SetPos(door:GetPos());
	fakeDoor:Spawn();
	
	local physicsObject = fakeDoor:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		if (!force) then
			if (IsValid(player)) then
				physicsObject:ApplyForceCenter((door:GetPos() - player:GetPos()):Normalize() * 10000);
			end;
		else
			physicsObject:ApplyForceCenter(force);
		end;
	end;
	
	Clockwork.entity:Decay(fakeDoor, 300);
	
	Clockwork:CreateTimer("ResetDoor"..door:EntIndex(), 300, 1, function()
		if (IsValid(door)) then
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
			door.cwIsBustedDown = nil;
		end;
	end);
end;

-- A function to load the belongings.
function Clockwork.schema:LoadBelongings()
	local belongings = Clockwork:RestoreSchemaData("plugins/belongings/"..game.GetMap());
	
	for k, v in pairs(belongings) do
		local entity = ents.Create("cw_belongings");
		
		if (v.inventory["human_meat"]) then
			v.inventory["human_meat"] = nil;
		end;
		
		entity:SetAngles(v.angles);
		entity:SetData(
			Clockwork.inventory:ToLoadable(v.inventory),
			v.cwCash
		);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (!v.isMoveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the belongings.
function Clockwork.schema:SaveBelongings()
	local belongings = {};
	
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
		if (v.cwIsBelongings and (v.cwCash > 0 or table.Count(v.cwInventory) > 0)) then
			belongings[#belongings + 1] = {
				cash = v.cwCash,
				angles = Angle(0, 0, -90),
				position = v:GetPos() + Vector(0, 0, 32),
				inventory = Clockwork.inventory:ToSaveable(v.cwInventory),
				isMoveable = true
			};
		end;
	end;
	
	for k, v in pairs(ents.FindByClass("cw_belongings")) do
		if (v.cwCash and v.cwInventory and (v.cwCash > 0 or table.Count(v.cwInventory) > 0)) then
			local physicsObject = v:GetPhysicsObject();
			local bMoveable = nil;
			
			if (IsValid(physicsObject)) then
				bMoveable = physicsObject:IsMoveable();
			end;
			
			belongings[#belongings + 1] = {
				cash = v.cwCash,
				angles = v:GetAngles(),
				position = v:GetPos(),
				inventory = Clockwork.inventory:ToSaveable(v.cwInventory),
				isMoveable = bMoveable
			};
		end;
	end;
	
	Clockwork:SaveSchemaData("plugins/belongings/"..game.GetMap(), belongings);
end;

-- A function to tie or untie a player.
function Clockwork.schema:TiePlayer(player, isTied, reset, government)
	player:SetSharedVar("IsTied", isTied == true);
	
	if (isTied) then
		Clockwork.player:DropWeapons(player);
		Clockwork:PrintLog(LOGTYPE_GENERIC, player:Name().." has been restrained.");
		
		player:Flashlight(false);
		player:StripWeapons();
	elseif (!reset) then
		if (player:Alive() and !player:IsRagdolled()) then 
			Clockwork.player:LightSpawn(player, true, true);
		end;
		
		Clockwork:PrintLog(LOGTYPE_GENERIC, player:Name().." has been un-restrained.");
	end;
end;

resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf");
resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt");
resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl");
resource.AddFile("resource/fonts/OldNewspaperTypes.ttf");
resource.AddFile("materials/models/weapons/v_katana/katana.vtf");
resource.AddFile("materials/models/weapons/v_katana/katana.vmt");
resource.AddFile("models/weapons/v_shovel/v_shovel.mdl");
resource.AddFile("materials/models/weapons/sledge.vtf");
resource.AddFile("materials/models/weapons/sledge.vmt");
resource.AddFile("materials/models/weapons/shovel.vtf");
resource.AddFile("materials/models/weapons/shovel.vmt");
resource.AddFile("materials/models/weapons/axe.vtf");
resource.AddFile("materials/models/weapons/axe.vmt");
resource.AddFile("models/weapons/w_sledgehammer.mdl");
resource.AddFile("models/weapons/v_axe/v_axe.mdl");
resource.AddFile("models/weapons/w_katana.mdl");
resource.AddFile("models/weapons/v_katana.mdl");
resource.AddFile("models/weapons/w_shovel.mdl");
resource.AddFile("models/tactical_rebel.mdl");
resource.AddFile("models/weapons/w_axe.mdl");
resource.AddFile("sound/item_found.mp3");
resource.AddFile("sound/sad_trombone.mp3");

Clockwork.config:Add("intro_text_small", "We're glad you're taking part in this experiment.", true);
Clockwork.config:Add("intro_text_big", "WELCOME TO THE TEST BED", true);
Clockwork.config:Add("max_locker_weight", 30);

Clockwork.config:Get("enable_gravgun_punt"):Set(false);
Clockwork.config:Get("default_inv_weight"):Set(8);
Clockwork.config:Get("enable_crosshair"):Set(false);
Clockwork.config:Get("minimum_physdesc"):Set(16);
Clockwork.config:Get("scale_prop_cost"):Set(0.2);
Clockwork.config:Get("scale_head_dmg"):Set(2);
Clockwork.config:Get("disable_sprays"):Set(false);
Clockwork.config:Get("wages_interval"):Set(360);
Clockwork.config:Get("default_cash"):Set(120);

Clockwork.hint:Add("Healing", "You can heal players by using the Give command in your inventory.");
Clockwork.hint:Add("Zip Tie", "Press F3 while looking at a character to use a zip tie.");
Clockwork.hint:Add("Search Char", "Press F3 while looking at a restrained character to search them.");

Clockwork:HookDataStream("JoinGroup", function(player, data)
	if (!player.cwGroupInvite) then
		Clockwork.player:Notify(player, "You have not been invited to a group!");
		return;
	end;
	
	local groupInfo = player:GetCharacterData("GroupInfo");
		groupInfo.name = player.cwGroupInvite;
		groupInfo.isOwner = false;
		groupInfo.isLeader = false;
	player.cwGroupInvite = nil;
end);

Clockwork:HookDataStream("StartGroup", function(player, data)
	if (!player.cwGroupName) then
		Clockwork.player:Notify(player, "You have not specified a name for your group!");
		return;
	end;
	
	local groupName = string.gsub(string.sub(player.cwGroupName, 1, 32), "[%p%d]", "");
	
	tmysql.query("SELECT * FROM test_groups WHERE _Name = \""..tmysql.escape(groupName).."\"", function(result)
		if (!IsValid(player)) then return; end;
		
		if (result and type(result) == "table" and #result > 0) then
			Clockwork.player:Notify(player, "A group with the name "..groupName.." already exists!");
		elseif (Clockwork.player:CanAfford(player, 2000)) then
			tmysql.query("INSERT INTO test_groups (_Name) VALUES (\""..tmysql.escape(groupName).."\")", function(result)
				local groupInfo = player:GetCharacterData("GroupInfo");
					groupInfo.name = groupName;
					groupInfo.isOwner = true;
					groupInfo.isLeader = true;
				player.cwGroupName = nil;
				
				Clockwork.player:GiveCash(player, -2000, "creating a group");
				Clockwork.player:Notify(player, "You have created the "..groupName.." group.");
			end, 1);
		else
			Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(2000 - player:GetCash(), nil, true).."!");
		end;
	end, 1);
end);

Clockwork:HookDataStream("RepairItem", function(player, data)
	local itemTable = player:FindItemByID(data.uniqueID, data.itemID);
	if (!itemTable) then return end;
	
	local durability = itemTable:GetData("Durability");
	if (durability == 100) then return; end;
	
	local itemCost = itemTable("cost");
	local minPrice = itemCost * 0.25;
	local maxPrice = itemCost * 0.75;
	local repairCost = math.max((maxPrice / 100) * (100 - durability), minPrice);
	local useSounds = {"buttons/button5.wav", "buttons/button4.wav"};
	local currentCash = player:GetCash();
	
	if (Clockwork.player:CanAfford(player, repairCost)) then
		Clockwork.player:GiveCash(player, -repairCost, "repairing an item");
			player:EmitSound(useSounds[math.random(1, #useSounds)]);
		itemTable:SetData("Durability", 100);
	elseif (currentCash >= minPrice) then
		local newDurability = ((100 - durability) / repairCost) * currentCash;
		local newRepairCost = (repairCost / (100 - durability)) * newDurability;
		Clockwork.player:GiveCash(player, -newRepairCost, "repairing an item");
			player:EmitSound(useSounds[math.random(1, #useSounds)]);
		itemTable:SetData("Durability", durability + newRepairCost);
	else
		Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(repairCost - currentCash, nil, true).."!");
	end;
end);

Clockwork:HookDataStream("ContainerPassword", function(player, data)
	local password = data[1];
	local entity = data[2];
	
	if (IsValid(entity) and Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel());
		
		if (Clockwork.schema.containers[model]) then
			local containerWeight = Clockwork.schema.containers[model][1];
			
			if (entity.cwPassword == password) then
				Clockwork.schema:OpenContainer(player, entity, containerWeight);
			else
				Clockwork.player:Notify(player, "You have entered an incorrect password!");
			end;
		end;
	end;
end);

--[[
	The schema must be registered so that the kernel information
	can be included (entities, effects, weapons, etc). This must
	be done at the end of the init.lua and cl_init.lua files.
--]]

Clockwork.schema:Register();