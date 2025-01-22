local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Bullsquid Meat";
ITEM.uniqueID = "bullsquid_meat";
ITEM.cost = 25;
ITEM.model = "models/gibs/shield_scanner_gib2.mdl";
ITEM.weight = 0.2;
ITEM.hunger = 25;
ITEM.access = "Mv";
ITEM.business = false;
ITEM.description = "A tender, juicy cut of bullsquid, likely taken from the leg. The meat is stringy and tough, but full of protein, and its acidic properties have been cooked off.";

ITEM:Register();