
local meta = FindMetaTable( "Player" );

function meta:HasWeaponOnlyFrom( id, iid )

	if( self:HasItemInInventory( id, iid ) ) then
	
		return !self:HasItemElsewhere( id, iid );
	
	end
	
	return false;

end

function meta:HasItemElsewhere( id, iid )

	for i, v in pairs( self.InventoryGrid ) do
	
		if( iid ~= i ) then
	
			for x, c in pairs( v ) do
			
				for y, u in pairs( c ) do
					
					if( self.InventoryGrid[i][x][y].ItemData ) then
					
						if( self.InventoryGrid[i][x][y].ItemData.ID == id ) then
							
							return true, i, x, y;
							
						end
				
					end
				
				end
			
			end
			
		end
	
	end
	
	return false;

end

function meta:HasItemInInventory( id, iid )

	for x, c in pairs( self.InventoryGrid[iid] ) do
		
		for y, u in pairs( c ) do
			
			if( self.InventoryGrid[iid][x][y].ItemData ) then
			
				if( self.InventoryGrid[iid][x][y].ItemData.ID == id ) then
					
					return true, x, y;
					
				end
		
			end
		
		end
	
	end
	

	return false;

end

function meta:HasMultipleCopiesOfItem( id )

	local count = 0;

	for i, v in pairs( self.InventoryGrid ) do
	
		for x, c in pairs( v ) do
		
			for y, u in pairs( c ) do
				
				if( self.InventoryGrid[i][x][y].ItemData ) then
				
					if( self.InventoryGrid[i][x][y].ItemData.ID == id ) then
						
						count = count + 1;
						
					end
			
				end
			
			end
		
		end
	
	end
	
	if( count > 1 ) then
		return true;
	end
	
	return false;

end

function meta:HasItem( id )

	if( not self.InventoryGrid ) then return; end

	for i, v in pairs( self.InventoryGrid ) do
	
		for x, c in pairs( v ) do
		
			for y, u in pairs( c ) do
				
				if( self.InventoryGrid[i][x][y].ItemData ) then
				
					if( self.InventoryGrid[i][x][y].ItemData.ID == id ) then
						
						return true, i, x, y;
						
					end
			
				end
			
			end
		
		end
	
	end
	
	return false;

end

function meta:TakeAllInventoryWeapons()

	if( not self.InventoryGrid ) then return; end

	for i, v in pairs( self.InventoryGrid ) do
	
		for x, c in pairs( v ) do
		
			for y, u in pairs( c ) do
				
				if( self.InventoryGrid[i][x][y].ItemData ) then
				
					if( string.find( self.InventoryGrid[i][x][y].ItemData.ID, "ts2_" ) and
						self.InventoryGrid[i][x][y].ItemData.ID ~= "ts2_hands" ) then
						
						self:StripWeapon( self.InventoryGrid[i][x][y].ItemData.ID );
						self:TakeItemAt( i, x, y );
						
					end
			
				end
			
			end
		
		end
	
	end

end

function meta:DropItemProp( id )

	local trace = { }
	
	if( self:Crouching() ) then
		trace.start = self:EyePos();
	else
		trace.start = self:EyePos() - Vector( 0, 0, 30 );
	end
	trace.endpos = trace.start + self:GetAngles():Forward() * 40;
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	return TS.CreateItemProp( id, tr.HitPos );

end

function meta:HasContainer( name )

	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name == name ) then
	
			return true;
			
		end
		
	end	
	
	return false;

end

function meta:CopyFromInventoryTable( iid, invgrid )

	if( type( iid ) == "string" ) then
	
		iid = self:GetInventoryIndex( iid );
	
	end
	
	local delay = 0;

	for k = 0, self.Inventories[iid].Height - 1 do
	
		for j = 0, self.Inventories[iid].Width - 1 do

			if( invgrid[j] and invgrid[j][k] ) then

				self.InventoryGrid[iid][j][k].Filled = invgrid[j][k].Filled;
				self.InventoryGrid[iid][j][k].SX = invgrid[j][k].SX;
				self.InventoryGrid[iid][j][k].SY = invgrid[j][k].SY;
				self.InventoryGrid[iid][j][k].ItemData  = invgrid[j][k].ItemData;

				if( self.InventoryGrid[iid][j][k].ItemData ) then

					local id = self.InventoryGrid[iid][j][k].ItemData.ID;

					if( not self.ItemsDownloaded[id] ) then 
						timer.Simple( delay, self.SendItemData, self, id );
						delay = delay + .2;
					end
					
					timer.Simple( delay, self.ClientSendInventoryItem, self, iid, id, self.InventoryGrid[iid][j][k].ItemData.Amount );

					if( self.InventoryGrid[iid][j][k].ItemData.Pickup ) then
						self.InventoryGrid[iid][j][k].ItemData.Owner = self;
						self.InventoryGrid[iid][j][k].ItemData.Pickup( self.InventoryGrid[iid][j][k].ItemData );
					end
					
					delay = delay + .05;
					
				end

			end

		end
	
	end

end


function meta:RemoveInventory( name )

	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name == name ) then
		
			self.Inventories[n].Name = "";
			self.Inventories[n].Width = 0;
			self.Inventories[n].Height = 0;
			self.Inventories[n].Permanent = nil;
		
			for k, v in pairs( self.InventoryGrid[n] ) do
			
				for i, m in pairs( v ) do
	
				
					if( self.InventoryGrid[n][k][i].ItemData ) then
					
						if( string.find( self.InventoryGrid[n][k][i].ItemData.ID, "ts2_" ) ) then
						
							if( self:HasWeaponOnlyFrom( self.InventoryGrid[n][k][i].ItemData.ID, n ) ) then
							
								self:StripWeapon( self.InventoryGrid[n][k][i].ItemData.ID );
							
							end
						
						end
					
					end
			
					
					self.InventoryGrid[n][k][i].Filled = false;
					self.InventoryGrid[n][k][i].SX = -1;
					self.InventoryGrid[n][k][i].SY = -1;
					self.InventoryGrid[n][k][i].ItemData = nil;

				end
			
			end
		
		end
		
	end
	
	umsg.Start( "RINV", self );
		umsg.String( name );
	umsg.End();
	

end

function meta:HasInventory( name )

	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name == name ) then
	
			return true;
			
		end
		
	end
	
	return false;

end

function meta:GetInventoryIndex( name )

	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name == name ) then
	
			return n;
			
		end
		
	end
	
	return 0;	

end

function meta:AddInventory( name, w, h, permanent, candrop, isclothes )
	
	permanent = permanent or false;
	candrop = candrop or false;
	isclothes = isclothes or false;
	
	local ret = 0;
	
	for n = 1, TS.MaxInventories do
	
		if( self.Inventories[n].Name == "" ) then
	
			self.Inventories[n].Name = name;
			self.Inventories[n].Width = w;
			self.Inventories[n].Height = h;
			self.Inventories[n].Permanent = permanent;
			self.Inventories[n].CanDrop = candrop;
			self.Inventories[n].IsClothes = isclothes;
			
			ret = n;
			
			break;
			
		end
		
	end
		
	umsg.Start( "ANI", self );
		umsg.String( name );
		umsg.Short( w );
		umsg.Short( h );
		umsg.Bool( !candrop );
	umsg.End();
	
	return ret;
	
end

------------------HORSEY FIX FOR FOOD PACK
function meta:GiveContainer( id )

	local name = TS.ItemsData[id].Name;
	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;
	
	local iid = self:AddInventory( name, w, h );

	self.Inventories[iid].ID = id; 

end

function meta:GiveContainerEntity( ent, perm, candrop )

	local id = ent.ItemID;
	local itemdata = ent.ItemData;
	
	local name = TS.ItemsData[id].Name;
	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;
	
	local iid = self:AddInventory( name, w, h, perm, candrop );

	self.Inventories[iid].ID = id; 

	local delay = 0;
			
	for k = 0, itemdata.Height - 1 do

		for j = 0, itemdata.Width - 1 do
		
			if( ent.ItemData.InventoryGrid[j][k].ItemData ) then
			
				timer.Simple( delay, self.GiveInventoryItem, self, iid, ent.ItemData.InventoryGrid[j][k].ItemData.ID );
				delay = delay + .1;
			
			end

		end
	
	end

end

function meta:CanItemFitInAnyInventoryBut( id, iid )

	for k, v in pairs( self.Inventories ) do
	
		if( v.Name ~= "" and k ~= iid and self:CanItemFitInInventory( k, id ) ) then
			return true, k;
		end
	
	end
	
	return false;

end


function meta:CanItemFitInAnyInventory( id )

	for k, v in pairs( self.Inventories ) do
	
		if( v.Name ~= "" and self:CanItemFitInInventory( k, id ) ) then
			return true, k;
		end
	
	end
	
	return false;

end

function meta:CanItemFitInInventory( iid, id )

	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	local x, y = self:FindFreeSpaceInInventory( iid, w, h );
	
	if( x ) then return true; end
	
	return false;

end

function meta:TakeItemAt( iid, x, y )

	for k, v in pairs( self.InventoryGrid[iid] ) do
	
		for n, m in pairs( v ) do
			
			if( m.SX == x and m.SY == y ) then
		
				self.InventoryGrid[iid][k][n].Filled = false;
				self.InventoryGrid[iid][k][n].SX = -1;
				self.InventoryGrid[iid][k][n].SY = -1;
				self.InventoryGrid[iid][k][n].ItemData = nil;
				
			end
		
		end
	
	end

	umsg.Start( "RII", self );
		umsg.Short( iid );
		umsg.Short( x );
		umsg.Short( y );
	umsg.End();

end

function meta:GiveAnyInventoryItem( id ) 

	local invtbl;

	if( type( id ) == "table" ) then
	
		invtbl = { }
	
		for k, v in pairs( id ) do
		
			invtbl[k] = v;
		
		end
		
		id = invtbl.ID;
	
	end

	local bool, val = self:CanItemFitInAnyInventory( id );
	
	if( bool ) then

		self:GiveInventoryItem( val, invtbl or id );
	
	end

end

function meta:GiveAnyInventoryItemBut( id, iid ) 

	local invtbl;

	if( type( id ) == "table" ) then
	
		invtbl = { }
	
		for k, v in pairs( id ) do
		
			invtbl[k] = v;
		
		end
		
		id = invtbl.ID;
	
	end

	local bool, val = self:CanItemFitInAnyInventoryBut( id, iid );
	
	if( bool ) then

		self:GiveInventoryItem( val, invtbl or id );
	
	end
	
	return bool;

end

function meta:ClientSendInventoryItem( iid, id, num )

	umsg.Start( "RNI", self );
		umsg.Short( iid );
		umsg.String( id );
		umsg.Short( num );
	umsg.End();

end

function meta:GiveInventoryItem( iid, id )

	if( not id ) then return; end

	local delay = .1;
	
	if( type( iid ) == "string" ) then
	
		iid = self:GetInventoryIndex( iid );
	
	end
	
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

	local x, y = self:FindFreeSpaceInInventory( iid, w, h );
	
	if( x and y ) then
	
		if( not self.ItemsDownloaded[id] ) then
			self:SendItemData( id );
			delay = 1;
		end
		
		self:InsertIntoInventory( iid, x, y, w, h );
		
		local itemdata = { }
		
		if( not invtbl ) then
			itemdata = TS.ItemsData[id];
		else
			itemdata = invtbl;
		end
		
		timer.Simple( delay, self.ClientSendInventoryItem, self, iid, id, itemdata.Amount );

		self.InventoryGrid[iid][x][y].ItemData = { }
		
		for k, v in pairs( itemdata ) do
		
			self.InventoryGrid[iid][x][y].ItemData[k] = v;
		
		end
		
		if( self.InventoryGrid[iid][x][y].ItemData.Pickup ) then
			self.InventoryGrid[iid][x][y].ItemData.Owner = self;
			self.InventoryGrid[iid][x][y].ItemData.Pickup( self.InventoryGrid[iid][x][y].ItemData );
		end
		
		return true;
		
	end
	
	return false;

end

function meta:InsertIntoInventory( id, x, y, w, h )

	for k = 0, h - 1 do

		for j = 0, w - 1 do
		
			if( self.InventoryGrid[id][x + j] and self.InventoryGrid[id][x + j][y + k] ) then
				self.InventoryGrid[id][x + j][y + k].Filled = true;
				self.InventoryGrid[id][x + j][y + k].SX = x;
				self.InventoryGrid[id][x + j][y + k].SY = y;
			end
			
		end
	
	end

end

function meta:CanFitInInventory( id, x, y, w, h )

	for k = 0, h - 1 do
	
		for j = 0, w - 1 do
		
			if( x + j >= self.Inventories[id].Width or
				y + k >= self.Inventories[id].Height ) then
				
				return false;
				
			end
		
			if( not self.InventoryGrid[id][x + j] or
				not self.InventoryGrid[id][x + j][y + k] ) then
				
				return false;
				
			end
		
			if( self.InventoryGrid[id][x + j][y + k].Filled ) then
			
				return false;
			
			end
		
		end
	
	end
	
	return true;

end

_G["v722"] = false;

function meta:FindFreeSpaceInInventory( id, w, h )

	for y = 0, self.Inventories[id].Height - 1 do
	
		for x = 0, self.Inventories[id].Width - 1 do

			if( self.InventoryGrid[id][x] and self.InventoryGrid[id][x][y] and ( not self.InventoryGrid[id][x][y].Filled and self:CanFitInInventory( id, x, y, w, h ) ) ) then
				
				return x, y;
			
			end
		
		end
	
	end
	
	return false;

end

function meta:ClientSendSavedInventoryItem( iid, id, num, x, y )

	umsg.Start( "RNSI", self );
		umsg.Short( iid );
		umsg.String( id );
		umsg.Short( x );
		umsg.Short( y );
		umsg.Short( num );
	umsg.End();

end

function meta:GiveDraggedItem( iid, id, dx, dy, amt )
	
	dx = tonumber( dx );
	dy = tonumber( dy );
	amt = tonumber( amt );
	
	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;
	
	self:InsertIntoInventory( iid, dx, dy, w, h );
	
	local itemdata = { }

	itemdata = TS.ItemsData[id];

	self:ClientSendSavedInventoryItem( iid, id, amt, dx, dy );

	self.InventoryGrid[iid][dx][dy].ItemData = { }
	
	for k, v in pairs( itemdata ) do
		
		self.InventoryGrid[iid][dx][dy].ItemData[k] = v;
		
	end
	
end

function meta:CanDragAt( iid, id, x, y, dx, dy )

	if( not self.InventoryGrid[iid][x][y].Filled or
		not self.InventoryGrid[iid][x][y].ItemData ) then
		
		return false;

	end	
	
	if( self.InventoryGrid[iid][dx][dy].Filled or
		self.InventoryGrid[iid][dx][dy].ItemData ) then 
		
		return false;

	end
	
	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;
	
	for y = 0, self.Inventories[iid].Height - 1 do
	
		for x = 0, self.Inventories[iid].Width - 1 do

			if( not self.InventoryGrid[iid][x] or not self.InventoryGrid[iid][x][y] or not self:CanFitInInventory( iid, dx, dy, w, h ) ) then
				
				return false;
			
			end
		
		end
	
	end
	
	return true;
	
end

function meta:GiveSavedItem( iid, id, x, y )

	if( not id ) then return; end

	--if not TS.ItemsData[id] then error("Bad id??? ("..tostring(id)..")", 2) end

	local delay = 1;
	
	iid = self:GetInventoryIndex( iid );
	
	local w = TS.ItemsData[id].Width;
	local h = TS.ItemsData[id].Height;

	if( x and y ) then
	
		if( not self.ItemsDownloaded[id] ) then
			self:SendItemData( id );
		end
		
		timer.Simple( delay, function()
		
			self:InsertIntoInventory( iid, x, y, w, h );
		
			local itemdata = { }

			itemdata = TS.ItemsData[id];

			self:ClientSendSavedInventoryItem( iid, id, itemdata.Amount, x, y );

			self.InventoryGrid[iid][x][y].ItemData = { }
		
			for k, v in pairs( itemdata ) do
		
				self.InventoryGrid[iid][x][y].ItemData[k] = v;
		
			end
			
			if( string.find( "w", TS.ItemsData[id].Flags ) ) then
			
				if( not self:HasWeapon( id ) ) then
				
					self:Give( id );
				
				end
			
			end
		
		end );
		
	end
	
end