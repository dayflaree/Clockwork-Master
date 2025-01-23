--[[
Name: "sh_ammo_357.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 80;
ITEM.name = ".30-06mm Ammunition";
ITEM.batch = 1;
ITEM.model = "models/Items/BoxMRounds.mdl";
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "sim_fas_ammo_3006";
ITEM.ammoClass = "GaussEnergy";
ITEM.ammoAmount = 100;
ITEM.description = "A green container with 7.92mm on the side.";

blueprint.item.Register(ITEM);