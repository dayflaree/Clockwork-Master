local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyGimp");
COMMAND.tip = "Gimp/Ungimp a player.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if target then
		if (target.gimped) then
			target.gimped = false;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have ungimped "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has ungimped you.")
				else
					Clockwork.player:Notify(player, "You have ungimped yourself.")
				end
			end;
		else
			target.gimped = true;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have gimped "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has gimped you.")
				else
					Clockwork.player:Notify(player, "You have gimped yourself.")
				end
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();