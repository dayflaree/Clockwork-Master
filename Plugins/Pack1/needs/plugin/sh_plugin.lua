
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");

Clockwork.flag:Add("f", "Food", "Access to food items on the business menu.");
Clockwork.flag:Add("d", "Light Drinks", "Access to light drinks on the business menu.");
Clockwork.flag:Add("D", "Heavy Drinks", "Access to heavy drinks on the business menu.");