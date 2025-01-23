--[[
	Free Clockwork!
--]]

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("Typing");
end;

Clockwork:IncludePrefixed("kernel/cl_hooks.lua");
Clockwork:IncludePrefixed("kernel/sv_kernel.lua");
Clockwork:IncludePrefixed("kernel/sh_enum.lua");