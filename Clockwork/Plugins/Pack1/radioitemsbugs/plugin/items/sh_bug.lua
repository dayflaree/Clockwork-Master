local ITEM = Clockwork.item:New("bug_base");

ITEM.name = "Civil Protection Bug";
ITEM.uniqueID = "cp_bug";
ITEM.model = "models/props_phx/wheels/magnetic_small_base.mdl";
ITEM.weight = 1;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.description = "A small, synthetic item disguised as a miscellanious object. It has an inbuilt speaker and microphone..";

ITEM:Register();