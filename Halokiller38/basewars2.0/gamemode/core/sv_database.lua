--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

RP.Data = {};

RP.Data.originalQuery = tmysql.query;

function tmysql.query(queryString, Callback, flags, argument)
	RP.Data.originalQuery(queryString, function(result, status, error)
		if (Callback) then
			Callback(result, status, error)
		end;
	end, 1);
end;

-- A function to connect to MySQL
function RP.Data:Connect()
	local connectData = self:GetConfig();
	
	if (tmysql.initialize(connectData.host, connectData.user, connectData.pass, connectData.database, 3306)) then
		RP:Log("========================");
		RP:Log("====MySQL Connected!====");
		RP:Log("========================");
	end;
end;

-- A function to get the data to connect to MySQL with
function RP.Data:GetConfig()
	return {
		host = "74.91.26.154",
		user = "spencer",
		pass = "sunpower24",
		database = "basewars"
	};
end;

-- A function to escape strings
function RP.Data:Safe(string)
	return tmysql.escape(tostring(string));
end;