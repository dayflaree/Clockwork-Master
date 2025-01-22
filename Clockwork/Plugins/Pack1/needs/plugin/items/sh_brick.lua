local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Brick";
ITEM.uniqueID = "brick";
ITEM.cost = 25;
ITEM.model = "models/props_debris/concrete_cynderblock001.mdl";
ITEM.weight = 2;
ITEM.hunger = 1;
ITEM.damage = 20;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A brick. Pretty self-explanatory. You can eat it but you'll probably lose some teeth.";

ITEM:Register();