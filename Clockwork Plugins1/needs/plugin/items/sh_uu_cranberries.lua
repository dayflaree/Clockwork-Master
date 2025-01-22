local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Cranberries";
ITEM.uniqueID = "uu_cranberries";
ITEM.cost = 40;
ITEM.hunger = 25;
ITEM.health = 5;
ITEM.model = "models/bioshockinfinite/silver_eagle_coin_pile.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A small punnet of synthetic berries, consisting of a dark red gel in silicone shells. They taste extremely bitter, but oddly sweet at the same time. Consumption causes an odd need to urinate.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/flesh");
end;

ITEM:Register();