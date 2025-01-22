
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:Add("main_server", "");
Clockwork.config:Add("server_whitelist_identity", "", true);

-- A function to load the area portals.
function PLUGIN:LoadAreaPortals()
	self.areaPortals = Clockwork.kernel:RestoreSchemaData("plugins/areaportals/"..game.GetMap(), {});
end;

-- A function to load the portal spawns.
function PLUGIN:LoadPortalSpawns()
	self.portalSpawns = Clockwork.kernel:RestoreSchemaData("plugins/portalspawns/"..game.GetMap(), {});
end;

-- A function to save the area portals.
function PLUGIN:SaveAreaPortals()
	Clockwork.datastream:Start(player.GetAll(), "AreaPortals", self.areaPortals);
	Clockwork.kernel:SaveSchemaData("plugins/areaportals/"..game.GetMap(), self.areaPortals);
end;

-- A function to save the portal spawns.
function PLUGIN:SavePortalSpawns()
	local superAdmins = {};
	for k, v in pairs(player.GetAll()) do
		if (v:IsSuperAdmin()) then
			superAdmins[#superAdmins + 1] = v;
		end;
	end;

	Clockwork.datastream:Start(superAdmins, "PortalSpawns", self.portalSpawns);
	Clockwork.kernel:SaveSchemaData("plugins/portalspawns/"..game.GetMap(), self.portalSpawns);
end;

Clockwork.datastream:Hook("UseAreaPortal", function(player, data)
	local areaPortal = PLUGIN.areaPortals[data[1]];
	if (areaPortal and PLUGIN:IsInBox(player:EyePos(), areaPortal.min, areaPortal.max)) then
		if (areaPortal.ip != "this") then
			if (areaPortal.serverWhitelist != "main") then
				player:GetData("ServerWhitelist")[areaPortal.serverWhitelist] = true;
			end;
			player:SetCharacterData("CurrentServer", areaPortal.serverWhitelist);

			if (areaPortal.spawnPoint) then
				player:SetCharacterData("PortalSpawn", areaPortal.spawnPoint);
			else
				player:SetCharacterData("PortalSpawn", -1);
			end;

			Clockwork.player:SaveCharacter(player);

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has switched to "..areaPortal.destination..".");

			Clockwork.datastream:Start(player, "UseAreaPortal", data);
		else
			local spawns = PLUGIN.portalSpawns[areaPortal.spawnPoint];
			if (spawns and #spawns > 0) then
				Clockwork.player:SetSafePosition(player, spawns[math.random(1, #spawns)]);
			end;
		end;
	end;
end);