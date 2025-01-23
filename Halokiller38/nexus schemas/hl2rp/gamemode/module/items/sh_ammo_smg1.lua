--[[
Name: "sh_ammo_smg1.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "SMG Bullets";
ITEM.cost = 30;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/items/boxmrounds.mdl";
ITEM.weight = 2;
ITEM.access = "V";
ITEM.uniqueID = "ammo_smg1";
ITEM.business = true;
ITEM.ammoClass = "smg1";
ITEM.ammoAmount = 30;
ITEM.description = "A heavy container filled with a lot of bullets.";

resistance.item.Register(ITEM);