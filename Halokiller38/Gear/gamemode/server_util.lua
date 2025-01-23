

function PostGamemodeLoad()

	CreatePlayersMetaTable();
	
	Players:BaseInitialize();
	
	if( InitializedOnce ) then

		Players:Initialize();
		
	end
	
	game.ConsoleCommand( "exec banned_user.cfg" );
	game.ConsoleCommand( "exec banned_ip.cfg" );
	
end

function IncludeResourcesInFolder( dir, keyword )

	local files = file.FindInLua( ( GAMEMODE.Folder or "" ) .. "/content/" .. dir .. "*" );
	
	for k, v in pairs( files ) do

		if( string.find( v, "vmt" ) or string.find( v, "vtf" ) or string.find( v, "mdl" ) ) then
		
			if( keyword ) then
			
				if( string.find( v, keyword ) ) then
				
					resource.AddFile( dir .. v );
				
				end
			
			else
		
				resource.AddFile( dir .. v );
				
			end
		
		end
	
	end

end

function CreateTableCopy( tbl )

	local newtbl = { }

	for k, v in pairs( tbl ) do
	
		newtbl[k] = v;
	
	end
	
	return newtbl;

end

function string.split2( str, size )

	local len = string.len( str );
	local passes = math.ceil( len / size );
	local start = 1;
	local ret = { }
	local count = 0;
	
	for n = 1, passes do
	
		local piece = string.sub( str, start, size * n );
		table.insert( ret, piece );
		start = start + size;
		
		count = count + 1;
	
	end

	return ret, count;
	
end
