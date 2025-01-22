local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("ListVortWarps");
COMMAND.tip = "Lists all available Vortigaunt warps.";
COMMAND.text = "";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player, arguments)
	Clockwork.player:Notify(player, "Available warp locations:")
	for k, v in pairs(PLUGIN.WarpLocations) do
		if !(v.name) then continue; end;
		local name = tostring(v.name);

		if (v.hidden and player:IsAdmin()) then
			Clockwork.player:Notify(player, "- " .. name);
		elseif !(v.hidden) then
			Clockwork.player:Notify(player, "- " .. name);
		end;
	end;
end;

COMMAND:Register();