
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SilentSetName");
COMMAND.tip = "Silently set a character's name.";
COMMAND.text = "<string Name> <string Name>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local name = table.concat(arguments, " ", 2);		
		Clockwork.player:SetName(target, name);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();