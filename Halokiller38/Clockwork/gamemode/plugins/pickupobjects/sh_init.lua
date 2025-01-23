--[[
	Free Clockwork!
--]]

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("IsDragged", true);
end;

Clockwork:IncludePrefixed("kernel/cl_kernel.lua");
Clockwork:IncludePrefixed("kernel/sv_kernel.lua");
Clockwork:IncludePrefixed("kernel/sv_hooks.lua");
Clockwork:IncludePrefixed("kernel/cl_hooks.lua");