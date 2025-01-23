--[[
Name: "sh_ammo_357.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 80;
ITEM.name = "9mm Ammunition";
ITEM.batch = 1;
ITEM.model = "sim_fas_ammo_9mm";
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "sim_fas_ammo_9mm";
ITEM.ammoClass = "Battery";
ITEM.ammoAmount = 100;
ITEM.description = "A green container with 9mm on the side.";

blueprint.item.Register(ITEM);