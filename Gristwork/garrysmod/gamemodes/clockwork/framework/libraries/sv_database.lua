--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local ErrorNoHalt = ErrorNoHalt;
local tostring = tostring;
local error = error;
local pairs = pairs;
local pcall = pcall;
local type = type;
local string = string;
local table = table;

Clockwork.database = Clockwork.kernel:NewLibrary("Database");
Clockwork.database.queryQueue = Clockwork.database.queryQueue or {};

MYSQL_UPDATE_CLASS = {__index = MYSQL_UPDATE_CLASS};
function MYSQL_UPDATE_CLASS:SetTable(tableName)
	self.tableName = tableName;
	return self;
end;

function MYSQL_UPDATE_CLASS:SetValue(key, value)
	if (Clockwork.NoMySQL) then return self; end;
		self.updateVars[key] = Clockwork.database:Escape(tostring(value));
	return self;
end;

function MYSQL_UPDATE_CLASS:Replace(key, search, replace)
	if (Clockwork.NoMySQL) then return self; end;
 
	search = "\""..Clockwork.database:Escape(tostring(search)).."\"";
	replace = "\""..Clockwork.database:Escape(tostring(replace)).."\"";
	self.updateVars[key] = "REPLACE("..key..", \""..search.."\", \""..replace.."\")";
 
	return self;
end;

function MYSQL_UPDATE_CLASS:AddWhere(key, value)
	if (Clockwork.NoMySQL) then return self; end;
 
	value = Clockwork.database:Escape(tostring(value));
	self.updateWhere[#self.updateWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
	return self;
end;

function MYSQL_UPDATE_CLASS:SetCallback(Callback)
	self.Callback = Callback;
	return self;
end;

function MYSQL_UPDATE_CLASS:SetFlag(value)
	self.Flag = value;
	return self;
end;

function MYSQL_UPDATE_CLASS:Push()
	if (Clockwork.NoMySQL) then return; end;
	if (!self.tableName) then return; end;
 
	local updateQuery = "";
 
	for k, v in pairs(self.updateVars) do
		if (updateQuery == "") then
			updateQuery = "UPDATE "..self.tableName.." SET "..k.." = \""..v.."\"";
		else
			updateQuery = updateQuery..", "..k.." = \""..v.."\"";
		end;
	end;
 
	if (updateQuery == "") then return; end;
 
	local whereTable = {};
 
	for k, v in pairs(self.updateWhere) do
		whereTable[#whereTable + 1] = v;
	end;
 
	local whereString = table.concat(whereTable, " AND ");
 
	if (whereString != "") then
		Clockwork.database:Query(updateQuery.." WHERE "..whereString, self.Callback, self.Flag);
	else
		Clockwork.database:Query(updateQuery, self.Callback, self.Flag);
	end;
end;

MYSQL_INSERT_CLASS = {__index = MYSQL_INSERT_CLASS};
function MYSQL_INSERT_CLASS:SetTable(tableName)
	self.tableName = tableName;
	return self;
end;

function MYSQL_INSERT_CLASS:SetValue(key, value)
	self.insertVars[key] = value;
	return self;
end;

function MYSQL_INSERT_CLASS:SetCallback(Callback)
	self.Callback = Callback;
	return self;
end;

function MYSQL_INSERT_CLASS:SetFlag(value)
	self.Flag = value;
	return self;
end;

function MYSQL_INSERT_CLASS:Push()
	if (Clockwork.NoMySQL) then return; end;
	if (!self.tableName) then return; end;
 
	local keyList = {};
	local valueList = {};
 
	for k, v in pairs(self.insertVars) do
		keyList[#keyList + 1] = k;
		valueList[#valueList + 1] = "\""..Clockwork.database:Escape(tostring(v)).."\"";
	end;
 
	if (#keyList == 0) then return; end;
 
	local insertQuery = "INSERT INTO "..self.tableName.." ("..table.concat(keyList, ", ")..")";
	insertQuery = insertQuery.." VALUES("..table.concat(valueList, ", ")..")";
	Clockwork.database:Query(insertQuery, self.Callback, self.Flag);
end;

MYSQL_SELECT_CLASS = {__index = MYSQL_SELECT_CLASS};

function MYSQL_SELECT_CLASS:SetTable(tableName)
	self.tableName = tableName;
	return self;
end;

function MYSQL_SELECT_CLASS:AddColumn(key)
	self.selectColumns[#self.selectColumns + 1] = key;
	return self;
end;

function MYSQL_SELECT_CLASS:AddWhere(key, value)
	if (Clockwork.NoMySQL) then return self; end;
 
	value = Clockwork.database:Escape(tostring(value));
	self.selectWhere[#self.selectWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
	return self;
end;

function MYSQL_SELECT_CLASS:SetCallback(Callback)
	self.Callback = Callback;
	return self;
end;

function MYSQL_SELECT_CLASS:SetFlag(value)
	self.Flag = value;
	return self;
end;

function MYSQL_SELECT_CLASS:SetOrder(key, value)
	self.Order = key.." "..value;
	return self;
end;

function MYSQL_SELECT_CLASS:Pull()
	if (Clockwork.NoMySQL) then return; end;
	if (!self.tableName) then return; end;
 
	if (#self.selectColumns == 0) then
		self.selectColumns[#self.selectColumns + 1] = "*";
	end;
 
	local selectQuery = "SELECT "..table.concat(self.selectColumns, ", ").." FROM "..self.tableName;
	local whereTable = {};
 
	for k, v in pairs(self.selectWhere) do
		whereTable[#whereTable + 1] = v;
	end;
 
	local whereString = table.concat(whereTable, " AND ");
 
	if (whereString != "") then
		selectQuery = selectQuery.." WHERE "..whereString;
	end;
 
	if (self.selectOrder != "") then
		selectQuery = selectQuery.." ORDER BY "..self.selectOrder;
	end;
 
	Clockwork.database:Query(selectQuery, self.Callback, self.Flag);
end;

MYSQL_DELETE_CLASS = {__index = MYSQL_DELETE_CLASS};

function MYSQL_DELETE_CLASS:SetTable(tableName)
	self.tableName = tableName;
	return self;
end;

function MYSQL_DELETE_CLASS:AddWhere(key, value)
	if (Clockwork.NoMySQL) then return self; end;
 
	value = Clockwork.database:Escape(tostring(value));
		self.deleteWhere[#self.deleteWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
	return self;
end;

function MYSQL_DELETE_CLASS:SetCallback(Callback)
	self.Callback = Callback;
	return self;
end;

function MYSQL_DELETE_CLASS:SetFlag(value)
	self.Flag = value;
	return self;
end;

function MYSQL_DELETE_CLASS:Push()
	if (Clockwork.NoMySQL) then return; end;
	if (!self.tableName) then return; end;
 
	local deleteQuery = "DELETE FROM "..self.tableName;
	local whereTable = {};
 
	for k, v in pairs(self.deleteWhere) do
		whereTable[#whereTable + 1] = v;
	end;
 
	local whereString = table.concat(whereTable, " AND ");
 
	if (whereString != "") then
		Clockwork.database:Query(deleteQuery.." WHERE "..whereString, self.Callback, self.Flag);
	else
		Clockwork.database:Query(deleteQuery, self.Callback, self.Flag);
	end;
end;

-- A function to begin a database update.
function Clockwork.database:Update(tableName)
	local object = Clockwork.kernel:NewMetaTable(MYSQL_UPDATE_CLASS);
		object.updateVars = {};
		object.updateWhere = {};
		object.tableName = tableName;
	return object;
end;

-- A function to begin a database insert.
function Clockwork.database:Insert(tableName)
	local object = Clockwork.kernel:NewMetaTable(MYSQL_INSERT_CLASS);
		object.insertVars = {};
		object.tableName = tableName;
	return object;
end;

-- A function to begin a database select.
function Clockwork.database:Select(tableName)
	local object = Clockwork.kernel:NewMetaTable(MYSQL_SELECT_CLASS);
		object.selectColumns = {};
		object.selectWhere = {};
		object.selectOrder = "";
		object.tableName = tableName;
	return object;
end;

-- A function to begin a database delete.
function Clockwork.database:Delete(tableName)
	local object = Clockwork.kernel:NewMetaTable(MYSQL_DELETE_CLASS);
		object.deleteWhere = {};
		object.tableName = tableName;
	return object;
end;

-- Called when a MySQL error occurs.
function Clockwork.database:Error(errorText, queryText)
	if (errorText) then
		ErrorNoHalt("[Clockwork] MySQL Error: "..errorText.."\nQuery: "..queryText.."\n");
	end;
end;

-- A function to queue a query.
function Clockwork.database:Queue(query, Callback, bRawQuery)
	self.queryQueue[#self.queryQueue + 1] = {query, Callback, bRawQuery};
end;

-- A function to query the database.
function Clockwork.database:Query(query, Callback, flag, bRawQuery)
	if (Clockwork.NoMySQL) then return; end;

	if (MANUAL_UPDATE) then
		Clockwork.database:Queue(query, Callback, bRawQuery);
		return; 
	end;
 
	if (!bRawQuery) then
		local queryObj = self.connection:query(query);

		queryObj:setOption(mysqloo.OPTION_NAMED_FIELDS);

		queryObj.onSuccess = function(queryObj, data)
			if (Callback) then
				Callback(data, queryObj:status(), queryObj:lastInsert());
			end;
		end;

		queryObj.onError = function(queryObj, errorText)
			local databaseStatus = Clockwork.database.connection:status();

			if (databaseStatus != mysqloo.DATABASE_CONNECTED) then
				Clockwork.database:Queue(query, Callback);

				if (databaseStatus == mysqloo.DATABASE_NOT_CONNECTED) then
					Clockwork.database.connection:connect();
				end;
			end;

			Clockwork.database:Error(errorText, query);
		end;

		queryObj:start();
	else
		local queryObj = self.connection:query(query);

		queryObj:start();
	end;
end;

-- A function to get whether a result is valid.
function Clockwork.database:IsResult(result)
	return (result and type(result) == "table" and #result > 0);
end;

-- A function to make a string safe for SQL.
function Clockwork.database:Escape(text)
	return self.connection:escape(text);
end;

-- Called when the database is connected.
function Clockwork.database:OnConnected()
	local BANS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_bans_table"):Get()..[[` (
		`_Key` int(11) NOT NULL AUTO_INCREMENT,
		`_Identifier` text NOT NULL,
		`_UnbanTime` int(11) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_Duration` int(11) NOT NULL,
		`_Reason` text NOT NULL,
		`_Schema` text NOT NULL,
		PRIMARY KEY (`_Key`))
	]];

	local CHARACTERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_characters_table"):Get()..[[` (
		`_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
		`_Data` text NOT NULL,
		`_Name` varchar(150) NOT NULL,
		`_Ammo` text NOT NULL,
		`_Cash` varchar(150) NOT NULL,
		`_Model` varchar(250) NOT NULL,
		`_Flags` text NOT NULL,
		`_Schema` text NOT NULL,
		`_Gender` varchar(50) NOT NULL,
		`_Faction` varchar(50) NOT NULL,
		`_SteamID` varchar(60) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_Inventory` text NOT NULL,
		`_OnNextLoad` text NOT NULL,
		`_Attributes` text NOT NULL,
		`_LastPlayed` varchar(50) NOT NULL,
		`_TimeCreated` varchar(50) NOT NULL,
		`_CharacterID` varchar(50) NOT NULL,
		`_RecognisedNames` text NOT NULL,
		PRIMARY KEY (`_Key`),
		KEY `_Name` (`_Name`),
		KEY `_SteamID` (`_SteamID`))
	]];

	local PLAYERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_players_table"):Get()..[[` (
		`_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
		`_Data` text NOT NULL,
		`_Schema` text NOT NULL,
		`_SteamID` varchar(60) NOT NULL,
		`_Donations` text NOT NULL,
		`_UserGroup` text NOT NULL,
		`_IPAddress` varchar(50) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_OnNextPlay` text NOT NULL,
		`_LastPlayed` varchar(50) NOT NULL,
		`_TimeJoined` varchar(50) NOT NULL,
		PRIMARY KEY (`_Key`),
		KEY `_SteamID` (`_SteamID`))
	]];

	self:Query(string.gsub(BANS_TABLE_QUERY, "%s", " "), nil, nil, true);
	self:Query(string.gsub(CHARACTERS_TABLE_QUERY, "%s", " "), nil, nil, true);
	self:Query(string.gsub(PLAYERS_TABLE_QUERY, "%s", " "), nil, nil, true);

	Clockwork.NoMySQL = false;
	Clockwork.plugin:Call("ClockworkDatabaseConnected");

	for k, v in pairs(self.queryQueue) do
		self:Query(v[1], v[2], nil, v[3]);
	end;

	self.queryQueue = {};
end;

-- Called when the database connection fails.
function Clockwork.database:OnConnectionFailed(errorText)
	ErrorNoHalt("[Clockwork] MySQL Error: "..errorText.."\n");
		Clockwork.NoMySQL = errorText;
	Clockwork.plugin:Call("ClockworkDatabaseConnectionFailed", errorText);
end;

-- A function to connect to the database.
function Clockwork.database:Connect(host, username, password, database, port)
	if (self.connection) then
		return;
	end;

	if (host == "localhost") then
		host = "127.0.0.1";
	end;

	if (type(mysqloo) != "table") then
		require("mysqloo");
	end;

	if (mysqloo) then
		self.connection = mysqloo.connect(host, username, password, database, port);

		self.connection.onConnected = function(database)
			Clockwork.database:OnConnected();
		end;

		self.connection.onConnectionFailed = function(database, errorText)
			Clockwork.database:OnConnectionFailed(errorText);
		end;

		self.connection:connect();
	else
		self:OnConnectionFailed("The mysqloo module does not exist!");
	end;
end;

--[[
	EXAMPLE:
	
	local myInsert = Clockwork.database:Insert();
		myInsert:SetTable("players");
		myInsert:SetValue("_Name", "Joe");
		myInsert:SetValue("_SteamID", "STEAM_0:1:9483843344");
		myInsert:AddCallback(MyCallback);
	myInsert:Push();
--]]