local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyMuteOOC");
COMMAND.tip = "Mute/unmute a player's OOC. (Global and Local)";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if target then
		if (!target.oocmuted) then
			target.oocmuted = true;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have muted "..target:Name().."'s local and global OOC.")
					Clockwork.player:Notify(target, player:Name().." has muted your local global OOC.")
				else
					Clockwork.player:Notify(player, "You have muted your own local and global OOC.")
				end
			end
		else
			target.oocmuted = false;
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have unmuted "..target:Name().."'s local and global OOC.")
					Clockwork.player:Notify(target, player:Name().." has unmuted your local global OOC.")
				else
					Clockwork.player:Notify(player, "You have unmuted your own local and global OOC.")
				end
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();