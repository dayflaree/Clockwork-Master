--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.tile = {};
SF.tile.stored = {};
SF.tile.folders = {};

function SF.tile:New(name, obj)
	return {name = name, isObj = obj};
end;

function SF.tile:Add(data)
	if (!data.uniqueID) then
		data.uniqueID = string.lower(string.Replace(data.name, " ", "_"));
	end;

	if (CLIENT) then
		data.material = Material("sf_ss13/"..data.path);
	end;

	if (!data.folder) then
		data.folder = "Misc";
	end;

	if (!self.folders[data.folder]) then
		self.folders[data.folder] = {};
	end;

	self.stored[data.uniqueID] = data;

	table.insert(self.folders[data.folder], data.uniqueID);
end;

function SF.tile:Get(uniqueID)
	return self.stored[uniqueID];
end;

function SF.tile:IsObj(uniqueID)
	if (self:Get(uniqueID)) then
		local tile = self:Get(uniqueID);
		if (tile.type == "obj") then
			return true;
		end;
	end;
	return false;
end;

function SF.tile:GetAll()
	return table.Copy(self.stored);
end;