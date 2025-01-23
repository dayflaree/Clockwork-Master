--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	self:SetTitle(Clockwork.option:GetKey("name_business"));
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:EnableVerticalScrollbar();
	
	self.isBusinessPanel = true;
	self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear(true);
	
	local categories = {};
	local itemsList = {};
	
	for k, v in pairs(Clockwork.item:GetAll()) do
		if (v:CanBeOrdered() and Clockwork:HasObjectAccess(Clockwork.Client, v)) then
			if (Clockwork.plugin:Call("PlayerCanSeeBusinessItem", v)) then
				local itemCategory = v("category");
				itemsList[itemCategory] = itemsList[itemCategory] or {};
				itemsList[itemCategory][#itemsList[itemCategory] + 1] = v;
			end;
		end;
	end;
	
	for k, v in pairs(itemsList) do
		categories[#categories + 1] = {
			itemsList = v,
			category = k
		};
	end;
	
	table.sort(categories, function(a, b)
		return a.category < b.category;
	end);
	
	if (table.Count(categories) == 0) then
		local label = vgui.Create("cwInfoText", self);
			label:SetText("You do not have access to the "..Clockwork.option:GetKey("name_business", true).." menu!");
			label:SetInfoColor("red");
		self.panelList:AddItem(label);
		
		Clockwork.plugin:Call("PlayerBusinessRebuilt", self, categories);
	else
		Clockwork.plugin:Call("PlayerBusinessRebuilt", self, categories);
		
		for k, v in pairs(categories) do
			local collapsibleCategory = vgui.Create("DCollapsibleCategory", self.panelList);
				collapsibleCategory:SetCookieName("cwBusiness."..v.category);
				collapsibleCategory:SetPadding(2);
				collapsibleCategory:SetLabel(v.category);
			self.panelList:AddItem(collapsibleCategory);
			
			collapsibleCategory:SetExpanded(false);
			collapsibleCategory:LoadCookies();
			
			local categoryList = vgui.Create("DPanelList", collapsibleCategory);
				categoryList:EnableHorizontal(true);
				categoryList:SetAutoSize(true);
				categoryList:SetPadding(4);
				categoryList:SetSpacing(4);
			collapsibleCategory:SetContents(categoryList);
			
			table.sort(v.itemsList, function(a, b)
				local itemTableA = a;
				local itemTableB = b;
				
				if (itemTableA.cost == itemTableB.cost) then
					return itemTableA.name < itemTableB.name;
				else
					return itemTableA.cost > itemTableB.cost;
				end;
			end);
			
			for k2, v2 in pairs(v.itemsList) do
				self.itemData = {
					itemTable = v2
				};
				
				categoryList:AddItem(vgui.Create("cwBusinessItem", self));
			end;
		end;
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:GetActivePanel() == self) then
		self:Rebuild();
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetSize(self:GetWide(), ScrH() * 0.75);
	self.panelList:StretchToParent(4, 28, 4, 4);
	
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

vgui.Register("cwBusiness", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 48);
	
	local customData = self:GetParent().customData or {};
	local toolTip = nil;
	
	if (customData.information) then
		if (type(customData.information) == "number") then
			if (customData.information != 0) then
				customData.information = FORMAT_CASH(customData.information);
			else
				customData.information = "Free";
			end;
		end;
	end;
	
	if (customData.description) then
		toolTip = Clockwork.config:Parse(customData.description);
	end;
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(36, 2);
	self.nameLabel:SetText(customData.name);
	self.nameLabel:SizeToContents();
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(36, 2);
	self.infoLabel:SetText(customData.information);
	self.infoLabel:SizeToContents();
	
	self.spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
	self.spawnIcon:SetColor(customData.spawnIconColor);
	
	if (customData.cooldown) then
		self.spawnIcon:SetCooldown(
			customData.cooldown.expireTime,
			customData.cooldown.textureID
		);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (customData.Callback) then
			customData.Callback();
		end;
	end;
	
	self.spawnIcon:SetModel(customData.model, customData.skin);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetIconSize(48);
end;

-- Called each frame.
function PANEL:Think()
	self.infoLabel:SetPos(self.infoLabel.x, 30 - self.infoLabel:GetTall());
end;
	
vgui.Register("cwBusinessCustom", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData;
		self:SetSize(48, 48);
		self.itemTable = itemData.itemTable;
	Clockwork.plugin:Call("PlayerAdjustBusinessItemTable", self.itemTable);
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	self.spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
	
	if (Clockwork.OrderCooldown and CurTime() < Clockwork.OrderCooldown) then
		self.spawnIcon:SetCooldown(Clockwork.OrderCooldown);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		Clockwork:RunCommand(
			"OrderShipment", self.itemTable("uniqueID")
		);
	end;
	
	self.spawnIcon:SetModel(model, skin);
	self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetIconSize(48);
end;

-- Called each frame.
function PANEL:Think()
	self.spawnIcon:SetMarkupToolTip(Clockwork.item:GetMarkupToolTip(self.itemTable, true));
	self.spawnIcon:SetColor(self.itemTable("color"));
end;
	
vgui.Register("cwBusinessItem", PANEL, "DPanel");