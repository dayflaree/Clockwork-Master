--[[
Name: "sh_empty_tin_can.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Tin Can";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty tin can.";

blueprint.item.Register(ITEM);