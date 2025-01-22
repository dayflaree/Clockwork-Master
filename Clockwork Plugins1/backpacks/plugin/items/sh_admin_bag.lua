
local ITEM = Clockwork.item:New("backpack_base");
ITEM.name = "Admin Bag";
ITEM.uniqueID = "admin_bag";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.business = false;
ITEM.actualWeight = 1;
ITEM.invSpace = 69420;
ITEM.slot = "back";
ITEM.slotSpace = 1;
ITEM.description = "For all your script item needs.";

function ITEM:CanPlayerWearBackpack(player, itemEntity)
	if (player:GetFaction() != FACTION_SRVADMIN) then
		Clockwork.player:Notify(player, "You cannot use an admin backpack!");
		player:TakeItem(self);
		return false;
	end;
end;

ITEM:Register();