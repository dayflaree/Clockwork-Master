--[[
Name: "sh_spray_can.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Spray Can";
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 1;
ITEM.category = "Reusables";
ITEM.description = "A standard spray can filled with paint.";
ITEM.access = "y";
ITEM.business = true;
ITEM.cost = 1;


-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);