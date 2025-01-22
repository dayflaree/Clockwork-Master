local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Soda";
ITEM.uniqueID = "soda";
ITEM.cost = 24;
ITEM.spawnValue = 6;
ITEM.spawnType = "consumable";
ITEM.model = "models/warz/consumables/soda.mdl";
ITEM.weight = 2;
ITEM.health = 5;
ITEM.thirst = 50;
ITEM.junk = "empty_bottle";
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A cheap can of off-brand soda. It appears to be from the same supermarket as the chocolate, due to the branding: 'Doctor Cara'.";

ITEM:Register();