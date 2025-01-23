--[[
Name: "sh_ammo_pistol.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 80;
ITEM.name = "7.62 Pistol Rounds";
ITEM.batch = 1;
ITEM.model = "models/items/boxsrounds.mdl";
ITEM.weight = 0.8;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "sim_fas_ammo_762pmm";
ITEM.ammoClass = "sniperround";
ITEM.ammoAmount = 100;
ITEM.description = "An average sized green container with 7.62 Pistol on the side.";

blueprint.item.Register(ITEM);