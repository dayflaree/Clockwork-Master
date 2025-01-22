local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("JoinWarp");
COMMAND.tip = "Join a group of Vortigaunts in channeling for a warp.";
COMMAND.text = "<string WarpName>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
	local location = arguments[1]:lower();
	local found = false;

	if !(player:GetFaction():find("Vortigaunt")) then return; end;

	if (player:GetSharedVar("vortChanneling")) then
		Clockwork.player:Notify(player, "You are already channeling!");
		return;
	end;

	if ((player:GetSharedVar("vortChannelCooldown") or 0) >= CurTime()) then
		Clockwork.player:Notify(player, "You are too weak to warp again so soon!");
		return;
	end;

	for k, v in pairs(PLUGIN.WarpLocations) do
		if (v.name == location) then
			found = true;
		end;
	end;

	if !(found) then
		Clockwork.player:Notify(player, "You have specified an invalid warp location.");
		return;
	end;

	PLUGIN:FindChannelToJoin(player, location);
	Clockwork.player:Notify(player, "You begin to channel the Vortessence...");
	Clockwork.player:Notify(player, "(Requires " .. PLUGIN.MinimumVorts .. " Vortigaunts to complete, including yourself)");
end;

COMMAND:Register()