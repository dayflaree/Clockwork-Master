--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]


SF.Fades = {};

function SF.Fades:Init(lifeTime, startVal, endVal, pause)
	self.pause = pause or 0;
	self.startTime = CurTime() + self.pause;
	self.lifeTime = lifeTime;
	self.startVal = startVal;
	self.endVal = endVal;
	self.decrease = false;
	if ((startVal <= 0 and endVal <= 0 and startVal < endVal) or (startVal >= 0 and endVal >= 0 and endVal < startVal)) then
		self.decrease = true;
	end;
end;

function SF.Fades:SetCurve(cType)
	if (cType == "quadratic") then
		self.parabolic = true;
	end;
end;
 
function SF.Fades:Value()
	local frac = math.Clamp((CurTime() - self.startTime) / self.lifeTime, 0, 1);
	if (self.decrease) then
		return self.startVal - Lerp(frac, self.startVal, self.endVal);
	end;

	if (CurTime() < self.startTime) then
		return self.startVal;
	end;
	if (self:Active()) then
		return Lerp(frac, self.startVal, self.endVal);
	end;
	return self.endVal;
end;

function SF.Fades:Active()
	if (CurTime() < self.startTime + self.lifeTime + self.pause + FrameTime()) then
		return true;
	end;
end;

function SF:NewFade(lifeTime, startVal, endVal, pause)
	local init = {};
	setmetatable(init, self.Fades);
	self.Fades.__index = self.Fades;
	init:Init(lifeTime, startVal, endVal, pause);
	return init;
end;