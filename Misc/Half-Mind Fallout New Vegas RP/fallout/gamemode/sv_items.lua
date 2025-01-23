local meta = FindMetaTable( "Player" );

function meta:ClearInventory()
	
	for _, v in pairs( self.Inventory ) do
		
		if( v.Primary or v.Secondary ) then
			
			self:StripWeapon( v.Class );
			
		end
		
	end
	
	self:SetPrimaryWeaponModel( "" );
	self:SetSecondaryWeaponModel( "" );
	
	self.Inventory = { };
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "';" );
	
	GAMEMODE.ItemData[self:SteamID()][self:CharID()] = { };
	
	net.Start( "nClearInventory" );
	net.Send( self );
	
end

function meta:GiveItemVars( class, vars, isTrader )

	if( self:CheckInventory() ) then return end
	
	local item = GAMEMODE:Item( class );
	
	local x, y = self:GetNextAvailableSlot( GAMEMODE:GetMetaItem( item.Class ).W, GAMEMODE:GetMetaItem( item.Class ).H );
	
	item.X = x;
	item.Y = y;
	item.Owner = self;
	
	if( vars and vars != { } ) then
		item.Vars = table.Copy( vars );
	end
	
	if( !self.NextItemKey ) then self.NextItemKey = 1 end
	item.Key = self.NextItemKey;
	self.NextItemKey = self.NextItemKey + 1;
	
	local varstr = "";
	for k, v in pairs( item.Vars ) do
		varstr = varstr .. k .. "|" .. v .. ";"
	end
	
	local p = BoolToNumber( item.Primary );
	local s = BoolToNumber( item.Secondary );
	local c,h,t;
	
	if( item.Clothing ) then
	
		c = BoolToNumber( item.Equipped );
		
	end
	
	if( item.Headgear ) then
	
		h = BoolToNumber( item.Equipped );
		
	end
	
	if( isTrader ) then
	
		t = BoolToNumber( isTrader );
		item.inTraderInv = isTrader;
		item.X = 0;
		item.Y = 0;
		
	end
	
	if( !p ) then p = 0 end
	if( !s ) then s = 0 end
	if( !c ) then c = 0 end
	if( !h ) then h = 0 end
	if( !t ) then t = 0 end
	
	mysqloo.Query( "INSERT INTO items ( SteamID, CharID, Class, X, Y, PrimaryEquipped, SecondaryEquipped, ClothingEquipped, HeadgearEquipped, InTraderInventory, Vars ) VALUES ( '" .. self:SteamID() .. "', '" .. self:CharID() .. "', '" .. item.Class .. "', '" .. item.X .. "', '" .. item.Y .. "', '" .. p .. "', '" .. s .. "', '" .. c .. "', '" .. h .. "', '" .. t .. "', '" .. varstr .. "' )",
	function( ret, query )

		item.id = query:lastInsert();
		
	end
	);
	
	net.Start( "nGiveItem" );
		net.WriteTable( item );
	net.Send( self );
	
	table.insert( self:GetItemDataByCharID( self:CharID() ), {
		CharID = self:CharID(),
		Class = item.Class,
		id = item.id,
		SteamID = self:SteamID(),
		Vars = varstr,
		X = item.X,
		Y = item.Y,
		Primary = item.Primary,
		Secondary = item.Secondary,
		Clothing = item.Clothing or false,
		Headgear = item.Headgear or false,
		Equipped = item.Equipped or false,
		inTraderInv = isTrader or false,
	} );
	
	self.Inventory[item.Key] = item;
	
end

function meta:GiveItem( item, isTrader )

	if( self:CheckInventory() ) then return end
	
	if( type( item ) == "string" ) then
		
		item = GAMEMODE:Item( item );
		
	end
	
	if( !item ) then return end;
	
	local x, y = self:GetNextAvailableSlot( GAMEMODE:GetMetaItem( item.Class ).W, GAMEMODE:GetMetaItem( item.Class ).H );
	
	item.X = x;
	item.Y = y;
	item.Owner = self;
	
	if( !self.NextItemKey ) then self.NextItemKey = 1 end
	item.Key = self.NextItemKey;
	self.NextItemKey = self.NextItemKey + 1;
	
	local varstr = "";
	for k, v in pairs( item.Vars ) do
		varstr = varstr .. k .. "|" .. v .. ";"
	end
	
	local p = BoolToNumber( item.Primary );
	local s = BoolToNumber( item.Secondary );
	local c,h,t;
	
	if( item.Clothing ) then
	
		c = BoolToNumber( item.Equipped );
		
	end
	
	if( item.Headgear ) then
	
		h = BoolToNumber( item.Equipped );
		
	end
	
	if( isTrader ) then
	
		t = BoolToNumber( isTrader );
		item.inTraderInv = isTrader;
		item.X = 0;
		item.Y = 0;
		
	end
	
	if( !p ) then p = 0 end
	if( !s ) then s = 0 end
	if( !c ) then c = 0 end
	if( !h ) then h = 0 end
	if( !t ) then t = 0 end
	
	mysqloo.Query( "INSERT INTO items ( SteamID, CharID, Class, X, Y, PrimaryEquipped, SecondaryEquipped, ClothingEquipped, HeadgearEquipped, InTraderInventory, Vars ) VALUES ( '" .. self:SteamID() .. "', '" .. self:CharID() .. "', '" .. item.Class .. "', '" .. item.X .. "', '" .. item.Y .. "', '" .. p .. "', '" .. s .. "', '" .. c .. "', '" .. h .. "', '" .. t .. "', '" .. varstr .. "' )",
	function( ret, query )

		item.id = query:lastInsert();
		
	end
	);
	
	net.Start( "nGiveItem" );
		net.WriteTable( item );
	net.Send( self );
	
	table.insert( self:GetItemDataByCharID( self:CharID() ), {
		CharID = self:CharID(),
		Class = item.Class,
		id = item.id,
		SteamID = self:SteamID(),
		Vars = varstr,
		X = item.X,
		Y = item.Y,
		Primary = item.Primary,
		Secondary = item.Secondary,
		Clothing = item.Clothing or false,
		Headgear = item.Headgear or false,
		Equipped = item.Equipped or false,
		inTraderInv = isTrader or false,
	} );
	
	self.Inventory[item.Key] = item;
	
	return item.Key;
	
end

function meta:RemoveItem( key )
	
	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "' AND Class = '" .. self.Inventory[key].Class .."';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			self:GetItemDataByCharID( self:CharID() )[k] = nil;
			
		end
		
	end
	
	local metaitem = GAMEMODE:GetMetaItem( self.Inventory[key].Class );
	
	if( metaitem.PrimaryWep or metaitem.SecondaryWep ) then
		
		self:StripWeapon( self.Inventory[key].Class );
		
		if( metaitem.PrimaryWep ) then
			
			self:SetPrimaryWeaponModel( "" );
			
		else
			
			self:SetSecondaryWeaponModel( "" );
			
		end
		
	end
	
	if( metaitem.Clothing and self.Inventory[key].Equipped ) then
	
		self.Inventory[key].Equipped = false;
	
		local originalMdl = self:GetCharacterField( "Model", GAMEMODE:GetModelGender( "models/thespireroleplay/humans/group100", self:Sex() ) ); -- doesnt call db
		self:SetModel( originalMdl );
		
		if( metaitem.Bodygroups ) then
		
			for _,v in pairs( metaitem.Bodygroups ) do
			
				self:SetBodygroup( v.a, 0 );
				
			end
			
		end
		
		if( metaitem.Skin ) then
		
			self:SetSkin( 0 );
			
		end
		
		net.Start( "nReceiveDummyItem" );
			net.WriteEntity( self );
			net.WriteInt( self.Inventory[key].id, 32 );
			net.WriteString( self.Inventory[key].Class );
			net.WriteBool( self.Inventory[key].Equipped );
		net.Broadcast();
	
	end
	
	if( metaitem.Headgear and self.Inventory[key].Equipped ) then
	
		self.Inventory[key].Equipped = false;
	
		local headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, self:Sex() );
		
		if( metaitem.UseSuffix ) then
		
			headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, self:Sex(), true );
			
		end
		
		net.Start( "nReceiveDummyItem" );
			net.WriteEntity( self );
			net.WriteInt( self.Inventory[key].id, 32 );
			net.WriteString( self.Inventory[key].Class );
			net.WriteBool( self.Inventory[key].Equipped );
		net.Broadcast();
	
	end
	
	net.Start( "nRemoveItem" );
		net.WriteFloat( key );
	net.Send( self );
	
	self.Inventory[key] = nil;
	
end

function meta:MoveItem( key, x, y )

	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( item.Primary ) then
		
		self:MoveItemEquipped( key, x, y, true );
		return;
		
	elseif( item.Secondary ) then
		
		self:MoveItemEquipped( key, x, y, false );
		return;
		
	elseif( item.Clothing ) then

		self:MoveItemEquipped( key, x, y, false, true );
		return;
		
	elseif( item.Headgear ) then

		self:MoveItemEquipped( key, x, y, false, false, true );
		return;
		
	end
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, metaitem.W, metaitem.H, key ) ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = x;
			v.Y = y;
			
		end
		
	end
	
	net.Start( "nMoveItem" );
		net.WriteFloat( key );
		net.WriteFloat( x );
		net.WriteFloat( y );
	net.Send( self );
	
	item.X = x;
	item.Y = y;
	
end

function meta:MoveItemEquipped( key, x, y, p, c, h )

	if( !self.Inventory[key] ) then return end
	
	local metaitem = GAMEMODE:GetMetaItem( self.Inventory[key].Class );
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, metaitem.W, metaitem.H, key ) ) then return end
	
	local primary = "PrimaryEquipped = '1'";
	
	if( !p ) then
		
		primary = "SecondaryEquipped = '1'";
		
	end
	
	if( c ) then
	
		primary = "ClothingEquipped = '1'";
	
	end
	
	if( h ) then
	
		primary = "HeadgearEquipped = '1'";
	
	end
	
	mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "', PrimaryEquipped = '0', SecondaryEquipped = '0', ClothingEquipped = '0', HeadgearEquipped = '0' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND " .. primary );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			v.X = x;
			v.Y = y;
			v.Primary = false;
			v.Secondary = false;
			if( metaitem.UnequipSound and v.Equipped ) then
		
				self:EmitSound( metaitem.UnequipSound );
		
			end
			v.Equipped = false;
			
		end
		
	end
	
	net.Start( "nMoveItem" );
		net.WriteFloat( key );
		net.WriteFloat( x );
		net.WriteFloat( y );
	net.Send( self );
	
	self.Inventory[key].X = x;
	self.Inventory[key].Y = y;
	self.Inventory[key].Primary = false;
	self.Inventory[key].Secondary = false;
	self.Inventory[key].Equipped = false;
	
	if( metaitem.PrimaryWep ) then
		
		self:StripWeapon( self.Inventory[key].Class );
		self:SetPrimaryWeaponModel( "" );
		
	elseif( metaitem.SecondaryWep ) then
		
		self:StripWeapon( self.Inventory[key].Class );
		self:SetSecondaryWeaponModel( "" );
		
	end
	
	if( metaitem.Clothing ) then
	
		local originalMdl = self:GetCharacterField( "Model", GAMEMODE:GetModelGender( "models/thespireroleplay/humans/group100", self:Sex() ) ); -- doesnt call db
	
		local oldArms,oldSkin = GAMEMODE:GetModelArms( self:GetModel(), self:Face() ); -- although skin shouldnt ever change, we should still make sure we get it right
		local newArms,newSkin = GAMEMODE:GetModelArms( originalMdl, self:Face() );
		self:SetModel( originalMdl );
		
		if( metaitem.Bodygroups ) then
		
			for _,v in pairs( metaitem.Bodygroups ) do
			
				self:SetBodygroup( v.a, 0 );
				
			end
			
		end
		
		if( metaitem.Skin ) then
		
			self:SetSkin( 0 );
			
		end
		
		net.Start( "nReceiveDummyItem" );
			net.WriteEntity( self );
			net.WriteInt( self.Inventory[key].id, 32 );
			net.WriteString( self.Inventory[key].Class );
			net.WriteBool( self.Inventory[key].Equipped );
		net.Broadcast();
	
	end
	
	if( metaitem.Headgear ) then
	
		local headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, self:Sex() );
		
		if( metaitem.UseSuffix ) then
		
			headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, self:Sex(), true );
			
		end
		
		net.Start( "nReceiveDummyItem" );
			net.WriteEntity( self );
			net.WriteInt( self.Inventory[key].id, 32 );
			net.WriteString( self.Inventory[key].Class );
			net.WriteBool( self.Inventory[key].Equipped );
		net.Broadcast();
	
	end
	
end

function meta:UseItem( key )
	
	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.OnUse ) then return end
	
	metaitem:OnUse( item, self );
	
	if( metaitem.UseHealth ) then
		
		self:SetHealth( math.Clamp( self:Health() + metaitem.UseHealth, 0, self:GetMaxHealth() ) );
		
	end
	
	if( metaitem.UseSound ) then
		
		self:EmitSound( metaitem.UseSound );
		
	end
	
	if( item.Vars.Uses ) then
		
		if( item.Vars.Uses > 0 ) then
			
			item.Vars.Uses = item.Vars.Uses - 1;
			
			if( item.Vars.Uses == 0 and metaitem.RemoveOnUse ) then
				
				self:RemoveItem( key );
				
			else
				
				self:UpdateItemVars( key );
				
			end
			
		end
		
	end
	
end

function meta:ToggleItem( key )

	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );

	if( !metaitem.ToggleFunc ) then	return end
	
	metaitem:ToggleFunc( item, self );
	
	if( metaitem.UseSound ) then
		
		self:EmitSound( metaitem.UseSound );
		
	end
	
end

function meta:EquipClothing( key )

	if( !self.Inventory[key] ) then return end
	
	net.Start( "nEquipClothing" );
		net.WriteFloat( key );
	net.Send( self );
	
end

function GM:CreateItemEnt( pos, ang, class, vars )
	
	local ent = ents.Create( "inf_item" );
	ent:SetPos( pos );
	ent:SetAngles( ang );
	ent:SetItemClass( class );
	
	if( vars ) then
		
		ent:SetVars( vars );
		
	else
		
		ent:SetVars( self:Item( class ).Vars );
		
	end
	
	ent:Spawn();
	ent:Activate();
	
	return ent;
	
end

function GM:NumItems()
	
	local c = 0;
	
	for _, v in pairs( ents.FindByClass( "inf_item" ) ) do
		
		if( v:GetAutospawn() ) then
			
			c = c + 1;
			
		end
		
	end
	
	return c;
	
end

function GM:SpawnItemRandom()
	
	local rarity = math.random( 1, 100 );
	local item;
	
	if( rarity > 98 ) then -- Ammo: 2%
		
		item = self:GetItemByTier( 5 );
		
	elseif( rarity > 94 ) then -- Primary weapons: 4%
		
		item = self:GetItemByTier( 4 );
		
	elseif( rarity > 85 ) then -- Secondary weapons: 9%
		
		item = self:GetItemByTier( 3 );
		
	elseif( rarity > 50 ) then -- Tier 2: 35%
		
		item = self:GetItemByTier( 2 );
		
	else -- Tier 1: 50%
		
		item = self:GetItemByTier( 1 );
		
	end
	
	if( !item ) then
		
		self:Log( "autospawn", "E", "Couldn't autospawn item - no item of tier!" );
		return;
		
	end
	
	local tab = { };
	
	for _, v in pairs( self.Nodes ) do
		
		if( self:IsSpotClear( v ) and !self:CanPlayerSeeZombieAt( v ) ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	if( #tab == 0 ) then
		
		self:Log( "autospawn", "E", "Couldn't autospawn item - no nodes!" );
		return;
		
	end
	
	local pos = table.Random( tab );
	
	local ent = self:CreateItemEnt( pos, Angle( 0, math.random( -180, 180 ), 0 ), item );
	ent:SetAutospawn( true );
	ent:SetAutospawnTime( CurTime() );
	
	self:Log( "autospawn", "A", "Created item " .. item .. " at Vector( " .. math.Round( pos.x ) .. ", " .. math.Round( pos.y ) .. ", " .. math.Round( pos.z ) .. " )." );
	
end

function meta:TakeMoney( amount ) -- helper function

	if( !self.Inventory ) then return end
	
	for _,item in pairs( self.Inventory ) do
	
		if( item.Vars.Caps ) then
		
			if( item.Vars.Caps >= amount ) then
			
				item.Vars.Caps = item.Vars.Caps - amount;
				self:UpdateItemVars( item.Key );
				
				if( item.Vars.Caps <= 0 ) then
				
					self:RemoveItem( item.Key );
					return true;
					
				end
				
				net.Start( "nTakeMoney" );
					net.WriteFloat( item.Key );
					net.WriteFloat( amount );
				net.Send( self );
				
				return true;
				
			end
			
		end
	
	end
	
	return false;

end

local function nMoveItem( len, ply )
	
	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	ply:MoveItem( key, x, y );
	
end
net.Receive( "nMoveItem", nMoveItem );

local function nUseItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:UseItem( key );
	
end
net.Receive( "nUseItem", nUseItem );

local function nToggleItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:ToggleItem( key );
	
end
net.Receive( "nToggleItem", nToggleItem );

local function nStackItem( len, ply )
	
	local dropper = net.ReadFloat();
	local receiver = net.ReadFloat();
	local receivermeta = GAMEMODE:GetMetaItem( ply.Inventory[receiver].Class )
	
	if( !ply.Inventory[dropper] ) then return end
	if( !ply.Inventory[receiver] ) then return end
	
	local tbl_DropItem = ply.Inventory[dropper];
	local tbl_Receiveritem = ply.Inventory[receiver];
	
	if( ply.Inventory[dropper].Vars ) then
		-- this went from 30+ lines to 14 lines.
		for _,v in pairs( GAMEMODE.PossibleStackVars ) do
		
			if( tbl_Receiveritem.Vars[v] and tbl_DropItem.Vars[v] ) then
			
				if( tbl_Receiveritem.Vars[v] + tbl_DropItem.Vars[v] > receivermeta.StackLimit ) then return end
			
				tbl_Receiveritem.Vars[v] = tbl_Receiveritem.Vars[v] + tbl_DropItem.Vars[v];
				
				ply:UpdateItemVars( receiver );
				
				break;
				
			end
		
		end
		
	end
	
	ply:RemoveItem( dropper );
	
end
net.Receive( "nStackItem", nStackItem );


local function nDropMoney( len, ply )
	
	local key = net.ReadFloat();
	local amount = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	if( ply.Inventory[key].Class != "caps" ) then return end
	if( ply.Inventory[key].Vars.Caps < amount ) then return end;
	
	if( ply.Inventory[key].Vars.Caps >= amount ) then
		
		ply.Inventory[key].Vars.Caps = ply.Inventory[key].Vars.Caps - amount;
		
		if( ply.Inventory[key].Vars.Caps <= 0 ) then
			
			ply:RemoveItem( key );
			
		else
			
			ply:UpdateItemVars( key );
			
		end
		
	end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), "caps", { Caps = amount } );
	
end
net.Receive( "nDropMoney", nDropMoney );

local function nDropItem( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), ply.Inventory[key].Class, ply.Inventory[key].Vars );
	ply:RemoveItem( key );
	
end
net.Receive( "nDropItem", nDropItem );

local function nDestroyItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:RemoveItem( key );
	
end
net.Receive( "nDestroyItem", nDestroyItem );

local function nEquipPrimary( len, ply )

	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.PrimaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '1', SecondaryEquipped = '0' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = true;
			v.Secondary = false;
			
		end
		
	end
	
	item.X = 0;
	item.Y = 0;
	item.Primary = true;
	item.Secondary = false;
	
	ply:Give( item.Class );
	ply:SetPrimaryWeaponModel( metaitem.Model );
	
	if( item.Vars.Clip ) then
		
		ply:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
		
	end
	
end
net.Receive( "nEquipPrimary", nEquipPrimary );

local function nEquipSecondary( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.SecondaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '0', SecondaryEquipped = '1' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = false;
			v.Secondary = true;
			
		end
		
	end
	
	item.X = 0;
	item.Y = 0;
	item.Primary = false;
	item.Secondary = true;
	
	ply:Give( item.Class );
	ply:SetSecondaryWeaponModel( metaitem.Model );
	
	if( item.Vars.Clip ) then
		
		ply:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
		
	end
	
end
net.Receive( "nEquipSecondary", nEquipSecondary );

local function nEquipClothing( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.Clothing ) then return end
	
	if( metaitem.Gender ) then
	
		if( metaitem.Gender != ply:Sex() ) then return end;
		
	end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', ClothingEquipped = '1' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Clothing = true;
			v.Equipped = true;
			
		end
		
	end
	
	local mdlStr = GAMEMODE:GetModelGender( metaitem.PlayerModel, ply:Sex() );
	local oldArms,oldSkin = GAMEMODE:GetModelArms( ply:GetModel(), ply:Face() );
	local newArms,newSkin = GAMEMODE:GetModelArms( mdlStr, ply:Face() );
	
	item.X = 0;
	item.Y = 0;
	item.Equipped = true;
	item.Clothing = true;
	
	if( metaitem.EquipSound ) then
		
		ply:EmitSound( metaitem.EquipSound );
		
	end
	
	if( metaitem.UseRealModelPath ) then
	
		mdlStr = metaitem.PlayerModel;
		newArms = metaitem.HandsPath;
		
	end
	
	ply:SetModel( mdlStr );
	
	if( metaitem.Bodygroups ) then
	
		for _,v in pairs( metaitem.Bodygroups ) do
		
			ply:SetBodygroup( v.a, v.b );
		
		end
		
	end
	
	if( metaitem.Skin ) then

		ply:SetSkin( metaitem.Skin );
		
	end
	
	net.Start( "nReceiveDummyItem" );
		net.WriteEntity( ply );
		net.WriteInt( item.id, 32 );
		net.WriteString( item.Class );
		net.WriteBool( item.Equipped );
	net.Broadcast();
	
end
net.Receive( "nEquipClothing", nEquipClothing );

local function nEquipHeadgear( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.Headgear ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', HeadgearEquipped = '1' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Headgear = true;
			v.Equipped = true;
			
		end
		
	end
	
	local headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, ply:Sex() );
	if( metaitem.UseSuffix ) then
	
		headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, ply:Sex(), true ); -- you know, we could just send metaitem.UseSuffix or false.
		
	end
	local bgcategory = metaitem.Bodygroup or 0;
	local bgvalue = metaitem.BodygroupValue or 0;
	
	item.X = 0;
	item.Y = 0;
	item.Equipped = true;
	item.Headgear = true;
	
	if( metaitem.EquipSound ) then
		
		ply:EmitSound( metaitem.EquipSound );
		
	end
	
	net.Start( "nReceiveDummyItem" );
		net.WriteEntity( ply );
		net.WriteInt( item.id, 32 );
		net.WriteString( item.Class );
		net.WriteBool( item.Equipped );
	net.Broadcast();
	
end
net.Receive( "nEquipHeadgear", nEquipHeadgear );

local function nUnloadItem( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !item.Vars.Clip ) then return end
	if( item.Vars.Clip <= 0 ) then return end
	
	local x, y = ply:GetNextAvailableSlot( metaitem.W, metaitem.H );
	
	if( x > 0 and y > 0 ) then
		
		ply:GiveItemVars( weapons.Get( item.Class ).ItemAmmo, { Ammo = item.Vars.Clip } );
		
		item.Vars.Clip = 0;
		ply:UpdateItemVars( key );
		
		local wep = ply:GetWeapon( item.Class );
		
		if( wep and wep:IsValid() ) then
			
			wep:SetClip1( 0 );
			
		end
		
	end
	
end
net.Receive( "nUnloadItem", nUnloadItem );

local function nMoveToInventory( len, ply )

	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	if( !ply.Inventory[key].inTraderInv ) then return end
	if( !ply:IsTrader() ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	local x,y = ply:GetNextAvailableSlot( metaitem.W, metaitem.H );
	
	if( x > 0 and y > 0 ) then
	
		item.X = x;
		item.Y = y;
		item.inTraderInv = false;
		
		mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "', InTraderInventory = '0' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND id = '" .. item.id .. "';" );
	
		net.Start( "nMoveToInventory" );
			net.WriteFloat( item.Key );
			net.WriteFloat( x );
			net.WriteFloat( y );
		net.Send( ply );
	
	end

end
net.Receive( "nMoveToInventory", nMoveToInventory );

local function nSellItem( len, ply ) -- need to check tier and confirm trader flags

	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	if( !ply:IsTrader() ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	ply:RemoveItem( key );
	ply:GiveItemVars( "caps", { Caps = metaitem.BasePrice * 0.85 } );

end
net.Receive( "nSellItem", nSellItem );

local function nBuyItem( len, ply ) -- need to check tier and confirm trader flags

	local str_ItemClass = net.ReadString();
	local metaitem = GAMEMODE:GetMetaItem( str_ItemClass );
	
	if( !ply:IsTrader() ) then return end
	
	if( ply:TakeMoney( metaitem.BasePrice ) ) then
	
		ply:GiveItem( str_ItemClass, true );
		
	end

end
net.Receive( "nBuyItem", nBuyItem );