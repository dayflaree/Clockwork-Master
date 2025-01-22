
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "combine";
CHANNEL.uniqueID = "combine";
CHANNEL.subChannels = 1;
CHANNEL.global = false;
CHANNEL.defaultPriority = 7;

CHANNEL.color = Color(200, 0, 0);
CHANNEL.sound = "npc/overwatch/radiovoice/on3.wav";

CHANNEL:Register();