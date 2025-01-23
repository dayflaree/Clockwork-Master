--[[
Name: "sh_ammo_smg1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 400;
ITEM.name = "Alien Power Cells";
ITEM.batch = 1;
ITEM.model = "models/fallout/ammo/alienpowercell.mdl";
ITEM.weight = 1;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_alienpowercell";
ITEM.ammoClass = "AlyxGun";
ITEM.ammoAmount = 100;
ITEM.description = "A clip which says Alien Power Cells on the side.";

blueprint.item.Register(ITEM);