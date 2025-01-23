--================
--	Doors Plugin
--================

local PLUGIN = PLUGIN

-- Gives a player access to a door.
function RP.doors:GiveAccess(ply, door)
	if (ValidEntity(door)) then
		door.rp = door.rp or {};
		door.rp.owner = ply;
		door.rp.value = self.defaultCost;
		door:SetNWEntity("RPOwner", ply);
	else
		return false, "Invalid entity!";
	end;
end;

-- Remove a player's access from a door.
function RP.doors:RemoveAccess(ply, door)
	if (ValidEntity(door)) then
		if (door.rp) then
			door.rp = nil;
			door:SetNWEntity("RPOwner", nil)
		end;
	else
		return false, "Invalid entity!";
	end;
end;

-- Sets the type of the door (unownable etc.)
function RP.doors:SetDoorType(door, _type)
	if (ValidEntity(door)) then
		if (_type) then
			door.rp = door.rp or {};
			door.rp.doorType = _type;
			door:SetNWString("RPDoorType", _type);
		else
			door.rp = nil;
		end;
	else
		return false, "Invalid entity!";
	end;
end;

-- Saves the door types to the database.
function RP.doors:Save()
	local doors = {};
	for k,v in ipairs(ents.GetAll()) do
		if (v.rp and v.rp.doorType) then
			table.insert(doors, {v:GetPos(), v.rp.doorType});
		end;
	end;
	
	if (#doors > 0) then
		tmysql.query("CREATE TABLE IF NOT EXISTS doors (map VARCHAR( 255 ) NOT NULL, x INT NOT NULL, y INT NOT NULL, z INT NOT NULL, type VARCHAR( 255 ) NOT NULL, uniqueID INT NOT NULL AUTO_INCREMENT PRIMARY KEY)");
		
		for k,v in ipairs(doors) do
			local query = Format("INSERT INTO doors (map, x, y, z, type) VALUES (%s, %d, %d, %d, %s)", game.GetMap(), v[1].x, v[1].y, v[1].z, RP.Data:Safe(v[2]));
			tmysql.query(query);
		end;
	end;
end;

-- Loads the door types from the database.
function RP.doors:Load()
	tmysql.query("SELECT * FROM doors WHERE map = "..RP.Data:Safe(game.GetMap()), function(result, status, error)
		if (#result > 0) then
			for k,v in ipairs(result) do
				local pos = Vector(v.x, v.y, v.z);
				for a,b in ipairs(ents.FindInSphere(pos, 16)) do
					RP.doors:SetDoorType(b, v.type);
				end;
			end;
		end;
	end);
end;

function PLUGIN:GlobalSaveData()
	RP.doors:Save();
end;

function PLUGIN:InitPostEntity()
	RP.doors:Load();
end;

function PLUGIN:ShowTeam(ply)
	RP.Command:Run(ply, "buyDoor");
end;

function PLUGIN:PlayerDisconnected(ply)
	for k,v in ipairs(ents.GetAll()) do
		if (v.rp and v.rp.doorType) then
			if (v.rp.owner == ply) then
				RP.doors:RemoveAccess(ply, door);
			end;
		end;
	end;
end;
