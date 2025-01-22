local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Baked Potato";
ITEM.uniqueID = "baked_potato";
ITEM.model = "models/bioshockinfinite/loot_potato.mdl";
ITEM.description = "A freshly baked potato, harvested only recently by the powers that be in the outlands. It is warm and wholesome.";
ITEM.plural = "Baked Potatoes";
ITEM.weight = 0.15;
ITEM.hunger = 35;
ITEM.health = 3;

ITEM:Register();