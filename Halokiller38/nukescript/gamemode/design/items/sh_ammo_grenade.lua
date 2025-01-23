--[[
Name: "sh_ammo_smg1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 1000;
ITEM.name = "Mini Nuke";
ITEM.batch = 1;
ITEM.model = "models/items/boxmrounds.mdl";
ITEM.weight = 1;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "Grenade";
ITEM.ammoClass = "Grenade";
ITEM.ammoAmount = 1;
ITEM.description = "A Mini...Nuke.";

blueprint.item.Register(ITEM);