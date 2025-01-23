--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "drug_base";
ITEM.cost = 20;
ITEM.name = "Buffout";
ITEM.model = "models/fallout/items/chems/buffout.mdl";
ITEM.batch = 1;
ITEM.weight = 0.15;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Strength = 50}
ITEM.description = "A drug that the wasters call 'Buffout', They say it makes you take more pain.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("used_buffout", 1, true);
end;

blueprint.item.Register(ITEM);
