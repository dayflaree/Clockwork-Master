
local meta = FindMetaTable( "Player" );
local emeta = FindMetaTable( "Entity" );

--[[
--======================================--
-- GIVING ITEMS                         --
--======================================--
:GiveItem is the function to call to give items.  

data: Can either be the item data table itself, to transfer existing item data
into the inventory, or it can be a string, to represent the string id of the item 
you want to give.

inv: The inventory ID of the player that you want to add the item to, because there 
are multiple inventories.

]]--

function emeta:ResetInv()
	
	self:GetTable().InventoryGrid = { }
	self:GetTable().InventoryList = { }
	
	if( self:IsPlayer() ) then
		
		for n = 1, MAX_INVENTORIES do
			
			self:GetTable().InventoryGrid[n] = { }
			self:ResetInventory( n );
			
		end
		
	else
		
		self:GetTable().InventoryGrid[1] = { }
		self:ResetInventory( 1 );
		
	end
	
	if( self:IsPlayer() ) then
		
		timer.Simple( .5, self.CallEvent, self, "CreateDefaultInventories" );
		
	end
	
	self:CreateDefaultInventories();
	
end

function emeta:TransmitMyInv( ply )
	
	for _, v in pairs( self:GetTable().InventoryGrid ) do
		
		for _, item in pairs( v ) do
			
			umsg.Start( "IEIV", ply );
				umsg.String( v[1]["ItemData"].ID );
				umsg.Short( v[1].sx );
				umsg.Short( v[1].sy );
				umsg.Short( v[1]["ItemData"].Amount );
			umsg.End();
			
		end
		
		umsg.Start( "FEIV", ply );
		umsg.End();
		
	end
	
end

function emeta:GiveItem( data, inv, amt )

	inv = tonumber( inv );

	if( not inv ) then return false; end

	local itemdata = { };

	if( type( data ) == "string" ) then
	
		if( ItemsData[data] ) then
	
			itemdata = CreateTableCopy( ItemsData[data] );
	
		else
		
			return false;
		
		end
	
	elseif( type( data ) == "Entity" ) then
	
		if( data:GetTable().ItemData ) then
	
			itemdata = CreateTableCopy( data:GetTable().ItemData );
	
		else
		
			return false;
		
		end
	
	end
	
	if( amt ) then
		
		itemdata.Amount = amt;
		
	end
	
	return self:PutItemInInventory( inv, itemdata );

end

function meta:UseItemEntity( ent )
	
	local itemdata;
	
	local usingent = false;
	
	if( type( ent ) == "Entity" ) then 
	
		usingent = true;
		
	end
	
	if( usingent ) then
		
		itemdata = ent:GetTable().ItemData;
		
		if( itemdata.InventoryUse ) then
			
			return;
			
		end
		
	else
	
		itemdata = ent;
	
	end
	
	itemdata.Owner = self;

	local function think()
	
		if( not usingent ) then return; end
		
		if( not ent or not ent:IsValid() ) then 
			return false;
		end
	
		if( ( self:EyePos() - ent:GetPos() ):Length() > 70 ) then
			return false;
		end
	
	end

	local function done()

		if( think() == false ) then
		
			return true;
		
		end
	
		self:NoticeUsedItem( itemdata );
		
		if( itemdata.Use( itemdata ) ) then
			
			if( usingent ) then
			
				ent:Remove();
				
			else
				
				self:RemoveFromInventory( itemdata.InvID, itemdata.InvX, itemdata.InvY );	
			
			end
			
			itemdata = nil;
			
		else
			
			if( !usingent ) then
				
				self:sqlUpdateAmount( itemdata.InvID, itemdata.InvX, itemdata.InvY, itemdata.Amount );
				
			end
			
		end
	
		return true;
	
	end

	local text = "";
	
	if( string.find( itemdata.Flags, "e" ) ) then
	
		text = "Eating ";
		
	elseif( string.find( itemdata.Flags, "d" ) ) then
	
		text = "Drinking ";
	
	elseif( string.find( itemdata.Flags, "u" ) ) then
	
		text = "Using ";

	elseif( string.find( itemdata.Flags, "s" ) ) then
	
		text = "Lighting ";

	elseif( string.find( itemdata.Flags, "i" ) ) then
	
		text = "Putting on ";
	
	end

	self:CreateProgressBar( "useitem", text .. " item", itemdata.UseDelay, itemdata.UseDelay * .5, think, done );

end

function meta:HandlePickingUpEntity( id, ent )

	local itemdata = ent:GetTable().ItemData;
	
	if( id == -1 ) then
	
		--todo
	
	else
	
		if( not self:HasInventorySpace( id, itemdata.Width, itemdata.Height ) ) then
		
			return;
		
		end
		
	end


	local function think()
	
		if( not ent or not ent:IsValid() ) then
		
			return false;
		
		end
	
		if( ( self:EyePos() - ent:GetPos() ):Length() > 90 ) then
			return false;
		end
	
	end

	local function done()

		if( think() == false ) then
		
			return true;
		
		end
	
		if( self:GiveItem( ent, id ) ) then
		
			if( itemdata.Pickup ) then
			
				itemdata.Owner = self;
				itemdata.Pickup( itemdata );
			
			end
		
			self:NoticePlainWhite( "Picked up " .. itemdata.NicePhrase .. "." );
			
			ent:Remove();
		
		end
		
		return true;
	
	end

	self:CreateProgressBar( "pickupitem", "Picking up item . . ", itemdata.PickupDelay, itemdata.PickupDelay * .5, think, done );

end


--Below is just inventory base code and no explanation will be given into the inner workings of it.

function emeta:HasItem( id )

	if( not self:GetTable().InventoryList ) then return false; end

	if( self:GetTable().InventoryList[id] ) then
	
		return true;
	
	end
	
	return false;

end

function meta:HasItemInventory( id )
	
	for k, v in pairs( self:GetTable().InventoryGrid ) do

		if( v.itemdata and v.itemdata.ID == id ) then
		
			return true;
		
		end
	
	end
	
	return false;

end

function meta:UpdateItemAmount( inv, x, y )
	
	umsg.Start( "CIIA", self );
		umsg.Short( inv );
		umsg.Short( x );
		umsg.Short( y );
		umsg.Short( self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount );
	umsg.End();

end

function emeta:IsInventoryAvailable( k )

	if( not self:GetTable().InventoryGrid[k] ) then return false; end
	
	if( self:GetTable().InventoryGrid[k].width <= 0 or
		self:GetTable().InventoryGrid[k].height <= 0 ) then return false; end
		
	return true;

end

function emeta:ValidInventoryItem( inv, x, y )

	if( self:GetTable().InventoryGrid[inv] and
		self:GetTable().InventoryGrid[inv][x] and
		self:GetTable().InventoryGrid[inv][x][y] and
		self:GetTable().InventoryGrid[inv][x][y].filled ) then
		
		return true;
		
	end
	
	return false;

end

function emeta:GetAvailableInventories()

	local tbl = { }

	for k, v in pairs( self:GetTable().InventoryGrid ) do
	
		if( v.width > 0 and v.height > 0 ) then
		
			table.insert( tbl, k );
		
		end
	
	end
	
	return tbl;

end

function emeta:IsInventorySpotFree( inv, x1, y1, w, h )

	for y = y1, y1 + h - 1 do
	
		for x = x1, x1 + w - 1 do

			if( x > self:GetTable().InventoryGrid[inv].width or y > self:GetTable().InventoryGrid[inv].height or not self:GetTable().InventoryGrid[inv][x] or not self:GetTable().InventoryGrid[inv][x][y] or self:GetTable().InventoryGrid[inv][x][y].filled ) then

				return false;
				
			end
		
		end
	
	end	

	return true;

end

function emeta:HasInventorySpace( inv, w, h )

	inv = tonumber( inv );

	local mw = self:GetTable().InventoryGrid[inv].width;
	local mh = self:GetTable().InventoryGrid[inv].height;

	for y = 1, mh do
	
		for x = 1, mw do
		
			if( self:IsInventorySpotFree( inv, x, y, w, h ) ) then
		
				return true;
		
			end
		
		end
	
	end
	
	return false;

end

function emeta:GetSuitableInventorySpace( inv, w, h )

	local mw = self:GetTable().InventoryGrid[inv].width;
	local mh = self:GetTable().InventoryGrid[inv].height;

	for y = 1, mh do
	
		for x = 1, mw do
		
			if( self:IsInventorySpotFree( inv, x, y, w, h ) ) then

				return x, y;
		
			end
		
		end
	
	end

	return nil;

end

function emeta:InsertIntoInventory( inv, itemdata, x, y, nosave, moving )
	
	local w = itemdata.Width - 1;
	local h = itemdata.Height - 1;

	for _y = y, y + h do
	
		for _x = x, x + w do
		
			self:GetTable().InventoryGrid[inv][_x][_y].filled = true;
			self:GetTable().InventoryGrid[inv][_x][_y].sx = x;
			self:GetTable().InventoryGrid[inv][_x][_y].sy = y;
			self:GetTable().InventoryGrid[inv][_x][_y].sub = true;
			
		end
	
	end
	
	self:GetTable().InventoryGrid[inv][x][y].ItemData = itemdata;
	
	self:GetTable().InventoryGrid[inv][x][y].ItemData.InvX = x;
	self:GetTable().InventoryGrid[inv][x][y].ItemData.InvY = y;
	self:GetTable().InventoryGrid[inv][x][y].ItemData.InvID = inv;	
	self:GetTable().InventoryGrid[inv][x][y].main = true;

	if( ( not nosave ) and self:IsPlayer() ) then
	
		self:sqlUpdateInventory( inv, x, y, itemdata.ID, itemdata.Amount or 1, moving );

	end
	
end

function emeta:RemoveFromInventory( inv, x, y )

	local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;

	if( itemdata ) then
		
		for _y = y, y + itemdata.Height - 1 do

			for _x = x, x + itemdata.Width - 1 do
	
				self:GetTable().InventoryGrid[inv][_x][_y].filled = false;
				self:GetTable().InventoryGrid[inv][_x][_y].sx = -1;
				self:GetTable().InventoryGrid[inv][_x][_y].sy = -1;
				self:GetTable().InventoryGrid[inv][_x][_y].ItemData = nil;
				
			end
			
		end
		
		if( self:IsPlayer() ) then
			
			umsg.Start( "RINV", self );
				umsg.Short( inv );
				umsg.Short( x );
				umsg.Short( y );
			umsg.End();
			
		end
		
	end
	
	if( self:IsPlayer() ) then
		
		self:sqlUpdateInventory( inv, x, y, nil );
		
	end

end

function meta:ClientInsertIntoInventory( inv, itemdata, x, y )

	if( not self:IsValid() ) then return; end

	umsg.Start( "IINV", self );
		umsg.Short( inv );
		umsg.String( itemdata.ID );
		umsg.Short( x );
		umsg.Short( y );
		umsg.Short( itemdata.Amount );
	umsg.End();

end

function meta:DropItemProp( itemdata )

	local itemprop = CreateItemProp( itemdata );

	local trace = { }
	trace.start = self:EyePos();
	trace.endpos = trace.start + self:GetAimVector() * 40;
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	itemprop:SetPos( tr.HitPos );
	itemprop:Spawn();
	
	self:NoticePlainWhite( "Dropped " .. itemdata.NicePhrase .. "." );
	
	return itemprop;
	
end

function meta:DropFromInventory( inv, x, y )

	if( self:ValidInventoryItem( inv, x, y ) ) then
	
		local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;
		
		if( not itemdata ) then
		
			return;
		
		end
		
		if( itemdata.Drop ) then
		
			itemdata.Owner = self;
			itemdata.Drop( itemdata );
			
		end	

		self:DropItemProp( itemdata );
		self:RemoveFromInventory( inv, x, y );
				
		if( self:GetTable().InventoryList[itemdata.ID] ) then
		
			self:GetTable().InventoryList[itemdata.ID] = self:GetTable().InventoryList[itemdata.ID] - 1;
			
			if( self:GetTable().InventoryList[itemdata.ID] <= 0 ) then
			
				self:GetTable().InventoryList[itemdata.ID] = nil;
			
			end
			
		end
	
	end

end

function emeta:AttemptToPutInInventoryAt( itemdata, dinv, dx, dy, exact, nosave, moving )
	
	local gencoords = false;
	
	if( dx and dy ) then
	
		if( dx < 1 or
			dy < 1 or
			dx > self:GetTable().InventoryGrid[dinv].width or
			dy > self:GetTable().InventoryGrid[dinv].height or 
			not self:IsInventorySpotFree( dinv, dx, dy, itemdata.Width, itemdata.Height ) ) then
			
			gencoords = true;
			
		end
	
	else
	
		gencoords = true;
	
	end

	if( exact and gencoords ) then
	
		dx = nil;
		dy = nil;
	
	elseif( not exact and gencoords ) then

		dx, dy = self:GetSuitableInventorySpace( dinv, itemdata.Width, itemdata.Height );
	
	end

	if( dx and dy ) then

		self:PutItemInInventory( dinv, itemdata, dx, dy, amt, nosave, moving );
		
		return true;
		
	end
	
	return false;

end

function emeta:MoveFromInventoryToInventory( inv, dinv, x, y, dx, dy )

	if( not self:ValidInventoryItem( inv, x, y ) ) then
	
		return;
	
	end
	
	local itemdata = self:GetTable().InventoryGrid[inv][x][y].ItemData;

	if( not itemdata ) then
	
		return;
	
	end

	if( not self:IsInventorySpotFree( dinv, dx, dy, 1, 1 ) ) then

		local sx = self:GetTable().InventoryGrid[dinv][dx][dy].sx;
		local sy = self:GetTable().InventoryGrid[dinv][dx][dy].sy;
		
		if( not self:GetTable().InventoryGrid[dinv][sx] or not self:GetTable().InventoryGrid[dinv][sx][sy] or not self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.AddsOn ) then
		
			return;
		
		end
		
		if( self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.ID ~=
			itemdata.ID and not table.HasValue( self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.CanCombineWith, itemdata.ID ) ) then
			
			return;
			
		end
		
		local item1amount = itemdata.Amount;
		
		local amountcanadd = math.Clamp( self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.AddOnMax - self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.Amount, 0, item1amount );
	
		if( amountcanadd > 0 ) then
		
			self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount = self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount - amountcanadd;
			self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.Amount = self:GetTable().InventoryGrid[dinv][sx][sy].ItemData.Amount + amountcanadd;
		
			if( self:GetTable().InventoryGrid[dinv][sx][sy].ItemData["CombineWith_" .. itemdata.ID] ) then
				
				self:GetTable().InventoryGrid[dinv][sx][sy].ItemData["CombineWith_" .. itemdata.ID]( self:GetTable().InventoryGrid[dinv][sx][sy].ItemData, itemdata );
				
			end
		
			self:UpdateItemAmount( dinv, sx, sy );
		
			if( self:GetTable().InventoryGrid[inv][x][y].ItemData.Amount <= 0 ) then

				self:RemoveFromInventory( inv, x, y );
			
			else
			
				self:UpdateItemAmount( inv, x, y );
			
			end
			
		end
	
	
	elseif( self:AttemptToPutInInventoryAt( itemdata, dinv, dx, dy, nil, nil, true ) ) then

		self:RemoveFromInventory( inv, x, y );

	end

end

function emeta:PutItemInInventory( inv, itemdata, _x, _y, nosave, moving )
	
	local x, y;

	if( _x and _y ) then
	
		x = _x;
		y = _y;
	
	else
	
		x, y = self:GetSuitableInventorySpace( inv, itemdata.Width, itemdata.Height );
	
	end

	if( x and y ) then
		
		if( self:IsPlayer() ) then
			
			if( self:GetTable().CLLoadedItems[itemdata.ID] ) then
			
				timer.Simple( .1, self.ClientInsertIntoInventory, self, inv, itemdata, x, y );
			
			else
			
				timer.Simple( 1.5, self.ClientInsertIntoInventory, self, inv, itemdata, x, y );
			
			end
			
		end
		
		itemdata.InInventory = true;
		
		if( self:IsPlayer() ) then
			
			self:SendItemData( itemdata );
			
		end
		
		self:InsertIntoInventory( inv, itemdata, x, y, nosave, moving );
		
		if( self:GetTable().InventoryList[itemdata.ID] ) then
		
			self:GetTable().InventoryList[itemdata.ID] = self:GetTable().InventoryList[itemdata.ID] + 1;
		
		else
		
			self:GetTable().InventoryList[itemdata.ID] = 1;	
		
		end
		
		return true;
	
	end
	
	return false;

end

function meta:SendItemData( itemdata )

	if( self:GetTable().CLLoadedItems[itemdata.ID] ) then return; end

	local flags = itemdata.Flags;
	
	if( string.find( flags, "a" ) ) then
	
		flags = flags .. "#" .. itemdata.AmmoType;
	
	end

	umsg.Start( "RECID", self );
		umsg.String( itemdata.ID );
		umsg.String( itemdata.Name );
		umsg.String( flags );
	umsg.End();
	
	timer.Simple( .2, function()
	
		umsg.Start( "RECMID", self );
			umsg.String( itemdata.ID );
			umsg.String( itemdata.Model );
			umsg.Short( itemdata.Width );
			umsg.Short( itemdata.Height );
		umsg.End();
	
	end );
	
	timer.Simple( .5, function()
	
		umsg.Start( "RECPID", self );
			umsg.String( itemdata.ID );
			umsg.Vector( itemdata.CamPos );
			umsg.Vector( itemdata.LookAt );
			umsg.Short( itemdata.FOV );
		umsg.End();
	
	end );

	timer.Simple( .7, function()
	
		local desc, count = string.split2( itemdata.Description, 230 );

		for n = 1, count do
	
			umsg.Start( "APID", self );
				umsg.String( itemdata.ID );
				umsg.String( desc[n] );
			umsg.End();
			
		end
	
	end );
	
	timer.Simple( .9, function()
	
		self:GetTable().CLLoadedItems[itemdata.ID] = { };
	
	end );
	
	

end

function emeta:ResetInventory( inv )

	self:GetTable().InventoryGrid[inv].name = "";
	self:GetTable().InventoryGrid[inv].id = "";
	self:GetTable().InventoryGrid[inv].width = 0;
	self:GetTable().InventoryGrid[inv].height = 0;
	self:GetTable().InventoryGrid[inv].itemdata = nil;
	
	for x = 1, MAX_INV_WIDTH do
	
		self:GetTable().InventoryGrid[inv][x] = { }
		
		for y = 1, MAX_INV_HEIGHT do
		
			self:GetTable().InventoryGrid[inv][x][y] =
			{
				filled = false,
				sx = -1, 
				sy = -1,
			}
		
		end
	
	end

end

function emeta:RemoveInventory( inv )

	self:ResetInventory( inv );
	
	if( self:IsPlayer() ) then
		
		umsg.Start( "RWINV", self );
			umsg.Short( inv );
		umsg.End();
		
		self:sqlClearInventory( inv );
		
	end

end

function emeta:AttemptToDropInventory( inv )

	if( self:GetTable().InventoryGrid[inv] and self:GetTable().InventoryGrid[inv].width > 0 and self:GetTable().InventoryGrid[inv].height > 0 and self:GetTable().InventoryGrid[inv].candrop ) then

		for x = 1, MAX_INV_WIDTH do

			for y = 1, MAX_INV_HEIGHT do
					
				if( not self:GetTable().InventoryGrid[inv].itemdata.InventoryGrid[x] ) then
			
					self:GetTable().InventoryGrid[inv].itemdata.InventoryGrid[x] = { }
			
				end
				
				self:GetTable().InventoryGrid[inv].itemdata.InventoryGrid[x][y] = self:GetTable().InventoryGrid[inv][x][y];

			end
		
		end

		if( self:GetTable().InventoryGrid[inv].itemdata and self:GetTable().InventoryGrid[inv].itemdata.Drop ) then
		
			self:GetTable().InventoryGrid[inv].itemdata.Owner = self;
			self:GetTable().InventoryGrid[inv].itemdata.Drop( self:GetTable().InventoryGrid[inv].itemdata );
		
		end
		
		self:RemoveInventory( inv );
	
	end

end

function meta:AddNewInventoryWithItemData( itemdata )

	local data = { }
	
	for k, v in pairs( itemdata ) do
	
		data[k] = itemdata[k];
	
	end

	local id = data.ID;
	
	if( self:GetTable().AddableInvs[id] ) then
	
		local invdata = self:GetTable().AddableInvs[id];
	
		self:AddNewInventory( invdata.name, invdata.id, data.Width, data.Height, data, invdata.candrop );
		
		umsg.Start( "AINV", self );
			umsg.Short( invdata.groupid );
			umsg.Short( invdata.id );
			umsg.Short( data.Width );
			umsg.Short( data.Height );
		umsg.End();
		
		local delay = 1;
		
		if( data.InventoryGrid ) then
			
			for x = 1, MAX_INV_WIDTH do
			
				if( data.InventoryGrid[x] ) then
				
					for y = 1, MAX_INV_HEIGHT do
					
						if( data.InventoryGrid[x][y] and data.InventoryGrid[x][y].data ) then
					
							timer.Simple( delay, self.PutItemInInventory, self, invdata.id, data.InventoryGrid[x][y].data, x, y );
					
						end
					
					end
					
				end
				
			end
			
		end
	
	end

end

function emeta:AddNewInventory( name, id, w, h, invitemdata, candrop )
	
	self:GetTable().InventoryGrid[id].name = name;
	self:GetTable().InventoryGrid[id].id = id;
	self:GetTable().InventoryGrid[id].width = w;
	self:GetTable().InventoryGrid[id].height = h;
	self:GetTable().InventoryGrid[id].itemdata = invitemdata;
	self:GetTable().InventoryGrid[id].candrop = candrop;

end

function emeta:CreateDefaultInventories()
	
	self:GetTable().AddableInvs = { }
	
	if( !self:IsPlayer() ) then
		
		self:GetTable().InventoryGrid[1].name = "Test Invent";
		self:GetTable().InventoryGrid[1].id = 1;
		self:GetTable().InventoryGrid[1].width = 3;
		self:GetTable().InventoryGrid[1].height = 3;
		self:GetTable().InventoryGrid[1].itemdata = nil;
		self:GetTable().InventoryGrid[1].candrop = nil;
		return;
		
	end

	local key;

	for k, v in pairs( PlayerModels ) do
	
		if( table.HasValue( v.Models, string.lower( self:GetModel() ) ) ) then
		
			key = k;
			break;
		
		end
	
	end
	
	if( not key ) then
	
		key = 1;
	
	end
	
	local k = key;
	local v = PlayerModels[key];
	
	for n, m in pairs( v.Inventories ) do
	
		if( m.Default ) then
		
			self:AddNewInventory( m.Name, n, m.w, m.h );
		
		end
		
		if( m.ItemData ) then
		
			self:GetTable().AddableInvs[m.ItemData] =
			{
			
				name = m.Name,
				id = n,
				groupid = k,
				candrop = m.CanDrop,
			
			}
		
		end
	
	end

end


