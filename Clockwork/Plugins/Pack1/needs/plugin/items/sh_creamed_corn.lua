local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Creamed Corn";
ITEM.uniqueID = "creamed_corn";
ITEM.cost = 40;
ITEM.hunger = 35;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.7;
ITEM.description = "A small can of creamed corn. It seems rather well preserved and not out of date. An American favourite, sure to go down well with Anti-Citizens of US origin.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props/cs_assault/pylon");
end;

ITEM:Register();