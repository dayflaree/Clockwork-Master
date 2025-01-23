
PlayersJoined = { }

SQLLiteMode = false;

if( !SQLLiteMode ) then
	
	require( "mysqloo" );
	
end

-- if( !SQLLiteMode and !mysqloo ) then
	
	-- MsgC( Color( 255, 0, 0, 255 ), "ERROR: NO MYSQLOO MODULE FOUND. Reverting to SQLLite." );
	-- SQLLiteMode = true;
	
-- end

function escSingle( str )
	
	str = string.gsub( str, "'", "" );
	str = "'" .. str .. "'";
	return str;
	
end

if( SQLLiteMode ) then
	
	sql.Query( "CREATE TABLE IF NOT EXISTS epi_characters ( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Name TEXT, SteamID TEXT, Class TEXT, Age TEXT, PhysDesc TEXT, OriMdl TEXT, CharFlags TEXT, HeavyWeaponry TEXT, LightWeaponry TEXT, HasBackpack INTEGER, HasPouch INTEGER, HWAmmo INTEGER, LWAmmo INTEGER, HWDeg INTEGER, LWDeg INTEGER );" );
	sql.Query( "CREATE TABLE IF NOT EXISTS epi_inv ( id INTEGER NOT NULL, itemid TEXT, x INTEGER, y INTEGER, amt INTEGER, inv INTEGER, SteamID TEXT );" );
	sql.Query( "CREATE TABLE IF NOT EXISTS epi_recog ( i INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, id INTEGER, recogid INTEGER, SteamID TEXT );" );
	sql.Query( "CREATE TABLE IF NOT EXISTS epi_users ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, SteamName TEXT, SteamID TEXT, IP TEXT, Date TEXT, Flags TEXT, PlayerDesc TEXT );" );
	
	function PurgeSQL()
		
		sql.Query( "DELETE FROM sqlite_sequence WHERE name = 'epi_recog';" );
		sql.Query( "DELETE FROM sqlite_sequence WHERE name = 'epi_characters';" );
		sql.Query( "DELETE FROM sqlite_sequence WHERE name = 'epi_inv';" );
		sql.Query( "DELETE FROM sqlite_sequence WHERE name = 'epi_users';" );
		sql.Query( "DROP TABLE 'epi_recog';" );
		sql.Query( "DROP TABLE 'epi_characters';" );
		sql.Query( "DROP TABLE 'epi_inv';" );
		sql.Query( "DROP TABLE 'epi_users';" );
		
	end
	
end

epdb = nil;
	
function ConnectToMySQL()
	
	if( SQLLiteMode ) then return end
	
	if( !mysqloo ) then error( "SQL Error: No module detected!" ) return end
	
	//if( not isDedicatedServer() ) then
		
		epdb = mysqloo.connect( "HOST", "USERNAME", "PASSWORD", "DATABASE" );
	
	//else
		
	//	epdb = mysqloo.connect( "127.0.0.1", "necrophiliac", "danceconmi", "necrotorrington" );
		
	//end
	
	epdb.onConnectionFailed = function( db, e )
		
		Msg( "=== MYSQL ERROR === \n" .. tostring(e) .. "\n" );
		
	end
	
	epdb.onConnected = function()
		
		Msg( "=== MYSQL CONNECTION ESTABLISHED === \n" );
		
	end
	
	epdb:connect();

end

ConnectToMySQL();

function CheckSQLStatus()
	
	if( SQLLiteMode ) then return end
	if( !epdb ) then return end
	
	local status = epdb:status();
	
	if( status == 0 ) then
		
		-- Connected
		
	elseif( status == 1 ) then
		
		-- Connecting
		
	elseif( status == 2 ) then
		
		-- Disconnected
		Msg( "=== MYSQL DISCONNECTED, RECONNECTING... ===\n" );
		ConnectToMySQL();
		
	else
		
		-- Some error occurred in the module
		
	end
	
end
timer.Create( "CheckSQLStatus", 30, 0, CheckSQLStatus );

function esc( str )
	
	if( SQLLiteMode ) then
		return SQLStr( tostring( str or "" ) );
	end
	return epdb:escape( tostring( str or "" ) );

end

function sqlDoQuery( str, tryonce )
	
	if( SQLLiteMode ) then
		
		local ret = sql.Query( str );
		
		if( !ret ) then
			
			return { };
			
		end
		
		for k, v in pairs( ret ) do
			
			if( type( v ) == "table" ) then
				
				for m, n in pairs( v ) do
					
					if( n == "NULL" ) then
						
						ret[k][m] = "";
						
					end
					
				end
				
			end
			
			if( v == "NULL" ) then
				
				ret[k] = "";
				
			end
			
		end
		return ret;
		
	end

	local tbl = { };
	local succ = false;
	local q = epdb:query( str );
	q.onSuccess = function()
		tbl = q:getData();
		succ = true;
		
	end
	q.onError = function( q, e )
		print("================================");
		print("MySQL Error: " .. e);
		print("!!!!!!!!!!!!!!!!!!!!!!");
		print(str);
		print("================================!");
		
		if( e == "MySQL server has gone away" and not tryonce ) then
			
			ConnectToMySQL();
			return sqlDoQuery( str, true );
			
		end
		
	end
	q:start();
	q:wait();
	
	return tbl;
	
end

local CurSQLTable;
local CurSQLVars = { }
local CurSQLConditions = { }

function sqlOpStart( table )

	CurSQLTable = table;
	CurSQLVars = { };
	CurSQLConditions = { };

end

function sqlOpDelete()

	local sqlstr = "DELETE FROM " .. CurSQLTable .. " WHERE ";
	
	local andc = false;
	
	for k, v in pairs( CurSQLConditions ) do
	
		if( andc ) then
		
			sqlstr = sqlstr .. " AND ";
		
		end
		
		andc = true;
	
		sqlstr = sqlstr .. v.Name .. " = '" .. v.Val .. "'";
	
	end
	
	sqlDoQuery( sqlstr );
	
end

function sqlOpUpdate()

	local sqlstr = "UPDATE " .. CurSQLTable .. " SET ";
	
	local comma = false;
	
	for k, v in pairs( CurSQLVars ) do
	
		if( comma ) then
		
			sqlstr = sqlstr .. ", ";
		
		end
		
		comma = true;
	
		sqlstr = sqlstr .. v.Name .. " = '" .. v.Val .. "'";
	
	end
	
	sqlstr = sqlstr .. " WHERE ";
	
	local andc = false;
	
	for k, v in pairs( CurSQLConditions ) do
	
		if( andc ) then
		
			sqlstr = sqlstr .. " AND ";
		
		end
		
		andc = true;
		
		sqlstr = sqlstr .. v.Name .. " = '" .. v.Val .. "'";
	
	end
	
	sqlDoQuery( sqlstr );

end

function sqlOpInsert()

	local sqlstr = "INSERT INTO " .. CurSQLTable .. " (";
	
	local comma = false;
	
	for k, v in pairs( CurSQLVars ) do
	
		if( comma ) then
		
			sqlstr = sqlstr .. ", ";
		
		end
		
		comma = true;
	
		sqlstr = sqlstr .. v.Name;
	
	end
	
	sqlstr = sqlstr .. ") VALUES ('";
	
	local comma = false;
	
	for k, v in pairs( CurSQLVars ) do
	
		if( comma ) then
		
			sqlstr = sqlstr .. "', '";
		
		end
		
		comma = true;
		
		sqlstr = sqlstr .. v.Val;
	
	end	
	
	sqlstr = sqlstr .. "')";
	
	sqlDoQuery( sqlstr );

end

function sqlOpAddVar( var, val )

	table.insert( CurSQLVars, { Name = var, Val = esc( val ) } );
	
end

function sqlOpAddCondition( var, val )

	table.insert( CurSQLConditions, { Name = var, Val = esc( val ) } );
	
end

function sqlTableHasEntryWithValue( table, field, value )

	local table = sqlDoQuery( "SELECT * FROM " .. table .. " WHERE " .. field .. " = '" .. esc( value ).."'" );

	if( table and table[1] ) then return true; end
	
	return false;

end

function sqlRemoveAnyEntryWithField( table, field, value )

	local table = sqlDoQuery( "DELETE FROM " .. table .. " WHERE " .. field .. " = '" .. esc( value ).."'" );
	
	if( table and table[1] ) then return true; end
	
	return false;	

end

------------------------------------------------------------
-- PLAYER / MYSQL INTERACTION
------------------------------------------------------------

local meta = FindMetaTable( "Player" );

function meta:sqlCharacterWithNameExists( name )

	local table = sqlDoQuery( "SELECT * FROM epi_characters WHERE Name = '" .. esc( name ) .. "' AND SteamID = '" .. esc( self:SteamID() ).."'" );
	
	if( table and table[1] ) then return true; end
	
	return false;

end

function meta:sqlCharacterExists()

	local table = sqlDoQuery( "SELECT * FROM epi_characters WHERE Name = '" .. esc( self:RPNick() ) .. "' AND SteamID = '" .. esc( self:SteamID() ).."'" );
	
	if( table and table[1] ) then return true; end
	
	return false;

end

function meta:sqlGetCharacterID()

	local table = sqlDoQuery( "SELECT id FROM epi_characters WHERE Name = '" .. esc( self:RPNick() ) .. "' AND SteamID = '" .. esc( self:SteamID() ).."'" );

	if( not table or not table[1] or not table[1].id ) then return 0; end

	return table[1].id;
	
end

function meta:sqlGetCharactersTable()

	local table = sqlDoQuery( "SELECT id, Name FROM epi_characters WHERE SteamID = '" .. esc( self:SteamID() ).."'" );

	table = table or { };
	
	return #table, table;

end

function meta:sqlGetCharactersTableExceptCurrent()

	local table = sqlDoQuery( "SELECT id, Name FROM epi_characters WHERE SteamID = '" .. esc( self:SteamID() ) .. "' AND id != " .. esc( self:GetPlayerMySQLCharID() ) );

	table = table or { };
	
	return #table, table;

end

function meta:sqlOpenSceneSendLoadableCharacters( ReloadCharList )

	local numchars, table = self:sqlGetCharactersTableExceptCurrent();
	local delay = 0;

	if( numchars > 0 ) then

		for k, v in pairs( table ) do
	
			local f = function()
		
				umsg.Start( "ACL", self );
					umsg.String( v.Name );
				umsg.End();
				
			end
			timer.Simple( delay, f );
			
			delay = delay + .03;

		end
	
	end
	
	if( ReloadCharList ) then
	
		timer.Simple( delay, self.CallEvent, self, "UCL" );
		
	end

end

function meta:sqlDeleteCharacter( id )
	
	local numchars, table = self:sqlGetCharactersTableExceptCurrent();

	if( table and table[id] ) then
	
		sqlOpStart( "epi_characters" );
			sqlOpAddCondition( "id", table[id].id );
			sqlOpAddCondition( "SteamID", self:SteamID() );
		sqlOpDelete();	
	
	end
	
end

function meta:sqlAttemptToSaveAmmo()

	local update = false;
		
	sqlOpStart( "epi_characters" );

		if( self:GetPlayerLWAmmo() ~= self:GetPlayerLastLWAmmo() ) then
		
			sqlOpAddVar( "LWAmmo", self:GetPlayerLWAmmo() );
			update = true;
		
		end
		
		if( self:GetPlayerHWAmmo() ~= self:GetPlayerLastHWAmmo() ) then
		
			sqlOpAddVar( "HWAmmo", self:GetPlayerHWAmmo() );
			update = true;
		
		end
		sqlOpAddCondition( "SteamID", self:SteamID() );
		sqlOpAddCondition( "id", self:GetPlayerMySQLCharID() );
		
	if( update ) then
	
		sqlOpUpdate( true );	
		
	end
	
	self:SetPlayerLastLWAmmo( self:GetPlayerLWAmmo() );
	self:SetPlayerLastHWAmmo( self:GetPlayerHWAmmo() );

end

function meta:sqlAttemptLoadCharacter( id )
	
	local numchars, table = self:sqlGetCharactersTableExceptCurrent();
	
	if( table and table[id] ) then

		if( table[id].id == self:GetPlayerMySQLCharID() ) then 
		
			self:SetPlayerDidInitialCC( true );
			self:GetTable().CanSeePlayerMenu = true;
			self:ApplyMovementSpeeds();
			self:MakeInvisible( false );
			self:Freeze( false );
			return true; 
			
		end
	
		local data = sqlDoQuery( "SELECT * FROM epi_characters WHERE SteamID = '" .. esc( self:SteamID() ) .. "' AND id = " .. esc( table[id].id ) );
		local invdata = sqlDoQuery( "SELECT * FROM epi_inv WHERE SteamID = '" .. esc( self:SteamID() ) .. "' AND id = " .. esc( table[id].id ) );
		
		if( data and data[1].id ) then
			
			if( data[1].Class ~= "Infected" and
				string.find( string.lower( data[1].OriMdl ), "infected/necropolis" ) ) then
				
				data[1].Class = "Infected";
				
			end
			
			self:TransferToNewCharacter( data[1].Name, data[1].Class, data[1].Age, data[1].PhysDesc, data[1].OriMdl, 1 ); -- height is taken care of below Tag: SKIN
	
			local hweap = data[1].HeavyWeaponry;
			local lweap = data[1].LightWeaponry;
			
			local hwdeg = tonumber( data[1].HWDeg );
			local lwdeg = tonumber( data[1].LWDeg );
			
			local hweapitem = ItemsData[hweap];
			local lweapitem = ItemsData[lweap];
			
			if( hweapitem ) then
				
				hweapitem.HealthAmt = hwdeg;
				
				self:SetHeavyWeapon( hweapitem );
				self:GetTable().HeavyWeapon.Data.HealthAmt = hwdeg;
				timer.Simple( 1, function()
					
					self:SetHeavyWeaponAmmo( tonumber( data[1].HWAmmo ) or 0 );
					self:SetPlayerLastHWAmmo( tonumber( data[1].HWAmmo ) or 0 );
					
				end );
				
			end
			
			if( lweapitem ) then
				
				lweapitem.HealthAmt = lwdeg;
				
				self:SetLightWeapon( lweapitem );
				self:GetTable().LightWeapon.Data.HealthAmt = lwdeg;
				timer.Simple( 1, function()
				
					self:SetLightWeaponAmmo( tonumber( data[1].LWAmmo ) or 0 );
					self:SetPlayerLastLWAmmo( tonumber( data[1].LWAmmo ) or 0 );
					
				end );
			
			end
			
			if( tonumber( data[1].HasBackpack ) == 1 ) then
			
				timer.Simple( .5, CallItemFunc, "backpack", self, "Use" );
			
			end
			
			if( tonumber( data[1].HasPouch ) == 1 ) then
			
				timer.Simple( .5, CallItemFunc, "pouch", self, "Use" );
			
			end
			
			if( invdata and invdata[1] ) then
				local delay = 1;
		
				for k, v in pairs( invdata ) do
				
					local itemdata = { }
					
					if( ItemsData[v.itemid] ) then
						for n, m in pairs( ItemsData[v.itemid] ) do
						
							itemdata[n] = ItemsData[v.itemid][n];
						
						end
						
						if( itemdata.ID == "binoculars" ) then
							
							self:SetCanZoom( true );
							
						end
						
						itemdata.Amount = tonumber( v.amt );
						
						timer.Simple( delay, self.AttemptToPutInInventoryAt, self, itemdata, tonumber( v.inv ), tonumber( v.x ), tonumber( v.y ), nil, true );
						delay = delay + .2;
						
					end
				
				end
				
			end
	
			return true;
	
		end

	end	
	
	return false;

end

function meta:sqlUpdateUsersField( var, val, stream )

	local id = self:SteamID();
	
	sqlOpStart( "epi_users" );
		sqlOpAddVar( var, val );
		sqlOpAddCondition( "SteamID", id );
	sqlOpUpdate( stream );		

end

function meta:sqlUpdateField( var, val, stream )

	local id = self:SteamID();
	local uid = self:GetPlayerMySQLCharID();

	sqlOpStart( "epi_characters" );
		sqlOpAddVar( var, val );
		sqlOpAddCondition( "id", uid );
		sqlOpAddCondition( "SteamID", id );
	sqlOpUpdate( stream );		

end

function meta:sqlUpdateFields( tbl, stream )

	local id = self:SteamID();
	local uid = self:GetPlayerMySQLCharID();

	sqlOpStart( "epi_characters" );
		for k, v in pairs( tbl ) do
			sqlOpAddVar( v[1], v[2] );
		end
		sqlOpAddCondition( "id", uid );
		sqlOpAddCondition( "SteamID", id );
	sqlOpUpdate( stream );		

end

function meta:sqlClearInventory( inv )

	local uid = self:GetPlayerMySQLCharID();

	sqlOpStart( "epi_inv" );
		sqlOpAddCondition( "id", uid );
		sqlOpAddCondition( "inv", inv );
	sqlOpDelete();

end

function meta:sqlGetRecognizedPlayers()

	local uid = self:GetPlayerMySQLCharID();

	local tbl = sqlDoQuery( "SELECT * FROM epi_recog WHERE id = " .. esc( uid ) );
	local recogtbl = { }

	if( not tbl ) then return { }; end

	for k, v in pairs( tbl ) do
	
		local ruid = tonumber( v.recogid );
		recogtbl[ruid] = { }

	end
	
	local plytbl = { }
	
	for k, v in pairs( player.GetAll() ) do

		if( v ~= self and recogtbl[tonumber( v:GetPlayerMySQLCharID() )] ) then
	
			table.insert( plytbl, v );
		
		end
	
	end
	
	return plytbl;

end

function meta:sqlSaveRecognition( ply )

	sqlOpStart( "epi_recog" );
		sqlOpAddVar( "id", self:GetPlayerMySQLCharID() );
		sqlOpAddVar( "SteamID", self:SteamID() );
		sqlOpAddVar( "recogid", ply:GetPlayerMySQLCharID() );
	sqlOpInsert( true );	
	
	sqlOpStart( "epi_recog" );
		sqlOpAddVar( "id", ply:GetPlayerMySQLCharID() );
		sqlOpAddVar( "SteamID", ply:SteamID() );
		sqlOpAddVar( "recogid", self:GetPlayerMySQLCharID() );
	sqlOpInsert( true );	

end

function meta:sqlUpdateInventory( inv, x, y, itemid, amt, new )

	local id = self:SteamID();
	local uid = self:GetPlayerMySQLCharID();

	if( itemid ) then
	
		local tbl = sqlDoQuery( "SELECT * FROM epi_inv WHERE id = " .. esc( uid ) .. " AND inv = " .. esc( inv ) .. " AND x = " .. esc( x ) .. " AND y = " .. esc( y ) );
	
		if( tbl and tbl[1] ) then
		
			if( tbl[1].itemid == itemid and not new ) then return; end
		
			sqlOpStart( "epi_inv" );
				sqlOpAddVar( "itemid", itemid );
				sqlOpAddVar( "amt", amt );
				sqlOpAddCondition( "id", uid );
				sqlOpAddCondition( "inv", inv );
				sqlOpAddCondition( "x", x );
				sqlOpAddCondition( "y", y );
			sqlOpUpdate( true );			
		
		else
		
			sqlOpStart( "epi_inv" );
				sqlOpAddVar( "SteamID", id );
				sqlOpAddVar( "id", uid );
				sqlOpAddVar( "x", x );
				sqlOpAddVar( "y", y );
				sqlOpAddVar( "itemid", itemid );
				sqlOpAddVar( "inv", inv );
				sqlOpAddVar( "amt", amt );
			sqlOpInsert( true );	
			
		end
		
	else
		
		sqlOpStart( "epi_inv" );
			sqlOpAddCondition( "id", uid );
			sqlOpAddCondition( "inv", inv );
			sqlOpAddCondition( "x", x );
			sqlOpAddCondition( "y", y );
		sqlOpDelete();	
	
	end
	
end

function meta:sqlUpdateAmount( inv, x, y, amt )
	
	local uid = self:GetPlayerMySQLCharID();
	
	local tbl = sqlDoQuery( "SELECT * FROM epi_inv WHERE id = " .. esc( uid ) .. " AND inv = " .. esc( inv ) .. " AND x = " .. esc( x ) .. " AND y = " .. esc( y ) );

	if( tbl and tbl[1] ) then
		
		sqlOpStart( "epi_inv" );
			sqlOpAddVar( "amt", amt );
			sqlOpAddCondition( "id", uid );
			sqlOpAddCondition( "inv", inv );
			sqlOpAddCondition( "x", x );
			sqlOpAddCondition( "y", y );
		sqlOpUpdate( true );
		
	end
	
end

function meta:sqlSaveInventory()

	local id = self:SteamID();
	local uid = self:GetPlayerMySQLCharID();

	local inventorygrid = self:GetTable().InventoryGrid;
	
	sqlRemoveAnyEntryWithField( "epi_inv", "id", uid );
	
	local f = function()
	
		for inv = 1, MAX_INVENTORIES do
	
			for x = 1, MAX_INV_WIDTH do

				for y = 1, MAX_INV_HEIGHT do
				
					if( inventorygrid[inv][x][y].main ) then
				
						if( inventorygrid[inv][x][y].ItemData ) then
				
							local itemid = inventorygrid[inv][x][y].ItemData.ID;
							local amt = inventorygrid[inv][x][y].ItemData.Amount or 1;
						
							sqlOpStart( "epi_inv" );
								sqlOpAddVar( "SteamID", id );
								sqlOpAddVar( "id", uid );
								sqlOpAddVar( "x", x );
								sqlOpAddVar( "y", y );
								sqlOpAddVar( "itemid", itemid );
								sqlOpAddVar( "inv", inv );
								sqlOpAddVar( "amt", amt );
							sqlOpInsert( true );	
							
						end
				
					end
				
				end
			
			end
	
		end

	
	end
	f();

end

function meta:sqlSaveCurrentCharacter()

	if( self:sqlCharacterExists() ) then
	
		local id = self:SteamID();
		local uid = self:GetPlayerMySQLCharID();
		local class = self:GetPlayerClass();
		local name = self:RPNick();
		local age = self:GetPlayerAge();
		local physdesc = self:GetPlayerPhysDesc();
		local orimdl = self:GetPlayerOriginalModel();

		sqlOpStart( "epi_characters" );
			sqlOpAddVar( "SteamID", id );
			sqlOpAddVar( "Class", class );
			sqlOpAddVar( "Name", name );
			sqlOpAddVar( "Age", age );
			sqlOpAddVar( "PhysDesc", physdesc );
			sqlOpAddVar( "OriMdl", orimdl );
			sqlOpAddCondition( "id", uid );
		sqlOpUpdate();		
		
		self:sqlSaveInventory();
	
	end
	

end

function meta:sqlCreateCharacterSave()

	if( not self:sqlCharacterExists() ) then
	
		local id = self:SteamID();
		
		sqlOpStart( "epi_characters" );
			sqlOpAddVar( "SteamID", id );
			sqlOpAddVar( "Class", self:GetPlayerClass() );
			sqlOpAddVar( "Name", self:RPNick() );
			sqlOpAddVar( "Age", self:GetPlayerAge() );
			sqlOpAddVar( "PhysDesc", self:GetPlayerPhysDesc() );
			sqlOpAddVar( "OriMdl", self:GetPlayerOriginalModel() );
		sqlOpInsert();		

	end

end

function meta:sqlLoadPlayerFlags()

	local id = self:SteamID();

	local tbl = sqlDoQuery( "SELECT Flags FROM epi_users WHERE SteamID = '" .. esc( id ).."'" );

	if( tbl and tbl[1] ) then
		print(self:Name().." Has flags "..string.gsub( tbl[1].Flags or "", "NULL", "" ));
		self:SetPlayerFlags( string.gsub( tbl[1].Flags or "", "NULL", "" ) or "" );
	
	end

end

function meta:sqlLoadPlayerInfo()

	local data = sqlDoQuery( "SELECT Date, PlayerDesc FROM epi_users WHERE SteamID = '" .. esc( self:SteamID() ).."'" );
	
	if( data and data[1] ) then
		
		self:SetPlayerJoinDate( data[1].Date );
		self:SetPlayerSBTitle( data[1].PlayerDesc );
		
	end
	
end

function meta:sqlHandleFirstTimeJoin()

	local id = self:SteamID();
	
	if( not PlayersJoined[id] ) then
	
		PlayersJoined[id] = true;
		
		if( not sqlTableHasEntryWithValue( "epi_users", "SteamID", id ) ) then
			
			sqlOpStart( "epi_users" );
				sqlOpAddVar( "SteamName", self:Nick() );
				sqlOpAddVar( "SteamID", id );
				sqlOpAddVar( "IP", self:IPAddress() );
				sqlOpAddVar( "Date", os.date( "%b-%d-%Y" ) );
			sqlOpInsert( true );
			
			self:SetPlayerJoinDate( os.date( "%b-%d-%Y" ) );
		
		else
		
			self:sqlLoadPlayerFlags();
			self:sqlLoadPlayerInfo();
		
		end
	
	else
	
		self:sqlLoadPlayerFlags();
	
	end

end
