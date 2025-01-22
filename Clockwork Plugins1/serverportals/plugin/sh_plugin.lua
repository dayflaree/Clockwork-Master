
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

Clockwork.config:ShareKey("server_whitelist_identity");

function PLUGIN:IsInBox(pos, min, max)
	if (min.x < pos.x and pos.x < max.x and
		min.y < pos.y and pos.y < max.y and
		min.z < pos.z and pos.z < max.z) then
		return true;
	else
		return false;
	end;
end;