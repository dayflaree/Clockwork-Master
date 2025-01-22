local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Mashed Potatoes with Gravy";
ITEM.uniqueID = "uu_mashed_gravy";
ITEM.cost = 40;
ITEM.hunger = 55;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A container filled with a small helping of synthetic potato, adorning the UU Brand. It's slathered in a thick brown liquid, that on its own, is barely edible, but seems to taste genuinely decent with the potatoes.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_c17/FurnitureMetal001a");
end;

ITEM:Register();