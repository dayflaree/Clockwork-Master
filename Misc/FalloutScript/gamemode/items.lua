LEMON.ItemData = {  };

function LEMON.LoadItem( schema, filename )

	local path = "schemas/" .. schema .. "/items/" .. filename;
	
	ITEM = {  };
	
	include( path );
	
	LEMON.ItemData[ ITEM.Class ] = ITEM;
	
end

function LEMON.CreateItem( class, pos, ang )

	if( LEMON.ItemData[ class ] == nil ) then return; end
	
	local itemtable = LEMON.ItemData[ class ];
	
	local item = ents.Create( "item_prop" );

	item:SetModel( itemtable.Model );
	item:SetAngles( ang );
	item:SetPos( pos );
	
	--print( class )
	-- if class == "drink_dirtywater" or "drink_randomwater" then
		-- item:SetName( "ritem1" )
	-- end
	if class == "drink_nukacola" then
		item:SetName( "ritem2" )
	elseif class == "drink_dirtywater" then
		item:SetName( "ritem2" )
	elseif class == "drink_randomwater" then
		item:SetName( "ritem2" )
	elseif class == "drink_quantum_nukacola" then
		item:SetName( "ritem2" )
	end
	
	if class == "drink_quantum_nukacola" then
		item:SetNWInt( "glowyitem", 1 )
	end

	-- print( item:GetName() )
	for k, v in pairs( itemtable ) do
		item[ k ] = v;
		if( type( v ) == "string" ) then
			item:SetNWString( k, v );
		end
	end
	
	item:Spawn( );
	item:Activate( );
	
end


function ccCreateItem( ply, cmd, args )

	if( ply:IsAdmin( ) or ply:IsSuperAdmin( ) ) then
	
		-- Drop the item 80 units infront of him.
		LEMON.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
		
	end
	
end
concommand.Add( "rp_createitem", ccCreateItem );

function LEMON.CreateMapItem( class, pos, ang, vel )


	
	if( LEMON.ItemData[ class ] == nil ) then return; end
	
	local itemtable = LEMON.ItemData[ class ];
	
	local item = ents.Create( "item_prop" );
	
	item:SetModel( itemtable.Model );
	item:SetAngles( ang );
	item:SetPos( pos );
	
	if( vel ) then
	item:SetVelocity( vel )
	end
	
	for k, v in pairs( itemtable ) do
		item[ k ] = v;
		if( type( v ) == "string" ) then
			item:SetNWString( k, v );
		end
	end
	
	item:Spawn( );
	item:Activate( );
		

	
end

function ccDropItem( ply, cmd, args )

	local inv = LEMON.GetCharField( ply, "inventory" );
	for k, v in pairs( inv ) do
		if( v == args[ 1 ] ) then
			LEMON.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
			ply:TakeItem( args[ 1 ] );
			return;
		end
	end
	
end
concommand.Add( "rp_dropitem", ccDropItem );

UnusableItems = { "item_ziptie" }

function ccUseInv( ply, cmd, args )

	local inv = LEMON.GetCharField( ply, "inventory" );
	for k, v in pairs( inv ) do
		if( v == args[ 1 ] ) then
	
		if(table.HasValue(UnusableItems, args[ 1 ])) then 
			LEMON.SendChat( ply, "This item cannot be used." );
			return; 
		end
	
    local itemtable = LEMON.ItemData[ args[ 1 ] ];
	
	local item = ents.Create( "item_prop" );
	item:SetModel( itemtable.Model );
	item:SetAngles( Vector( 0, 0, 0 ) );
	item:SetPos( Vector( 0, 0, 0 ) );
	item:SetColor( Color( 0, 0, 0, 0 ) );

	for k, v in pairs( itemtable ) do
		item[ k ] = v;
		if( type( v ) == "string" ) then
			item:SetNWString( k, v );
		end
	end

	item:Spawn( );
	item:Activate( );
	item:UseItem( ply );
	ply:TakeItem( args[ 1 ] );
	return;
		end
	end
	
end
concommand.Add( "rp_useinvitem", ccUseInv );

function ccBuyItem( ply, cmd, args )
	
	if( LEMON.ItemData[ args[ 1 ] ] != nil ) then
	
		if( LEMON.Teams[ ply:Team( ) ][ "business" ] ) then
		
			if( table.HasValue(LEMON.Teams[ ply:Team( ) ][ "item_groups" ], LEMON.ItemData[ args[ 1 ] ].ItemGroup)) then
			
				if( LEMON.ItemData[ args[ 1 ] ].Purchaseable and tonumber(LEMON.GetCharField(ply, "money" )) >= LEMON.ItemData[ args[ 1 ] ].Price ) then
				
					ply:ChangeMoney( 0 - LEMON.ItemData[ args[ 1 ] ].Price );
					LEMON.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) );
				
				else
				
					LEMON.SendChat( ply, "You do not have enough money to purchase this item!" );
				
				end
				
			else
			
			LEMON.SendChat( ply, "You cannot purchase this item!" );
			
			end
			
		else
		
			LEMON.SendChat( ply, "You do not have access to Business!" );
		
		end
	end
end

concommand.Add( "rp_buyitem", ccBuyItem );

function ccSellItem( ply, cmd, args )

	local inv = LEMON.GetCharField( ply, "inventory" );
	for k, v in pairs( inv ) do
		if( v == args[ 1 ] ) then
			if( LEMON.Teams[ ply:Team( ) ][ "business" ] ) then -- are you from business
				if( LEMON.ItemData[ args[ 1 ] ].Purchaseable ) then -- only sell stuff that already purchasable
					local sellprice = math.ceil(LEMON.ItemData[ args[ 1 ] ].Price / 2)
					ply:ChangeMoney( sellprice );
					ply:TakeItem( args[ 1 ] );
					
					LEMON.SendChat( ply, "Item sold for $" .. sellprice .. " dollars.");
					
					return;
					
				else
					
					LEMON.SendChat( ply, "You cannot sell this item!" );
					
				end
				
			else
				
				LEMON.SendChat( ply, "You do not have access to Business!" );
				
			end
			
		else
			
			LEMON.SendChat( ply, "You cannot sell this item!" );
			
			
		end
	end
end

concommand.Add( "rp_sellitem", ccSellItem );