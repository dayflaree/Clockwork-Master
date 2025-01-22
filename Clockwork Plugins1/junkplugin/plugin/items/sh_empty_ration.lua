local ITEM = Clockwork.item:New();
ITEM.name = "Ration Wrapper";
ITEM.uniqueID = "empty_ration";
ITEM.spawnValue = 30;
ITEM.spawnType = "junk";
ITEM.cost = 6;
ITEM.model = "models/props/cs_office/trash_can_p5.mdl";
ITEM.weight = 0.01;
ITEM.access = "jM";
ITEM.business = false;
ITEM.category = "Junk";
ITEM.description = "A crumpled and torn supplement wrapper. Its contents have long-since been taken.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	self.model = "models/props/cs_office/trash_can_p5.mdl";
end;

ITEM:Register();