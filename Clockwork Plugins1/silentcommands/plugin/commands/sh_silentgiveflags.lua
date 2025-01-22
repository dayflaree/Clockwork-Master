
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SilentGiveFlags");
COMMAND.tip = "Silently give flags to a character.";
COMMAND.text = "<string Name> <string Flag(s)>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
			Clockwork.player:Notify(player, "You cannot give 'o', 'a' or 's' flags!");
			return;
		end;
		Clockwork.player:GiveFlags(target, arguments[2]);		
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();