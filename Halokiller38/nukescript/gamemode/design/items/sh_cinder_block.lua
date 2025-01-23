--[[
Name: "sh_cinder_block.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Cinder Block";
ITEM.worth = 20;
ITEM.model = "models/props_junk/cinderblock01a.mdl";
ITEM.weight = 2;
ITEM.description = "A heavy block of concrete.";

blueprint.item.Register(ITEM);