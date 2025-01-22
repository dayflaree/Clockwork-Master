local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PlyIgnite");
COMMAND.tip = "Ignite/unignite a player.";
COMMAND.text = "<string Name> [number Seconds]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local seconds = arguments[2] or 30;
	echo = Clockwork.config:Get("admin_echoes"):Get()
	if (target and target:Alive()) then
		if (target:IsOnFire() and !arguments[2]) then
			target:Extinguish();
			if echo then
				if (target != player) then
					Clockwork.player:Notify(player, "You have unignited "..target:Name()..".")
					Clockwork.player:Notify(target, player:Name().." has unignited you.")
				else
					Clockwork.player:Notify(player, "You have unignited yourself.")
				end
			end
			return;
		end
		
		target:Ignite(seconds);
		if echo then
			if (player != target) then
				Clockwork.player:Notify(player, "You have ignited "..target:Name().." for "..seconds..".")
				Clockwork.player:Notify(target, player:Name().." has ignited you for "..seconds..".")
			else
				Clockwork.player:Notify(player, "You have ignited yourself for "..seconds..".")
			end
		end
	else		
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();