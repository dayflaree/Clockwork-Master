--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

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
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(100, 500);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );

end;

-- A function to populate the panel.
function PANEL:Populate(data)
	local colorWhite = Clockwork.option:GetColor("white");
	
	self:SetTitle("ItemBuilder");
	
	self.panelList:Clear();
	
	self.button = vgui.Create("DButton");	
	
	self.button:SetText("New Item");
	
	-- Called when the button is clicked.
	function self.button.DoClick()
		if (IsValid(PLUGIN.CreatePanel)) then
			PLUGIN.CreatePanel:Close();
			PLUGIN.CreatePanel:Remove();
		end;
		
		local stuff = {};
		stuff.name = "Skull";
		stuff.cost = "1";
		stuff.model = "models/Gibs/HGIBS.mdl";
		stuff.weight = "1";
		stuff.access = "l";
		stuff.useText = "Use";
		stuff.category = "Custom";
		stuff.description = "This is a skull.";
		
		PLUGIN.CreatePanel = vgui.Create("cwCreateItem");
		PLUGIN.CreatePanel:Populate(stuff);
		PLUGIN.CreatePanel:MakePopup();
	end;
	
		for k, v in ipairs(data) do
			itemIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
			itemlabel = vgui.Create("DLabel");
			itemIcon:SetModel(v.model);
			
			itemlabel:SetAutoStretchVertical(true);
			itemlabel:SetTextColor(colorWhite);
			itemlabel:SetWrap(true)
			itemlabel:SetText(v.name);
			
			-- Called when the spawn icon is clicked.
			function itemIcon.DoClick(itemIcon)
				if (IsValid(PLUGIN.CreatePanel)) then
					PLUGIN.CreatePanel:Close();
					PLUGIN.CreatePanel:Remove();
				end;
				
				PLUGIN.CreatePanel = vgui.Create("cwCreateItem");
				PLUGIN.CreatePanel:Populate(v);
				PLUGIN.CreatePanel:MakePopup();
			end;
			
			self.panelList:AddItem(itemlabel);
			self.panelList:AddItem(itemIcon);	
		end;
	
	self.panelList:AddItem(self.button);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(4, 28, 4, 4);
	DFrame.PerformLayout(self);
end;

vgui.Register("cwItemMainMenu", PANEL, "DFrame");