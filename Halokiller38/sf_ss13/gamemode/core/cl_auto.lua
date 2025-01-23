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
	local dont = {"CHudHealth", "CHudBattery", "CHudSuitPower", "CHudCrosshair", "CHudAmmo", "CHudWeaponSelection", "CHudZoom"};
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

function SF:IntroComplete()
	self.mainMenu = vgui.Create("SFMainMenu");
end;

concommand.Add("editor", function(ply, cmd, args)
	if (SF.editorPanel) then
		SF.editorPanel:Remove();
		SF.editorPanel = nil;	
	else
		SF.editorPanel = vgui.Create("SFeditor");
		SF.editorPanel:MakePopup();
	end;
end);