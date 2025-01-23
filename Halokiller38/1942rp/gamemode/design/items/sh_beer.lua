--[[
Name: "sh_beer.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "alcohol_base";
ITEM.cost = 4;
ITEM.name = "Beer";
ITEM.model = "models/fallout/items/beerbottle.mdl";
ITEM.batch = 1;
ITEM.weight = 0.25;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Strength = 4};
ITEM.description = "A glass bottle filled with liquid, it has a funny smell.";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("empty_beer_bottle", 1, true);
end;

blueprint.item.Register(ITEM);