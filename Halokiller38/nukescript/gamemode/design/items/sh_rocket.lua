--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "rocket_base";
ITEM.cost = 30;
ITEM.name = "Rocket";
ITEM.model = "models/clutter/jet.mdl";
ITEM.batch = 1;
ITEM.weight = 0.15;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Dexterity = 8, Stamina = 8}
ITEM.description = "A drug that the wasters call 'Rocket', They say it's 2x as strong as normal Jet.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("used_rocket", 1, true);
end;

blueprint.item.Register(ITEM);
