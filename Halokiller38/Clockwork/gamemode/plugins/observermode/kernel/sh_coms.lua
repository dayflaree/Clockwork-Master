--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

COMMAND = Clockwork.command:New();
COMMAND.tip = "Enter or exit observer mode.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:Alive() and !player:IsRagdolled() and !player.cwObserverReset) then
		if (player:GetMoveType(player) == MOVETYPE_NOCLIP) then
			PLUGIN:MakePlayerExitObserverMode(player);
		else
			PLUGIN:MakePlayerEnterObserverMode(player);
		end;
	end;
end;

Clockwork.command:Register(COMMAND, "Observer");