--[[
Name: "sh_whiskey.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.base = "alcohol_base";
ITEM.cost = 4;
ITEM.name = "Whiskey";
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.25;
ITEM.access = "T";
ITEM.business = true;
ITEM.attributes = {Stamina = 4};
ITEM.description = "A brown colored whiskey bottle, be careful!";

-- Called when a player drinks the item.
function ITEM:OnDrink(player)
	player:UpdateInventory("empty_whiskey_bottle", 1, true);
end;

blueprint.item.Register(ITEM);