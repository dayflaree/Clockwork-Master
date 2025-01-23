local PANEL = {};

AccessorFunc(PANEL, "align", "Align", 10);
AccessorFunc(PANEL, "font", "Font", 1);
AccessorFunc(PANEL, "textColour", "TextColour");
AccessorFunc(PANEL, "hoverColour", "HoverColour");
AccessorFunc(PANEL, "autoSize", "AutoSize", 11);
AccessorFunc(PANEL, "active", "Active", 11);
AccessorFunc(PANEL, "clickSound", "ClickSound", 1);

function PANEL:Init()
	self.textColour = Color(255, 255, 255, 255);
	self.hoverColour = Color(50, 150, 100, 255);
	
	self.text = Format("TextButton:%s", tostring(self));
	self.font = "Default";
	self.align = 0;
	self.autoSize = true;
	self.active = true;
	self.clickSound = "buttons/lightswitch2.wav";
end;

function PANEL:SetText(text, font)
	self.text = text;
	self.font = font or "Default";
end;

function PANEL:Paint()
	local colour = self.textColour;
	if (self.hovered) then
		colour = self.hoverColour;
	end;
	if (!self.active) then
		colour = Color(100, 100, 100, 255);
	end;
	
	RP.menu:DrawSimpleText(self.text, self.font, 2, self:GetTall() / 2, colour, self.align, 1);
	
	if (self.autoSize) then
		surface.SetFont(self.font);
		local w,h = surface.GetTextSize(self.text);
		
		self:SetSize(w + 4, h);
	end;
end;

function PANEL:OnMousePressed()
	if (self.active) then
		self.pressed = true;
	end;
end;

function PANEL:OnMouseReleased()
	if (self.active) then
		self.pressed = false;
		surface.PlaySound(self.clickSound);
		
		if (self.onPressed) then
			self:onPressed()
		end;
	end;
end;

function PANEL:OnCursorEntered()
	self.hovered = true;
end;

function PANEL:OnCursorExited()
	self.hovered = false;
end;

vgui.Register("RP_textButton", PANEL, "DPanel");

local PANEL = {};

AccessorFunc(PANEL, "followCursor", "FollowCursor", 11);
AccessorFunc(PANEL, "creator", "Creator");

function PANEL:Init()
	self:SetDrawOnTop(true);
	self.rows = {};
	self.followCursor = true;
end;

function PANEL:AddRow(text, colour, font)
	local data = {
		text = text or "Default",
		colour = colour or COLOR_WHITE,
		font = font or "Default"
	};
	
	table.insert(self.rows, data);
	
	self:InvalidateLayout(true);
end;

function PANEL:SetRows(rows)
	self.rows = rows;
	
	self:InvalidateLayout(true);
end;

function PANEL:Think()
	if (!self.creator or !self.creator:IsVisible()) then
		self:Remove();
	end;
	if (self.followCursor) then
		local x, y = gui.MousePos();
		
		self:SetPos(x + 15, y);
	end;
end;

local tex = surface.GetTextureID("gui/gradient_up");
function PANEL:Paint()
	surface.SetDrawColor(60, 60, 60, 255);
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
	
	surface.SetDrawColor(20, 20, 20, 255);
	surface.SetTexture(tex);
	surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall());
	
	local y = 2;
	
	for k,v in pairs(self.rows) do
		y = RP.core:DrawSimpleText(v.text, v.font, 4, y, v.colour, 0, 0, true);
	end;
end;

function PANEL:PerformLayout()
	local height = 0;
	local width = 0;
	
	for k,v in pairs(self.rows) do
		surface.SetFont(v.font);
		local w,h = surface.GetTextSize(v.text);
		
		height = height + h + 2;
		width = math.max(width, w + 8);
	end;
	
	self:SetSize(width, height + 2);
end;

vgui.Register("RP_toolTip", PANEL, "DPanel");
