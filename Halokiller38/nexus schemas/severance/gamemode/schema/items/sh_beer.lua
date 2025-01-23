--[[
Name: "sh_beer.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "alcohol_base";
ITEM.name = "Beer";
ITEM.model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.weight = 0.6;
ITEM.attributes = {Strength = 2};
ITEM.description = "A glass bottle filled with liquid, it has a funny smell.";

nexus.item.Register(ITEM);