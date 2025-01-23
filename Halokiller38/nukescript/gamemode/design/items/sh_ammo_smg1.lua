--[[
Name: "sh_ammo_smg1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 90;
ITEM.name = "5.56x45mm Rounds";
ITEM.batch = 1;
ITEM.model = "models/fallout/containers/ammobox01.mdl";
ITEM.weight = 1;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_smg1";
ITEM.ammoClass = "smg1";
ITEM.ammoAmount = 60;
ITEM.description = "A large green container with 5.56x45mm on the side.";

blueprint.item.Register(ITEM);