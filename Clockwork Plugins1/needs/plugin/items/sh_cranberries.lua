local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Cranberries";
ITEM.uniqueID = "cranberries";
ITEM.cost = 40;
ITEM.hunger = 25;
ITEM.health = 5;
ITEM.model = "models/bioshockinfinite/silver_eagle_coin_pile.mdl";
ITEM.weight = 0.7;
ITEM.description = "A small amount of red berries with a very tart, bitter taste. Perfect for consumption by anti-citizens, they're incredibly hydrating and will prevent urinary tract infections.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/flesh");
end;

ITEM:Register();