
local string = string;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle(Clockwork.Client:Name().."'s Notes");

	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);

	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(256, 362);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();

	self.textEntry = vgui.Create("DTextEntry", self.panelList);
	self.textEntry:SetMultiline(true);
	self.textEntry:SetHeight(300);
	self.panelList:AddItem(self.textEntry);

	self.button = vgui.Create("DButton", self.panelList);
	self.button:SetText("Save & Close");
	self.panelList:AddItem(self.button);

	-- A function to set the text entry's real value.
	function self.textEntry:SetRealValue(text)
		self:SetValue(text);
		self:SetCaretPos(string.len(text));
	end;

	-- Called each frame.
	function self.textEntry:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 1000) then
			self:SetRealValue(string.sub(text, 0, 1000));
			
			surface.PlaySound("common/talk.wav");
		end;
	end;
	
	-- Called when the button is clicked.
	function self.button.DoClick(button)
		self:Close(); self:Remove();
		
		Clockwork.datastream:Start("EditNotes", {string.sub(self.textEntry:GetValue(), 0, 1000)});
		
		gui.EnableScreenClicker(false);
	end;

	self:Center();
end;

-- A function to populate the panel.
function PANEL:Populate(notes)
	self.textEntry:SetText(notes);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(4, 28, 4, 4);
	
	DFrame.PerformLayout(self);
end;

vgui.Register("cwNotes", PANEL, "DFrame");