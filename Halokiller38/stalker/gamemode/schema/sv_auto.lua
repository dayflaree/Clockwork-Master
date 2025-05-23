--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

openAura:IncludePrefixed("sh_auto.lua");

resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf");
resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt");
resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl");
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
resource.AddFile("models/weapons/w_katana.mdl");
resource.AddFile("models/weapons/v_katana.mdl");
resource.AddFile("models/weapons/w_shovel.mdl");
resource.AddFile("models/stalker_bandit_veteran.mdl");
resource.AddFile("models/stalker_bandit_veteran2.mdl");
resource.AddFile("models/srp/masterfreedom.mdl");
resource.AddFile("models/srp/mastermonolith.mdl");
resource.AddFile("models/srp/mastermercenary.mdl");
resource.AddFile("models/srp/masterduty.mdl");
resource.AddFile("models/srp/masterstalker.mdl");
resource.AddFile("resource/fonts/DOWNCOME.ttf");
resource.AddFile("models/weapons/w_axe.mdl");
resource.AddFile("sound/stalker/stalker_intro.mp3");
resource.AddFile("models/stalkertnb/psz9d_duty.mdl");

for k, v in pairs( _file.Find("../materials/stalker/*.*") ) do
	resource.AddFile("materials/stalker/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/deadbodies/*.*") ) do
	resource.AddFile("materials/models/deadbodies/"..v);
end;

for k, v in pairs( _file.Find("../models/deadbodies/*.*") ) do
	resource.AddFile("models/deadbodies/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/stalkertnb/humans/*.*") ) do
	resource.AddFile("material/models/stalkertnb/humans/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/stalkertnb/mutants/*.*") ) do
	resource.AddFile("material/models/stalkertnb/mutants/"..v);
end;

for k, v in pairs( _file.Find("../materials/models/stalkertnb/humans/*.*") ) do
	resource.AddFile("material/models/stalkertnb/humans/"..v);
end;

for k, v in pairs( _file.Find("../models/stalkertnb/*.*") ) do
	resource.AddFile("models/stalkertnb/"..v);
end;

for k, v in pairs( {34, 37, 38, 40, 41, 42, 43, 51} ) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( _file.Find("../models/humans/"..groupName.."/*.*") ) do
		resource.AddFile("models/humans/"..groupName.."/"..v2);
	end;
end;

openAura.config:Add("intro_text_small", "Begin your story Marked one..", true);
openAura.config:Add("intro_text_big", "THE ZONE 2012.", true);

openAura.config:Get("enable_gravgun_punt"):Set(false);
openAura.config:Get("default_inv_weight"):Set(2);
openAura.config:Get("enable_crosshair"):Set(false);
openAura.config:Get("scale_prop_cost"):Set(0);
openAura.config:Get("default_cash"):Set(20);
openAura.config:Get("door_cost"):Set(10);

openAura.hint:Add("Staff", "The staff are here to help you, please respect them.");
openAura.hint:Add("Grammar", "Try to speak correctly in-character, and don't use emoticons.");
openAura.hint:Add("Healing", "You can heal players by using the Give command in your inventory.");
openAura.hint:Add("Wasteland", "Bored and alone in the wasteland? Travel with a friend.");
openAura.hint:Add("Metagaming", "Metagaming is when you use out-of-character information in-character.");
openAura.hint:Add("Development", "Develop your character, give them a story to tell.");
openAura.hint:Add("Powergaming", "Powergaming is when you force your actions on others.");
openAura.hint:Add("Join us on www.democracy.org today.");

openAura:HookDataStream("ObjectPhysDesc", function(player, data)
	if (type(data) == "table" and type( data[1] ) == "string") then
		if ( player.objectPhysDesc == data[2] ) then
			local physDesc = data[1];
			
			if (string.len(physDesc) > 80) then
				physDesc = string.sub(physDesc, 1, 80).."...";
			end;
			
			data[2]:SetNetworkedString("physDesc", physDesc);
		end;
	end;
end);

-- A function to load the radios.
function openAura.schema:LoadRadios()
	local radios = openAura:RestoreSchemaData( "plugins/radios/"..game.GetMap() );
	
	for k, v in pairs(radios) do
		local entity;
		
		if (v.frequency) then
			entity = ents.Create("aura_radio");
		end;
		
		openAura.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
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

-- A function to load the trash spawns.
function openAura.schema:LoadTrashSpawns()
	self.trashSpawns = openAura:RestoreSchemaData( "plugins/trash/"..game.GetMap() );
	
	if (!self.trashSpawns) then
		self.trashSpawns = {};
	end;
end;

-- A function to get a random trash spawn.
function openAura.schema:GetRandomTrashSpawn()
	local position = self.trashSpawns[ math.random(1, #self.trashSpawns) ];
	local players = _player.GetAll();
	
	for k, v in ipairs(players) do
		if (v:HasInitialized() and v:GetPos():Distance(position) <= 1024) then
			if ( !openAura.player:IsNoClipping(v) ) then
				return self:GetRandomTrashSpawn();
			end;
		end;
	end;
	
	return position;
end;

-- A function to get a random trash item.
function openAura.schema:GetRandomTrashItem()
	local trashItem = self.trashItems[ math.random(1, #self.trashItems) ];
	
	if ( trashItem and math.random() <= ( 1 / (trashItem.worth * 2) ) ) then
		return trashItem;
	else
		return self:GetRandomTrashItem();
	end;
end;

-- A function to save the trash spawns.
function openAura.schema:SaveTrashSpawns()
	openAura:SaveSchemaData("plugins/trash/"..game.GetMap(), self.trashSpawns);
end;

-- A function to save the radios.
function openAura.schema:SaveRadios()
	local radios = {};
	
	for k, v in pairs( ents.FindByClass("aura_radio") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = openAura.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = openAura.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetSharedVar("frequency")
		};
	end;
	
	openAura:SaveSchemaData("plugins/radios/"..game.GetMap(), radios);
end;

-- A function to make an explosion.
function openAura.schema:MakeExplosion(position, scale)
	local explosionEffect = EffectData();
	local smokeEffect = EffectData();
	
	explosionEffect:SetOrigin(position);
	explosionEffect:SetScale(scale);
	smokeEffect:SetOrigin(position);
	smokeEffect:SetScale(scale);
	
	util.Effect("explosion", explosionEffect, true, true);
	util.Effect("aura_effect_smoke", smokeEffect, true, true);
end;

-- A function to get a player's heal amount.
function openAura.schema:GetHealAmount(player, scale)
	return 15 * (scale or 1);
end;

-- A function to get a player's dexterity time.
function openAura.schema:GetDexterityTime(player)
	return 7;
end;

-- A function to make a player wear clothes.
function openAura.schema:PlayerWearClothes(player, itemTable)
	local clothes = player:GetCharacterData("clothes");
	local team = player:Team();
	
	if (itemTable) then
		itemTable:OnChangeClothes(player, true);
		
		player:SetCharacterData("clothes", itemTable.index);
		player:SetSharedVar("clothes", itemTable.index);
	else
		itemTable = openAura.item:Get(clothes);
		
		if (itemTable) then
			itemTable:OnChangeClothes(player, false);
			
			player:SetCharacterData("clothes", nil);
			player:SetSharedVar("clothes", 0);
		end;
	end;
	
	if (itemTable) then
		player:UpdateInventory(itemTable.uniqueID);
	end;
end;

openAura:HookDataStream("UpgradeWeapon", function(player, data)
	if (type(data) == "string") then
		local itemTable = openAura.item:Get(data);
		
		if (itemTable and itemTable.weaponLevel and itemTable.nextWeaponID) then
			if (player:HasItem(itemTable.uniqueID) and itemTable.weaponLevel != 10) then
				local cost = itemTable.weaponLevel * 5000;
				
				if ( !openAura.player:CanAfford(player, cost) ) then
					openAura.player:Notify(player, "You need another "..FORMAT_CASH(cost - openAura.player:GetCash(player), nil, true).."!");
				else
					openAura.player:GiveCash(player, -cost, "upgrading a weapon");
					openAura.player:Notify(player, "You have upgraded this weapon to level "..(itemTable.weaponLevel + 1)..".");
					
					player:UpdateInventory(itemTable.nextWeaponID, 1, true, true);
					player:UpdateInventory(itemTable.uniqueID, -1, true, true);
				end;
			end;
		end;
	end;
end);

openAura:HookDataStream("UpgradeArmor", function(player, data)
	if (type(data) == "string") then
		local itemTable = openAura.item:Get(data);
		
		if (itemTable and itemTable.armorLevel and itemTable.nextArmorID) then
			if (player:HasItem(itemTable.uniqueID) and itemTable.armorLevel != 10) then
				local cost = itemTable.armorLevel * 4500;
				
				if ( !openAura.player:CanAfford(player, cost) ) then
					openAura.player:Notify(player, "You need another "..FORMAT_CASH(cost - openAura.player:GetCash(player), nil, true).."!");
				else
					openAura.player:GiveCash(player, -cost, "upgrading some armor");
					openAura.player:Notify(player, "You have upgraded this armor to level "..(itemTable.armorLevel + 1)..".");
					
					player:UpdateInventory(itemTable.nextArmorID, 1, true, true);
					player:UpdateInventory(itemTable.uniqueID, -1, true, true);
				end;
			end;
		end;
	end;
end);