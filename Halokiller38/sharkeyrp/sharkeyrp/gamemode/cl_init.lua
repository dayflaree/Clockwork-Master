include("shared.lua");

hook.hookCall = hook.Call;

function hook.Call(name, gamemode, ...)
	if (!IsValid(RP.Client)) then
		RP.Client = LocalPlayer();
	end;
	
	return hook.hookCall(name, gamemode or RP, ...);
end;