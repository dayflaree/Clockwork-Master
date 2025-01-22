local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Champagne";
ITEM.uniqueID = "champagne";
ITEM.model = "models/bioshockinfinite/champagne_bottle.mdl";
ITEM.description = "A large bottle of sparkling alcohol, courtesy of the Champagne region of France. It is clearly preserved from before the Seven Hour War, and has aged well. The particular branding appears to be 'Quill River'.";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.weight = 1.2;
ITEM.thirst = 50;
ITEM.hunger = 15;
ITEM.health = 12;
ITEM.drunkTime = 360;
ITEM.junk = "empty_bottle";
ITEM.cost = 70;
ITEM.business = true;
ITEM.access = "Mv";

ITEM:Register();