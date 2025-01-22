
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadAreaPortals();
	self:LoadPortalSpawns();
end;

function PLUGIN:PlayerSendDataStreamInfo(player)
	Clockwork.datastream:Start(player, "AreaPortals", self.areaPortals);
	Clockwork.datastream:Start(player, "PortalSpawns", self.portalSpawns);
end;

function PLUGIN:PlayerAdjustCharacterScreenInfo(player, character, info)
	local serverWhitelistIdentity = Clockwork.config:Get("server_whitelist_identity"):Get("");

	if (serverWhitelistIdentity != (character.data["CurrentServer"] or "")) then
		local factionTable = Clockwork.faction:FindByID(character.faction);
		if (!factionTable or !factionTable.allServers) then
			info.banned = true;
			info.details = "This character is in another area.";
		end;
	end;
end;

function PLUGIN:PlayerCanUseCharacter(player, character)
	local serverWhitelistIdentity = Clockwork.config:Get("server_whitelist_identity"):Get("");

	if (serverWhitelistIdentity != (character.data["CurrentServer"] or "")) then
		local factionTable = Clockwork.faction:FindByID(character.faction);
		if (!factionTable or !factionTable.allServers) then
			return character.name.." is in another area and cannot be used.";
		end;
	end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (!data["CurrentServer"] or data["CurrentServer"] == "main") then
		data["CurrentServer"] = "";
	end;
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if (!data["CurrentServer"] or data["CurrentServer"] == "main") then
		data["CurrentServer"] = "";
	end;

	if (data["PortalSpawn"]) then
		data["SpawnPoint"] = nil;

		if (!self.portalSpawns[data["PortalSpawn"]]) then
			data["PortalSpawn"] = nil;
		end;
	end;
end;

-- Called when a player's data should be saved.
function PLUGIN:PlayerSaveData(player, data)
	if (data["ServerWhitelist"] and table.Count(data["ServerWhitelist"]) == 0) then
		data["ServerWhitelist"] = nil;
	end;
end;

-- Called when a player's data should be restored.
function PLUGIN:PlayerRestoreData(player, data)
	if (!data["ServerWhitelist"]) then
		data["ServerWhitelist"] = {};
	end;

	local serverWhitelistIdentity = Clockwork.config:Get("server_whitelist_identity"):Get("");

	if (serverWhitelistIdentity != "") then
		if (!data["ServerWhitelist"][serverWhitelistIdentity]) then
			if (Clockwork.config:Get("main_server"):Get("") != "") then
				Clockwork.datastream:Start(player, "ConnectToMain", {Clockwork.config:Get("main_server"):Get()});
			else
				player:Kick("You are not whitelisted for this server!");

				return true;
			end;
		end;
	end;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, bLightSpawn, bChangeClass, bFirstSpawn)
	if (!bLightSpawn) then
		local spawnPos = player:GetCharacterData("PortalSpawn");
		
		if (spawnPos) then
			player:SetCharacterData("PortalSpawn", nil);

			spawnPos = self.portalSpawns[spawnPos][math.random(1, #self.portalSpawns[spawnPos])];
			player:SetPos(Vector(spawnPos.x, spawnPos.y, spawnPos.z));
		end;
	end;
end;

function PLUGIN:PlayerCanCreateCharacter(player, character, characterID)
	local factionTable = Clockwork.faction:FindByID(character.faction);
	if (factionTable) then
		if (Clockwork.config:Get("server_whitelist_identity"):Get("") != "") then
			if (!factionTable.allServers and (!factionTable.serverCharacterCreationWhitelist or 
				!factionTable.serverCharacterCreationWhitelist[Clockwork.config:Get("server_whitelist_identity"):Get("")])) then
				return "You cannot create a new character on this whitelist in this area!";
			end;
		elseif (factionTable.cannotCreateOnMain == true) then
			return "You cannot create a new character on this whitelist on the main server!";
		end;
	end;
end;