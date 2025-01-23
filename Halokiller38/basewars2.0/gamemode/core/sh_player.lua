--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]
RP.player = {};

function RP.player:FindPlayer(data)
	local players = player.GetAll();

	for k, v in pairs(players) do
		if (tonumber(data) == v:UserID()) then
			return v;
		end;
	end;
	
	for k,v in pairs(players) do
		if (data == v:UniqueID()) then
			return v;
		end;
	end;
	
	for k, v in pairs(players) do
		if (data == v:SteamID()) then
			return v;
		end;
	end;
	
	for k, v in pairs(players) do
		if (string.find(string.lower(v:GetName()), string.lower(tostring(data)))) then
			return v;
		end;
	end;
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:Notify(string)
	local icon = "gui/silkicons/wrench";
	local color = Color(150, 205, 255);
	if (string.sub(string, -1) == "!") then
		icon = "gui/silkicons/exclamation";
		color = Color(255, 140, 140);
	end;
	
	if (SERVER) then
		RP.chat:Add(self, {color, string}, icon, "npc/turret_floor/ping.wav");
	else 
		RP.chat:Add({color, string}, icon, "npc/turret_floor/ping.wav");
	end;
end;

-- Gets an eye trace with a distance.
function playerMeta:EyeTrace(distance)
	local trace = {};
	trace.start = self:GetShootPos();
	trace.endpos = trace.start + (self:GetAimVector() * distance);
	trace.filter = self;
	trace = util.TraceLine(trace);

	return trace;
end;
