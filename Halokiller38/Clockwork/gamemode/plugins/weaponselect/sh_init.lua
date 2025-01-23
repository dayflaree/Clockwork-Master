--[[
	Free Clockwork!
--]]

Clockwork:IncludePrefixed("kernel/cl_kernel.lua");
Clockwork:IncludePrefixed("kernel/sv_kernel.lua");
Clockwork:IncludePrefixed("kernel/cl_hooks.lua");

Clockwork.config:ShareKey("weapon_selection_multi");

if (CLIENT) then
	PLUGIN.displaySlot = 0;
	PLUGIN.displayFade = 0;
	PLUGIN.displayAlpha = 0;
	PLUGIN.displayDelay = 0;
	PLUGIN.weaponPrintNames = {};
end;