
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "overwatch";
CHANNEL.uniqueID = "overwatch";
CHANNEL.subChannels = 1;
CHANNEL.global = false;
CHANNEL.defaultPriority = 11;

CHANNEL.color = Color(0, 114, 188, 255);
CHANNEL.sound = "npc/overwatch/radiovoice/on3.wav";

CHANNEL:Register();