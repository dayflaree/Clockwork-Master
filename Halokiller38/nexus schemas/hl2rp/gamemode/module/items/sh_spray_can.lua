--[[
Name: "sh_spray_can.lua".
Product: "Terminator RP".
--]]

local ITEM = {};

ITEM.name = "Spray Can";
ITEM.cost = 15;
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Reusables";
ITEM.business = true;
ITEM.description = "A standard spray can filled with paint.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);