local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Canned Beans";
ITEM.uniqueID = "canned_beans";
ITEM.model = "models/bioshockinfinite/baked_beans.mdl";
ITEM.description = "A tin can, filled with baked beans in tomato sauce. It is not yet cooked.";
ITEM.weight = 0.2;
ITEM.hunger = 40;
ITEM.thirst = -10;
ITEM.health = 7;
ITEM.junk = "rusty_can"
ITEM.access = "Mv";

ITEM:Register();