--[[
Name: "sh_ammo_xbowbolt.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "Crossbow Bolts";
ITEM.cost = 50;
ITEM.model = "models/items/crossbowrounds.mdl";
ITEM.access = "V";
ITEM.weight = 2;
ITEM.uniqueID = "ammo_xbowbolt";
ITEM.business = true;
ITEM.ammoClass = "xbowbolt";
ITEM.ammoAmount = 4;
ITEM.description = "A set of iron bolts, the coating is rusting away.";

resistance.item.Register(ITEM);