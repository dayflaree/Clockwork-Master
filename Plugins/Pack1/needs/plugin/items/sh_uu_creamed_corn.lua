local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Creamed Corn";
ITEM.uniqueID = "uu_creamed_corn";
ITEM.cost = 40;
ITEM.hunger = 35;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A small can of synthetic creamed corn. It's not quite clear what is in it, and the smell is foul, but it's bound to harbour calories, if you can stomach the food itself.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props/cs_assault/pylon");
end;

ITEM:Register();