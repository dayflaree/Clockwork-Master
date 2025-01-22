local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("DeleteVortWarp");
COMMAND.tip = "Deletes the specified Vortigaunt warp.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
	local name = arguments[1]:lower()

	if (!arguments[1] or arguments[1] == "") then
		Clockwork.player:Notify(player, "You did not specify a valid warp name.");
		return;
	end;

	for k, v in pairs(PLUGIN.WarpLocations) do
		if (v.name == name) then
			table.remove(PLUGIN.WarpLocations, k);
			Clockwork.player:Notify(player, "You have removed the '" .. name .. "' vort warp.");
		end;
	end;

	PLUGIN:SaveWarps();
end;

COMMAND:Register();