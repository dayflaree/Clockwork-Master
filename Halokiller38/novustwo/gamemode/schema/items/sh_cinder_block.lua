--[[
Name: "sh_cinder_block.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Cinder Block";
ITEM.worth = 20;
ITEM.model = "models/props_junk/cinderblock01a.mdl";
ITEM.weight = 2;
ITEM.description = "A heavy block of concrete.";

nexus.item.Register(ITEM);