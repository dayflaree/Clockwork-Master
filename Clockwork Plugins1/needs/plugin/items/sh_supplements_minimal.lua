local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Minimal Supplements";
ITEM.uniqueID = "minimal_supplements";
ITEM.model = "models/gibs/props_canteen/vm_sneckol.mdl";
ITEM.description = "A small bag containing an odd, thick, porridge-like substance. It's grey, and appears to be lumpy and salty. It happens to also come with a little plastic spoon. It's got what you need in terms of calories, but little else.";
ITEM.weight = 0.6;
ITEM.hunger = 11;
ITEM.health = 3;
ITEM.junk = "empty_ration";
ITEM.business = false;
ITEM.category = "UU-Branded Items";

ITEM:Register();