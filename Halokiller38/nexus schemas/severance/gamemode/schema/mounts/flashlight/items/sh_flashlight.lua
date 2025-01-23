--[[
Name: "sh_flashlight.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Flashlight";
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.8;
ITEM.category = "Reusables";
ITEM.uniqueID = "nx_flashlight";
ITEM.fakeWeapon = true;
ITEM.meleeWeapon = true;
ITEM.description = "A black flashlight with Maglite printed on the side.";

nexus.item.Register(ITEM);