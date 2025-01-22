local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Gravy";
ITEM.uniqueID = "uu_gravy";
ITEM.cost = 40;
ITEM.thirst = 5;
ITEM.hunger = 10;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A thick, greasy lumpy mess, kept in a container adorning the UU Brand. It's a deep brown, and smells of industrial grease and thickener. Calories aplenty, if you can stomach it.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_combine/citadel_cable_b");
end;

ITEM:Register();