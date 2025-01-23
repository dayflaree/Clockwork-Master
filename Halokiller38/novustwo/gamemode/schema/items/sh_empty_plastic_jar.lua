--[[
Name: "sh_empty_plastic_jar.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Empty Plastic Jar";
ITEM.worth = 1;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.1
ITEM.description = "An empty plastic can, it smells like beans.";

nexus.item.Register(ITEM);