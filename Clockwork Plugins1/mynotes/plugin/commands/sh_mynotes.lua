
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("MyNotes");
COMMAND.tip = "View my own notes.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(player, "EditNotes", {player:GetCharacterData("NotesText", "")});
end;

COMMAND:Register();