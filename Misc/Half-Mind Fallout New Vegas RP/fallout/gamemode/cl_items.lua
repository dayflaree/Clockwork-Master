local function nClearInventory( len )
	
	LocalPlayer().Inventory = { };
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nClearInventory", nClearInventory );

local function nGiveItem( len )
	
	if( LocalPlayer():CheckInventory() ) then return end
	
	local tab = net.ReadTable();
	
	LocalPlayer().Inventory[tab.Key] = tab;
	
	GAMEMODE:RefreshInventory();
	
	if( GAMEMODE.D.F4 ) then
	
		GAMEMODE:RefreshTrader();
		
	end
	
end
net.Receive( "nGiveItem", nGiveItem );

local function nTakeMoney( len )

	local key = net.ReadFloat();
	local amount = net.ReadFloat();
	
	if( !LocalPlayer().Inventory[key] ) then return end
	
	local item = LocalPlayer().Inventory[key];
	
	item.Vars.Caps = item.Vars.Caps - amount;

end
net.Receive( "nTakeMoney", nTakeMoney );

local function nRemoveItem( len )
	
	if( LocalPlayer():CheckInventory() ) then return end
	
	local key = net.ReadFloat();
	
	LocalPlayer().Inventory[key] = nil;
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nRemoveItem", nRemoveItem );

local function nMoveItem( len )
	
	if( LocalPlayer():CheckInventory() ) then return end
	
	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	if( !LocalPlayer().Inventory[key] ) then return end
	
	LocalPlayer().Inventory[key].X = x;
	LocalPlayer().Inventory[key].Y = y;
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nMoveItem", nMoveItem );

local function nItemTooBig( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", COLOR_ERROR, "You can't fit that in your inventory." );
	
end
net.Receive( "nItemTooBig", nItemTooBig );

local function nEquipClothing( len )

	local key = net.ReadFloat();
	local invItem = LocalPlayer().Inventory[key];

	if( !GAMEMODE:GetMetaItem( invItem.Class ).Clothing ) then return end
	
	if( GAMEMODE:GetMetaItem( invItem.Class ).Gender ) then
	
		if( GAMEMODE:GetMetaItem( invItem.Class ).Gender != LocalPlayer():Sex() ) then return end
		
	end

	invItem.X = 0;
	invItem.Y = 0;
	invItem.Clothing = true;
	invItem.Equipped = true;

	net.Start( "nEquipClothing" );
		net.WriteFloat( invItem.Key );
	net.SendToServer();

end
net.Receive( "nEquipClothing", nEquipClothing );

local function nMoveToInventory( len )

	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	if( !LocalPlayer().Inventory[key] ) then return end;
	
	local item = LocalPlayer().Inventory[key];
	
	item.X = x;
	item.Y = y;
	item.inTraderInv = false;
	
	GAMEMODE:RefreshTrader();
	GAMEMODE:RefreshTraderItemButtons();

end
net.Receive( "nMoveToInventory", nMoveToInventory );

function GM:ShowInventory()
	
	if( LocalPlayer():CheckInventory() ) then return end
	
	self.D.Inventory = vgui.Create( "DFrame" );
	self.D.Inventory:SetSize( 800, 34 + ( 48 * 10 ) + 10 + 150 );
	self.D.Inventory:Center();
	self.D.Inventory:SetTitle( "Inventory" );
	self.D.Inventory:MakePopup();
	
	self.D.Inventory.Back = vgui.Create( "IInventoryBack", self.D.Inventory );
	self.D.Inventory.Back:SetPos( 180, 34 );
	self.D.Inventory.Back:SetSize( 48 * 6, 48 * 10 );
	
	self.D.Inventory.T = vgui.Create( "DLabel", self.D.Inventory );
	self.D.Inventory.T:SetPos( 48 * 10, 34 );
	self.D.Inventory.T:SetFont( "Infected.SubTitle" );
	self.D.Inventory.T:SetText( "" );
	self.D.Inventory.T:SizeToContents();
	self.D.Inventory.T:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.Inventory.D = vgui.Create( "DLabel", self.D.Inventory );
	self.D.Inventory.D:SetPos( 48 * 10, 70 );
	self.D.Inventory.D:SetFont( "Infected.LabelSmall" );
	self.D.Inventory.D:SetText( "" );
	self.D.Inventory.D:SetAutoStretchVertical( true );
	self.D.Inventory.D:SetWrap( true );
	self.D.Inventory.D:SetSize( 800 - 10 - ( 10 + 48 * 10 + 30 ), 48 * 10 - 200 );
	self.D.Inventory.D:SetTextColor( Color( 255, 255, 255, 255 ) );
	self.D.Inventory.D:PerformLayout();
	
	self:RefreshInventory();
	
end

function GM:FindSlotsFrom( i, j, x, y, w, h )
	
	local wh = math.floor( w / 2 );
	local hh = math.floor( h / 2 );
	
	i = i - wh;
	j = j - hh;
	
	if( x > 24 ) then
		
		if( w % 2 == 0 ) then
			
			i = i + 1;
			
		end
		
	end
	
	if( y > 24 ) then
		
		if( h % 2 == 0 ) then
			
			j = j + 1;
			
		end
		
	end
	
	return i, j;
	
end

function GM:RefreshInventory()
	
	if( !self.D.Inventory ) then return end
	if( !self.D.Inventory.Back ) then return end
	
	for _, v in pairs( self.D.Inventory.Back:GetChildren() ) do
		
		v:Remove();
		
	end
	
	self.D.Inventory.Slots = { };
	
	for j = 1, 10 do
		
		self.D.Inventory.Slots[j] = { };
		
		for i = 1, 6 do
			
			self.D.Inventory.Slots[j][i] = vgui.Create( "IInventorySquare", self.D.Inventory.Back );
			self.D.Inventory.Slots[j][i]:SetPos( ( i - 1 ) * 48, ( j - 1 ) * 48 );
			self.D.Inventory.Slots[j][i]:SetSize( 48, 48 );
			self.D.Inventory.Slots[j][i]:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
				
				if( bDoDrop ) then
					
					local item = droppable[1].Item;
					local metaitem = GAMEMODE:GetMetaItem( item.Class );
					
					local i, j = GAMEMODE:FindSlotsFrom( receiver.ItemX, receiver.ItemY, x, y, metaitem.W, metaitem.H );
					
					if( self.D.Inventory.Slots[j] and self.D.Inventory.Slots[j][i] ) then
						
						receiver = self.D.Inventory.Slots[j][i];
						
						if( !receiver.Item ) then
							
							if( LocalPlayer():IsInventorySlotOccupiedItemFilter( receiver.ItemX, receiver.ItemY, metaitem.W, metaitem.H, item.Key ) ) then return end
							
							if( droppable[1].Item.X > 0 and droppable[1].Item.Y > 0 ) then
								self.D.Inventory.Slots[item.Y][item.X].Item = nil;
							end
							
							if( droppable[1].Item.Primary ) then
								self.D.Inventory.Primary.Item = nil;
							end
							
							if( droppable[1].Item.Secondary ) then
								self.D.Inventory.Secondary.Item = nil;
							end
							
							receiver.Item = droppable[1];
							
							droppable[1].Item.X = receiver.ItemX;
							droppable[1].Item.Y = receiver.ItemY;
							droppable[1].Item.Primary = false;
							droppable[1].Item.Secondary = false;
							
							net.Start( "nMoveItem" );
								net.WriteFloat( item.Key );
								net.WriteFloat( receiver.ItemX );
								net.WriteFloat( receiver.ItemY );
							net.SendToServer();
							
							self:DeselectInventory();
							
							item.X = i;
							item.Y = j;
							item.Primary = false;
							item.Secondary = false;
							
							droppable[1]:SetPos( ( item.X - 1 ) * 48, ( item.Y - 1 ) * 48 );
							
						end
						
					end
					
				end
				
			end );
			self.D.Inventory.Slots[j][i].ItemX = i;
			self.D.Inventory.Slots[j][i].ItemY = j;
			
		end
		
	end
	
	if( self.D.Inventory.Primary ) then
		
		self.D.Inventory.Primary:Remove();
		
	end
	
	self.D.Inventory.Primary = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Primary:SetPos( 10, 34 + ( 48 * 10 ) + 20 );
	self.D.Inventory.Primary:SetSize( 400 - 15, 130 );
	self.D.Inventory.Primary:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			if( !GAMEMODE:GetMetaItem( droppable[1].Item.Class ).PrimaryWep ) then return end
			
			if( droppable[1].Item.X and droppable[1].Item.Y ) then
				self.D.Inventory.Slots[droppable[1].Item.Y][droppable[1].Item.X].Item = nil;
			end
			
			droppable[1].Item.X = 0;
			droppable[1].Item.Y = 0;
			droppable[1].Item.Primary = true;
			droppable[1].Item.Secondary = false;
			
			receiver.Item = droppable[1];
			
			net.Start( "nEquipPrimary" );
				net.WriteFloat( droppable[1].Item.Key );
			net.SendToServer();
			
			self:RefreshInventory();
			self:DeselectInventory();
			
		end
		
	end );
	
	if( self.D.Inventory.Secondary ) then
		
		self.D.Inventory.Secondary:Remove();
		
	end
	
	self.D.Inventory.Secondary = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Secondary:SetPos( 405, 34 + ( 48 * 10 ) + 20 );
	self.D.Inventory.Secondary:SetSize( 400 - 15, 130 );
	self.D.Inventory.Secondary:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			if( !GAMEMODE:GetMetaItem( droppable[1].Item.Class ).SecondaryWep ) then return end
			
			if( droppable[1].Item.X and droppable[1].Item.Y ) then
				self.D.Inventory.Slots[droppable[1].Item.Y][droppable[1].Item.X].Item = nil;
			end
			
			droppable[1].Item.X = 0;
			droppable[1].Item.Y = 0;
			droppable[1].Item.Primary = false;
			droppable[1].Item.Secondary = true;
			
			receiver.Item = droppable[1];
			
			net.Start( "nEquipSecondary" );
				net.WriteFloat( droppable[1].Item.Key );
			net.SendToServer();
			
			self:RefreshInventory();
			self:DeselectInventory();
			
		end
		
	end );
	
	if( self.D.Inventory.Clothing ) then
		
		self.D.Inventory.Clothing:Remove();
		
	end
	
	self.D.Inventory.Clothing = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Clothing:SetPos( 10, ( 48 * 10 ) - 286 );
	self.D.Inventory.Clothing:SetSize( 160, 320 );
	self.D.Inventory.Clothing:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			if( !GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Clothing ) then return end
			
			if( GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Gender ) then
			
				if( GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Gender != LocalPlayer():Sex() ) then return end
				
			end
			
			if( LocalPlayer():PlayerClass() != PLAYERCLASS_SURVIVOR ) then return end
			
			if( droppable[1].Item.X and droppable[1].Item.Y ) then
				self.D.Inventory.Slots[droppable[1].Item.Y][droppable[1].Item.X].Item = nil;
			end
			
			droppable[1].Item.X = 0;
			droppable[1].Item.Y = 0;
			droppable[1].Item.Clothing = true;
			droppable[1].Item.Equipped = true;
			
			receiver.Item = droppable[1];
 			
			net.Start( "nEquipClothing" );
				net.WriteFloat( droppable[1].Item.Key );
			net.SendToServer();
			
			self:RefreshInventory();
			self:DeselectInventory();
			
		end
		
	end );
	
	if( self.D.Inventory.Headgear ) then
		
		self.D.Inventory.Headgear:Remove();
		
	end
	
	self.D.Inventory.Headgear = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Headgear:SetPos( 10, 34 );
	self.D.Inventory.Headgear:SetSize( 160, 150 );
	self.D.Inventory.Headgear:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			if( !GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Headgear ) then return end
			
			if( GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Gender ) then
			
				if( GAMEMODE:GetMetaItem( droppable[1].Item.Class ).Gender != LocalPlayer():Sex() ) then return end
				
			end
			
			if( LocalPlayer():PlayerClass() != PLAYERCLASS_SURVIVOR ) then return end
			
			if( droppable[1].Item.X and droppable[1].Item.Y ) then
				self.D.Inventory.Slots[droppable[1].Item.Y][droppable[1].Item.X].Item = nil;
			end
			
			droppable[1].Item.X = 0;
			droppable[1].Item.Y = 0;
			droppable[1].Item.Headgear = true;
			droppable[1].Item.Equipped = true;
			
			receiver.Item = droppable[1];
 			
			net.Start( "nEquipHeadgear" );
				net.WriteFloat( droppable[1].Item.Key );
			net.SendToServer();
			
			self:RefreshInventory();
			self:DeselectInventory();
			
		end
		
	end );
	
	for _, v in pairs( LocalPlayer().Inventory ) do
		
		local metaitem = self:GetMetaItem( v.Class );
		
		if( v.inTraderInv ) then continue end;
		
		if( v.X != 0 and v.Y != 0 ) then
			
			local item = vgui.Create( "IItem", self.D.Inventory.Back );
			item:SetPos( ( v.X - 1 ) * 48, ( v.Y - 1 ) * 48 );
			item:SetSize( metaitem.W * 48, metaitem.H * 48 );
			item.Item = v;
			item:SetModel( metaitem.Model );
			if( metaitem.DropSkin ) then
				item:SetSkin( metaitem.DropSkin );
			end
			item:Droppable( "Items" );
			item:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
				
				if( bDoDrop ) then
					
					local item = droppable[1].Item;
					local metaitem = GAMEMODE:GetMetaItem( item.Class );
					local recmetaitem = GAMEMODE:GetMetaItem( receiver.Item.Class );
					
					if( item == receiver.Item ) then return end;
					
					if( metaitem.Stackable and recmetaitem.Stackable and receiver.Item.Class == item.Class ) then
						-- this is much better than what it was originally.
						for _,v in pairs( GAMEMODE.PossibleStackVars ) do
						
							if( item.Vars[v] and receiver.Item.Vars[v] ) then
							
								if( receiver.Item.Vars[v] + item.Vars[v] > recmetaitem.StackLimit ) then return end;
								
								receiver.Item.Vars[v] = receiver.Item.Vars[v] + item.Vars[v];
								
								net.Start( "nStackItem" );
									net.WriteFloat( item.Key );
									net.WriteFloat( receiver.Item.Key );
								net.SendToServer();
								
								LocalPlayer().Inventory[item.Key] = nil;
								self:RefreshInventory();
								self:DeselectInventory();
								
								break; -- even if there are multiple vars, it will stop at the first one found.
								
							end
							
						end
					
					end
					
				end
				
			end );
			
			self.D.Inventory.Slots[v.Y][v.X].Item = item;
			
		else
			
			if( v.Primary ) then
				
				local item = vgui.Create( "IItem", self.D.Inventory.Primary );
				item:SetPos( 0, 0 );
				item:SetSize( self.D.Inventory.Primary:GetWide(), self.D.Inventory.Primary:GetTall() );
				item.Item = v;
				item:SetModel( metaitem.Model );
				item:Droppable( "Items" );
				
				self.D.Inventory.Primary.Item = item;
				
			elseif( v.Secondary ) then
				
				local item = vgui.Create( "IItem", self.D.Inventory.Secondary );
				item:SetPos( 0, 0 );
				item:SetSize( self.D.Inventory.Secondary:GetWide(), self.D.Inventory.Secondary:GetTall() );
				item.Item = v;
				item:SetModel( metaitem.Model );
				item:Droppable( "Items" );
				
				self.D.Inventory.Secondary.Item = item;
				
			elseif( v.Clothing ) then
				
				local item = vgui.Create( "IItem", self.D.Inventory.Clothing );
				item:SetPos( 0, 0 );
				item:SetSize( self.D.Inventory.Clothing:GetWide(), self.D.Inventory.Clothing:GetTall() );
				item.Item = v;
				item:SetModel( metaitem.Model );
				if( metaitem.DropSkin ) then
					item:SetSkin( metaitem.DropSkin );
				end
				item:Droppable( "Items" );
				
				self.D.Inventory.Clothing.Item = item;
				
			elseif( v.Headgear ) then
				
				local item = vgui.Create( "IItem", self.D.Inventory.Headgear );
				item:SetPos( 0, 0 );
				item:SetSize( self.D.Inventory.Headgear:GetWide(), self.D.Inventory.Headgear:GetTall() );
				item.Item = v;
				item:SetModel( metaitem.Model );
				if( metaitem.DropSkin ) then
					item:SetSkin( metaitem.DropSkin );
				end
				item:Droppable( "Items" );
				
				self.D.Inventory.Headgear.Item = item;
				
			end
			
		end
		
	end
	
end

function GM:DeselectInventory()
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item ) then
				
				self.D.Inventory.Slots[j][i].Item.Selected = false;
				
			end
			
		end
		
	end
	
	if( self.D.Inventory.Primary.Item ) then
		self.D.Inventory.Primary.Item.Selected = false;
	end
	if( self.D.Inventory.Secondary.Item ) then
		self.D.Inventory.Secondary.Item.Selected = false;
	end
	if( self.D.Inventory.Clothing.Item ) then
		self.D.Inventory.Clothing.Item.Selected = false;
	end
	if( self.D.Inventory.Headgear.Item ) then
		self.D.Inventory.Headgear.Item.Selected = false;
	end
	
	if( self.D.Inventory.T ) then
		
		self.D.Inventory.T:SetText( "" );
		
	end
	
	if( self.D.Inventory.D ) then
		
		self.D.Inventory.D:SetText( "" );
		
	end
	
	self:RefreshItemButtons();
	
end

function GM:HandleItemClick( panel, item )
	
	local metadata = self:GetMetaItem( item.Class );
	
	if( panel.Click ) then
		
		panel:Click( item, metadata );
		return;
		
	end
	
	if( !self.D.Inventory ) then return end
	
	if( self.D.Inventory.T ) then
		
		self.D.Inventory.T:SetText( metadata.Name );
		self.D.Inventory.T:SizeToContents();
		
	end
	
	if( self.D.Inventory.D ) then
		
		if( metadata.GetDesc ) then
			
			self.D.Inventory.D:SetText( metadata:GetDesc( item ) );
			self.D.Inventory.D:PerformLayout();
			
		else
			
			self.D.Inventory.D:SetText( metadata.Desc );
			self.D.Inventory.D:PerformLayout();
			
		end
		
	end
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item ) then
				
				self.D.Inventory.Slots[j][i].Item.Selected = false;
				
			end
			
		end
		
	end
	
	if( self.D.Inventory.Primary.Item ) then
		self.D.Inventory.Primary.Item.Selected = false;
	end
	if( self.D.Inventory.Secondary.Item ) then
		self.D.Inventory.Secondary.Item.Selected = false;
	end
	if( self.D.Inventory.Clothing.Item ) then
		self.D.Inventory.Clothing.Item.Selected = false;
	end
	if( self.D.Inventory.Headgear.Item ) then
		self.D.Inventory.Headgear.Item.Selected = false;
	end
	
	panel.Selected = true;
	self:RefreshItemButtons();
	
end

function GM:GetSelectedItem()
	
	if( self.D.Inventory.Primary.Item and self.D.Inventory.Primary.Item.Selected ) then
		
		return self.D.Inventory.Primary.Item;
		
	end
	
	if( self.D.Inventory.Secondary.Item and self.D.Inventory.Secondary.Item.Selected ) then
		
		return self.D.Inventory.Secondary.Item;
		
	end
	
	if( self.D.Inventory.Clothing.Item and self.D.Inventory.Clothing.Item.Selected ) then
		
		return self.D.Inventory.Clothing.Item;
		
	end
	
	if( self.D.Inventory.Headgear.Item and self.D.Inventory.Headgear.Item.Selected ) then
		
		return self.D.Inventory.Headgear.Item;
		
	end
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item and self.D.Inventory.Slots[j][i].Item.Selected ) then
				
				return self.D.Inventory.Slots[j][i].Item;
				
			end
			
		end
		
	end
	
end

function GM:RefreshItemButtons()
	
	if( self.D.Inventory.Use ) then
		
		self.D.Inventory.Use:Remove();
		
	end
	
	if ( self.D.Inventory.Equip ) then
	
		self.D.Inventory.Equip:Remove();
	
	end
	
	if ( self.D.Inventory.Toggle ) then
	
		self.D.Inventory.Toggle:Remove();
	
	end
	
	if( self.D.Inventory.Drop ) then
		
		self.D.Inventory.Drop:Remove();
		
	end
	
	if( self.D.Inventory.Destroy ) then
		
		self.D.Inventory.Destroy:Remove();
		
	end
	
	if( self.D.Inventory.Unload ) then
		
		self.D.Inventory.Unload:Remove();
		
	end
	
	local panel = self:GetSelectedItem();
	
	if( panel ) then
		
		local item = panel.Item;
		local metaitem = self:GetMetaItem( item.Class );
		
		local y = 34 + ( 48 * 10 ) - 30;
		
		self.D.Inventory.Destroy = vgui.Create( "DButton", self.D.Inventory );
		self.D.Inventory.Destroy:SetPos( 480, y );
		self.D.Inventory.Destroy:SetSize( 200, 30 );
		self.D.Inventory.Destroy:SetFont( "Infected.TinyTitle" );
		self.D.Inventory.Destroy:SetText( "Destroy" );
		function self.D.Inventory.Destroy:DoClick()
			
			GAMEMODE:CreatePopupConfirm( "Are you sure?", "Do you want do destroy this item?", function() 
		
				net.Start( "nDestroyItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				LocalPlayer().Inventory[item.Key] = nil;
			
			end )
			
			GAMEMODE:RefreshInventory();
			GAMEMODE:DeselectInventory();
			
		end
		
		y = y - 40;
		
		self.D.Inventory.Drop = vgui.Create( "DButton", self.D.Inventory );
		self.D.Inventory.Drop:SetPos( 480, y );
		self.D.Inventory.Drop:SetSize( 200, 30 );
		self.D.Inventory.Drop:SetFont( "Infected.TinyTitle" );
		self.D.Inventory.Drop:SetText( "Drop" );
		function self.D.Inventory.Drop:DoClick()
		
			if( item.Vars.Caps ) then
				
				GAMEMODE:CreatePopupEntry( "Drop Money", item.Vars.Caps, 1, 10, function( amount ) 
			
					if( tonumber( amount ) > item.Vars.Caps ) then
					
						GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "You don't have " .. amount .. " caps." );
						return;
						
					end
					
					if( tonumber( amount ) <= 0 ) then
					
						GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "You cannot drop negative or zero caps." );
						return;
						
					end
			
					item.Vars.Caps = item.Vars.Caps - tonumber( amount );
					
					if( item.Vars.Caps == 0 ) then
						
						LocalPlayer().Inventory[item.Key] = nil;
						
						GAMEMODE:RefreshInventory();
						GAMEMODE:DeselectInventory();
						
					end
					
					net.Start( "nDropMoney" );
						net.WriteFloat( item.Key );
						net.WriteFloat( tonumber( amount ) );
					net.SendToServer();
					
					GAMEMODE:RefreshItemButtons();
				
				end )
				
			else
			
				net.Start( "nDropItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				
				LocalPlayer().Inventory[item.Key] = nil;
				
				GAMEMODE:RefreshInventory();
				GAMEMODE:DeselectInventory();
				
			end
			
		end
		
		y = y - 40;
		
		if( metaitem.GetUseText and metaitem.OnUse ) then
			
			self.D.Inventory.Use = vgui.Create( "DButton", self.D.Inventory );
			self.D.Inventory.Use:SetPos( 480, y );
			self.D.Inventory.Use:SetSize( 200, 30 );
			self.D.Inventory.Use:SetFont( "Infected.TinyTitle" );
			self.D.Inventory.Use:SetText( metaitem:GetUseText( item ) );
			function self.D.Inventory.Use:DoClick()
				
				metaitem:OnUse( item );
				
				if( item.Vars.Uses ) then
					
					item.Vars.Uses = item.Vars.Uses - 1;
					
					if( item.Vars.Uses == 0 ) then
						
						LocalPlayer().Inventory[item.Key] = nil;
						
						GAMEMODE:RefreshInventory();
						GAMEMODE:DeselectInventory();
						
					end
					
				end
				
				net.Start( "nUseItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				
				GAMEMODE:RefreshItemButtons();
				
			end
			
			y = y - 40;
			
		end
		
		if (metaitem.ToggleFunc) then
		
			self.D.Inventory.Toggle = vgui.Create( "DButton", self.D.Inventory );
			self.D.Inventory.Toggle:SetPos( 480, y );
			self.D.Inventory.Toggle:SetSize( 200,30 );
			self.D.Inventory.Toggle:SetFont( "Infected.TinyTitle" )
			self.D.Inventory.Toggle:SetText( metaitem:GetToggleText( item ) );
			function self.D.Inventory.Toggle:DoClick()
			
				metaitem:ToggleFunc(item)
				
				net.Start( "nToggleItem" )
					net.WriteFloat( item.Key )
				net.SendToServer()
				
				GAMEMODE:RefreshInventory();
				GAMEMODE:DeselectInventory();
				
				GAMEMODE:RefreshItemButtons()
				
			end
			
			y = y - 40;
		end
		
		if( ( metaitem.PrimaryWep or metaitem.SecondaryWep ) and item.Vars.Clip and item.Vars.Clip > 0 ) then
			
			self.D.Inventory.Unload = vgui.Create( "DButton", self.D.Inventory );
			self.D.Inventory.Unload:SetPos( 480, y );
			self.D.Inventory.Unload:SetSize( 200, 30 );
			self.D.Inventory.Unload:SetFont( "Infected.TinyTitle" );
			self.D.Inventory.Unload:SetText( "Unload" );
			function self.D.Inventory.Unload:DoClick()
				
				net.Start( "nUnloadItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				
				item.Vars.Clip = 0;
				
				GAMEMODE:RefreshInventory();
				GAMEMODE:DeselectInventory();
				
			end
			
			y = y - 40;
			
		end
		
	end
	
end
--[[
function GM:PrePlayerDraw( ply )
	
	if( ply:SecondaryWeaponModel() != "" ) then
		
		if( ply:GetActiveWeapon() and ply:GetActiveWeapon() != NULL and ply:GetActiveWeapon():GetModel() != ply:SecondaryWeaponModel() ) then
			
			if( !ply.SecondaryBackpack ) then
				
				ply.SecondaryBackpack = ClientsideModel( ply:SecondaryWeaponModel(), RENDERGROUP_BOTH );
				ply.SecondaryBackpack:SetPos( ply:GetPos() );
				ply.SecondaryBackpack:SetAngles( ply:GetAngles() );
				
			else
				
				local idx = ply:LookupBone( "ValveBiped.Bip01_R_Thigh" );
				local pos, ang = ply:GetBonePosition( idx );
				
				ply.SecondaryBackpack:SetPos( pos + ang:Up() * -3.5 + ang:Forward() * 5 );
				
				ang:RotateAroundAxis( ang:Up(), 180 );
				ang:RotateAroundAxis( ang:Right(), 270 );
				ang:RotateAroundAxis( ang:Forward(), 270 );
				
				ply.SecondaryBackpack:SetAngles( ang );
				
				if( ply.SecondaryBackpack:GetModel() != ply:SecondaryWeaponModel() ) then
					
					ply.SecondaryBackpack:SetModel( ply:SecondaryWeaponModel() );
					
				end
				
			end
			
		elseif( ply.SecondaryBackpack ) then
			
			ply.SecondaryBackpack = nil;
			
		end
		
	elseif( ply.SecondaryBackpack ) then
		
		
		
	end
	
end--]]