local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Uncooked Headcrab Stew";
ITEM.uniqueID = "uncooked_headcrab_stew";
ITEM.spawnValue = 14;
ITEM.spawnType = "consumable";
ITEM.cost = 25;
ITEM.model = "models/bioshockinfinite/baked_beans.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 5;
ITEM.access = "Mv";
ITEM.business = true;
ITEM.faction = {FACTION_VORT}
ITEM.description = "A rudimentary sealed can of oddly smelling stew. It seems fairly appetising, but needs to be cooked before consumption.";

ITEM:Register();