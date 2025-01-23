-------------------------------------------------------------------
--                          Config                               --
-- Uban system by Meggido, implemented for TnB by Suicide Bomber --
-------------------------------------------------------------------

-----------this part goes in admin_cc.lua eventually ------------------

function ccGban( ply, command, argv, args )
	if #argv < 1 then
		ply:PrintMessage( 2, "rpa_gban <user> [<time>] [<comment>] - Globally bans a user, time is in minutes. 0 or blank for perma." );
		return
	end

	local target = TS.RunPlayerSearch( ply, argv[1], true );
	if not target or not TS.AdminCanTarget( ply, target ) then
		ply:PrintMessage( 3, "Invalid Target" );
		return
	end
	
	local time = tonumber( argv[ 2 ] or 0 )
	if not time then
		ply:PrintMessage( 3, "Invalid Time" );
		return
	end
	if( not ply:IsSuperAdmin() ) then
		if( time > 1440 or time < 1 ) then
			ply:PrintMessage( 2, "Maximum of 1440 minutes exceeded!" );
			return
		end
	end
	
	local comment = argv[ 3 ] or ""

	local b, e = pcall( gBanUser, ply, target, time * 60, comment )
	if b then
		TS.PrintMessageAll( 3, TS.GetConsoleNick( ply ) .. " globaly banned " .. TS.GetConsoleNick( target ));
		ply:PrintMessage( 3, "Global Ban Successful" );
	else
		Msg( "GBan failure. Error is: " .. tostring( e ) .. "\n" )
		ply:PrintMessage( 3, "Global ban failed!" );
	end
end
concommand.Add( "rpa_gban", ccGban );



function ccGbanId( ply, command, argv, args )
	if( not ply:IsSuperAdmin() ) then
		return
	end
	if #argv < 1 then
		ply:PrintMessage( 2, "rpa_gbanid <Steam ID> [<time>] [<comment>] - Globally bans an ID, time is in minutes. 0 or blank for perma." );
		return
	end

	local steamid = argv[ 1 ]
	
	local time = tonumber( argv[ 2 ] or 0 )
	if not time then
		ply:PrintMessage( 3, "Invalid Time" );
		return
	end
	
	local comment = argv[ 3 ] or ""

	local b, e = pcall( gManualBan, ply, steamid, nil, time * 60, comment )
	
	if b then
	
		local steamidtable = { }
		for k, v in pairs( player.GetAll() ) do
			steamidtable[v:SteamID()] = v;
		end
		
		if( steamidtable[steamid] ) then
			local target = steamidtable[steamid];
			-- If they are in the server, kick them
			local str = string.format( "kickid %s Banned for %d minutes by %s\n", target:SteamID(), time,  ply:Nick()   )
			game.ConsoleCommand( str );
		end
		
		ply:PrintMessage( 3, "Global Ban Successful" );
	else
		Msg( "GBan failure. Error is: " .. tostring( e ) .. "\n" )
		ply:PrintMessage( 3, "Global ban failed!" );	
	end
end
concommand.Add( "rpa_gban", ccGbanId );

local function ccGunbanid( ply, command, argv, args )
	if( not ply:IsSuperAdmin() ) then
		return
	end
	if #argv < 1 then
		ply:PrintMessage( 3, "Invalid Arguments" );
		return
	end

	gClearBan( argv[ 1 ] )
	ply:PrintMessage( 3, "Global unban successful (assuming this ban existed)." );
end
--TS.AdminCommand( "rp_gunbanid", ccGunbanid, "<steamid> - Globally unbans a user's steamid.")







------------------------------------------------------------------------

local gbhost = "localhost"
local gbusername = "bansys"
local gbpassword = "@7e&HADr-pra9?ED"
local gbdatabase = "bans"
local gbport = 3306
local table = "gbans"

local updatetime = 1 -- How often, in minutes, it updates the bans from mysql
-- (So if a person banned from one server joins another server using the same DB, it could take up to this long to get rid of him/her)

local persistent = true -- Use a persistent MySQL connection?

local baninterval = 44000 -- Ban time to report to console. We can't use 0 because we don't want it to be saved with writeid. 44k minutes == 1 month.
-- If you plan on keeping your server on one map without restarting for more than a month at a time (hah) then you'll need to up this value.

--[[
Table structure:
CREATE TABLE gbans (
id INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
steamid CHAR( 12 ) NOT NULL,
name CHAR( 31 ),
time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
unban_time TIMESTAMP NOT NULL DEFAULT 0,
comment CHAR( 128 ),
serverip INT UNSIGNED NOT NULL,
serverport SMALLINT UNSIGNED NOT NULL DEFAULT 27015,
adminname CHAR( 31 ),
adminsteamid CHAR( 12 )
);
]]--

require( "mysqloo" )

local db

Bans = {} -- Keep track of all the last known bans

function gDoQuery( query, type, success )
	local query = db:query( query )
	type = type or mysqloo.OPTION_NUMERIC_FIELDS

	if type == mysqloo.OPTION_NUMERIC_FIELDS then
		query:setOption(mysqloo.OPTION_NUMERIC_FIELDS, true)
		query:setOption(mysqloo.OPTION_NAMED_FIELDS, false)
	end
	query:wait()
	return query:getData()
end

function Connect()
	if db then return db end -- Still connected

	db = mysqloo.connect( gbhost, gbusername, gbpassword, gbdatabase, gbport )
	db.onConnectionFailed = function(err)
		db = nil
		error( tostring( err ), 1 )
	end
	db:connect()
	db:wait()

	return db
end

function Disconnect( force )
	if not db then return end -- Already disconnected
	if persistent and not force then return end -- Don't disconnect, persistent

	local succ, err = db:delete()
	
	db = nil
end
hook.Add( "ShutDown", "UBanClose", function() Disconnect( true ) end ) -- Force closed on shutdown.

function Escape( str )
	if not db then
		Msg( "Not connected to DB.\n" )
		return
	end
	
	if not str then return end

	db:escape(tostring(str))

	-- print( "esc=" .. esc ) -- For debug
	return esc
end

-- Because we use this a lot
function Format( str )
	if not str then return "NULL" end
	return string.format( "%q", str )
end

-- Ban user
function gBanUser( banner, ply, time, comment )
	local time2
	if not time or time == 0 then
		time2 = baninterval
	else
		time2 = math.min( time / 60, baninterval )
	end
	bannername = "Console"
	if banner and banner:IsValid() and banner:IsPlayer() then
		bannername = banner:Nick()
	end
	
	local str = string.format( "kickid %s Banned for %d minutes by %s\n", ply:SteamID(), time2,  bannername) 
	game.ConsoleCommand( str )

	local str = string.format( "banid %f %s kick\n", time2, ply:SteamID() ) -- Convert time to minutes
	game.ConsoleCommand( str )

	return gManualBan( banner, ply:SteamID(), ply:Nick(), time, comment )
end

function gManualBan( banner, steamid, name, time, comment )
	if not steamid then
		error( "Bad arguments passed to ManualBan", 2 )
		return
	end

	Connect() -- Make sure we're connected

	local curuser = gDoQuery( "SELECT CURRENT_USER()" )
	curuser = curuser[ 1 ][ 1 ] -- Get to the info we want

	local curip = curuser:gsub( ".-@", "" ) or "127.0.0.1"
	if curip == "localhost" then 
		curip = "127.0.0.1" 
	end
	local curport = GetConVarNumber( "hostport" )

	steamid = steamid:upper():gsub( "STEAM_", "" )

	local bannername
	local bannersteam
	if banner and banner:IsValid() and banner:IsPlayer() then
		bannername = banner:Nick()
		bannersteam = banner:SteamID():upper():gsub( "STEAM_", "" )
	end
	
	local timestring = "0" -- ban duration part
	if time and time > 0 then
		timestring = "ADDTIME( NOW(), SEC_TO_TIME( " .. time .. " ) )"
	end
	
	local result
	result = gDoQuery( "INSERT INTO " .. table .. " ( steamid, name, unban_time, comment, serverip, serverport, adminname, adminsteamid ) VALUES( \"" ..
	   Escape( steamid ) .. "\", " .. Format( Escape( name ) ) .. ", " .. timestring .. ", " .. Format( Escape( comment ) ) .. ", INET_ATON( \"" .. curip .. "\" ), " .. curport .. ", " .. Format( Escape( bannername ) ) .. ", " .. Format( Escape( bannersteam ) ) .. " )" )
	
	if time == 0 then
		Bans[ steamid ] = baninterval
	else
		Bans[ steamid ] = time
	end

	Disconnect() -- Make sure we're disconnected

	return result
end

function gClearBan( steamid )
	steamid = steamid:upper():gsub( "STEAM_", "" )

	Connect() -- Make sure we're connected

	local results = gDoQuery( "UPDATE " .. table .. " SET unban_time=NOW(), comment=CONCAT( \"(ban lifted before expired) \", comment ) WHERE (NOW() < unban_time OR unban_time = 0) AND steamid=\"" .. Escape( steamid ) .. "\"", mysqloo.OPTION_NAMED_FIELDS ) -- Select active bans
	game.ConsoleCommand( "removeid STEAM_" .. steamid .. "\n" )
	
	Bans[ steamid ] = nil

	Disconnect() -- Make sure we're disconnected
end

function GetBans()
	Connect() -- Make sure we're connected

	local results = gDoQuery( "SELECT id, steamid, TIME_TO_SEC( TIMEDIFF( unban_time, NOW() ) ) as timeleft, name, time, unban_time, comment, INET_NTOA( serverip ) as serverip, serverport, adminname, adminsteamid FROM " .. table .. " WHERE NOW() < unban_time OR unban_time = 0", mysqloo.OPTION_NAMED_FIELDS ) -- Select active bans

	Disconnect() -- Make sure we're disconnected

	return results
end

function gDoBans()
	Connect()

	local results = gDoQuery( "SELECT steamid, TIME_TO_SEC( TIMEDIFF( unban_time, NOW() ) ) as timeleft FROM " .. table .. " WHERE NOW() < unban_time OR unban_time = 0", mysqloo.OPTION_NAMED_FIELDS ) -- Select active bans

	local steamids = {}

	for _, t in ipairs( results ) do
		local steamid = t.steamid

		local time = t.timeleft
		if not time or time == 0 then
			time = baninterval
		else
			time = math.min( time / 60, baninterval )
		end

		steamids[ steamid ] = math.max( time, steamids[ steamid ] or 0 ) -- We're doing this so oddly so we can catch multiple results and use the largest one.
	end

	-- We're using this following chunk of code to identify current steamids in the server
	local cursteamids = {}
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		cursteamids[ ply:SteamID() ] = ply
	end

	for steamid, time in pairs( steamids ) do -- loop through all currently banned ids
		if cursteamids[ "STEAM_" .. steamid ] then -- Currently connected
			local str = string.format( "kickid STEAM_%s Banned on global ban list\n", steamid )
			game.ConsoleCommand( str )
			Bans[ steamid ] = nil -- Clear their ban info to make sure they get banned. (A 'reban' should only ever arise if console removeid's a steamid)
		end

		if not Bans[ steamid ] or Bans[ steamid ] < time or Bans[ steamid ] > time + baninterval * 2 then -- If we don't already have them marked as banned or it's a new time
			local str = string.format( "banid %f STEAM_%s kick\n", time, steamid )
			game.ConsoleCommand( str )
			-- print( str ) -- For debug
		end
		Bans[ steamid ] = time
	end
	
	for steamid in pairs( Bans ) do -- loop through all recorded bans
		if not steamids[ steamid ] then -- If they're not on the ban list we just pulled off the server, they're out of jail!
			game.ConsoleCommand( "removeid STEAM_" .. steamid .. "\n" )
			Bans[ steamid ] = nil
		end
	end
	
	Disconnect()
end

gDoBans() -- Initial
timer.Create( "GBantimer", updatetime * 60, 0, gDoBans ) -- Updates