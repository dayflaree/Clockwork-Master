local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlaySound");
COMMAND.tip = "Make all players play a sound.";
COMMAND.text = "<string SoundPath>";
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for k, v in pairs(_player.GetAll()) do
		v:ConCommand("play "..table.concat(arguments, " "))
	end;
end;

COMMAND:Register();