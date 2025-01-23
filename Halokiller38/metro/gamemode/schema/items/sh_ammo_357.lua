--[[
Name: "sh_ammo_357.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "ammo_base";
ITEM.name = ".357 Rounds";
ITEM.model = "models/items/357ammo.mdl";
ITEM.weight = 0.35;
ITEM.uniqueID = "ammo_357";
ITEM.ammoClass = "357";
ITEM.ammoAmount = 8;
ITEM.description = "An orange container with Magnum on the side.";
ITEM.cost = 2;
ITEM.access = "A";
ITEM.business = true;

openAura.item:Register(ITEM);