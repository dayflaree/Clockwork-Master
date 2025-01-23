--[[
Name: "sh_gas_canister.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "junk_base";
ITEM.name = "Gas Canister";
ITEM.worth = 10;
ITEM.model = "models/props_junk/gascan001a.mdl";
ITEM.weight = 1;
ITEM.description = "A red can filled with gasoline.";

blueprint.item.Register(ITEM);