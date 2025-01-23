--[[
GlobalData by _Undefined
- Used for sharing data between servers.
]]--

include("globaldata_config.lua")

require("mysqloo")

-- Error handler.
local function DBError(self, err)
	if err then
		MsgN("GData [DB Error]: " .. err)
	end
end

-- Connect.
local GDataDB = mysqloo.connect(gdatadb_host, gdatadb_user, gdatadb_pass, gdatadb_name, gdatadb_port)
GDataDB.onConnectionFailed = DBError
GDataDB:connect()

-- If no connection, stop here.
if not GDataDB:status() == mysqloo.DATABASE_CONNECTED then MsgN("GData [DB]: Connection failed! (" .. err .. ")") return end

local GData = {}

local function DBError(self, err)
	if err then
		MsgN("GData [DB Error]: " .. err)
	end
end

function SetGData(key, value)
	GData[key] = value
	
	deleteQ = GDataDB:query("DELETE FROM `globaldata` WHERE `key` = '" .. key .. "'")
	deleteQ.onError = DBError
	deleteQ:start()
	
	insertQ = GDataDB:query("INSERT INTO `globaldata` (`key`, `value`) VALUES ('" .. key .. "', '" .. value .. "')")
	insertQ.onError = DBError
	insertQ:start()
end

function GetGData(key)
	return GData[key] or nil
end

local function MySQL2Local()
	selectQ = GDataDB:query("SELECT * FROM `globaldata`")
	selectQ.onData = function(self, data)
		MsgN("GData [MySQL]: Updated " .. data.key .. " with " .. data.value .. "!")
		GData[data.key] = data.value
	end
	selectQ.onError = DBError
	selectQ:start()
end

timer.Create("Update_Local_GData", gdatasync_schedule, 0, function()
	MySQL2Local()
end)

hook.Add("Initialize", "GData_Initialize", function()
	MySQL2Local()
end)