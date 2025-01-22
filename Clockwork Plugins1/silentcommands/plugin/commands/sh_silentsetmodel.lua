
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SilentSetModel");
COMMAND.tip = "Silently set a character's model.";
COMMAND.text = "<string Name> <string Model>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local model = table.concat(arguments, " ", 2);
		target:SetCharacterData("Model", model, true);
		target:SetModel(model);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();