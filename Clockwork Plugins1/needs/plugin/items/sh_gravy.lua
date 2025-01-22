local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Gravy";
ITEM.uniqueID = "gravy";
ITEM.cost = 40;
ITEM.thirst = 5;
ITEM.hunger = 10;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.7;
ITEM.description = "A lashing of thick, brown liquid, designed to be poured over meats and roasted vegetables. This one smells distinctly of beef. It's not technically meant to be drank alone, but hey, nobody's watching.";
ITEM.spawnValue = 15;
ITEM.spawnType = "consumable";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_combine/citadel_cable_b");
end;

ITEM:Register();