local PLUGIN = PLUGIN;

local PANEL = {};

function PANEL:Init()
	self.categoryList = vgui.Create("DPanelList", self);
	self:Build();
end;

function PANEL:OnMenuOpened()
	if (RP.menu:GetActivePanel() == self) then
		self:Build();
	end;
end;

function PANEL:OnSelected() self:Build(); end;

function PANEL:Build()
	self.categoryList:Clear();
	self.categoryList:StretchToParent(0, 0, 0, 0);
	self.categoryList:SetDrawBackground(false);
	self.categoryList:SetSpacing(2);
	self.categoryList:SetPadding(0);
	self.categoryList:SetAutoSize(true);
	
	self.modelForm = vgui.Create("DForm", self);
	self.modelForm:SetPadding(4);
	self.modelForm:SetName("Model");
	self.modelForm:AddItem(vgui.Create("rpCustomize", self.modelForm));
	---self.modelForm:StretchToParent(1, 1, 1, 1);
	
	self.categoryList:AddItem(self.modelForm);
	
	self:InvalidateLayout(true);
end;

function PANEL:PerformLayout()
	self.categoryList:StretchToParent(0, 0, 0, 0);

	self:SetSize(RP.menu.width, math.min(self.categoryList.pnlCanvas:GetTall() + 8, RP.menu.height));
end;

function PANEL:Paint()
	self:InvalidateLayout(true);
	
	return;
end;

vgui.Register("rpSettings", PANEL, "DPanel");
