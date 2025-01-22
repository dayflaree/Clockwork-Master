
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ServerPortalRemove");
COMMAND.tip = "Remove all server portals you are currently inside of.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local pos = player:GetShootPos();
	local removed = false;
	for k, v in pairs(PLUGIN.areaPortals) do
		if (PLUGIN:IsInBox(pos, v.min, v.max)) then
			Clockwork.player:Notify(player, "You removed the server portal with destination "..v.destination..".");
			PLUGIN.areaPortals[k] = nil;
			removed = true;
		end;
	end;
	
	if (!removed) then
		Clockwork.player:Notify(player, "There were no server portals near your position.");
	else
		PLUGIN:SaveAreaPortals();
	end;
end;

COMMAND:Register();