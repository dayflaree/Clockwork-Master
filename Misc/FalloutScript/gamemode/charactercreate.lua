-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- charactercreate.lua
-- Contains the character creation concommands.
-------------------------------	
	
-- Set Model
function ccSetModel( ply, cmd, args )

	local mdl = args[ 1 ];
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
			
		if( table.HasValue( LEMON.ValidModels, string.lower( mdl ) ) ) then
			
			LEMON.CallHook( "CharacterCreation_SetModel", ply, mdl );
			LEMON.SetCharField(ply, "model", mdl );

		else
		
			LEMON.CallHook( "CharacterCreation_SetModel", ply, "models/player/group01/male_01.mdl" );
			LEMON.SetCharField(ply, "model", "models/player/group01/male_01.mdl" );
			
		end

	end
	
	return;
end
concommand.Add( "rp_setmodel", ccSetModel );

-- Start Creation
function ccStartCreate( ply, cmd, args )
	
	local PlyCharTable = LEMON.PlayerData[ LEMON.FormatSteamID( ply:SteamID() ) ][ "characters" ]
	
	-- Find the highest Unique ID
	local high = 0;
	
	for k, v in pairs( PlyCharTable ) do
	
		k = tonumber( k );
		high = tonumber( high );
		
		if( k > high ) then 
		
			high = k;
			
		end
		
	end
	
	high = high + 1;
	ply:SetNWString( "uid", tostring(high) );
	
	ply:SetNWInt( "charactercreate", 1 );
	LEMON.PlayerData[ LEMON.FormatSteamID( ply:SteamID() ) ][ "characters" ][ tostring(high) ] = {  }
	
	LEMON.CallHook( "CharacterCreation_Start", ply );
	
end
concommand.Add( "rp_startcreate", ccStartCreate );

-- Finish Creation
function ccFinishCreate( ply, cmd, args )

	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		
		ply:SetNWInt( "charactercreate", 0 )
		
		local SteamID = LEMON.FormatSteamID( ply:SteamID() );
		
		for fieldname, default in pairs( LEMON.CharacterDataFields ) do
		
			if( LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] == nil) then

				LEMON.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = LEMON.ReferenceFix(default);
		
			end
			
		end
		
		LEMON.ResendCharData( ply );

		ply:RefreshInventory( )
		ply:RefreshBusiness( )
		
		ply:SetTeam( 1 );
		
		ply:Spawn( );
		
		ply:ConCommand( "fadein" );
		
		LEMON.CallHook( "CharacterCreation_Finished", ply, ply:GetNWString( "uid" ) );
		
	end
	
end
concommand.Add( "rp_finishcreate", ccFinishCreate );

function ccSelectChar( ply, cmd, args )

	local uid = args[ 1 ];
	local SteamID = LEMON.FormatSteamID(ply:SteamID());
	
	if( LEMON.PlayerData[ SteamID ][ "characters" ][ uid ] != nil ) then
	
		ply:SetNWString( "uid", uid );
		LEMON.ResendCharData( ply );
		
		ply:SetNWInt( "charactercreate", 0 );
	
		ply:SetTeam( 1 );
		LEMON.CallHook( "CharacterSelect_PostSetTeam", ply, LEMON.PlayerData[ SteamID ][ "characters" ][ uid ] );
		
		ply:RefreshInventory( )
		ply:RefreshBusiness( )
		
		ply:ConCommand( "fadein" );
		
		ply:Spawn( );
		
		--LEMON.CallHook( "CharacterCreation_Finished", ply, ply:GetNWString( "uid" ) );
		LEMON.CallHook( "CharacterSelected", ply, LEMON.PlayerData[ SteamID ][ "characters" ][ uid ] );
		
	else
	
		return;
		
	end

end
concommand.Add( "rp_selectchar", ccSelectChar );

function ccReady( ply, cmd, args )

	if( ply.Ready == false ) then

		ply.Ready = true;
	
		-- Find the highest Unique ID and set it - just in case they want to create a character.
		local high = 0;
		
		local PlyCharTable = LEMON.PlayerData[ LEMON.FormatSteamID( ply:SteamID() ) ]["characters"];
		
		for k, v in pairs( PlyCharTable ) do
		
			k = tonumber( k );
			high = tonumber( high );
			
			if( k > high ) then 
			
				high = k;
				
			end
			
		end
		
		high = high + 1;
		ply:SetNWString( "uid", tostring(high) );
		
		for k, v in pairs( PlyCharTable ) do -- Send them all their characters for selection

			umsg.Start( "ReceiveChar", ply );
				umsg.Long( tonumber(k) );
				umsg.String( v[ "name" ] );
				umsg.String( v[ "model" ] );
			umsg.End( );

		end

		ply:SetNWInt( "charactercreate", 1 )
		
		umsg.Start( "charactercreate", ply );
		umsg.End( );
		
		LEMON.CallHook( "PlayerReady", ply );
		
	end
	
end
concommand.Add( "rp_ready", ccReady );