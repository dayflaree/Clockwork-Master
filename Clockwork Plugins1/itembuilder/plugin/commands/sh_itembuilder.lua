local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("ItemBuilder");
COMMAND.tip = "Build items that will be permanently saved.";
COMMAND.text = "[No Text]";
COMMAND.access = "s";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(player, "ItemBuilder", PLUGIN.customItems);
end;

COMMAND:Register();