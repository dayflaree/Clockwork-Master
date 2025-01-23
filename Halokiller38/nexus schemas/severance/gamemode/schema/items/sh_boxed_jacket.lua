--[[
Name: "sh_jacket.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Boxed Jacket";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.weight = 2;
ITEM.useText = "Open";
ITEM.category = "Storage"
ITEM.description = "A brown box, open it to reveal its contents.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("jacket") and player:HasItem("jacket") >= 1) then
		nexus.player.Notify(player, "You've hit the jackets limit!");
		
		return false;
	end;
	
	player:UpdateInventory("jacket", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);