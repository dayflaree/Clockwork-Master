local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlySilentSlay");
COMMAND.tip = "Slay a player silently.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if (target and target:Alive()) then
		target:KillSilent();
		if(echo) then
			if (player != target) then
				Clockwork.player:Notify(player, "You have silently slain "..target:Name()..".");
				Clockwork.player:Notify(target, player:Name().." has silently slain you.");
			else
				Clockwork.player:Notify(player, "You have silently slain yourself.")
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();