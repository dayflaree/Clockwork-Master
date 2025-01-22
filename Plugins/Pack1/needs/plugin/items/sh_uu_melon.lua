local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Melon";
ITEM.uniqueID = "uu_melon";
ITEM.cost = 60;
ITEM.model = "models/props_junk/watermelon01.mdl";
ITEM.weight = 2;
ITEM.hunger = 40;
ITEM.thirst = 15;
ITEM.health = 4;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = true;
ITEM.description = "A large, green synthetic fruit consisting of a silicone shell concealing red arrowroot gel. Biting into the gel would taste somewhat reminiscent of watermelon candy, but saccharin sweet, almost uncomfortably so.";

ITEM:Register();