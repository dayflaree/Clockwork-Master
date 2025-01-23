surface.CreateFont("Arial", 24, 700, true, false, "rpButtonFont");

local PANEL = {};

function PANEL:Init()
	self:SetSize(0, 0);
	self:SetPos(0, 0);
end;

function PANEL:GetTextDimensions(text)
	surface.SetFont("rpButtonFont");
	return surface.GetTextSize(text);
end;

function PANEL:SetValue(text)
	local w, h = self:GetTextDimensions(text);
	self.value = text;
	self:SetSize(w+4, h+4);
end;

function PANEL:Paint()
	draw.SimpleTextOutlined(self.value or "Nil", "rpButtonFont", 2, 2, Color(255, 255, 255), 0, 0, 2, Color(0, 0, 0));
end;

function PANEL:OnMouseReleased(mouseCode)
	if (mouseCode == MOUSE_LEFT) then
		if (self.Callback) then
			self:Callback();
			surface.PlaySound("buttons/button16.wav");
		end;
	end;
end;

-- function PANEL:Paint()
	-- local quadObj = {
		
-- end;

vgui.Register("rpButton", PANEL);