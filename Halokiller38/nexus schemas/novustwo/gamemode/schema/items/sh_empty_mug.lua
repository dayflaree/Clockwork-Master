--[[
Name: "sh_empty_mug.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Mug";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty coffee mug.";

nexus.item.Register(ITEM);