
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ServerPortalAdd");
COMMAND.tip = "Add a portal that will take the player to another server.";
COMMAND.text = "<string ServerWhitelist> <string IP:Port> <string Destination> [string spawnPoint]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 3;
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
	local areaPointData = player.areaPointData;
	local trace = player:GetEyeTraceNoCursor();
	
	if (!areaPointData) then
		player.areaPointData = {
			first = trace.HitPos
		};

		Clockwork.player:Notify(player, "You have added point A of the server portal, now add point B.");
	else
		local first = areaPointData.first;
		local second = trace.HitPos;
		
		local data = {
			min = Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
			max = Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z)),
			serverWhitelist = arguments[1],
			ip = arguments[2],
			destination = arguments[3]
		};

		if (arguments[4]) then
			data.spawnPoint = string.lower(arguments[4]);
		end;
		
		PLUGIN.areaPortals[#PLUGIN.areaPortals + 1] = data;
		
		PLUGIN:SaveAreaPortals();
		
		Clockwork.player:Notify(player, "You have added a server portal.");
		
		player.areaPointData = nil;
	end;
end;

COMMAND:Register();