local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlySlay");
COMMAND.tip = "Slay a player.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target and target:Alive()) then
		target:Kill();
		Clockwork.player:NotifyAll(player:Name().." has slain "..target:Name()..".");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();