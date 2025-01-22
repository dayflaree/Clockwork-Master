local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Vodka";
ITEM.uniqueID = "vodka";
ITEM.cost = 20;
ITEM.thirst = 40;
ITEM.drunkTime = 360;
ITEM.health = 5;
ITEM.business = true;
ITEM.access = "Mv";
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.weight = 0.7;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.description = "A 70CL bottle of vodka. It's clearly appealing to a niche, with a hammer and sickle theme and the branding: 'Human Revolution'. It appears to be around 40% ABV.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_combine/citadel_cable");
end;

ITEM:Register();