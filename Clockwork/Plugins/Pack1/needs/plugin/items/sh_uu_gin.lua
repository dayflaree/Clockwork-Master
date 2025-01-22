local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Gin";
ITEM.uniqueID = "uu-branded_gin";
ITEM.cost = 40;
ITEM.model = "models/bioshockinfinite/jin_bottle.mdl";
ITEM.weight = 0.7;
ITEM.thirst = 30;
ITEM.drunkTime = 360;
ITEM.health = 2;
ITEM.junk = "empty_bottle";
ITEM.access = "u";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A very strong bottle of alcohol, adorning the UU Brand. It smells incredibly potent, and a single sip would reveal it to be little more than flavoured ethanol. This stuff is dangerous. It can poison you, and the Union know it.";

ITEM:Register();