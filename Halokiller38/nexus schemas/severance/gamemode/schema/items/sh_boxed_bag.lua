--[[
Name: "sh_boxed_bag.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Boxed Bag";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.weight = 1;
ITEM.useText = "Open";
ITEM.category = "Storage"
ITEM.description = "A brown box, open it to reveal its contents.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("small_bag") and player:HasItem("small_bag") >= 2) then
		nexus.player.Notify(player, "You've hit the bags limit!");
		
		return false;
	end;
	
	player:UpdateInventory("small_bag", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);