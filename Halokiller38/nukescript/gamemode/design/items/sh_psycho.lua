--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "drug_base";
ITEM.cost = 15;
ITEM.name = "Psycho";
ITEM.model = "models/clutter/psycho.mdl";
ITEM.batch = 1;
ITEM.weight = 0.15;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Strength = 4, Agility = 4, Endurance = 10}
ITEM.description = "A drug that the wasters call 'Psycho', They say it makes you take more pain.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("used_psycho", 1, true);
end;

blueprint.item.Register(ITEM);
