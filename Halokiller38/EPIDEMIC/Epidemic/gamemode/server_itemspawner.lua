
ItemSpawnPoints = { }
ITEMSPAWN_ENABLED = false;

function SaveItemSpawnerState()
	
	file.Write( "Epidemic/itemspawnstate.txt", tostring( ITEMSPAWN_ENABLED ) );
	
end

function LoadItemSpawnerState()
	
	if( file.Exists( "Epidemic/itemspawnstate.txt" ) ) then
		
		local dat = file.Read( "Epidemic/itemspawnstate.txt" );
		if( dat == "false" ) then
			ITEMSPAWN_ENABLED = false;
		elseif( dat == "true" ) then
			ITEMSPAWN_ENABLED = true;
		end
		
	end
	
end

function LoadItemSpawnerMap()

	local dir = "Epidemic/mapdata/" .. GetMap() .. ".txt";
	
	if( not file.Exists( dir ) ) then return; end
	
	local data = string.gsub( file.Read( dir ), "\n", " " );
	data = string.Explode( " ", data );

	for k, v in pairs( data ) do

		if( v == "NEW" ) then
		
			local x, y, z;
		
			x = data[k + 1];
			y = data[k + 2];
			z = data[k + 3];
			table.insert( ItemSpawnPoints,
			{
			
				x = tonumber( x ),
				y = tonumber( y ), 
				z = tonumber( z ),
				nextinterval = 0,
			
			} );
			
			k = k + 3;
		
		end
	
	end

end

function HandleItemSpawning( id )

	local data = ItemSpawnPoints[id];
	
	ItemSpawnPoints[id].nextinterval = CurTime() + math.random( 2700, 4500 );
	--ItemSpawnPoints[id].nextinterval = CurTime() + math.random( 5, 10 );
	
	if( data.Entity and data.Entity:IsValid() ) then return; end
	
	local vec = Vector( data.x, data.y, data.z );

	for k, v in pairs( player.GetAll() ) do
		
		if( v:VisibleVec( vec ) ) then
		
			return;
		
		end
	
	end
	
	local chance = math.random( 1, 64 );
	local tier = 0;
	
	if( chance == 1 ) then
		
		tier = 4;
	
	elseif( chance <= 3 ) then
		
		tier = 3;
	
	elseif( chance <= 10 ) then
		
		tier = 2;
	
	elseif( chance <= 24 ) then
		
		tier = 1;
		
	end
	
	if( tier > 0 ) then
		
		local tabPoss = { };
		
		for k, v in pairs( ItemsData ) do
			
			if( v.Tier == tier ) then
				
				table.insert( tabPoss, k );
				
			end
			
		end
		
		local item = CreateItemProp( table.Random( tabPoss ) );
		
		item:SetPos( vec );
		item:SetAngles( Angle( 0, 0, 0 ) );
		
		item:Spawn();
		
		ItemSpawnPoints[id].Entity = item;
		
	end

end

function StreamItemSpawnPoints()
	
	for _, v in pairs( ItemSpawnPoints ) do
		
		umsg.Start( "GetItemSpawnPoint" );
		umsg.Vector( Vector( v.x, v.y, v.z ) );
		umsg.End();
		
	end
	
end
