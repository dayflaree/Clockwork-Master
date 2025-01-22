local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Fig";
ITEM.uniqueID = "fig";
ITEM.cost = 30;
ITEM.health = 1;
ITEM.hunger = 20;
ITEM.model = "models/bioshockinfinite/loot_pear.mdl";
ITEM.weight = 0.2;
ITEM.description = "A small, darkly coloured fruit. It's got stones in it, you think. Seriously, you've never seen a fig before? What is a fig, anyway?";
ITEM.spawnValue = 12;
ITEM.spawnType = "consumable";

function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/pack2/darkblue");
end;

ITEM:Register();