local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Mashed Potatoes with Gravy";
ITEM.uniqueID = "mashed_gravy";
ITEM.cost = 40;
ITEM.hunger = 55;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.7;
ITEM.description = "A container filled with a small helping of potato slathered in gravy. The hot brown liquid seems to perfectly compliment the potatoes, and makes it look genuinely appetising.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_c17/FurnitureMetal001a");
end;

ITEM:Register();