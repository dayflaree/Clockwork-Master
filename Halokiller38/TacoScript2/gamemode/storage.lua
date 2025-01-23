
local ContainerWrapper = { }

function TS.ItemToContainer( item )

	for k, v in pairs( ContainerWrapper ) do
	
		item[k] = ContainerWrapper[k];
	
	end
	
	local w = item.Width;
	local h = item.Height;

	if( item.InvWidth and item.InvHeight ) then
	
		w = item.InvWidth;
		h = item.InvHeight;
	
	end
	
	item.RecPlayers = { }
	item.InventoryGrid = { }

	for x = 0, w - 1 do
	
		item.InventoryGrid[x] = { }
	
		for y = 0, h - 1 do
		
			item.InventoryGrid[x][y] = { }
			item.InventoryGrid[x][y].Filled = false;
		
		end
		
	end
	
	return item;

end

function ContainerWrapper:CopyFromInventoryTable( invgrid )
	
	local w = self.Width;
	local h = self.Height;

	if( self.InvWidth and self.InvHeight ) then
	
		w = self.InvWidth;
		h = self.InvHeight;
	
	end
	
	local itemdata = self;
	
	for k = 0, h - 1 do

		for j = 0, w - 1 do
		
			if( invgrid[j] and invgrid[j][k] ) then
		
				self.InventoryGrid[j][k].Filled = invgrid[j][k].Filled;
				self.InventoryGrid[j][k].SX = invgrid[j][k].SX;
				self.InventoryGrid[j][k].SY = invgrid[j][k].SY;
				self.InventoryGrid[j][k].ItemData  = invgrid[j][k].ItemData;

			end

		end
	
	end

end

function ContainerWrapper:CopyFromPlayerInventory( ply, iid )
	
	if( type( iid ) == "string" ) then
	
		iid = ply:GetInventoryIndex( iid );
	
	end

	local itemdata = self;
	
	local w = self.Width;
	local h = self.Height;

	if( self.InvWidth and self.InvHeight ) then
	
		w = self.InvWidth;
		h = self.InvHeight;
	
	end
	
	for k = 0, h - 1 do

		for j = 0, w - 1 do
		
			self.InventoryGrid[j][k].Filled = ply.InventoryGrid[iid][j][k].Filled;
			self.InventoryGrid[j][k].SX = ply.InventoryGrid[iid][j][k].SX;
			self.InventoryGrid[j][k].SY = ply.InventoryGrid[iid][j][k].SY;
			self.InventoryGrid[j][k].ItemData  = ply.InventoryGrid[iid][j][k].ItemData;

		end
	
	end

end

function ContainerWrapper:HasItem( id )

	for i, v in pairs( self.InventoryGrid ) do
	
		for x, c in pairs( v ) do
		
			for y, u in pairs( c ) do
				
				if( self.InventoryGrid[x][y].ItemData ) then
				
					if( self.InventoryGrid[x][y].ItemData.ID == id ) then
						
						return true, x, y;
						
					end
			
				end
			
			end
		
		end
	
	end
	
	return false;

end

function ContainerWrapper:CanItemFitInInventory( id )

	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	local x, y = self:FindFreeSpaceInInventory( w, h );
	
	if( x ) then return true; end
	
	return false;

end

function ContainerWrapper:RemoveItemAt( x, y, ply )

	for k, v in pairs( self.InventoryGrid ) do
	
		for n, m in pairs( v ) do

			if( m.SX == x and m.SY == y ) then
		
				self.InventoryGrid[k][n].Filled = false;
				self.InventoryGrid[k][n].SX = -1;
				self.InventoryGrid[k][n].SY = -1;
				self.InventoryGrid[k][n].ItemData = nil;
				
			end
		
		end
	
	end
	
	local rec;
	
	if( self.ItemEntity and self.ItemEntity:IsValid() ) then
	
		rec = RecipientFilter();
		
		for k, v in pairs( self.RecPlayers ) do
		
			if( v and v:IsValid() and v:IsPlayer() ) then
				if( ( self.ItemEntity:GetPos() - v:GetPos() ):Length() > 90 ) then
					self.RecPlayers[k] = nil;
				else
					rec:AddPlayer( v );
				end
			end
			
		end
		
	end
	
	umsg.Start( "RSI", rec or ply );
		umsg.Short( x );
		umsg.Short( y );
	umsg.End();

end

function ContainerWrapper:GiveInventoryItem( id )

	local invtbl;

	if( type( id ) == "table" ) then

		invtbl = { }
	
		for k, v in pairs( id ) do
		
			invtbl[k] = v;
		
		end
		
		id = invtbl.ID;
	
	end

	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	local x, y = self:FindFreeSpaceInInventory( w, h );

	if( x ) then

		self:InsertIntoInventory( x, y, w, h );
		
		if( invtbl ) then
			self.InventoryGrid[x][y].ItemData = invtbl;
		else
			self.InventoryGrid[x][y].ItemData = TS.ItemsData[id];
		end
	
		local rec = RecipientFilter();
		
		local delay = 0;

		
		for k, v in pairs( self.RecPlayers ) do
		
			if( v and v:IsValid() and v:IsPlayer() ) then
				
				if( ( self.ItemEntity:GetPos() - v:GetPos() ):Length() > 90 ) then
					self.RecPlayers[k] = nil;
				else
					rec:AddPlayer( v );
					
					if( not v.ItemsDownloaded[id] ) then 
						v:SendItemData( id );
						delay = 1;
					end
					
				end
				
			end
			
		end

		local isi = function()

			umsg.Start( "ISI", rec );
				umsg.String( id );
				umsg.Short( x );
				umsg.Short( y );
			umsg.End();
		
		end
		timer.Simple( delay, isi );
		
		return true;
		
	end
	
	return false;

end

function ContainerWrapper:InsertIntoInventory( x, y, w, h )

	for k = 0, h - 1 do

		for j = 0, w - 1 do
		
			if( self.InventoryGrid[x + j] and self.InventoryGrid[x + j][y + k] ) then
				self.InventoryGrid[x + j][y + k].Filled = true;
				self.InventoryGrid[x + j][y + k].SX = x;
				self.InventoryGrid[x + j][y + k].SY = y;
			end
			
		end
	
	end

end


function ContainerWrapper:CanFitInInventory( x, y, w, h )

	local iw = self.Width;
	local ih = self.Height;

	if( self.InvWidth and self.InvHeight ) then
	
		iw = self.InvWidth;
		ih = self.InvHeight;
	
	end

	for k = 0, h - 1 do
	
		for j = 0, w - 1 do
		
			if( x + j >= iw or
				y + k >= ih ) then
				
				return false;
				
			end
		
			if( not self.InventoryGrid[x + j] or
				not self.InventoryGrid[x + j][y + k] ) then
				
				return false;
				
			end
		
			if( self.InventoryGrid[x + j][y + k].Filled ) then
			
				return false;
			
			end
		
		end
	
	end
	
	return true;

end

function ContainerWrapper:FindFreeSpaceInInventory( w, h )

	local iw = self.Width;
	local ih = self.Height;

	if( self.InvWidth and self.InvHeight ) then
	
		iw = self.InvWidth;
		ih = self.InvHeight;
	
	end
	

	for y = 0, ih - 1 do
	
		for x = 0, iw - 1 do

			if( self.InventoryGrid[x] and self.InventoryGrid[x][y] and ( not self.InventoryGrid[x][y].Filled and self:CanFitInInventory( x, y, w, h ) ) ) then
				
				return x, y;
			
			end
		
		end
	
	end
	
	return false;

end