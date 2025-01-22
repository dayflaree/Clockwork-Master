local PLUGIN = PLUGIN;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("rappelling");
	playerVars:Vector("climbNorm");
end;

function PLUGIN:Move(player, move)
	if (player:GetSharedVar("rappelling")) then
		move:SetForwardSpeed(0);
		move:SetSideSpeed(0);
	end;
end;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");