
local CHANNEL = Clockwork.radio:New();
CHANNEL.name = "cp main";
CHANNEL.uniqueID = "cp_main";
CHANNEL.subChannels = 1;
CHANNEL.global = false;
CHANNEL.defaultPriority = 10;

CHANNEL.color = Color(0, 114, 188, 255);
CHANNEL.sound = "npc/overwatch/radiovoice/on3.wav";

CHANNEL:Register();