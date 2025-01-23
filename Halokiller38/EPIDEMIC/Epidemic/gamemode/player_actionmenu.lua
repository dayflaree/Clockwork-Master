
local meta = FindMetaTable( "Player" );

function meta:NewActionMenu( ent )

	self:GetTable().ActionMenu =
	{
	
		Entity = ent,
		Options = { },
	
	}

end

function meta:ActionMenuCategory( title )

	table.insert( self:GetTable().ActionMenu.Options, { Text = title, Cmd = "nil" } );

end

function meta:ActionMenuOption( text, cmd )

	table.insert( self:GetTable().ActionMenu.Options, { Text = text, Cmd = cmd or "" } );

end

function meta:ActionMenuSend()

	local count = #self:GetTable().ActionMenu.Options;

	umsg.Start( "CAM", self );
		umsg.Entity( self:GetTable().ActionMenu.Entity );
		umsg.Short( count );
	umsg.End();
	
	local itercount = math.ceil( count / 4 );
	
	for n = 1, itercount do
	
		local function d()
			
			if( self:GetTable().ActionMenu ) then
				
				umsg.Start( "AAMC", self );
				
					for k = 1, 4 do
						
						local v = self:GetTable().ActionMenu.Options[k + ( n - 1 ) * 4];
							
						if( v ) then
							
							umsg.PoolString( v.Text );
							umsg.PoolString( v.Cmd );
							umsg.String( v.Text );
							umsg.String( v.Cmd );
							
						end
						
					end
					
				umsg.End();	
				
			end
			
		end
		
		timer.Simple( n * .2, d );

	end

end

