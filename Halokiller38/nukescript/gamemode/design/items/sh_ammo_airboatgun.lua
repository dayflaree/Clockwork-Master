--[[
Name: "sh_ammo_smg1.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.cost = 200;
ITEM.name = "Flamer Fuel";
ITEM.batch = 1;
ITEM.model = "models/props_c17/canister_propane01a.mdl";
ITEM.weight = 1;
ITEM.access = "T";
ITEM.business = true;
ITEM.uniqueID = "ammo_AirboatGun";
ITEM.ammoClass = "AirboatGun";
ITEM.ammoAmount = 450;
ITEM.description = "A large white container, it sounds like some type of fuel is inside.";

blueprint.item.Register(ITEM);