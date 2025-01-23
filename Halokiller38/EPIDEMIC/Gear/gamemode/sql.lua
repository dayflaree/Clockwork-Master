

SQLITE = -1;

SQL_INSERT = 1;
SQL_UPDATE = 2;
SQL_SELECT = 3;

mysql = { };
mysql.query = function( db, query )
	
	local tbl = { };
	local succ = false;
	local err = "";
	
	local q = db:query( query );
	q.onSuccess = function()
		
		tbl = q:getData();
		succ = true;
		
	end
	q.onFailure = function( e )
		
		err = e;
		
	end
	q:start();
	q:wait();
	
	return tbl, succ, err;
	
end

gsql = {

	SqlData = 0,
	CmdType = 0,
	CmdFilter = { },
	Assns = { },
	Condition = "",
	Table = ""

}

function QueryStart( sqlinfo )

	gsql.SqlData = sqlinfo;
	gsql.CmdFilter = { };
	gsql.Assns = { };
	gsql.CmdType = 0;
	gsql.Table = "";
	gsql.Condition = "";
	
end

function QueryCommand( cmdtype )

	gsql.CmdType = cmdtype;

end

function QueryCommandFilter( cmdfilter )

	if( type( cmdfilter ) == "table" ) then
		for k, v in pairs( cmdfilter ) do
			if( not table.HasValue( gsql.CmdFilter, v ) ) then
				table.insert( gsql.CmdFilter, v );
			end
		end
	else
		table.insert( gsql.CmdFilter, cmdfilter );
	end
	
end

function QueryTable( table )

	gsql.Table = table;

end

function QueryCondition( condition )

	gsql.Condition = condition;

end

function QueryAssignment( var, val )

	table.insert( gsql.Assns, { Var = var, Val = val } );

end

function QueryFinish()

	local query = "";
	
	if( gsql.CmdType == SQL_INSERT ) then
	
		query = "INSERT INTO " .. gsql.Table .. " ( ";
	
		for n = 1, #gsql.Assns do
		
			if( n > 1 ) then
				query = query .. ", ";
			end
		
			query = query .. gsql.Assns[n].Var;
		
		end
		
		query = query .. ") VALUES ( ";
		
		for n = 1, #gsql.Assns do
		
			if( n > 1 ) then
				query = query .. ", ";
			end
		
			query = query .. "'" .. gsql.Assns[n].Val .. "'";
		
		end
	
		query = ")";
	
	elseif( sql.CmdType == SQL_UPDATE ) then
	
		query = "UPDATE " .. gsql.Table .. " ";
	
		for n = 1, #gsql.Assns do
		
			if( n > 1 ) then
				query = query .. "AND ";
			end
		
			query = query .. "SET " .. gsql.Assns[n].Var .. " = '" .. gsql.Assns[n].Val .. "' ";
		
		end
	
		query = query .. gsql.Condition;
	
	elseif( sql.CmdType == SQL_SELECT ) then
	
		query = "SELECT ";
		
		for n = 1, #gsql.CmdFilter do
		
			if( n > 1 ) then
			
				query = query .. ", ";
			
			end
		
			query = query .. gsql.CmdFilter[n];
		
		end
		
		query = query .. " FROM " .. gsql.Table .. gsql.Condition;
	
	else
	
		return;
	
	end
	

	if( gsql.SqlData == SQLITE ) then
		
		return sql.Query( query );
		
	else
		 
		 return mysql.query( gsql.SqlData, query );
		 
	end

end

function QueryTableExists( sqldata, tbl )

	local query = "SELECT * FROM information_schema.tables WHERE table_name = '" .. tbl .. "'";

	local result = nil;

	if( sqldata == SQLITE ) then
		
		 return sql.TableExists( tbl );
		
	else
		 
		 result = mysql.query( sqldata, query );
		 
	end
	
	if( result and result[1] and result[1][1] ) then return true; end
	
	return false;
	

end

function QueryGetData( sqldata, tbl, list, condition )

	if( condition == nil ) then
		condition = "";
	end

	QueryStart( sqldata );
		QueryCommand( SQL_SELECT );
		QueryCommandFilter( list );
		QueryTable( tbl );
		QueryCondition( condition );
	local results = QueryFinish();
		
	local ret = { }
		
	if( sqldata ~= SQLITE ) then
	
		results = results[1];
		
		for n = 1, #list do
		
			ret[list[n]] = results[n];
		
		end
	
	else
	
		ret = results;
	
	end

	return ret;

end

function SqlConnect( address, username, pass, db )
	
	local sql = mysqloo.connect( address, username, pass, db, 3306 );
	local succ = false;
	
	sql.onConnected = function()
		
		Msg( "SQL connection success\n" );
		succ = true;
		
	end
	
	sql.onConnectionFailed = function( err )
		
		error( "SQL connection failure to " .. address .. " because: " .. err .. "\n" );
		
	end
	
	return succ, sql;

end




