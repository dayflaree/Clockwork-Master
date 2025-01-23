
TS.MapProperties = { }
TS.MapDoors = { }
TS.PropertyCount = 0;

TS.MapEditors = { }

function TS.LoadMapData()

	local dir = "TS2/mapdata/" .. game.GetMap() .. ".txt";
	
	if( file.Exists( dir ) ) then
	
		local data = file.Read( dir );
		
		data = string.gsub( data, "\r", "" );
		data = string.gsub( data, "\n", "" );
		
		local args = string.Explode( ";", data );
		
		for n = 1, #args do
		
			if( string.find( args[n], "PROPERTY " ) ) then
			
				local propertyname = string.sub( args[n], 10 );
				local propertyid = tonumber( args[n + 1] ); 
			
				table.insert( TS.MapProperties, { Name = propertyname, id = propertyid } );
				
				TS.PropertyCount = TS.PropertyCount + 1;
				
				n = n + 1;
			
			elseif( string.find( args[n], "DOOR " ) ) then
			
				local coords = string.Explode( ",", string.sub( args[n], 6 ) );
				local x = coords[1];
				local y = coords[2];
				local z = coords[3];
				
				local name = args[n + 1];
				local price = tonumber( args[n + 2] );
				local flags = args[n + 3];
				local propertyfamily = args[n + 4];
				local w = tonumber( args[n + 5] );
				local h = tonumber( args[n + 6] );
				
				local tbl = ents.FindInSphere( Vector( x, y, z ), 1 );
				
				for k, v in pairs( tbl ) do
				
					if( v:IsDoor() ) then
						
						if( string.find( flags, "s" ) ) then
						
							v:Fire( "close", "", 0 );
							v:Fire( "lock", "", 0 );
						
						end
						
						if( string.find( flags, "l" ) ) then
						
							v:Fire( "lock", "", 0 );
						
						end
						
						v.DoorName = name;
						v.DoorPrice = price;
						v.DoorFlags = flags;
						v.PropertyFamily = propertyfamily;
						v.PropertyParent = "";
						v.PropertyChild = "";
						if( string.find( propertyfamily, ":" ) ) then
						
							v.PropertyParent = tonumber( string.sub( propertyfamily, 1, string.find( propertyfamily, ":" ) - 1 ) );
							v.PropertyChild = tonumber( string.sub( propertyfamily, string.find( propertyfamily, ":" ) + 1 ) );
							
						end
						v.StorageWidth = w;
						v.StorageHeight = h;
						v.OwnerSteamIDs = { }
						v.OwnerLevels = { }
						table.insert( TS.MapDoors, { Door = v, Name = name, Price = price, Flags = flags, PropertyFamily = propertyfamily, PropertyParent = v.PropertyParent, PropertyChild = v.PropertyChild, StorageWidth = w, StorageHeight = h } );
					
					end
				
				end
				
				n = n + 6;
				
			end
		
		end
	
	end
	
	for k, v in pairs( TS.MapDoors ) do
	
		TS.BindPropertyAndDoor( v.Door );
		TS.BindContainerAndDoor( v.Door );
	
	end

end

function TS.BindContainerAndDoor( doorent )

	if( doorent.DoorFlags and string.find( doorent.DoorFlags, "s" ) ) then

		doorent.ItemData = { }
		doorent.ItemData.Name = doorent.DoorName;
		doorent.ItemData.Width = doorent.StorageWidth;
		doorent.ItemData.Height = doorent.StorageHeight;
		doorent.ItemData.ItemEntity = doorent;
		doorent.ItemData = TS.ItemToContainer( doorent.ItemData );

	end

end

function TS.BindPropertyAndDoor( doorent )

	if( doorent.PropertyFamily and string.find( doorent.PropertyFamily, ":" ) ) then
	
		local parent = tonumber( string.sub( doorent.PropertyFamily, 1, string.find( doorent.PropertyFamily, ":" ) - 1 ) );
	
		if( parent ) then
		
			for k, v in pairs( TS.MapProperties ) do
			
				if( parent == v.id ) then
				
					doorent.PropertyName = v.Name;
					break;
				
				end
			
			end
		
		end
	
	end

end

function ccSetDoorSettings( ply, cmd, arg )

	if( #arg < 7 ) then
		return;
	end
	
	local ent = tonumber( arg[1] );
	local name = arg[2];
	local price = tonumber( arg[3] );
	local flags = arg[4];
	local family = arg[5];
	local w = tonumber( arg[6] );
	local h = tonumber( arg[7] );

	local doorent = ents.GetByIndex( ent );
	
	doorent.DoorName = name;
	doorent.DoorPrice = price;
	doorent.DoorFlags = flags;
	doorent.PropertyFamily = family;
	doorent.StorageWidth = w;
	doorent.StorageHeight = h;
	
	if( not table.HasValueWithField( TS.MapDoors, "Door", doorent ) ) then
		table.insert( TS.MapDoors, { Door = doorent, Name = name, Price = price, Flags = flags, PropertyFamily = family, StorageWidth = w, StorageHeight = h } );
	end
	

	local rec = RecipientFilter();
	
	for k, v in pairs( TS.MapEditors ) do
	
		rec:AddPlayer( v );
	
	end
	
	umsg.Start( "MEUD", rec );
		umsg.Entity( doorent );
		umsg.String( doorent.DoorName or "" );
		umsg.Short( doorent.DoorPrice or 0 );
		umsg.String( doorent.DoorFlags or "" );
		umsg.String( doorent.PropertyFamily or "" );
		umsg.Short( doorent.StorageWidth or 0 );
		umsg.Short( doorent.StorageHeight or 0 );
	umsg.End();
	
	for k, v in pairs( TS.MapDoors ) do
	
		if( v.Door == doorent ) then
		
			v.Name = doorent.DoorName;
			v.Price = doorent.DoorPrice;
			v.Flags = doorent.DoorFlags;
			v.PropertyFamily = doorent.PropertyFamily;
			v.StorageWidth = doorent.StorageWidth;
			v.StorageHeight = doorent.StorageHeight;
			v.Unlocked = false;
		
		end
	
	end
	
	TS.BindPropertyAndDoor( doorent );
	TS.BindContainerAndDoor( doorent );
	
end
concommand.Add( "rpa_me_setdoorsettings", ccSetDoorSettings );

function ccMapEditor( ply )

	if( ply:IsRick() or ply:SteamID() == "STEAM_0:0:36262603" ) then

		if( not ply:HasWeapon( "ts2_mapeditor" ) ) then
			ply:Give( "ts2_mapeditor" );
		end

		umsg.Start( "MEM", ply );
		umsg.End();
		
		local d = 0;
	
		for k, v in pairs( TS.MapProperties ) do
	
			local delay = function()
				umsg.Start( "MEAP", ply );
					umsg.Short( v.id );
					umsg.String( v.Name );
				umsg.End();
			end
			timer.Simple( d, delay );
			
			d = d + .2;
	
		end
	
		if( not table.HasValue( TS.MapEditors, ply ) ) then
			table.insert( TS.MapEditors, ply );
		end

	end
		
end
concommand.Add( "rpa_mapeditor", ccMapEditor );

function ccMEAddProperty( ply, cmd, arg )

	local rec = RecipientFilter();
	
	for k, v in pairs( TS.MapEditors ) do
	
		rec:AddPlayer( v );
	
	end

	umsg.Start( "MEAP", rec );
		umsg.Short( TS.PropertyCount );
		umsg.String( arg[1] );
	umsg.End();
	
	table.insert( TS.MapProperties, { Name = arg[1], id = TS.PropertyCount } );

	TS.PropertyCount = TS.PropertyCount + 1;

end
concommand.Add( "rpa_me_newproperty", ccMEAddProperty );

function ccMESaveMap( ply, cmd, arg )

	local dir = "TS2/mapdata/" .. game.GetMap() .. ".txt";

	local str = "";

	for k, v in pairs( TS.MapProperties ) do
	
		str = str .. "PROPERTY " .. v.Name .. ";" .. v.id .. ";\n";
	
	end

	for k, v in pairs( TS.MapDoors ) do
	
		local pos = v.Door:GetPos();
	
		str = str .. "DOOR " .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";" .. v.Name .. ";" .. v.Price .. ";" .. v.Flags .. ";" .. v.PropertyFamily .. ";" .. ( v.StorageWidth or 0 ) .. ";" .. ( v.StorageHeight or 0 ) .. ";\n";
	
	end

	file.Write( dir, str );

end
concommand.Add( "rpa_me_savemap", ccMESaveMap );
