
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local ipairs = ipairs;
local string = string;
local tonumber = tonumber;

Clockwork.option:SetKey("RecordsTable", "character_records");
Clockwork.option:SetKey("DataFileTable", "character_datafile");

Clockwork.datastream:Hook("AddEntryToRecord", function(player, data)
	if (PLUGIN:CanPlayerAddEntry(player, data[1], data[2])) then
		if (data[4] and data[2] == PLUGIN.types.violation) then
			PLUGIN:AddPointsToRecord(data[1], data[4])
		end;
		PLUGIN:AddEntryToRecords(data[1], player, data[2], false, data[3]);
	end;
end);

Clockwork.datastream:Hook("SetEntryHidden", function(player, data)
	if (PLUGIN:CanPlayerHideEntry(player, data)) then
		PLUGIN:SetEntryHidden(data.key, data.hidden);
	end;
end);

Clockwork.datastream:Hook("SetCivilStatus", function(player, data)
	if (PLUGIN:CanPlayerChangeCivilStatus(player, data[1], data[2], data[3], data[4])) then
		local tier = string.match(data[4], "loyalist(%d+)");
		if (tier) then
			PLUGIN:UpdateDataFilePoints(data[1], nil, tonumber(tier));
			PLUGIN:AddLoyalistTierChangedNote(player, data[1], data[5]);
		else
			if (PLUGIN.defaultCivilStatus[data[4]]) then
				PLUGIN:UpdateDataFilePoints(data[1], nil, 0);
				PLUGIN:UpdateDataFileStatus(data[1], nil, "");
			else
				PLUGIN:UpdateDataFileStatus(data[1], nil, data[4]);
			end;

			if (string.find(data[3], "loyalist%d")) then
				PLUGIN:AddLoyalistTierRevokedNote(player, data[1], data[5]);
			end;

			PLUGIN:AddCivilStatusChangedNote(player, data[1], data[5]);
		end;
	end;
end);

Clockwork.datastream:Hook("SetSocEndStatus", function(player, data)
	if (PLUGIN:CanPlayerChangeSocEndStatus(player, data[1], data[2], data[3], data[4])) then
		if (PLUGIN.defaultSocEndStatus[data[4]]) then
			PLUGIN:UpdateDataFileStatus(data[1], "");
		else
			PLUGIN:UpdateDataFileStatus(data[1], data[4]);
		end;

		PLUGIN:AddSocEndStatusChangedNote(player, data[1], data[5]);
	end;
end);

local characterLoadSelectTypes = {[PLUGIN.types.violation] = true};
local loadVerdictPointsFunc = function(records, player)
	local points = 0;
	for k, v in ipairs(records) do
		points = points + v.points;
	end;

	player.dataFile.vp = points;
end;

local loadDataFileFunc = function(dataFile, player)
	player.dataFile = dataFile;
	PLUGIN:GetCharacterRecords(player:GetCharacter().key, false, characterLoadSelectTypes, loadVerdictPointsFunc, player);
end;

function PLUGIN:PlayerCharacterLoaded(player)
	self:GetCharacterDataFile(player:GetCharacter().key, loadDataFileFunc, player);
end;

function PLUGIN:ClockworkDatabaseConnected()
	local RECORD_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.option:GetKey("RecordsTable")..[[` (
		`_Key` int(11) unsigned NOT NULL AUTO_INCREMENT,
		`_CharacterKey` int(11) NOT NULL,
		`_CreatedByKey` int(11) NOT NULL,
		`_CreatedBy` varchar(60) NOT NULL,
		`_Hidden` bool,
		`_Points` int(5) NOT NULL,
		`_TimeStamp` int(11) unsigned NOT NULL,
		`_Type` varchar(1) NOT NULL,
		`_Text` text NOT NULL,
		PRIMARY KEY (`_Key`),
		KEY `_CharacterKey` (`_CharacterKey`))
	]];

	local DATAFILE_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.option:GetKey("DataFileTable")..[[` (
		`_CharacterKey` int(11) NOT NULL,
		`_SocEndStatus` varchar(60) NOT NULL,
		`_CivilStatus` varchar(60) NOT NULL,
		`_Data` text,
		PRIMARY KEY (`_CharacterKey`))
	]];
	
	Clockwork.database:Query(string.gsub(RECORD_TABLE_QUERY, "%s", " "), nil, nil, true);
	Clockwork.database:Query(string.gsub(DATAFILE_TABLE_QUERY, "%s", " "), nil, nil, true);
end;