local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Banana";
ITEM.uniqueID = "uu_banana";
ITEM.cost = 30;
ITEM.model = "models/bioshockinfinite/hext_banana.mdl";
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.weight = 0.2;
ITEM.health = 2;
ITEM.hunger = 15;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "An entirely synthetic banana, composed of a flavoured gel inside a silicone shell. It tastes distinctly of banana candy, but saccharin sweet.";

ITEM:Register();