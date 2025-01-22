
local PLUGIN = PLUGIN;
local COMMAND = Clockwork.command:New("Observerstay");
COMMAND.tip = "Stay where you are when exiting observer mode.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";

function COMMAND:OnRun(player, arguments)
	if (player:Alive() and !player:IsRagdolled() and !player.cwObserverReset) then
		if (player:GetMoveType(player) == MOVETYPE_NOCLIP) then
			PLUGIN:MakePlayerExitObserverMode(player);
		end;
	end;
end;

COMMAND:Register();
