--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

-- A method called as the gamemode finishes loading
function RP:Initialize()
	if (self.InitCore) then
		self:InitCore();
	end;
end;

-- A function to modify the alpha of a color system
function RP:ModAlpha(color, alpha)
	local r = color.r;
	local g = color.g;
	local b = color.b;
	local a = math.Clamp(alpha, 0, 255);
	return Color(r, g, b, a);
end;

-- Called when the target ID HUD should be drawn.
function RP:HUDDrawTargetID()
	--print("sup");
	if (IsValid(self.Client) and self.Client:Alive()) then
		local fadeDistance = 196;
		local curTime = UnPredictedCurTime();
		local trace = RP.Client:GetEyeTrace()
		--PrintTable(trace);
		if (trace.Entity.HUDPaintTargetID) then
			local toScreen = ( trace.HitPos + Vector(0, 0, 16) ):ToScreen();
			local x, y = toScreen.x, toScreen.y;
			
			trace.Entity:HUDPaintTargetID(x, y, 255);
		end;
	end;
end;

function RP:ForceDermaSkin()
	return "omicron";
end;



RP.DescMeta = {};

function RP.DescMeta:Init()
	self.desc = {};
end;

function RP.DescMeta:HorizontalRule()
	table.insert(self.desc, "<hr>");
end;

function RP.DescMeta:NewLine()
	table.insert(self.desc, "<br>");
end;

function RP.DescMeta:Color(color)
	table.insert(self.desc, color);
end;

function RP.DescMeta:Text(text)
	table.insert(self.desc, text);
end;

function RP.DescMeta:Get()
	return self.desc;
end;

function RP:NewDescMeta()
	local o = {};
		setmetatable(o, self.DescMeta);
		self.DescMeta.__index = self.DescMeta;
		o:Init();
	return o;
end;