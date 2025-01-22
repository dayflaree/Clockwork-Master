local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Vodka";
ITEM.uniqueID = "uu_vodka";
ITEM.cost = 40;
ITEM.thirst = 40;
ITEM.drunkTime = 360;
ITEM.health = 5;
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.weight = 0.7;
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A 70CL bottle of vodka adorning the UU Brand. It's plainly labelled and sits at around 65% ABV.";

-- Called when the item entity has spawned.
function ITEM:OnEntitySpawned(entity)
	entity:SetMaterial("models/props_combine/citadel_cable");
end;

ITEM:Register();