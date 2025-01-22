local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SilentCharBan");
COMMAND.tip = "Silently ban a character from being used.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(table.concat(arguments, " "));
	
	if (target) then
		if (!Clockwork.player:IsProtected(target)) then
			Clockwork.player:SetBanned(target, true);
			target:KillSilent();
		else
			Clockwork.player:Notify(player, target:Name().." is protected!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();