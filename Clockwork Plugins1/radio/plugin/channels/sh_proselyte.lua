
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "proselyte";
CHANNEL.uniqueID = "freq_proselyte";
CHANNEL.subChannels = 1;
CHANNEL.global = false;
CHANNEL.defaultPriority = 5;

CHANNEL:Register();