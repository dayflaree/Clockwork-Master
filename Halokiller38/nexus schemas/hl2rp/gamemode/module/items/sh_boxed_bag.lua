--[[
Name: "sh_boxed_bag.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Boxed Bag";
ITEM.cost = 15;
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.weight = 1;
ITEM.access = "1v";
ITEM.useText = "Open";
ITEM.category = "Storage"
ITEM.business = true;
ITEM.description = "A brown box, open it to reveal its contents.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("small_bag") and player:HasItem("small_bag") >= 2) then
		resistance.player.Notify(player, "You've hit the bags limit!");
		
		return false;
	end;
	
	player:UpdateInventory("small_bag", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);