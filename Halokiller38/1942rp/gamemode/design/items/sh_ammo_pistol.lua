--[[
Name: "sh_ammo_pistol.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 70;
ITEM.name = "9mm Rounds";
ITEM.batch = 1;
ITEM.model = "models/items/boxsrounds.mdl";
ITEM.weight = 0.8;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_pistol";
ITEM.ammoClass = "Battery";
ITEM.ammoAmount = 100;
ITEM.description = "An average sized green container with 9mm on the side.";

blueprint.item.Register(ITEM);