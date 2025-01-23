-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- player_data.lua
-- Handles player data and such.
-------------------------------

-- Define the table of player information.
LEMON.PlayerData = {  };

-- This is to be used only by the main player table.
LEMON.PlayerDataFields = {  };

-- This is to be used only by the characters table.
LEMON.CharacterDataFields = {  };

local meta = FindMetaTable( "Player" );

function LEMON.FormatCharString( ply )
	
	return ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" );
	
end

-- This formats a player's SteamID for things such as data file names
-- For example, STEAM_0:1:5947214 would turn into 015947214
function LEMON.FormatSteamID( SteamID )

	local SteamID = LEMON.NilFix(SteamID, "STEAM_0:0:0");

	s = string.gsub( SteamID,"STEAM","" );
	s = string.gsub( s,":","" );
	s = string.gsub( s,"_","" );
	
	return s;
	
end

-- When fieldtype is 1, it adds it to the player table.
-- When it is 2, it adds it to the character table.
function LEMON.AddDataField( fieldtype, fieldname, default )

	if( fieldtype == 1 ) then
	
		--LEMON.DayLog( "script.txt", "Adding player data field " .. fieldname .. " with default value of " .. tostring( default ) );
		LEMON.PlayerDataFields[ fieldname ] = LEMON.ReferenceFix(default);
	
	elseif( fieldtype == 2 ) then
	
		--LEMON.DayLog( "script.txt", "Adding character data field " .. fieldname .. " with default value of " .. tostring( default ) );
		LEMON.CharacterDataFields[ fieldname ] = LEMON.ReferenceFix(default);
		
	end
	
end

-- Load a player's data
function LEMON.LoadPlayerDataFile( ply )

	local SteamID = LEMON.FormatSteamID( ply:SteamID( ) );
	
	LEMON.PlayerData[ SteamID ]  = {  };
	
	if( file.Exists( "FalloutScript/PlayerData/" .. LEMON.ConVars[ "Schema" ] .. "/" .. LEMON.FormatSteamID( ply:SteamID() ) .. ".txt" ) ) then
	
		LEMON.CallHook( "LoadPlayerDataFile", ply );
		
		--LEMON.DayLog( "script.txt", "Loading player data file for " .. ply:SteamID( ) );
		
		-- Read the data from their data file
		local Data_Raw = file.Read( "FalloutScript/PlayerData/" .. LEMON.ConVars[ "Schema" ] .. "/" .. LEMON.FormatSteamID( ply:SteamID() ) .. ".txt" );
		
		-- Convert the data into a table
		local Data_Table = LEMON.NilFix(util.KeyValuesToTable( Data_Raw ), { });
		
		-- Insert the table into the data table
		LEMON.PlayerData[ SteamID ] = Data_Table;
		
		-- Retrieve the data table for easier access
		local PlayerTable = LEMON.PlayerData[ SteamID ];
		local CharTable = LEMON.PlayerData[ SteamID ][ "characters" ];

		-- If any values were loaded and they aren't in the DataFields table, delete them from the player.
		for _, v in pairs( PlayerTable ) do
			
			if( LEMON.PlayerDataFields[ _ ] == nil ) then
			
				--LEMON.DayLog( "script.txt", "Invalid player data field '" .. tostring( _ ) .. "' in " .. ply:SteamID( ) .. ", removing." );
				LEMON.PlayerData[ SteamID ][ _ ] = nil;
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for fieldname, default in pairs( LEMON.PlayerDataFields ) do
			
			if( PlayerTable[ fieldname ] == nil ) then
			
				--LEMON.DayLog( "script.txt", "Missing player data field '" .. tostring( fieldname ) .. "' in " .. ply:SteamID( ) .. ", inserting with default value of '" .. tostring(default) .. "'" );
				LEMON.PlayerData[ SteamID ][ fieldname ] = LEMON.ReferenceFix(default);
				
			end
			
		end
		
		-- If any values were loaded and they aren't in the DataFields table, delete them from the character.
		for _, char in pairs( CharTable ) do
		
			for k, v in pairs( char ) do
			
				if( LEMON.CharacterDataFields[ k ] == nil ) then
				
					--LEMON.DayLog( "script.txt", "Invalid character data field '" .. tostring( _ ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", removing." );
					LEMON.PlayerData[ SteamID ][ "characters" ][ _ ][ k ] = nil;
					
				end
				
			end
			
		end
		
		-- If any fields were not loaded and they are in the DataFields table, add them.
		for _, char in pairs( CharTable ) do
			
			for fieldname, default in pairs( LEMON.CharacterDataFields ) do
			
				if( char[ fieldname ] == nil ) then
				
					--LEMON.DayLog( "script.txt", "Missing character data field '" .. tostring( fieldname ) .. "' in character " .. ply:SteamID( ) .. "-" .. _ .. ", inserting with default value of '" .. tostring(default) .. "'" );
					LEMON.PlayerData[ SteamID ][ "characters" ][ _ ][ fieldname ] = LEMON.ReferenceFix(default);
					
				end
				
			end
			
		end
		
		LEMON.SavePlayerData(ply);
		
		LEMON.CallHook( "LoadedPlayerDataFile", ply, Data_Table );
		
	else
		
		-- Seems they don't have a player table. Let's create a default one for them.
		
		--LEMON.DayLog( "script.txt", "Creating new data file for " .. ply:SteamID( ) );
		
		LEMON.PlayerData[ SteamID ] = {  };
		
		-- Let's get the default fields and add them to the table.
		for fieldname, default in pairs( LEMON.PlayerDataFields ) do
			
			if( LEMON.PlayerData[ fieldname ] == nil ) then
			
				LEMON.PlayerData[ SteamID ][ fieldname ] = LEMON.ReferenceFix(default);
				
			end
			
		end
		
		-- We won't make a character, obviously. That is done later.
		
		LEMON.SavePlayerData(ply);
		
		-- Technically, we didn't load it, but the data is now there.
		LEMON.CallHook( "LoadedPlayerDataFile", ply, Data_Table );
		
	end
	
end

function LEMON.ResendCharData( ply ) -- Network all of the player's character data

	local SteamID = LEMON.FormatSteamID( ply:SteamID() );
	
	if( LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ] == nil ) then
		return;
	end

	for fieldname, data in pairs( LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ] ) do
		
		if( type( data ) != "table" ) then
			
			ply:SetNWString( fieldname, tostring( data ) );
			
		end

	end
	
end

function LEMON.SetPlayerField( ply, fieldname, data )

	local SteamID = LEMON.FormatSteamID( ply:SteamID() );
	
	-- Check to see if this is a valid field
	if( LEMON.PlayerDataFields[ fieldname ] ) then
	
		
		LEMON.PlayerData[ SteamID ][ fieldname ] = data;
		LEMON.SavePlayerData(ply);
		
	else
	
		return "";
		
	end
	
end
	
function LEMON.GetPlayerField( ply, fieldname )

	local SteamID = LEMON.FormatSteamID( ply:SteamID() );

	-- Check to see if this is a valid field
	if( LEMON.PlayerDataFields[ fieldname ] ) then
		
		return LEMON.NilFix(LEMON.PlayerData[ SteamID ][ fieldname ], "");
		
	else
	
		return "";
		
	end
	
end

function LEMON.SetCharField( ply, fieldname, data )

	local SteamID = LEMON.FormatSteamID( ply:SteamID() );

	if( LEMON.CharacterDataFields[ fieldname ] ) then
	
		LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = data;
		LEMON.SavePlayerData(ply);
		
	else
	
		return "";
		
	end
	
end
	
function LEMON.GetCharField( ply, fieldname )

	local SteamID = LEMON.FormatSteamID( ply:SteamID() )

	if( LEMON.CharacterDataFields[ fieldname ] ) then

	return LEMON.NilFix(LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ], "")

	else

	return ""

	end
	
end

function LEMON.SavePlayerData( ply )

	local keys = util.TableToKeyValues(LEMON.PlayerData[LEMON.FormatSteamID( ply:SteamID() )])
	file.Write( "FalloutScript/PlayerData/" .. LEMON.ConVars[ "Schema" ] .. "/" .. LEMON.FormatSteamID( ply:SteamID() ) .. ".txt" , keys)
	
end

