local PLUGIN = PLUGIN;

PLUGIN.TeleportCooldown = 2700; --Time in seconds before a vortigaunt is ready to channel again. Default: 45 minutes
PLUGIN.ChannelDist = 300;--Max distance away from each other vortigaunts can be to channel
PLUGIN.MinimumVorts = 4; --Minimum number of Vortigaunts to begin a warp sequence
PLUGIN.TeleportDelay = 20; --Time in seconds it takes for channeling to complete and actually teleport the users

PLUGIN.ElderNames = {};
PLUGIN.ElderNames["'Turr'Chackt'"] = true; --I don't know what constitutes as an elder's prefix, so add your own

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("vortDest");
	playerVars:Bool("vortChanneling");
	playerVars:Number("vIndex");
	playerVars:Number("vortChannelCooldown");
end;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");