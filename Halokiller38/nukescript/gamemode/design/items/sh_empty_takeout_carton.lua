--[[
Name: "sh_empty_takeout_carton.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Takeout Carton";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.1
ITEM.description = "An old and empty takeout carton.";

blueprint.item.Register(ITEM);