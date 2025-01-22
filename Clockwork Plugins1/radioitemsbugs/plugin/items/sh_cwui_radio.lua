
local ITEM = Clockwork.item:New("simple_radio_base");
ITEM.name = "CWU-Industrial Radio";
ITEM.uniqueID = "cwui_radio";
ITEM.description = "An encrypted radio branded with the CWU logo, permanently tuned to the CWU-I subchannel.";

ITEM.frequency = "CWU-I";
ITEM.frequencyID = "freq_cwui";

ITEM:Register();