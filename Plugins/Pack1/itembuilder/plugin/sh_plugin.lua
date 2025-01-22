local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");

function PLUGIN:Initialize()
	print("-------------")
	print("[ItemBuilder]")
	print("[IB] Created by NightAngel.")
	if (SERVER) then
		print("[IB] Loading custom items...")
		self:LoadCustomItems();
		print("[IB] Loading Complete!")
	end;
	print("-------------")
end;