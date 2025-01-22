local PLUGIN = PLUGIN;
local COMMAND = Clockwork.command:New("Datafile");

COMMAND.tip = "Brings up the Combine datafile of a character.";
COMMAND.text = "Usage: /Datafile John Doe";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(ply, arguments)
	local factionTable = Clockwork.player:GetFactionTable(ply);
	if (!factionTable.canUseDataFiles) then
		Clockwork.player:Notify(ply, "You aren't authorized to access datafiles on this character!");
		return;
	end;

	local name = table.concat(arguments, " ");
	local subject = Clockwork.player:FindByID(name);

	if (!IsValid(subject)) then
		Clockwork.player:Notify(ply, "Couldn't find datafile of entity '" .. name .. "'!");
		return;
	end;

	if (!subject.Datafile or type(subject.Datafile) != "table") then
		Clockwork.player:Notify(ply, "Something went wrong with that person's datafile. Have the person rejoin and if the problem persists, report it, please!");
		return;
	end;

	net.Start("Datafiles");
	net.WriteString("Datafile");
	net.WriteTable(subject:GetFullDatafile());
	net.Send(ply);
end;

COMMAND:Register();