-- (c) Khub 2012-2013.

local PLUGIN = PLUGIN;

function PLUGIN:PlayerCharacterInitialized(ply)
	Datafiles.Database:LoadPlayerCharacter(ply);
end;

function PLUGIN:ClockworkDatabaseConnected()
	local DATAFILES_DATA = [[
		CREATE TABLE IF NOT EXISTS `datafiles_data` (
		`CharacterKey` int(11) NOT NULL,
		`Citizenship` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Basically a boolean in a number representation.',
		`Warrant` tinyint(1) NOT NULL DEFAULT '0',
		`LoyaltyTier` int(1) NOT NULL DEFAULT '0',
		`LastSpottedLocation` varchar(256) COLLATE utf8_unicode_ci NOT NULL DEFAULT '-',
		`LastSpottedTimestamp` int(11) NOT NULL DEFAULT '0',
		`Location` varchar(256) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'NO DATA',
		PRIMARY KEY (`CharacterKey`),
		KEY `CharacterKey` (`CharacterKey`))
	]];

	local DATAFILES_RECORDS = [[
		CREATE TABLE IF NOT EXISTS `datafiles_records` (
		`DatafileRecordID` int(11) NOT NULL AUTO_INCREMENT,
		`CharacterKey` int(11) NOT NULL COMMENT 'datafiles_records',
		`RecordType` varchar(64) NOT NULL DEFAULT 'UNKNOWN',
		`Performer` varchar(128) NOT NULL COMMENT 'Name of the character who did this action or who added this record',
		`_Timestamp` int(11) NOT NULL COMMENT 'Set by the Lua code with os.time()',
		`_Data` text NOT NULL,
		PRIMARY KEY (`DatafileRecordID`),
		KEY `CharacterKey` (`CharacterKey`))
	]];

	Clockwork.database:Query(string.gsub(DATAFILES_DATA, "%s", " "), nil, nil, true);
	Clockwork.database:Query(string.gsub(DATAFILES_RECORDS, "%s", " "), nil, nil, true);
end;
