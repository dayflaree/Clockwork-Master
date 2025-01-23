
ChatCommands = { }

function ChatCommand( cmd, func )

	table.insert( ChatCommands, { cmd = cmd, cb = func } );

end

function PlayerSay( ply, text )

	if( CurTime() - ply:GetTable().LastSayCommand < .4 ) then
		return "";
	end

	ply:GetTable().LastSayCommand = CurTime();

	local correctcmd = nil;
	local crntlen;
	
	for k, v in pairs( ChatCommands ) do
	
		local len = string.len( v.cmd );
		local chatsub = string.sub( text, 1, len );
		
		if( string.lower( chatsub ) == string.lower( v.cmd ) ) then
		
			if( correctcmd ) then
			
				if( crntlen < len ) then
				
					correctcmd = k;
					crntlen = len;
				
				end
			
			else
			
				correctcmd = k;
				crntlen = len;
		
			end
		
		end
	
	end

	if( correctcmd ) then
	
		local ret = ( ChatCommands[correctcmd].cb( ply, ChatCommands[correctcmd].cmd, string.sub( text, crntlen + 1 ) ) or "" );	
	
		if( ret ~= "" and ret ~= " " ) then
		
			ply:SayGlobalChat( ret );
			
		end
		
		return ret;
	
	elseif( string.sub( text, 1, 1 ) == "/" ) then
	
		return "";
	
	end
	
	ply:SayGlobalChat( text );
	
	return text;

end
hook.Add( "PlayerSay", "GearPlayerSay", PlayerSay );

local meta = FindMetaTable( "Player" );

function meta:SayGlobalChat( text )

 	umsg.Start( "GC" );
		umsg.Entity( self );
		umsg.String( text );
	umsg.End();

end

