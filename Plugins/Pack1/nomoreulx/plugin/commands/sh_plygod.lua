local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyGod");
COMMAND.tip = "God a player.";
COMMAND.text = "<string Name>";
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	if target then
		echo = Clockwork.config:Get("admin_echoes"):Get()
		if !target.godded then
			target:GodEnable()
			target.godded = true
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have godded "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has godded you.")
				else
					Clockwork.player:Notify(player, "You have godded yourself.")
				end
			end
		else
			target:GodDisable()
			target.godded = false
			if echo then
				if (player != target) then
					Clockwork.player:Notify(player, "You have ungodded "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has ungodded you.")
				else
					Clockwork.player:Notify("You have ungodded yourself.")
				end
			end
		end
	else
		player:Notify(arguments[2].." is not a valid player!")
	end
end;

COMMAND:Register();