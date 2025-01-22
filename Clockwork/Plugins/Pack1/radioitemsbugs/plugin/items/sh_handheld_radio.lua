
local ITEM = Clockwork.item:New("radio_base");
ITEM.name = "Handheld Radio";
ITEM.uniqueID = "handheld_radio";
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.cost = 40;
ITEM.classes = {CLASS_EOW};
ITEM.access = "Mv";
ITEM.business = true;
ITEM.category = "Communication";
ITEM.description = "A handheld radio with multiple channels.";

ITEM.spawnValue = 5;
ITEM.spawnType = "misc";

ITEM:Register();