
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

if (CLIENT) then
	Clockwork.config:AddToSystem("Health Regen Time", "health_regen_time", "The amount of hours it takes for someone's health to fully regenerate.", 1, 48, 0);
end;