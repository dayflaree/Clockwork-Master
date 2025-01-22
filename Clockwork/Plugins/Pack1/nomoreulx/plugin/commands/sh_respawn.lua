local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Respawn");
COMMAND.tip = "Respawn a player.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if(target) then
		target:Spawn()
		if(echo) then
			if (player != target) then
				Clockwork.player:Notify(player, "You have respawned "..target:Name()..".")
				Clockwork.player:Notify(target, player:Name().." has respawned you.")
			else
				Clockwork.player:Notify(player, "You have respawned yourself")
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!")
	end;
end;

COMMAND:Register();