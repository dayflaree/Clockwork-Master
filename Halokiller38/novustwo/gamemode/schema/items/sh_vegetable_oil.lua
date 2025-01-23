--[[
Name: "sh_vegetable_oil.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Vegetable Oil";
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl";
ITEM.worth = 1;
ITEM.weight = 0.1;
ITEM.description = "A bottle of vegetable oil, it isn't very tasty.";

nexus.item.Register(ITEM);