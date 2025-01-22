local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("BeginWarp");
COMMAND.tip = "Begin channeling with nearby Vortigaunts in order to warp. Specify a name if you want to bring someone with you.";
COMMAND.text = "<string WarpName> [string BuddyName]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
	local location = arguments[1]:lower();
	local bringwithus = Clockwork.player:FindByID(arguments[2] or "") or false;
	local found = false

	if (IsValid(bringwithus) and ((bringwithus:GetSharedVar("vortChanneling") or bringwithus:GetPos():Distance(player:GetPos()) > PLUGIN.ChannelDist))) then
		bringwithus = false;
	end;

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
		Clockwork.player:Notify(player, "You have specified an invalid warp location.")
		return;
	end;

	PLUGIN:BeginChannel(player, location, bringwithus, #PLUGIN.channels + 1);
	Clockwork.player:Notify(player, "You begin to channel the Vortessence...");
	Clockwork.player:Notify(player, "(Requires " .. PLUGIN.MinimumVorts .. " Vortigaunts to complete, including yourself)");
end;

COMMAND:Register();