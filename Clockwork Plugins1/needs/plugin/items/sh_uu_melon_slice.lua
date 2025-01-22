local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Melon Slice";
ITEM.uniqueID = "uu_melon_slice";
ITEM.cost = 8;
ITEM.model = "models/props_junk/watermelon01_chunk01b.mdl";
ITEM.weight = 0.25;
ITEM.health = 1;
ITEM.hunger = 8;
ITEM.thirst = 2;
ITEM.access = "u";
ITEM.category = "UU-Branded Items";
ITEM.business = false;
ITEM.description = "A slice of synthetic fruit consisting of a silicone shell, attached to some red arrowroot gel. Biting into the gel would taste somewhat reminiscent of watermelon candy, but saccharin sweet, almost uncomfortably so.";

ITEM:Register();