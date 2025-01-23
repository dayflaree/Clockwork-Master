--[[
Name: "sh_flashlight.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Flashlight";
ITEM.cost = 15;
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.category = "Reusables";
ITEM.uniqueID = "roleplay_flashlight";
ITEM.business = true;
ITEM.fakeWeapon = true;
ITEM.meleeWeapon = true;
ITEM.description = "A ceiling light, a button has been wired on to it.";

resistance.item.Register(ITEM);