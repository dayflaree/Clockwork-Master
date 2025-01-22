local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Homemade King's Tea";
ITEM.uniqueID = "uu_tea";
ITEM.cost = 15;
ITEM.model = "models/bioshockinfinite/ebsinthebottle.mdl";
ITEM.iconModel = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.thirst = 10;
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A bottle of tea, adorning the UU Brand. It is cold, but the bottle has a caricature of Wayne King spouting something about 'Caramels'.";
 
ITEM:Register();