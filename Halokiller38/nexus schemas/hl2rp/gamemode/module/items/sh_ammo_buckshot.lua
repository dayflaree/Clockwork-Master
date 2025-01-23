--[[
Name: "sh_ammo_buckshot.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "Shotgun Shells";
ITEM.cost = 30;
ITEM.classes = {CLASS_EOW};
ITEM.model = "models/items/boxbuckshot.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_buckshot";
ITEM.business = true;
ITEM.ammoClass = "buckshot";
ITEM.ammoAmount = 16;
ITEM.description = "A red box filled with shells.";

resistance.item.Register(ITEM);