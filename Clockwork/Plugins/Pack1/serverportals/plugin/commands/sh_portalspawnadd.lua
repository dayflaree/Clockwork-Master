
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("PortalSpawnAdd");
COMMAND.tip = "Add a portal spawn at your target position.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local spawnName = string.lower(arguments[1]);
	PLUGIN.portalSpawns[spawnName] = PLUGIN.portalSpawns[spawnName] or {};
	PLUGIN.portalSpawns[spawnName][#PLUGIN.portalSpawns[spawnName] + 1] = player:GetEyeTraceNoCursor().HitPos;
	PLUGIN:SavePortalSpawns();
	
	Clockwork.player:Notify(player, "You have added a '"..spawnName.."' portal spawn.");
end;

COMMAND:Register();