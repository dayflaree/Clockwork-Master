
function PrintToConsole( ply, message )

	if( ply:EntIndex() == 0 ) then
	
		Msg( message );
	
	else
	
		ply:PrintMessage( 2, message );
		
	end

end

--Searches for more than just name btw
function SearchPlayerName( name )

	name = name or "";

	local r = { }

	for k, v in pairs( player.GetAll() ) do
	
		if( string.find( v:RPNick(), name ) ) then
		
			table.insert( r, v );
		
		end
	
	end
	
	if( #r == 0 ) then
	
		for k, v in pairs( player.GetAll() ) do
		
			if( v:SteamID() == name ) then
			
				table.insert( r, v );
			
			end
		
		end
	
	end
	
	if( #r == 0 ) then
	
		for k, v in pairs( player.GetAll() ) do
			
			if( string.find( v:Nick(), name ) ) then
			
				table.insert( r, v );
			
			end
		
		end
	
	end
	
	if( #r == 1 ) then
	
		return true, r[1];
	
	elseif( #r == 0 ) then
	
		return false, "No player found with that name";
	
	else
	
		return false, "Multiple players found with that name";
	
	end

end

function SearchPlayerDesc( name )

	name = name or "";

	local r = { }

	for k, v in pairs( player.GetAll() ) do
	
		if( string.find( v:GetPlayerPhysDesc(), name ) ) then
		
			table.insert( r, v );
		
		end
	
	end
	
	if( #r == 1 ) then
	
		return true, r[1];
	
	elseif( #r == 0 ) then
	
		return false, "No player found with that desc";
	
	else
	
		return false, "Multiple players found with that desc";
	
	end

end

function LoadAdminFile()

	if( not file.Exists( "Epidemic/admins.txt" ) ) then return; end
	
	local data = util.KeyValuesToTable( file.Read( "Epidemic/admins.txt" ) );

	for id, flags in pairs( data ) do

		GM.ServerAdmins[string.gsub( id, "steam", "STEAM" )] = flags;
	
	end

end

GM.ScoreboardTitles = { }

function LoadScoreboardTitles()

	if( not file.Exists( "Epidemic/player_titles.txt" ) ) then return; end

	local data = util.KeyValuesToTable( file.Read( "Epidemic/player_titles.txt" ) );

	for id, info in pairs( data ) do

		local steamid = string.gsub( id, "steam", "STEAM" );
		local text = string.sub( info, 1, string.find( info, ":" ) - 1 );
		local color = string.sub( info, string.find( info, ":" ) + 1 );

		local arg = string.Explode( " ", color );
		
		local color = Vector( arg[1], arg[2], arg[3] );

		GM.ScoreboardTitles[string.gsub( id, "steam", "STEAM" )] = {
			
			SteamID = steamid,
			Text = text,
			Color = color,
		
		};
	
	end

end

GM.PlayerSpawnLimits = { }

function LoadPlayerSpawnLimits()

	if( not file.Exists( "Epidemic/player_spawnlimits.txt" ) ) then return; end

	local data = util.KeyValuesToTable( file.Read( "Epidemic/player_spawnlimits.txt" ) );

	for id, info in pairs( data ) do

		local steamid = string.gsub( id, "steam", "STEAM" );
		local arg = string.Explode( ":", info );
	 	
		local proplimit = tonumber( arg[1] ) or -1;
		local ragdolllimit = tonumber( arg[2] ) or -1;
	
		GM.PlayerSpawnLimits[string.gsub( id, "steam", "STEAM" )] = {
			
			PropLimit = proplimit,
			RagdollLimit = ragdolllimit,
		
		};
	
	end

end

require( "luaerror" );

function LuaError( e )
	
	if( file.Exists( "Epidemic/errors.txt" ) ) then
		
		file.Append( "Epidemic/errors.txt", "\n" .. e );
		
	else
		
		file.Write( "Epidemic/errors.txt", e );
		
	end
	
end
hook.Add( "LuaError", "LuaError", LuaError );