--[[
Name: "sh_ammo_ar2.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "Pulse-Rifle Energy";
ITEM.cost = 30;
ITEM.classes = {CLASS_EOW};
ITEM.model = "models/items/combine_rifle_cartridge01.mdl";
ITEM.plural = "Pulse-Rifle Energy";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_ar2";
ITEM.business = true;
ITEM.ammoClass = "ar2";
ITEM.ammoAmount = 30;
ITEM.description = "A cartridge with a blue glow emitting from it.";

resistance.item.Register(ITEM);