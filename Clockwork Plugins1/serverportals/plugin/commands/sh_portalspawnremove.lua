
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("PortalSpawnRemove");
COMMAND.tip = "Remove portal spawns at your target position.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local spawnName = string.lower(arguments[1]);
	if (PLUGIN.portalSpawns[spawnName]) then
		local position = player:GetEyeTraceNoCursor().HitPos;
		local removed = 0;
		
		for k, v in pairs(PLUGIN.portalSpawns[spawnName]) do
			if (v:DistToSqr(position) <= 65000) then
				PLUGIN.portalSpawns[spawnName][k] = nil;
				
				removed = removed + 1;
			end;
		end;

		if (table.Count(PLUGIN.portalSpawns[spawnName]) == 0) then
			PLUGIN.portalSpawns[spawnName] = nil;
		else
			local newTable = {};
			for k, v in pairs(PLUGIN.portalSpawns[spawnName]) do
				newTable[#newTable + 1] = v;
			end;

			PLUGIN.portalSpawns[spawnName] = newTable;
		end;
		
		if (removed > 0) then
			if (removed == 1) then
				Clockwork.player:Notify(player, "You have removed "..removed.." '"..spawnName.."' portal spawn.");
			else
				Clockwork.player:Notify(player, "You have removed "..removed.." '"..spawnName.."' portal spawns.");
			end;
		else
			Clockwork.player:Notify(player, "There were no '"..spawnName.."' portal spawns near this position.");
		end;
	else
		Clockwork.player:Notify(player, "There are no '"..spawnName.."' portal spawns.");
	end;
	
	PLUGIN:SavePortalSpawns();
end;

COMMAND:Register();