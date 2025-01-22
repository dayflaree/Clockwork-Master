
local ITEM = Clockwork.item:New("simple_radio_base");
ITEM.name = "UP Radio";
ITEM.uniqueID = "up_radio";
ITEM.description = "A special encrypted radio that requires a password to be used. It has a Unity Party logo on it.";

ITEM.frequency = "up";
ITEM.frequencyID = "freq_up";

ITEM:Register();