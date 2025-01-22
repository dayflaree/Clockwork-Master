local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Milk Tea";
ITEM.uniqueID = "tea";
ITEM.cost = 15;
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.5;
ITEM.health = 5;
ITEM.thirst = 10;
ITEM.access = "Mv";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.business = true;
ITEM.description = "A bottle of Milk Tea, popularised by Asian Supermarkets. In true Chinese fashion, the strange brand name is 'Black Quill Milk Tea'.";
 
ITEM:Register();