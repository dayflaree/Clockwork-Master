--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

function SF:HUDPaint()
	self:DrawStatusMessage();
end;

function SF:StatusMessage(text)
	if (!text) then
		self.statusMessage = false;
	else
		self.statusMessage = text;
	end;
end;

function SF:DrawStatusMessage()
	if (self.statusMessage) then
		draw.SimpleTextOutlined(self.statusMessage, "Trebuchet24", ScrW()/2, ScrH()/3, Color(255, 255, 255), 1, 1, 5, Color(0, 0, 0));
	end;
end;

function SF:ShowMouse(bool)
	if (self.mouseEnabled and bool == false) then
		self.mouseEnabled = false;
		gui.EnableScreenClicker(false);
	elseif (!self.mouseEnabled and bool == true) then
		self.mouseEnabled = true;
		gui.EnableScreenClicker(true);
	end;
end;