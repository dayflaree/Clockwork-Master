--[[
Name: "sh_whiskey.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "alcohol_base";
ITEM.name = "Whiskey";
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 1.2;
ITEM.attributes = {Stamina = 4};
ITEM.description = "A brown colored whiskey bottle, be careful!";

nexus.item.Register(ITEM);