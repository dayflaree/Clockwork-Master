local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Headcrab Stew";
ITEM.uniqueID = "headcrab_stew";
ITEM.cost = 45;
ITEM.hunger = 50;
ITEM.health = 10;
ITEM.junk = "rusty_can";
ITEM.model = "models/bioshockinfinite/baked_beans.mdl";
ITEM.weight = 0.8;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A thick stew, with headcrab chunks that have clearly been slow cooked to tenderize the meat. Contrary to popular belief, this wholesome dish is actually fairly tasty.";

ITEM:Register();