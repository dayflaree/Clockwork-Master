local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyMuteIC");
COMMAND.tip = "Mute/unmute a player's IC chat.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if target then
		if (target.icmuted) then
			target.icmuted = false;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have unmuted "..target:Name().."'s IC.")
					Clockwork.player:Notify(target, player:Name().." has unmuted your IC.")
				else
					Clockwork.player:Notify(player, "You have unmuted your own IC.")
				end
			end
		else
			target.icmuted = true;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have muted "..target:Name().."'s IC.")
					Clockwork.player:Notify(target, player:Name().." has muted your IC.")
				else
					Clockwork.player:Notify(player, "You have muted your own IC.")
				end
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();