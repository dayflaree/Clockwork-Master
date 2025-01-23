--[[
Name: "sh_spray_can.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Spray Can";
ITEM.cost = 30;
ITEM.model = "models/sprayca2.mdl";
ITEM.batch = 1;
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.business = true;
ITEM.category = "Reusables";
ITEM.description = "A standard spray can filled with paint.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);