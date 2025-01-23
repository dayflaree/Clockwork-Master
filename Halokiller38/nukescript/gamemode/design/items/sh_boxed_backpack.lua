--[[
Name: "sh_boxed_backpack.lua".
Product: "Day One".
--]]

local ITEM = {};

ITEM.name = "Boxed Backpack";
ITEM.cost = 30;
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Open";
ITEM.business = true;
ITEM.category = "Storage"
ITEM.description = "A brown box, open it to reveal its contents.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("backpack") and player:HasItem("backpack") >= 1) then
		blueprint.player.Notify(player, "You can only carry one backpack!");
		
		return false;
	end;
	
	player:UpdateInventory("backpack", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);