--[[
Name: "sh_ammo_xbowbolt.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 70;
ITEM.name = "5.7x28mm Rounds";
ITEM.batch = 1;
ITEM.model = "models/items/boxzrounds.mdl";
ITEM.weight = 0.8;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_xbowbolt";
ITEM.ammoClass = "xbowbolt";
ITEM.ammoAmount = 24;
ITEM.description = "An average sized blue container with 5.7x28mm on the side.";

nexus.item.Register(ITEM);