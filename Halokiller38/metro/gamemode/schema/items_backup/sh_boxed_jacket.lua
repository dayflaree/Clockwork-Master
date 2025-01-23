--[[
Name: "sh_jacket.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Boxed Jacket";
ITEM.cost = 20;
ITEM.model = "models/avoxgaming/mrp/jake/props/clothes_shirt_dark.mdl";
ITEM.weight = 0.2;
ITEM.access = "A";
ITEM.business = true;
ITEM.useText = "Open";
ITEM.category = "Storage";
ITEM.description = "A brown box, open it to reveal its contents.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("jacket") and player:HasItem("jacket") >= 1) then
		openAura.player:Notify(player, "You can only carry one jacket!");
		
		return false;
	end;
	
	player:UpdateInventory("jacket", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);