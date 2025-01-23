--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]
SF.DB = {};
SF.DB.O = nil;
SF.DB.Host = "slidefuse.net";
SF.DB.Username = "spencer";
SF.DB.Password = "spencer45";
SF.DB.Database = "sf_gamemodes";

require("mysqloo");

function SF.DB:Query(query, Callback)
	local q = self.O:query(query);

	q.onData = function(Q, D)
		if (Callback) then
			Callback(D);
		end;
	end;

	q.onError = function(Q, E)
		print("SLIDEFUSE: "..E);
		if (Callback) then
			Callback(false, E);
		end;
	end;

	q:start();
end;

function SF.DB:Esc(s)
	return self.O:escape(s);
end;

function SF.DB:Init()
	local dbObj = mysqloo.connect(self.Host, self.Username, self.Password, self.Database);
	dbObj.onConnected = function(db)
		SF.DB:Connection(db);
	end;

	dbObj.onConnectionFailed = function(db, error)
		SF.DB:FailedConnection(error);
	end;

	dbObj:connect();
end;

function SF.DB:Connection(db)
	print("SLIDEFUSE: Connected to database!")
	self.O = db;
	self.failed = false;
end;

function SF.DB:FailedConnection(error)
	print("SLIDEFUSE: Database failed! "..error);
	self.failed = true;
end;

function SF.DB:Active()
	return !self.failed;
end;