--[[
Name: "cl_browser.lua".
Author: "TJjokerR".
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize( openAura.menu:GetWidth(), openAura.menu:GetHeight() );
	self:SetTitle("Browser");
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.addressBar = vgui.Create("DTextEntry", self);
	self.addressBar:SetPos(5, 25);
	
	self.loadText = vgui.Create("DLabel", self);
	self.loadText:SetFont("bb_IntroTextBig");
	self.loadText:SetText("Loading page...");
	self.loadText:SizeToContents();
	
	self.goButton = vgui.Create("DButton", self);
	self.goButton:SetText("Go");
	self.goButton:SetSize(35,22);
	self.goButton.DoClick = function(btn)
		self.htmlScreen:OpenURL(self.addressBar:GetValue());
	end;
	
	self.htmlScreen = vgui.Create("HTML", self);
	self.htmlScreen.OpeningURL = function(pnl, url)
		self.addressBar:SetText(url);
	end;
 	self.htmlScreen:OpenURL("http://avoxgaming.com/index_server.htm");
	
	openAura.browser = self;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.htmlScreen:StretchToParent(4, 50, 4, 4);
	self.addressBar:SetWide(self.addressBar:GetParent():GetWide() - 50);
	
	self.goButton:SetPos(self.addressBar:GetWide() + self.addressBar.x + 5, 25);
	self:SetSize( self:GetWide(), openAura.menu:GetHeight() );
	
	self.loadText:SetPos(self:GetWide() * .5 - self.loadText:GetWide() * .5, self:GetTall() * .5 - self.loadText:GetTall() * .5);
	
	derma.SkinHook("Layout", "Frame", self);
end;

-- Called when the panel is painted.
function PANEL:Paint()
	derma.SkinHook("Paint", "Frame", self);
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("aura_Browser", PANEL, "DFrame");