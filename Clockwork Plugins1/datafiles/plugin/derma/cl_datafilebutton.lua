-- (c) Khub 2012-2013.
-- VGUI Extension - DatafileButton
-- A button that's used thorough the datafiles clientside popup instead of the ugly standard DButton.

local DatafileButton = {};
AccessorFunc(DatafileButton, "LabelText", "Text");

surface.CreateFont("DatafileButton", {
	font = "Arial",
	size = 15,
	weight = 800
});

DatafileButton.Colors = {
	blue = Color(0, 64, 255),
	red = Color(128, 0, 0),
	orange = Color(255, 92, 0),
	green = Color(0, 128, 32)
};

function DatafileButton:Init()
	self.Color = "blue";
	self:SetButtonState(true);
	self:SetText("Button");
end;

function DatafileButton:SetButtonState(bSetState)
	self.ButtonState = bSetState == true;
	self:ButtonStateChanged();
end;

function DatafileButton:GetButtonState()
	return self.ButtonState;
end;

function DatafileButton:ButtonStateChanged()
	if (self:GetButtonState()) then
		self:SetCursor("hand");
	else
		self:SetCursor("no");
	end;
end;

function DatafileButton:AdjustSize(maxWide, maxTall)
	self:SetWide(maxWide - 6);
	self:SetTall(maxTall - 6);
	self:SetPos(3, 3);
end;

function DatafileButton:SetButtonColor(clrIdentifier)
	if (self.Colors[clrIdentifier]) then
		self.Color = clrIdentifier;
	end;
end;

function DatafileButton:ChangeColor(clr, affection)
	if (type(affection) == "number") then
		affection = Color(affection, affection, affection, affection);
	end;

	local newClr = Color(255,255,255, 255);

	newClr.r = math.Clamp(clr.r + affection.r, 0, 255);
	newClr.g = math.Clamp(clr.g + affection.g, 0, 255);
	newClr.b = math.Clamp(clr.b + affection.b, 0, 255);
	newClr.a = math.Clamp(clr.a + affection.a, 0, 255);

	return newClr;
end;

function DatafileButton:MakeColorGrayscale(clr)
	local val = math.Clamp((0.21*clr.r + 0.71*clr.g + 0.07*clr.b) + 25, 0, 255);
	return Color(val, val, val);
end;

function DatafileButton:Paint(w, h)
	local backgroundColor = self.Colors[self.Color];

	if (self:GetButtonState() == false) then
		backgroundColor = self:MakeColorGrayscale(backgroundColor);
	elseif (self:IsHovered()) then
		backgroundColor = self:ChangeColor(backgroundColor, 25);
	end;

	surface.SetDrawColor(backgroundColor);
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(self:ChangeColor(backgroundColor, 40));
	surface.DrawOutlinedRect(0, 0, w, h);

	surface.SetFont("DatafileButton");
	surface.SetTextColor(isHovered and Color(255, 255, 255) or Color(220, 220, 220));

	local tw, th = surface.GetTextSize(self:GetText());
	surface.SetTextPos(0.5*w - 0.5*tw, 0.5*h - 0.5*th);
	surface.DrawText(self:GetText());

	return true;
end;

function DatafileButton:OnMouseReleased(keyCode)
	if (keyCode == MOUSE_LEFT) then
		if (self:GetButtonState()) then
			if (self.DoClick) then
				self.DoClick(self);
			end;
		elseif (!self.NextSound or CurTime() > self.NextSound) then
			self.NextSound = CurTime() + 0.75;
			surface.PlaySound("buttons/button7.wav");
		end;
	end;
end;

vgui.Register("DatafileButton", DatafileButton, "DPanel");