--[[
Name: "sh_wrench.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Wrench";
ITEM.worth = 2;
ITEM.model = "models/props_c17/tools_wrench01a.mdl";
ITEM.weight = 0.2
ITEM.description = "A rusty wrench.";

blueprint.item.Register(ITEM);