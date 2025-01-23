--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.objs = {};
SF.objs.stored = {};
SF.objs.folders = {};

function SF.objs:New(name)
	return {name = name};
end;

function SF.objs:Add(data)
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

function SF.objs:Get(uniqueID)
	return self.stored[uniqueID];
end;

function SF.objs:GetAll()
	return table.Copy(self.stored);
end;