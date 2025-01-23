--[[
Name: "sh_flashlight.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.cost = 40;
ITEM.name = "Flashlight";
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.batch = 1;
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.business = true;
ITEM.category = "Reusables";
ITEM.uniqueID = "bp_flashlight";
ITEM.fakeWeapon = true;
ITEM.meleeWeapon = true;
ITEM.description = "A black flashlight with Maglite printed on the side.";

blueprint.item.Register(ITEM);