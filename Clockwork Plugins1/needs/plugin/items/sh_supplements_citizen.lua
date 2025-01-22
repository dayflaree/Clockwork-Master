local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Citizen Supplements";
ITEM.uniqueID = "citizen_supplements";
ITEM.model = "models/foodnhouseholdaaaaa/combirationb.mdl";
ITEM.description = "A small bag containing an odd, thick, porridge-like substance, and two crackers. It's grey, and appears to be lumpy and salty. It happens to also come with a little plastic spoon. It doesn't taste the best, or of anything, really, but it's filling enough.";
ITEM.weight = 0.6;
ITEM.hunger = 18;
ITEM.health = 3;
ITEM.junk = "empty_ration";
ITEM.business = false;
ITEM.category = "UU-Branded Items";

ITEM:Register();