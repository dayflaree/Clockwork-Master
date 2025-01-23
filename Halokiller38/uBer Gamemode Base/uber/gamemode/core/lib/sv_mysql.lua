--[[
		uBer
File: sv_mysql.lua
--]]


--[[A function to run a mysql query.--]]
function lib_mysql_RunQuery(Q,database)
	if (!Q) then return end; //Make sure that the query is not empty
	
	local tab, succ, error = mysql.query(database, Q);  //Run the Query
	
	if (not succ) then
		Msg("uBer - MySQL: " .. error .. "\n")
	end;
	
	if (tab) then
		return tab;
	end;
end;

--[[A function to connect to a mysql database.--]]
function lib_mysql_MakeConnection(connection)
	//Table 'connectionInfo' (1 - Host, 2 - Username, 3 - Password, 4 - Database Name)
		
	local db, error = mysql.connect(connection[1], connection[2], connection[3], connection[4]);  
	if (db == 0) then
		Msg("uBer - MySQL: " .. error .. "\n");
		return false;
	end;
	return db;
end;

--[[A function to disconnect from a mysql database.--]]
function lib_mysql_DestroyConnection(database)

	local succ, error = mysql.disconnect(database);
	
	if (not succ) then
		Msg("uBer - MySQL: " .. error .. "\n");
		return false;
	end;

	return true;
	
end;