local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "Priority Supplements";
ITEM.uniqueID = "priority_supplements";
ITEM.model = "models/probs_misc/tobdcco_box-1.mdl";
ITEM.weight = 0.6;
ITEM.hunger = 30;
ITEM.health = 3;
ITEM.junk = "empty_ration";
ITEM.category = "UU-Branded Items";
ITEM.business = false;
ITEM.description = "A somewhat hefty box, containing some gluten-free rice pasta. There appears to be small chunks of something like tofu in it, and it seems covered heartily in a thin sauce tasting vaguely of tomatoes. It happens to also come with a little plastic spoon. Not much else to it, apart from four small cracker bread pieces and a 30ml tube of what appears to be a peanut butter paste.";

ITEM:Register();