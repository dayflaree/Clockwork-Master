--[[
Name: "sh_ammo_smg1.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.base = "ammo_base";
ITEM.name = "5.56x45mm Rounds";
ITEM.model = "models/items/boxmrounds.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_smg1";
ITEM.ammoClass = "smg1";
ITEM.ammoAmount = 60;
ITEM.description = "A large green container with 5.56x45mm on the side.";

nexus.item.Register(ITEM);