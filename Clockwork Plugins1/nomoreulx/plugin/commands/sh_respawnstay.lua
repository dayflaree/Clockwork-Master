local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RespawnStay");
COMMAND.tip = "Respawn a player, but keep them at their current position.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	if (target) then
		echo = Clockwork.config:Get("admin_echoes"):Get()
		local pos = target:GetPos()
		local angs = target:GetAngles()
		local eyeAngs = target:EyeAngles()
		target:Spawn()
		target:SetPos(pos)
		target:SetAngles(angs)
		target:SetEyeAngles(eyeAngs)
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