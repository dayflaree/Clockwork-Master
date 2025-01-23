--[[
Name: "sh_ammo_357.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 80;
ITEM.name = ".357 Rounds";
ITEM.batch = 1;
ITEM.model = "models/items/357ammo.mdl";
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_357";
ITEM.ammoClass = "357";
ITEM.ammoAmount = 8;
ITEM.description = "An orange container with Magnum on the side.";

blueprint.item.Register(ITEM);