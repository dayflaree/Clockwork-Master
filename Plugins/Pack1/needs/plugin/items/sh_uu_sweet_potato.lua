local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Sweet Potato";
ITEM.uniqueID = "uu_sweet_potato";
ITEM.cost = 40;
ITEM.hunger = 30;
ITEM.health = 5;
ITEM.model = "models/bioshockinfinite/loot_potato.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A weird looking synthetic vegetable. It has an odd mush inside the silicone shell, tasting like nothing you've ever had before.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/fender_wood");
end;

ITEM:Register();