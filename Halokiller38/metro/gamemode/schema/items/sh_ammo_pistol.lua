--[[
Name: "sh_ammo_pistol.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "ammo_base";
ITEM.name = "9x19mm Rounds";
ITEM.model = "models/items/boxsrounds.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "ammo_pistol";
ITEM.ammoClass = "pistol";
ITEM.ammoAmount = 24;
ITEM.description = "An average sized green container with 9mm on the side.";
ITEM.cost = 2;
ITEM.access = "A";
ITEM.business = true;

openAura.item:Register(ITEM);