--[[
Name: "sv_auto.lua".
Product: "Day One".
--]]

BLUEPRINT:IncludePrefixed("sh_auto.lua");

resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf");
resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt");
resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl");
resource.AddFile("materials/models/humans/male/group01/dug_facemap.vmt");
resource.AddFile("materials/models/humans/male/group01/dug_facemap.vtf");
resource.AddFile("materials/models/humans/male/group01/dav_facemap.vmt");
resource.AddFile("materials/models/humans/male/group01/dav_facemap.vtf");
resource.AddFile("materials/models/weapons/v_katana/katana.vtf");
resource.AddFile("materials/models/weapons/v_katana/katana.vmt");
resource.AddFile("models/weapons/v_shovel/v_shovel.mdl");
resource.AddFile("models/weapons/v_axe/v_axe.mdl");
resource.AddFile("materials/models/weapons/sledge.vtf");
resource.AddFile("materials/models/weapons/sledge.vmt");
resource.AddFile("materials/models/weapons/shovel.vtf");
resource.AddFile("materials/models/weapons/shovel.vmt");
resource.AddFile("materials/models/weapons/axe.vtf");
resource.AddFile("materials/models/weapons/axe.vmt");
resource.AddFile("models/weapons/w_sledgehammer.mdl");
resource.AddFile("models/pmc/pmc_3/pmc__07.mdl");
resource.AddFile("models/pmc/pmc_3/pmc__04.mdl");
resource.AddFile("models/weapons/w_remingt.mdl");
resource.AddFile("models/weapons/v_remingt.mdl");
resource.AddFile("models/weapons/w_katana.mdl");
resource.AddFile("models/weapons/v_katana.mdl");
resource.AddFile("models/weapons/w_shovel.mdl");
resource.AddFile("resource/fonts/alsina.ttf");
resource.AddFile("models/weapons/w_axe.mdl");
resource.AddFile("models/sprayca2.mdl");

for k, v in pairs( g_File.Find("../materials/models/humans/female/group03/novusthr_sheet.*") ) do
	resource.AddFile("materials/models/humans/female/group03/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/humans/male/group03/novusthr_sheet.*") ) do
	resource.AddFile("materials/models/humans/male/group03/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/humans/female/group01/apoca*.*") ) do
	resource.AddFile("materials/models/humans/female/group01/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/humans/male/group01/apoca*.*") ) do
	resource.AddFile("materials/models/humans/male/group01/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/weapons/ashotgunskin1/*.*") ) do
	resource.AddFile("materials/models/weapons/ashotgunskin1/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/pmc/pmc_shared/*.*") ) do
	resource.AddFile("materials/models/pmc/pmc_shared/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/pmc/pmc_3/*.*") ) do
	resource.AddFile("materials/models/pmc/pmc_3/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/lagmite/*.*") ) do
	resource.AddFile("materials/models/lagmite/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/spraycan3.*") ) do
	resource.AddFile("materials/models/"..v);
end;

for k, v in pairs( g_File.Find("../materials/dayone/*.*") ) do
	resource.AddFile("materials/dayone/"..v);
end;

for k, v in pairs( g_File.Find("../materials/models/deadbodies/*.*") ) do
	resource.AddFile("materials/models/deadbodies/"..v);
end;

for k, v in pairs( g_File.Find("../models/deadbodies/*.*") ) do
	resource.AddFile("models/deadbodies/"..v);
end;

for k, v in pairs( g_File.Find("../models/lagmite/*.*") ) do
	resource.AddFile("models/lagmite/"..v);
end;

for k, v in pairs( {34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 97} ) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( g_File.Find("../models/humans/"..groupName.."/*.*") ) do
		resource.AddFile("models/humans/"..groupName.."/"..v2);
	end;
end;

blueprint.config.Add("intro_text_small", "A storm is rising in the Eastern front..", true);
blueprint.config.Add("intro_text_big", "1942, Crimea, Sevastopol", true);

blueprint.config.Get("enable_gravgun_punt"):Set(false);
blueprint.config.Get("default_inv_weight"):Set(1.5);
blueprint.config.Get("enable_crosshair"):Set(false);
blueprint.config.Get("scale_prop_cost"):Set(0);
blueprint.config.Get("disable_sprays"):Set(false);
blueprint.config.Get("default_flags"):Set("pe");
blueprint.config.Get("default_cash"):Set(0);
blueprint.config.Get("door_cost"):Set(0);

blueprint.hint.Add("Staff", "The staff are here to help you, please respect them.");
blueprint.hint.Add("Grammar", "Try to speak correctly in-character, and don't use emoticons.");
blueprint.hint.Add("Healing", "You can heal players by using the Give command in your inventory.");
blueprint.hint.Add("Metagaming", "Metagaming is when you use out-of-character information in-character.");
blueprint.hint.Add("Development", "Develop your character, give them a story to tell.");
blueprint.hint.Add("Powergaming", "Powergaming is when you force your actions on others.");

BLUEPRINT:HookDataStream("ObjectPhysDesc", function(player, data)
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
function DESIGN:GetPlayerGear(player, class)
	local uniqueID = BLUEPRINT:SetCamelCase(class.."Gear");
	
	if ( IsValid( player[uniqueID] ) ) then
		return player[uniqueID];
	end;
end;

-- A function to create a player's gear.
function DESIGN:CreatePlayerGear(player, class, itemTable)
	local uniqueID = BLUEPRINT:SetCamelCase(class.."Gear");
	
	if ( IsValid( player[uniqueID] ) ) then
		player[uniqueID]:Remove();
	end;
	
	if (itemTable.isAttachment) then
		local position = player:GetPos();
		local angles = player:GetAngles();
		
		player[uniqueID] = ents.Create("bp_gear");
		player[uniqueID]:SetParent(player);
		player[uniqueID]:SetAngles(angles);
		player[uniqueID]:SetColor(255, 255, 255, 0);
		player[uniqueID]:SetModel(itemTable.model);
		player[uniqueID]:SetPos(position);
		player[uniqueID]:Spawn();
		
		if (itemTable.color) then
			player[uniqueID]:SetColor( BLUEPRINT:UnpackColor(itemTable.color) );
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
function DESIGN:LoadRadios()
	local radios = BLUEPRINT:RestoreDesignData( "plugins/radios/"..game.GetMap() );
	
	for k, v in pairs(radios) do
		local entity;
		
		if (v.frequency) then
			entity = ents.Create("bp_radio");
		end;
		
		blueprint.player.GivePropertyOffline(v.key, v.uniqueID, entity);
		
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
function DESIGN:LoadBelongings()
	local belongings = BLUEPRINT:RestoreDesignData( "plugins/belongings/"..game.GetMap() );
	
	for k, v in pairs(belongings) do
		local entity = ents.Create("bp_belongings");
		
		if ( v.inventory["human_meat"] ) then
			v.inventory["human_meat"] = nil;
		end;
		
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

-- A function to load the trash spawns.
function DESIGN:LoadTrashSpawns()
	self.trashSpawns = BLUEPRINT:RestoreDesignData( "plugins/trash/"..game.GetMap() );
	
	if (!self.trashSpawns) then
		self.trashSpawns = {};
	end;
end;

-- A function to get a random trash spawn.
function DESIGN:GetRandomTrashSpawn()
	local position = self.trashSpawns[ math.random(1, #self.trashSpawns) ];
	local players = g_Player.GetAll();
	
	for k, v in ipairs(players) do
		if (v:HasInitialized() and v:GetPos():Distance(position) <= 1024) then
			if ( !blueprint.player.IsNoClipping(v) ) then
				return self:GetRandomTrashSpawn();
			end;
		end;
	end;
	
	return position;
end;

-- A function to get a random trash item.
function DESIGN:GetRandomTrashItem()
	local trashItem = self.trashItems[ math.random(1, #self.trashItems) ];
	
	if ( trashItem and math.random() <= ( 1 / (trashItem.worth * 2) ) ) then
		return trashItem;
	else
		return self:GetRandomTrashItem();
	end;
end;

-- A function to save the trash spawns.
function DESIGN:SaveTrashSpawns()
	BLUEPRINT:SaveDesignData("plugins/trash/"..game.GetMap(), self.trashSpawns);
end;

-- A function to save the belongings.
function DESIGN:SaveBelongings()
	local belongings = {};
	
	for k, v in pairs( ents.FindByClass("prop_ragdoll") ) do
		if (v.areBelongings) then
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
	
	for k, v in pairs( ents.FindByClass("bp_belongings") ) do
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
	
	BLUEPRINT:SaveDesignData("plugins/belongings/"..game.GetMap(), belongings);
end;

-- A function to save the radios.
function DESIGN:SaveRadios()
	local radios = {};
	
	for k, v in pairs( ents.FindByClass("bp_radio") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = blueprint.entity.QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = blueprint.entity.QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetSharedVar("sh_Frequency")
		};
	end;
	
	BLUEPRINT:SaveDesignData("plugins/radios/"..game.GetMap(), radios);
end;

-- A function to make a player drop their belongings.
function DESIGN:PlayerDropBelongings(player, ragdoll)
	local inventory = blueprint.player.GetInventory(player);
	local team = player:Team();
	local cash = blueprint.player.GetCash(player);
	local info = {
		inventory = {},
		cash = cash
	};
	
	for k, v in pairs(inventory) do
		local itemTable = blueprint.item.Get(k);
		
		if (itemTable and itemTable.allowStorage != false) then
			local success, fault = player:UpdateInventory(k, -v, true, true);
			
			if (success) then
				info.inventory[k] = v;
			end;
		end;
	end;
	
	player:SetCharacterData("cash", 0, true);
	
	if ( !IsValid(ragdoll) ) then
		if (table.Count(info.inventory) > 0 or info.cash > 0) then
			info.entity = ents.Create("bp_belongings");
				info.entity:SetAngles( Angle(0, 0, -90) );
				info.entity:SetData(info.inventory, info.cash);
				info.entity:SetPos( player:GetPos() + Vector(0, 0, 48) );
			info.entity:Spawn();
		end;
	else
		ragdoll.areBelongings = true;
		ragdoll.inventory = info.inventory;
		ragdoll.cash = info.cash;
	end;
	
	blueprint.player.SaveCharacter(player);
end;

-- A function to permanently kill a player.
function DESIGN:PermaKillPlayer(player, ragdoll)
	if ( player:Alive() ) then
		player:Kill();
	end;
	
	if ( !IsValid(ragdoll) ) then
		ragdoll = player:GetRagdollEntity();
	end;
	
	local inventory = blueprint.player.GetInventory(player);
	local cash = blueprint.player.GetCash(player);
	local info = {};
	
	if ( !player:GetCharacterData("permakilled") ) then
		info.inventory = inventory;
		info.cash = cash;
		
		if ( !IsValid(ragdoll) ) then
			info.entity = ents.Create("bp_belongings");
		end;
		
		player:SetCharacterData("permakilled", true);
		player:SetCharacterData("inventory", {}, true);
		player:SetCharacterData("cash", 0, true);
		
		for k, v in pairs(info.inventory) do
			local itemTable = blueprint.item.Get(k);
			
			if (itemTable and itemTable.allowStorage == false) then
				info.inventory[k] = nil;
			end;
		end;
		
		if ( !IsValid(ragdoll) ) then
			if (table.Count(info.inventory) > 0 or info.cash > 0) then
				info.entity:SetAngles( Angle(0, 0, -90) );
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
		
		blueprint.player.SaveCharacter(player);
	end;
end;

-- A function to make an explosion.
function DESIGN:MakeExplosion(position, scale)
	local explosionEffect = EffectData();
	local smokeEffect = EffectData();
	
	explosionEffect:SetOrigin(position);
	explosionEffect:SetScale(scale);
	smokeEffect:SetOrigin(position);
	smokeEffect:SetScale(scale);
	
	util.Effect("explosion", explosionEffect, true, true);
	util.Effect("bp_effect_smoke", smokeEffect, true, true);
end;

-- A function to get a player's heal amount.
function DESIGN:GetHealAmount(player, scale)
	return 15 + blueprint.attributes.Fraction(player, ATB_DEXTERITY, 35) * (scale or 1);
end;

-- A function to get a player's dexterity time.
function DESIGN:GetDexterityTime(player)
	return 7 - blueprint.attributes.Fraction(player, ATB_DEXTERITY, 5, 5);
end;

-- A function to bust down a door.
function DESIGN:BustDownDoor(player, door, force)
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door.bustedDown = true;
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
	
	blueprint.entity.Decay(fakeDoor, 300);
	
	BLUEPRINT:CreateTimer("Reset Door: "..door:EntIndex(), 300, 1, function()
		if ( IsValid(door) ) then
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
			door.bustedDown = nil;
		end;
	end);
end;

-- A function to tie or untie a player.
function DESIGN:TiePlayer(player, boolean, reset)
	if (boolean) then
		player:SetSharedVar("sh_Tied", 1);
	else
		player:SetSharedVar("sh_Tied", 0);
	end;
	
	if (boolean) then
		blueprint.player.DropWeapons(player);
		
		player:Flashlight(false);
		player:StripWeapons();
	elseif (!reset) then
		if ( player:Alive() and !player:IsRagdolled() ) then 
			blueprint.player.LightSpawn(player, true, true);
		end;
	end;
end;