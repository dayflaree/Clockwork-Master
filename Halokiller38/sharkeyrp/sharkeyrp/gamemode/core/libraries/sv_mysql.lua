RP.MySQL = {};

function RP.MySQL:Connect()
	local host = "68.68.16.87";
	local user = "darkrp";
	local pass = "darkrp";
	local database = "darkrp";
	
	tmysql.initialize(host, user, pass, database, 3306, 6, 6);
	print("Connected MySQL '"..host.."' to database '"..database.."' with user '"..user.."'");
end;

function RP.MySQL:Query(query, Callback, lastID)
	if (!lastID) then
		tmysql.query(self:Escape(query), function(result, status, error)
			if (result or !error) then
				if (Callback) then
					Callback(result);
				end;
			else
				print(error);
			end;
		end, 1);
	end;
end;

function RP.MySQL:Escape(escapeString)
	return escapeString;
end;