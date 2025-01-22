local PLUGIN = PLUGIN;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("KickingDoor");
end;

--Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");