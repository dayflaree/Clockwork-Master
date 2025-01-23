--[[
Name: "sv_auto.lua".
Product: "Severance".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf");
resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt");
resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl");
resource.AddFile("materials/vgui/entities/nx_zombie.vtf");
resource.AddFile("materials/vgui/entities/nx_zombie.vmt");
resource.AddFile("resource/fonts/nu_century_gothic.ttf");
resource.AddFile("models/weapons/v_shovel/v_shovel.mdl");
resource.AddFile("materials/models/weapons/sledge.vtf");
resource.AddFile("materials/models/weapons/sledge.vmt");
resource.AddFile("materials/models/weapons/shovel.vtf");
resource.AddFile("materials/models/weapons/shovel.vmt");
resource.AddFile("materials/models/weapons/axe.vtf");
resource.AddFile("materials/models/weapons/axe.vmt");
resource.AddFile("models/weapons/w_sledgehammer.mdl");
resource.AddFile("models/weapons/v_plank/v_plank.mdl");
resource.AddFile("models/weapons/v_axe/v_axe.mdl");
resource.AddFile("models/weapons/w_remingt.mdl");
resource.AddFile("models/weapons/v_remingt.mdl");
resource.AddFile("models/weapons/w_shovel.mdl");
resource.AddFile("models/weapons/w_plank.mdl");
resource.AddFile("models/weapons/w_remingt.mdl");
resource.AddFile("models/weapons/v_remingt.mdl");
resource.AddFile("models/weapons/w_axe.mdl");
resource.AddFile("models/sprayca2.mdl");

for k, v in pairs( g_File.Find("../materials/models/humans/female/group01/apocal*.*") ) do
	resource.AddFile("materials/models/humans/female/group01/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/humans/male/group01/apocal*.*") ) do
	resource.AddFile("materials/models/humans/male/group01/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/bloocobalt/clothes/*.*") ) do
	resource.AddFile("materials/models/bloocobalt/clothes/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/pmc/pmc_shared/*.*") ) do
	resource.AddFile("materials/models/pmc/pmc_shared/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/weapons/ashotgunskin1/*.*") ) do
	resource.AddFile("materials/models/weapons/ashotgunskin1/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/pmc/pmc_4/*.*") ) do
	resource.AddFile("materials/models/pmc/pmc_4/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/zed/male/*.*") ) do
	resource.AddFile("materials/models/zed/male/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/lagmite/*.*") ) do
	resource.AddFile("materials/models/lagmite/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/spraycan3.*") ) do
	resource.AddFile("materials/models/"..v);
end;

for k, v in pairs( g_File.Find("../materials/severance/*.*") ) do
	resource.AddFile("materials/severance/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/deadbodies/*.*") ) do
	resource.AddFile("materials/models/deadbodies/"..v);
end;

for k, v in pairs( g_File.Find("../models/bloocobalt/clothes/*.*") ) do
	resource.AddFile("models/bloocobalt/clothes/"..v);
end;

for k, v in pairs( g_File.Find("../models/deadbodies/*.*") ) do
	resource.AddFile("models/deadbodies/"..v);
end;

for k, v in pairs( g_File.Find("../models/lagmite/*.*") ) do
	resource.AddFile("models/lagmite/"..v);
end;

for k, v in pairs( g_File.Find("../sound/runner/*.*") ) do
	resource.AddFile("sound/runner/"..v);
end;

for k, v in pairs( g_File.Find("../models/zed/*.*") ) do
	resource.AddFile("models/zed/"..v);
end;

for k, v in pairs( g_File.Find("../models/pmc/pmc_4/*.mdl") ) do
	resource.AddFile("models/pmc/pmc_4/"..v);
end;

local groups = {34, 35, 36, 37, 38, 39, 40, 41};

for k, v in pairs(groups) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( g_File.Find("../models/humans/"..groupName.."/*.*") ) do
		resource.AddFile("models/humans/"..groupName.."/"..v2);
	end;
end;

nexus.config.Add("intro_text_small", "The dead walk the streets.", true);
nexus.config.Add("intro_text_big", "THE CITY OF LONDON, 2013.", true);

nexus.config.Get("enable_gravgun_punt"):Set(false);
nexus.config.Get("default_inv_weight"):Set(5);
nexus.config.Get("enable_crosshair"):Set(false);
nexus.config.Get("disable_sprays"):Set(false);
nexus.config.Get("default_flags"):Set("pe");
nexus.config.Get("cash_enabled"):Set(false, nil, true);
nexus.config.Get("door_cost"):Set(0);

nexus.hint.Add("Admins", "The admins are here to help you, please respect them.");
nexus.hint.Add("Grammar", "Try to speak correctly in-character, and don't use emoticons.");
nexus.hint.Add("Healing", "You can heal players by using the Give command in your inventory.");
nexus.hint.Add("F3 Hotkey", "Press F3 while looking at a character to use a zip tie.");
nexus.hint.Add("F4 Hotkey", "Press F3 while looking at a tied character to search them.");
nexus.hint.Add("Metagaming", "Metagaming is when you use OOC information in-character.");
nexus.hint.Add("Development", "Develop your character, give them a story to tell.");
nexus.hint.Add("Powergaming", "Powergaming is when you force your actions on others.");

NEXUS:HookDataStream("ObjectPhysDesc", function(player, data)
	if (type(data) == "table" and type( data[1] ) == "string") then
		if ( player.objectPhysDesc == data[2] ) then
			local physDesc = data[1];
			
			if (string.len(physDesc) > 80) then
				physDesc = string.sub(physDesc, 1, 80).."...";
			end;
			
			data[2]:SetNetworkedString("sh_PhysDesc", physDesc);
		end;
	end;
end);

-- A function to get a player's gear.
function SCHEMA:GetPlayerGear(player, class)
	local uniqueID = NEXUS:SetCamelCase(class.."Gear");
	
	if ( IsValid( player[uniqueID] ) ) then
		return player[uniqueID];
	end;
end;

-- A function to create a player's gear.
function SCHEMA:CreatePlayerGear(player, class, itemTable)
	local uniqueID = NEXUS:SetCamelCase(class.."Gear");
	
	if ( IsValid( player[uniqueID] ) ) then
		player[uniqueID]:Remove();
	end;
	
	if (itemTable.isAttachment) then
		local position = player:GetPos();
		local angles = player:GetAngles();
		
		player[uniqueID] = ents.Create("nx_gear");
		player[uniqueID]:SetParent(player);
		player[uniqueID]:SetAngles(angles);
		player[uniqueID]:SetColor(255, 255, 255, 0);
		player[uniqueID]:SetModel(itemTable.model);
		player[uniqueID]:SetPos(position);
		player[uniqueID]:Spawn();
		
		if (itemTable.color) then
			player[uniqueID]:SetColor( NEXUS:UnpackColor(itemTable.color) );
		end;
		
		if (itemTable.material) then
			player[uniqueID]:SetMaterial(material);
		end;
		
		if ( IsValid( player[uniqueID] ) ) then
			player[uniqueID]:SetOwner(player);
			player[uniqueID]:SetItem(itemTable);
		end;
	end;
end;

-- A function to load the radios.
function SCHEMA:LoadRadios()
	local radios = NEXUS:RestoreSchemaData( "mounts/radios/"..game.GetMap() );
	
	for k, v in pairs(radios) do
		local entity;
		
		if (v.frequency) then
			entity = ents.Create("nx_radio");
		end;
		
		nexus.player.GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetOff(v.off);
			
			if (v.frequency) then
				entity:SetFrequency(v.frequency);
			end;
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if ( IsValid(physicsObject) ) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to load the belongings.
function SCHEMA:LoadBelongings()
	local belongings = NEXUS:RestoreSchemaData( "mounts/belongings/"..game.GetMap() );
	
	for k, v in pairs(belongings) do
		local entity = ents.Create("nx_belongings");
		
		entity:SetAngles(v.angles);
		entity:SetData(v.inventory, v.cash);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if ( IsValid(physicsObject) ) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the belongings.
function SCHEMA:SaveBelongings()
	local belongings = {};
	
	for k, v in pairs( ents.FindByClass("prop_ragdoll") ) do
		if (v.areBelongings and v.cash and v.inventory) then
			if (v.cash > 0 or table.Count(v.inventory) > 0) then
				belongings[#belongings + 1] = {
					cash = v.cash,
					angles = Angle(0, 0, -90),
					moveable = true,
					position = v:GetPos() + Vector(0, 0, 32),
					inventory = v.inventory
				};
			end;
		end;
	end;
	
	for k, v in pairs( ents.FindByClass("nx_belongings") ) do
		if ( v.cash and v.inventory and (v.cash > 0 or table.Count(v.inventory) > 0) ) then
			local physicsObject = v:GetPhysicsObject();
			local moveable;
			
			if ( IsValid(physicsObject) ) then
				moveable = physicsObject:IsMoveable();
			end;
			
			belongings[#belongings + 1] = {
				cash = v.cash,
				angles = v:GetAngles(),
				moveable = moveable,
				position = v:GetPos(),
				inventory = v.inventory
			};
		end;
	end;
	
	NEXUS:SaveSchemaData("mounts/belongings/"..game.GetMap(), belongings);
end;

-- A function to save the radios.
function SCHEMA:SaveRadios()
	local radios = {};
	
	for k, v in pairs( ents.FindByClass("nx_radio") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = nexus.entity.QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = nexus.entity.QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetSharedVar("sh_Frequency")
		};
	end;
	
	NEXUS:SaveSchemaData("mounts/radios/"..game.GetMap(), radios);
end;

-- A function to permanently kill a player.
function SCHEMA:PermaKillPlayer(player, ragdoll)
	if ( player:Alive() ) then
		player:Kill(); ragdoll = player:GetRagdollEntity();
	end;
	
	local inventory = nexus.player.GetInventory(player);
	local cash = nexus.player.GetCash(player);
	local info = {};
	
	if ( !player:GetCharacterData("permakilled") ) then
		info.inventory = inventory;
		info.cash = cash;
		
		if ( !IsValid(ragdoll) ) then
			info.entity = ents.Create("nx_belongings");
		end;
		
		nexus.mount.Call("PlayerAdjustPermaKillInfo", player, info);
		
		for k, v in pairs(info.inventory) do
			local itemTable = nexus.item.Get(k);
			
			if (itemTable and itemTable.allowStorage == false) then
				info.inventory[k] = nil;
			end;
		end;
		
		player:SetCharacterData("inventory", {}, true);
		player:SetCharacterData("cash", 0, true);
		player:SetCharacterData("permakilled", true);
		
		if ( !IsValid(ragdoll) ) then
			if (table.Count(info.inventory) > 0 or info.cash > 0) then
				info.entity:SetData(info.inventory, info.cash);
				info.entity:SetPos( player:GetPos() + Vector(0, 0, 48) );
				info.entity:Spawn();
			else
				info.entity:Remove();
			end;
		else
			ragdoll.areBelongings = true;
			ragdoll.inventory = info.inventory;
			ragdoll.cash = info.cash;
		end;
		
		nexus.player.SaveCharacter(player);
	end;
end;

-- A function to make an explosion.
function SCHEMA:MakeExplosion(position, scale)
	local explosionEffect = EffectData();
	local smokeEffect = EffectData();
	
	explosionEffect:SetOrigin(position);
	explosionEffect:SetScale(scale);
	smokeEffect:SetOrigin(position);
	smokeEffect:SetScale(scale);
	
	util.Effect("explosion", explosionEffect, true, true);
	util.Effect("nx_effect_smoke", smokeEffect, true, true);
end;

-- A function to get a player's location.
function SCHEMA:PlayerGetLocation(player)
	local areaNames = nexus.mount.Get("Area Names");
	local closest;
	
	if (areaNames) then
		for k, v in pairs(areaNames.areaNames) do
			if ( nexus.entity.IsInBox(player, v.minimum, v.maximum) ) then
				if (string.sub(string.lower(v.name), 1, 4) == "the ") then
					return string.sub(v.name, 5);
				else
					return v.name;
				end;
			else
				local distance = player:GetShootPos():Distance(v.minimum);
				
				if ( !closest or distance < closest[1] ) then
					closest = {distance, v.name};
				end;
			end;
		end;
		
		if (!completed) then
			if (closest) then
				if (string.sub(string.lower( closest[2] ), 1, 4) == "the ") then
					return string.sub(closest[2], 5);
				else
					return closest[2];
				end;
			end;
		end;
	end;
	
	return "unknown location";
end;

-- A function to make a player wear clothes.
function SCHEMA:PlayerWearClothes(player, itemTable, noMessage)
	local clothes = player:GetCharacterData("clothes");
	
	if (itemTable) then
		local model = nexus.class.GetAppropriateModel(player:Team(), player, true);
		
		if (!model) then
			itemTable:OnChangeClothes(player, true);
			
			player:SetCharacterData("clothes", itemTable.index);
			player:SetSharedVar("sh_Clothes", itemTable.index);
		end;
	else
		itemTable = nexus.item.Get(clothes);
		
		if (itemTable) then
			itemTable:OnChangeClothes(player, false);
			
			player:SetCharacterData("clothes", nil);
			player:SetSharedVar("sh_Clothes", 0);
		end;
	end;
	
	if (itemTable) then
		player:UpdateInventory(itemTable.uniqueID);
	end;
end;

-- A function to get a player's heal amount.
function SCHEMA:GetHealAmount(player, scale)
	local medical = nexus.attributes.Fraction(player, ATB_MEDICAL, 35);
	local healAmount = (15 + medical) * (scale or 1);
	
	return healAmount;
end;

-- A function to get a player's dexterity time.
function SCHEMA:GetDexterityTime(player)
	return 7 - nexus.attributes.Fraction(player, ATB_DEXTERITY, 5, 5);
end;

-- A function to bust down a door.
function SCHEMA:BustDownDoor(player, door, force)
	door.bustedDown = true;
	
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door:SetNoDraw(true);
	door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
	door:Fire("Unlock", "", 0);
	
	if ( IsValid(door.breach) ) then
		door.breach:BreachEntity();
	end;
	
	local fakeDoor = ents.Create("prop_physics");
	
	fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD);
	fakeDoor:SetAngles( door:GetAngles() );
	fakeDoor:SetModel( door:GetModel() );
	fakeDoor:SetSkin( door:GetSkin() );
	fakeDoor:SetPos( door:GetPos() );
	fakeDoor:Spawn();
	
	local physicsObject = fakeDoor:GetPhysicsObject();
	
	if ( IsValid(physicsObject) ) then
		if (!force) then
			if ( IsValid(player) ) then
				physicsObject:ApplyForceCenter( (door:GetPos() - player:GetPos() ):Normalize() * 10000 );
			end;
		else
			physicsObject:ApplyForceCenter(force);
		end;
	end;
	
	nexus.entity.Decay(fakeDoor, 300);
	
	NEXUS:CreateTimer("Reset Door: "..door:EntIndex(), 300, 1, function()
		if ( IsValid(door) ) then
			door.bustedDown = nil;
			
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
		end;
	end);
end;

-- A function to tie or untie a player.
function SCHEMA:TiePlayer(player, boolean, reset)
	if (boolean) then
		player:SetSharedVar("sh_Tied", 1);
	else
		player:SetSharedVar("sh_Tied", 0);
	end;
	
	if (boolean) then
		nexus.player.DropWeapons(player);
		
		NEXUS:PrintDebug(player:Name().." has been tied.");
		
		player:Flashlight(false);
		player:StripWeapons();
	elseif (!reset) then
		if ( player:Alive() and !player:IsRagdolled() ) then 
			nexus.player.LightSpawn(player, true, true);
		end;
		
		NEXUS:PrintDebug(player:Name().." has been untied.");
	end;
end;