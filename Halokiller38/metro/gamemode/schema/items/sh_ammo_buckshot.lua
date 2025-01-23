--[[
Name: "sh_ammo_buckshot.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "ammo_base";
ITEM.name = "Buckshot Rounds";
ITEM.model = "models/items/boxbuckshot.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "ammo_buckshot";
ITEM.ammoClass = "buckshot";
ITEM.ammoAmount = 12;
ITEM.description = "A small red box filled with Buckshot on the side.";
ITEM.cost = 3;
ITEM.access = "A";
ITEM.business = true;

openAura.item:Register(ITEM);