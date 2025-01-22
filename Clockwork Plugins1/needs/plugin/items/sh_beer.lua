--player:BoostAttribute(self.name, ATB_ACROBATICS, 2, 120);

local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Beer";
ITEM.uniqueID = "beer";
ITEM.description = "A sealed and preserved bottle of beer. A label reading 'Warwick Breweries, established 1818' adorns the front. It is hoppy and nostalgic, and around 4.8% ABV.";
ITEM.model = "models/bioshockinfinite/loot_bottle_lager.mdl";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.weight = 0.6;
ITEM.thirst = 20;
ITEM.hunger = -10;
ITEM.health = 4;
ITEM.junk = "empty_bottle";
ITEM.business = true;
ITEM.access = "Mv";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 19;

ITEM:Register();