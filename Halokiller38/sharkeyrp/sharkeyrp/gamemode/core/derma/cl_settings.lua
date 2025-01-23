RP.menu = {};

local PANEL = {};

function PANEL:Init()
	self:SetVisible(false);
	self:SetSize(ScrW()*0.5, ScrH()*0.75);
	self:SetSizable(true);
	self:SetMinimumSize(400, 400);
	self:SetPos((ScrW()/2)-self:GetWide()/2, (ScrH()/2)-self:GetTall()/2);
end;

vgui.Register("rpSettings", PANEL, "DFrame");