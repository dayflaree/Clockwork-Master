--[[
Name: "sh_ammo_357.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = ".357 Rounds";
ITEM.model = "models/items/357ammo.mdl";
ITEM.weight = 0.35;
ITEM.uniqueID = "ammo_357";
ITEM.ammoClass = "357";
ITEM.ammoAmount = 8;
ITEM.description = "An orange container with Magnum on the side.";

nexus.item.Register(ITEM);