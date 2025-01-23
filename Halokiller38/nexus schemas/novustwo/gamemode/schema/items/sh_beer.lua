--[[
Name: "sh_beer.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.base = "alcohol_base";
ITEM.cost = 4;
ITEM.name = "Beer";
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
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

nexus.item.Register(ITEM);