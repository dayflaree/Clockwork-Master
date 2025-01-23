--[[
Name: "sh_boxed_backpack.lua".
Product: "Severance".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Boxed Backpack";
ITEM.model = "models/avoxgaming/mrp/jake/props/backpack.mdl";
ITEM.weight = 2;
ITEM.useText = "Open";
ITEM.category = "Storage";
ITEM.description = "A brown box, open it to reveal its contents.";
ITEM.cost = 30;
ITEM.access = "A";
ITEM.business = true;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:HasItem("backpack") and player:HasItem("backpack") >= 1) then
		openAura.player:Notify(player, "You've hit the backpacks limit!");
		
		return false;
	end;
	
	player:UpdateInventory("backpack", 1, true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);