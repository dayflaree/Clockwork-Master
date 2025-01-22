local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RespawnBring");
COMMAND.tip = "Respawn a player at your crosshairs location.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	target = Clockwork.player:FindByID(arguments[1])
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if(target) then
		local trace = player:GetEyeTrace()
		local pos = trace.HitPos
		target:Spawn()
		target:SetPos(pos)
		if(echo) then
			if (player != target) then
				Clockwork.player:Notify(player, "You have respawned "..target:Name()..", and brought them to your crosshair location.")
				Clockwork.player:Notify(target, player:Name().." has respawned you, and brought you to their crosshair location.")
			else
				Clockwork.player:Notify(player, "You have respawned yourself, and brought you to your crosshair location.")
			end
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!")
	end;
end;

COMMAND:Register();