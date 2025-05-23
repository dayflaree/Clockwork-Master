--[[
	Free Clockwork!
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	self:SetTitle("Classes");
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	self:Rebuild();
end;

-- A function to get whether the button is visible.
function PANEL:IsButtonVisible()
	for k, v in pairs(Clockwork.class.stored) do
		if (Clockwork:HasObjectAccess(Clockwork.Client, v)) then
			if (Clockwork.plugin:Call("PlayerCanSeeClass", v)) then
				if (Clockwork.Client:Team() != v.index) then
					return true;
				end;
			end;
		end;
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear(true);
	self.classTable = nil;
	
	local available = nil;
	local classes = {};
	
	for k, v in pairs(Clockwork.class.stored) do
		classes[#classes + 1] = v;
	end;
	
	table.sort(classes, function(a, b)
		local aWages = a.wages or 0;
		local bWages = b.wages or 0;
		
		if (aWages == bWages) then
			return a.name < b.name;
		else
			return aWages > bWages;
		end;
	end);
	
	if (#classes > 0) then
		local label = vgui.Create("cwInfoText", self);
			label:SetText("Classes you choose do not stay with your character.");
			label:SetInfoColor("blue");
		self.panelList:AddItem(label);
		
		for k, v in ipairs(classes) do
			if (Clockwork:HasObjectAccess(Clockwork.Client, v)) then
				if (Clockwork.plugin:Call("PlayerCanSeeClass", v)) then
					self.classTable = Clockwork.class.stored[v.name];
					self.panelList:AddItem(vgui.Create("cwClassesItem", self));
				end;
			end;
		end;
	else
		local label = vgui.Create("cwInfoText", self);
			label:SetText("You do not have access to any classes!");
			label:SetInfoColor("red");
		self.panelList:AddItem(label);
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
	self.panelList:StretchToParent(4, 28, 4, 4);
	self:SetSize(self:GetWide(), math.min(self.panelList.pnlCanvas:GetTall() + 32, ScrH() * 0.75));
	
	derma.SkinHook("Layout", "Frame", self);
end;

-- Called when the panel is painted.
function PANEL:Paint()
	derma.SkinHook("Paint", "Frame", self);
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	local team = Clockwork.Client:Team();
	
	self:InvalidateLayout(true);
	
	if (!self.playerClass) then
		self.playerClass = team;
	end;
	
	if (team != self.playerClass) then
		self.playerClass = team;
		self:Rebuild();
	end;
end;

vgui.Register("cwClasses", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local colorWhite = Clockwork.option:GetColor("white");
	local parent = self:GetParent();
	
	self.classTable = parent.classTable;
	self:SetSize(parent:GetWide(), 32);
	
	if (parent.overrideData) then
		self.overrideData = parent.overrideData;
	else
		self.overrideData = {};
	end;
	
	local players = _team.NumPlayers(self.classTable.index);
	local limit = Clockwork.class:GetLimit(self.classTable.name);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetText(self.classTable.name);
	self.nameLabel:SetTextColor(colorWhite);
	
	self.information = vgui.Create("DLabel", self);
	
	if (self.overrideData.information) then
		self.information:SetText(self.overrideData.information);
	else
		self.information:SetText("There are "..players.."/"..limit.." characters with this class.");
	end;
	
	self.information:SetTextColor(colorWhite);
	self.information:SizeToContents();
	
	local model, skin = Clockwork.class:GetAppropriateModel(self.classTable.index, Clockwork.Client);
	local info = {
		model = model,
		skin = skin
	};
	
	Clockwork.plugin:Call("PlayerAdjustClassModelInfo", self.classTable.index, info);
	
	if (!self.classTable.image) then
		self.spawnIcon = vgui.Create("SpawnIcon", self);
		self.spawnIcon:SetModel(info.model, info.skin);
		self.spawnIcon:SetToolTip(self.classTable.description);
		self.spawnIcon:SetIconSize(32);
	else
		self.spawnIcon = vgui.Create("DImageButton", self);
		self.spawnIcon:SetToolTip(self.classTable.description);
		self.spawnIcon:SetImage(self.classTable.image);
		self.spawnIcon:SetSize(32, 32);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (self.overrideData.Callback) then
			self.overrideData.Callback(self.classTable);
		else
			Clockwork:RunCommand("SetClass", tonumber(self.classTable.index));
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	if (self.classTable and !self.overrideData.information) then
		self.information:SetText("There are ".._team.NumPlayers(self.classTable.index).."/"..Clockwork.class:GetLimit(self.classTable.name).." characters with this class.");
		self.information:SizeToContents();
	end;
	
	self.spawnIcon:SetPos(1, 1);
	self.spawnIcon:SetSize(30, 30);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.nameLabel:SizeToContents();
	self.information:SizeToContents();

	self.spawnIcon:SetPos(1, 1);
	self.nameLabel:SetPos(40, 2);
	self.spawnIcon:SetSize(30, 30);
	self.information:SetPos(40, 30 - self.information:GetTall());
end;
	
vgui.Register("cwClassesItem", PANEL, "DPanel");