
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("vPoints");
	playerVars:String("lPoints");
end;
