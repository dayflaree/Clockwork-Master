local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("AddVortWarp");
COMMAND.tip = "Add a Vortigaunt warp location where you're standing. If the second argument is true, the warp will not appear in the list if you aren't an admin.";
COMMAND.text = "<string Name> [boolean Hidden]";
COMMAND.access = "s";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
	local pos = player:GetPos();
	local name = arguments[1]:lower();
	local hidden = tobool(arguments[2] or false);
	local buffer = {
		name = name,
		pos = pos,
		hidden = hidden
	};

	if (!arguments[1] or arguments[1] == "") then
		Clockwork.player:Notify(player, "You did not specify a valid warp name.");
		return;
	end;

	PLUGIN.WarpLocations[#PLUGIN.WarpLocations + 1] = buffer;
	PLUGIN:SaveWarps();
	Clockwork.player:Notify(player, "You have added the '" .. name .. "' vort warp.");
end;

COMMAND:Register();