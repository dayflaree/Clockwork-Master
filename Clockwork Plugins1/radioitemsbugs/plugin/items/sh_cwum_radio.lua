
local ITEM = Clockwork.item:New("simple_radio_base");
ITEM.name = "CWU-Medical Radio";
ITEM.uniqueID = "cwum_radio";
ITEM.description = "An encrypted radio branded with the CWU logo, permanently tuned to the CWU-M subchannel.";

ITEM.frequency = "CWU-M";
ITEM.frequencyID = "freq_cwum";

ITEM:Register();