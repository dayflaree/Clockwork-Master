--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

function SF:HUDPaint()
	self:DrawBackground();
	self:ShowIntro();

	self:DrawStatusMessage();
end;

function SF:HUDShouldDraw(name)
	local dont = {"CHudHealth", "CHudBattery", "CHudSuitPower", "CHudAmmo", "CHudWeaponSelection", "CHudZoom"};
	if (table.HasValue(dont, name)) then
		return false;
	end;
	return true;
end;

function SF:StatusMessage(text)
	if (!text) then
		self.statusMessage = false;
	else
		self.statusMessage = text;
	end;
end;