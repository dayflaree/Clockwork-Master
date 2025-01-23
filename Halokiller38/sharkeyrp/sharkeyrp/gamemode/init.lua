require("tmysql");
require("json");

AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

include("shared.lua");

hook.hookCall = hook.Call;

function hook.Call(name, gamemode, ...)
	local arguments = {...};
	
	-- if (name == "EntityTakeDamage") then
		-- if (RP:DoEntityTakeDamageHook(arguments)) then
			-- return;
		-- end;
		
	-- elseif (name == "PlayerDisconnected") then
		-- if (!IsValid(arguments[1])) then
			-- return;
		-- end;
		
	-- elseif (name == "PlayerSay") then
		-- arguments[2] = string.Replace(arguments[2], "~", "\"");
	-- end;
	
	return hook.hookCall(name, gamemode or RP, unpack(arguments));
end;