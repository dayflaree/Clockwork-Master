--[[
Name: "sh_ammo_357.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 80;
ITEM.name = "7.62 Rounds";
ITEM.batch = 1;
ITEM.model = "models/Items/BoxMRounds.mdl";
ITEM.weight = 0.35;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "sim_fas_ammo_762mm";
ITEM.ammoClass = "StriderMinigun";
ITEM.ammoAmount = 100;
ITEM.description = "7.62 Rounds, used for weapons like the SVT";

blueprint.item.Register(ITEM);