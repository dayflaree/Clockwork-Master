function GM:SetupDataDirectories()
	
	file.CreateDir( "Infected" );
	file.CreateDir( "Infected/nodes" );
	file.CreateDir( "Infected/logs" );
	file.CreateDir( "Infected/logs/" .. os.date( "%y-%m-%d" ) );
	
	if( !file.Exists( "infected/spawns.txt", "DATA" ) ) then
	
		file.Write( "infected/spawns.txt", "[]" );
		
	end
	
end

function GM:Log( filename, prefix, str, ply )
	
	local f = "Infected/logs/" .. os.date( "%y-%m-%d" ) .. "/" .. filename .. ".txt";
	local write = os.date( "%m-%H-%S" ) .. "\t[" .. prefix .. "]\t" .. str;
	
	if( ply and ply:IsValid() ) then
		
		write = os.date( "%m-%H-%S" ) .. " " .. ply:SteamID() .. " [" .. prefix .. "] " .. str;
		
	end
	
	if( file.Exists( f, "DATA" ) ) then
		
		file.Append( f, "\n" .. write );
		
	else
		
		file.Write( f, write );
		
	end
	
	for _,ply in pairs( player.GetAll() ) do
	
		if ( ply:IsAdmin() ) then
		
			net.Start( "nPrintConsole" );
				net.WriteString( write );
			net.Send( ply );
		
		end
	
	end
	
end