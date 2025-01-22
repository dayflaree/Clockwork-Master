local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Moonshine";
ITEM.uniqueID = "moonshine";
ITEM.cost = 25;
ITEM.health = 2;
ITEM.thirst = 35;
ITEM.drunkTime = 600;
ITEM.model = "models/props_junk/glassjug01.mdl";
ITEM.weight = 1;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A glass bottle filled with clear liquid. Smelling it would reveal it is distilled alcohol, made likely in a shack somewhere on a mountain side. The only real taste is burning, so pound it down and hope it doesn't kill you. After all, it's around 80% ABV.";

ITEM:Register();