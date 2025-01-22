local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Eggnog";
ITEM.uniqueID = "eggnog";
ITEM.cost = 40;
ITEM.thirst = 50;
ITEM.health = 15;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.junk = "empty_milk_carton";
ITEM.weight = 0.7;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.description = "A distinctive alcoholic beverage that tastes like Christmas. It's fairly high proof, surprisingly.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props/de_nuke/nukconcretewalla");
end;

ITEM:Register();