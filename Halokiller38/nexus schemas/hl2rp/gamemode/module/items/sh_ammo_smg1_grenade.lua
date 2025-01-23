
--[[
Name: "sh_ammo_smg1_grenade.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "MP7 Grenade";
ITEM.cost = 50;
ITEM.classes = {CLASS_EOW};
ITEM.model = "models/items/ar2_grenade.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_smg1_grenade";
ITEM.business = true;
ITEM.ammoClass = "smg1_grenade";
ITEM.ammoAmount = 1;
ITEM.description = "A large bullet shaped item, you'll figure it out.";

resistance.item.Register(ITEM);