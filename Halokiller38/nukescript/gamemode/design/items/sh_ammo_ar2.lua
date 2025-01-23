--[[
Name: "sh_ammo_smg1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 150;
ITEM.name = "Energy Cells";
ITEM.batch = 1;
ITEM.model = "models/fallout/ammo/eccell.mdl";
ITEM.weight = 1;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_CombineCannon";
ITEM.ammoClass = "CombineCannon";
ITEM.ammoAmount = 60;
ITEM.description = "A fairly small container which says Energy Cells on the top.";

blueprint.item.Register(ITEM);