local PLUGIN = PLUGIN;

local ITEM = Clockwork.item:New("equipable_item_base");
ITEM.name = "Rappelling Kit";
ITEM.model = "models/props_c17/suitcase001a.mdl";
ITEM.weight = 2;
ITEM.business = true;
ITEM.access = "V";
ITEM.batch = 3;
ITEM.cost = 12000;
ITEM.category = "Clothing";
ITEM.uniqueID = "cw_rappelkit";
ITEM.useText = "Equip";
ITEM.isAttachment = false;
ITEM.description = "A reusable harness bundled with some sturdy rope, two carabiners, a piton, and a spool.";

function ITEM:CanPlayerWear(player, itemEntity)
	for k, v in pairs(Clockwork.inventory:GetItemsByID(player:GetInventory(), "cw_rappelkit")) do
		if (v:HasPlayerEquipped(player)) then
			Clockwork.player:Notify(player, "You are already wearing a rappelling kit!");
			return false;
		end;
	end;
end;

function ITEM:OnPlayerUnequipped(player, extraData)
	-- If they unequip it while climbing and attempt to exploit, boot them off their rope.
	if (player:GetSharedVar("rappelling")) then
		PLUGIN:Dismount(player, false, true);
	else
		self:SetData("equipped", false);
		self:OnWearItem(player, false);
		player:RebuildInventory();
	end;
end;

ITEM:Register();