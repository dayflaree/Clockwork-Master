--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "drug_base";
ITEM.cost = 10;
ITEM.name = "Jet";
ITEM.model = "models/clutter/jet.mdl";
ITEM.batch = 1;
ITEM.weight = 0.15;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Dexterity = 4, Stamina = 4}
ITEM.description = "A drug that the wasters call 'Jet', They say you can run longer and untie quicker while under the influence of it.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("used_jet", 1, true);
end;

blueprint.item.Register(ITEM);
