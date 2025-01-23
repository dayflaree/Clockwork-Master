--[[
Name: "sh_spray_can.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Spray Can";
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 1;
ITEM.category = "Reusables";
ITEM.description = "A standard spray can filled with paint.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);