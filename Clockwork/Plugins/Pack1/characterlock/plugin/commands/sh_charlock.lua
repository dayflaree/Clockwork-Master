local COMMAND = Clockwork.command:New("CharLock");
COMMAND.tip = "Whether or not to disable character switching.";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if(Clockwork.config:Get("char_lock"):Get() == true) then
		Clockwork.config:Get("char_lock"):Set(false);
		Clockwork.player:Notify(player, "You have disabled character lock, players may now switch characters.");
	else
		Clockwork.config:Get("char_lock"):Set(true);
		Clockwork.player:Notify(player, "You have enabled character lock.");
	end;
end;

COMMAND:Register();