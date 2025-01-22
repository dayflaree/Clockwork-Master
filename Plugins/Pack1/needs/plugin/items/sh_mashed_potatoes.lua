local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Mashed Potatoes";
ITEM.uniqueID = "mashed_potatoes";
ITEM.cost = 40;
ITEM.hunger = 40;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.7;
ITEM.description = "A container filled with a small helping of potato that had evidently been smashed to a pulp after peeling, then heated over a stove. However, having added no butter or milk, it's quite bland.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_c17/FurnitureMetal001a");
end;

ITEM:Register();