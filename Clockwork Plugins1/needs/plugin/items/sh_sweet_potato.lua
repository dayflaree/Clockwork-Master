local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Sweet Potato";
ITEM.uniqueID = "sweet_potato";
ITEM.cost = 40;
ITEM.hunger = 30;
ITEM.health = 5;
ITEM.model = "models/bioshockinfinite/loot_potato.mdl";
ITEM.weight = 0.7;
ITEM.description = "A freshly grown sweet potato, suitable for making fries if you're some kind of hipster.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("phoenix_storms/fender_wood");
end;

ITEM:Register();