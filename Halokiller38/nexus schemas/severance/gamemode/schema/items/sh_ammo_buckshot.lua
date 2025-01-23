--[[
Name: "sh_ammo_buckshot.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "Buckshot Rounds";
ITEM.model = "models/items/boxbuckshot.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "ammo_buckshot";
ITEM.ammoClass = "buckshot";
ITEM.ammoAmount = 12;
ITEM.description = "A small red box filled with Buckshot on the side.";

nexus.item.Register(ITEM);