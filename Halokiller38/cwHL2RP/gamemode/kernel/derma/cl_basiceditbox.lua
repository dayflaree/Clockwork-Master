--[[
	Free Clockwork!
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); self:Remove();
		gui.EnableScreenClicker(false);
	end;
	
	self.callback = nil;
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
end;

function PANEL:SetCallback(Callback)
	self.callback = Callback;
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(256, 318);
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2));
end;

-- A function to populate the panel.
function PANEL:Populate(title, text)
	self:SetTitle(title);
	
	self.panelList:Clear();
		self.textEntry = vgui.Create("DTextEntry");
		self.button = vgui.Create("DButton");
		self.textEntry:SetMultiline(true);
		self.textEntry:SetHeight(256);
		self.textEntry:SetText(text);
	self.button:SetText("Okay");
	
	-- A function to set the text entry's real value.
	function self.textEntry:SetRealValue(text)
		self:SetValue(text);
		self:SetCaretPos(string.len(text));
	end;
	
	-- Called each frame.
	function self.textEntry:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 2000) then
			self:SetRealValue(string.sub(text, 0, 2000));
			surface.PlaySound("common/talk.wav");
		end;
	end;
	
	-- Called when the button is clicked.
	function self.button.DoClick(button)
		self:Close(); self:Remove();
			if (self.callback) then
				self.callback(self.textEntry:GetValue())
			end;
		gui.EnableScreenClicker(false);
	end;
	
	self.panelList:AddItem(self.textEntry);
	self.panelList:AddItem(self.button);
end;

function PANEL:ReadOnly(bool)
	if (bool) then
		self.button:SetEnabled(false);
		self.textEntry:SetEditable(false);
	else
		self.button:SetEnabled(true);
		self.textEntry:SetEditable(true);
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(4, 28, 4, 4);
	derma.SkinHook("Layout", "Frame", self);
end;

vgui.Register("cwBasicEditbox", PANEL, "DFrame");