--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.player = {};
local meta = FindMetaTable("Player");

function meta:SaveData()
	local query = "UPDATE players SET steamname = '"..SF:Esc(self:Name()).."', data = '"..SF:Esc(Json.Encode(self:GetDataTable())).."', ip = '"..SF:Esc(self:IPAddress()).."', lastplayed = "..(os.time()).." WHERE theme = '"..SF:GetThemeFolder().."' AND steamid = '"..self:SteamID().."'";

	SF:Query(query, function(D, A)
		print("Saved "..meta:Name().."'s Data!");
	end);
end;

function meta:SetData(key, value)
	if (!self.sfData) then
		self.sfData = {};
	end;

	self.sfData[key] = value;
end;

function meta:GetData(key)
	if (self.sfData and self.sfData[key]) then
		return self.sfData[key];
	end;
	return false;
end;

function meta:GetDataTable()
	return self.sfData or {};
end;