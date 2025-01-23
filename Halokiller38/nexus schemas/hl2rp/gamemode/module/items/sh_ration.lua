--[[
Name: "sh_ration.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Ration";
ITEM.model = "models/weapons/w_package.mdl";
ITEM.weight = 2;
ITEM.useText = "Open";
ITEM.description = "A purple container, what goodies have they given you this time?";

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	if (quickUse) then
		if ( !resistance.inventory.CanHoldWeight(player, self.weight) ) then
			resistance.player.Notify(player, "You do not have enough inventory space!");
			
			return false;
		end;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if ( MODULE:PlayerIsCombine(player) ) then
		resistance.player.Notify(player, "You cannot open this ration!");
		
		return false;
	elseif (player:QueryCharacter("faction") == FACTION_ADMIN) then
		resistance.player.Notify(player, "You cannot open this ration!");
		
		return false;
	else
		resistance.player.GiveCash(player, 60, "ration packet");
		
		player:UpdateInventory("citizen_supplements", 1, true);
		
		resistance.plugin.Call("PlayerUseRation", player);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);