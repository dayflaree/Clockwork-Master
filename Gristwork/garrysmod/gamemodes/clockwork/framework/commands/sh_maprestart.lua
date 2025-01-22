--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("MapRestart");
COMMAND.tip = "Restart the current map.";
COMMAND.text = "[number Delay]";
COMMAND.access = "a";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local delay = tonumber(arguments[1]) or 10;
	
	if (type(arguments[1]) == "number") then
		delay = arguments[1];
	end;

	local delayMessage = player:Name().." is restarting the map in ";
	local hours = math.Round(math.max(delay / 3600, 0));
	local minutes = math.Round(math.max(delay / 60, 0));

	if (hours >= 1) then
		delayMessage = delayMessage..hours.." hour(s).";
	elseif (minutes >= 1) then
		delayMessage = delayMessage..minutes.." minute(s).";
	else
		delayMessage = delayMessage..delay.." second(s).";
	end;

	Clockwork.player:NotifyAll(delayMessage);
	
	timer.Simple(delay, function()
		RunConsoleCommand("changelevel", game.GetMap());
	end);
end;

COMMAND:Register();