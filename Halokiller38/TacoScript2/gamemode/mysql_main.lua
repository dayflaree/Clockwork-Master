local meta = FindMetaTable( "Player" );

require("mysqloo");

if( not mysqloo ) then

	MySQLOff = true;

end

function TS.ConnectToSQL()
	if MySQLOff then ErrorNoHalt("MySQL off\n") return end
	local host = "localhost";
	local name = "root";
	local pass = "";
	local database = "tacoscript2";
	local port = 3306;

	TS.SQL = mysqloo.connect(host, name, pass, database, port)

	TS.SQL.onConnected = function()
		Msg( "Successfully connected to SQL: " .. database .. "\n" );
	end

	TS.SQL.onConnectionFailed = function(q, err)
		Msg( "Failed connection to SQL: " .. database .. ". Reason: " .. err .. "\n" );
		TS.SQL = 0
	end

	TS.SQL:connect()
	Msg("Connecting to SQL...\n")
end

local function empty_function() end

function TS.AsyncQuery(query, completed, err, data, wait)
	if TS.SQL == 0 then ErrorNoHalt("MySQL is not connected\n") return end
	if type(wait) ~= "boolean" then wait = false end
	local query = TS.SQL:query(query)
	query.onSuccess = function(...) return (completed or empty_function)(query, ...) end
	query.onFailure = function(...) return (err or empty_function)(query, ...) end
	query.onData = function(...) return (data or empty_function)(query, ...) end
	query:start()
	if wait then query:wait() end
	return query
end

function TS.SyncQuery(query)
	if TS.SQL == 0 then ErrorNoHalt("MySQL is not connected\n") return end
	local query = TS.SQL:query(query)
	query:start()
	query:wait()
	return query
end

function TS.Escape(string)
	return TS.SQL:escape(tostring(string))
end

function TS.CheckSQL() -- May as well be re-added.
	--This function checks if the SQL is active every minute.
	if not MySQLOff then
		if type(TS.SQL) ~= "Database" then
				TS.ConnectToSQL()
		else
			local status = TS.SQL:status()
			if status == mysqloo.DATABASE_NOT_CONNECTED or status == mysqloo.DATABASE_INTERNAL_ERROR then
				TS.ConnectToSQL()
			end
		end
	end
end
timer.Create( "CheckSQL", 60, 0, TS.CheckSQL );

function TS.PeriodicSave()

	for k, v in pairs( player.GetAll() ) do
	
		if( v.Initialized and not v.CharacterMenu ) then
		
			v:CharSave();
		
		end
		
	end

end
timer.Create( "PeriodicSave", 120, 0, TS.PeriodicSave );

function TS.DisconnectFromSQL()

	if not MySQLOff and type(TS.SQL) == "Database" then
	
		for k, v in pairs( player.GetAll() ) do
	
			if( v.Initialized and not v.CharacterMenu ) then
		
				v:CharSave(true);
		
			end
		
		end

		TS.SQL:delete()
		TS.SQL = nil
		
	end

end

function GM:ShutDown()

	TS.DisconnectFromSQL();

end

function meta:SetSQLData( name, val )

	if( name ~= nil and val ~= nil ) then
	
		if( self and self:IsValid() ) then

			self[name] = val;
			
		end
		
	end

end

function meta:GetSQLData( name )

	if( name ~= nil ) then
	
		if( self and self:IsValid() ) then
	
			return self[name];
			
		end
		
	end
	
end

function meta:GetGroupID()

	return tonumber( self:GetSQLData( "group_id" ) );

end
