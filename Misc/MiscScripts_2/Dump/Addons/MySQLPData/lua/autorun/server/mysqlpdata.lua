--[[
MySQL PData Replacement by _Undefined
- Used for sharing player data between servers.
]]--

include("mysqlpdata_config.lua")

require("mysqloo")

-- Error handler.
local function DBError(self, err)
	if err then
		MsgN("PData [DB Error]: " .. err)
	end
end

-- Connect.
local PDataDB = mysqloo.connect(pdatadb_host, pdatadb_user, pdatadb_pass, pdatadb_name, pdatadb_port)
PDataDB.onConnectionFailed = DBError
PDataDB:connect()

-- If no connection, stop here.
if not PDataDB:status() == mysqloo.DATABASE_CONNECTED then MsgN("PData [DB]: Connection failed! (" .. err .. ")") return end

local Player = _R.Player
local oldsetpdata = _R.Player.SetPData -- Only need to override Set, as Get will always pull from the local database, and be synched.

-- Override SetPData to send to MySQL.
function Player:SetPData(key, value)
	oldsetpdata(self, key, value) -- Keep it local.
	
	MsgN("PData [SQL -> MySQL]: Updating '" .. key .. "' for '" .. self:UniqueID() .. "' with '" .. value .. "'!")
	
	deleteQ = PDataDB:query("DELETE FROM `playerdata` WHERE `uniqueid` = '" .. self:UniqueID() .. "' AND `key` = '" .. key .. "'")
	deleteQ.onError = DBError
	deleteQ:start()
	
	insertQ = PDataDB:query("INSERT INTO `playerdata` (`uniqueid`, `key`, `value`) VALUES ('" .. self:UniqueID() .. "', '" .. key .. "', '" .. value .. "')")
	insertQ.onError = DBError
	insertQ:start()
end

-- Sync from MySQL to local SQL. Done on a timer, or manually with pdata_mysql2sql.
local function MySQL2SQL()
	selectQ = PDataDB:query("SELECT * FROM `playerdata`")
	selectQ.onData = function(self, data)
		MsgN("PData [MySQL -> SQL]: Updated '" .. data.key .. "' for '" .. data.uniqueid .. "' with '" .. data.value .. "'!")
		key = Format("%s[%s]", data.uniqueid, data.key)
		sql.Query("DELETE FROM playerpdata WHERE infoid = " .. SQLStr(data.key))
		sql.Query("INSERT INTO playerpdata (infoid, value) VALUES ("..SQLStr(data.key)..", "..SQLStr(data.value)..")")
	end
	selectQ.onError = DBError
	selectQ:start()
end

-- Sync from local SQL to MySQL. Only done by command, and should be done once on the ititial server.
local function SQL2MySQL()
	local data = sql.Query("select * from playerpdata")
	
	for _, row in pairs(data) do
		local value = row['value']
		local infoid = row['infoid']
		
		local split = string.Explode("[", infoid)
		
		local uniqueid = split[1]
		local key = string.sub(split[2], 1, -2)
		
		deleteQ = PDataDB:query("DELETE FROM `playerdata` WHERE `uniqueid` = '" .. uniqueid .. "' and `key` = '" .. key .. "'")
		deleteQ.onError = DBError
		deleteQ:start()
		
		insertQ = PDataDB:query("INSERT INTO `playerdata` (`uniqueid`, `key`, `value`) VALUES ('" .. uniqueid .. "', '" .. key .. "', '" .. value .. "')")
		insertQ.onError = DBError
		insertQ:start()
		MsgN("PData [SQL -> MySQL]: Updated '" .. key .. "' for '" .. uniqueid .. "' with '" .. value .. "'!")
	end
end

-- Create timer to update SQL from MySQL.
timer.Create("Update_Local_PData", pdatasync_schedule, 0, function()
	MySQL2SQL()
end)

-- Command to sync from SQL to MySQL.
concommand.Add("pdata_sql2mysql", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	
	if not ply.HasBeenWarned then
		ply.HasBeenWarned = true
		ply:PrintMessage(HUD_PRINTCONSOLE, "WARNING! This command will overwrite anything in the MySQL database with the data in the local SQL database. Are you sure you want to do this? Run this command again to confirm.\n")
		return
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "Updated MySQL with SQL data!\n")
		SQL2MySQL()
	end
end)

-- Command to sync from MySQL to SQL. Should be run once on initial server.
concommand.Add("pdata_mysql2sql", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	
	if not ply.HasBeenWarned then
		ply.HasBeenWarned = true
		ply:PrintMessage(HUD_PRINTCONSOLE, "WARNING! This command will overwrite anything in the local SQL database with data from the MySQL database. Are you sure you want to do this? Run this command again to confirm.\n")
		return
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "Updated SQL with MySQL data!\n")
		MySQL2SQL()
	end
end)