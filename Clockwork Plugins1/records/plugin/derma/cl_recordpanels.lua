
local PLUGIN = PLUGIN;
local Clockork = Clockwork;

local ipairs = ipairs;
local pairs = pairs;
local tonumber = tonumber;
local string = string;
local os = os;
local vgui = vgui;
local gui = gui;
local DLabel = DLabel;
local DPanel = DPanel;

local PANEL = {};

function PANEL:Init()
	self:SetDrawBackground(false);

	self.listPanel = vgui.Create("DPanel", self);
	self.listPanel:SetDrawBackground(false);
	self.listPanel:Dock(FILL);

	self.tagLabel = vgui.Create("DLabel", self.listPanel);
	self.tagLabel:SetDark(true);
	self.tagLabel:SetFont("DermaLarge");
	self.tagLabel:SizeToContents();
	self.tagLabel:Dock(TOP);

	self.scrollPanel = vgui.Create("DScrollPanel", self.listPanel);
	self.scrollPanel:Dock(FILL);
	self.scrollPanel:SetDrawBackground(true);
	self.scrollPanel:SetBackgroundColor(Color(128, 128, 128));

	self.recordList = vgui.Create("DIconLayout", self.scrollPanel:GetCanvas());
	self.recordList:SetSpaceY(4);
	self.recordList:Dock(FILL);
end;

function PANEL:SetTagLabelText(text)
	self.tagLabel:SetText(text);
end;

function PANEL:AddPanelToTop(panel)
	panel:SetParent(self);
	panel:DockMargin(0, 0, 0, 6);
	panel:Dock(TOP);
end;

function PANEL:AddPanelToBottom(panel)
	panel:SetParent(self);
	panel:DockMargin(0, 6, 0, 0);
	panel:Dock(BOTTOM);
end;

function PANEL:AddItem(record, redoChildren)
	local panel = vgui.Create("cwRecordEntry");
	panel:SetWide(self.recordList:GetWide());
	panel:Populate(record);

	if (!redoChildren) then
		self.recordList:Add(panel);
	else
		local children = {panel};
		for k, v in ipairs(self.recordList:GetChildren()) do
			children[#children + 1] = v;
			v:SetParent(nil);
		end;

		for k, v in ipairs(children) do
			self.recordList:Add(v);
		end;
	end;
	self.scrollPanel:GetCanvas():SetTall(self.scrollPanel:GetTall());
end;

function PANEL:PerformLayout()
	DPanel.PerformLayout(self);

	if (self.scrollPanel:GetVBar()) then
		self.scrollPanel:GetCanvas():SetWide(self.scrollPanel:GetWide() - self.scrollPanel:GetVBar():GetWide());
	else
		self.scrollPanel:GetCanvas():SetWide(self.scrollPanel:GetWide());
	end;
end;

vgui.Register("cwRecordListPanel", PANEL, "DPanel");


PANEL = {};

function PANEL:Init()
	self.timeStampLabel = vgui.Create("cwRecordDLabel", self);
	self.timeStampLabel:DockMargin(4, 4, 4, 0);
	self.timeStampLabel:Dock(TOP);

	self.textLabel = vgui.Create("cwRecordDLabel", self);
	self.textLabel:SetWrap(true);
	self.textLabel:DockMargin(4, 2, 4, 0);
	self.textLabel:Dock(TOP);

	self.createdByLabel = vgui.Create("cwRecordDLabel", self);
	self.createdByLabel:DockMargin(16, 2, 4, 4);
	self.createdByLabel:Dock(BOTTOM);
end;

function PANEL:Populate(record)
	self.record = record;

	self.timeStampLabel:SetText((tonumber(os.date("%Y", record.timeStamp)) + 5)..os.date("/%m/%d %H:%M:%S", record.timeStamp));

	self.textLabel:SetText(record.text);

	self.createdByLabel:SetText("-"..record.createdBy);

	if (PLUGIN:CanPlayerHideEntry(Clockwork.Client, record)) then
		self.hideButton = vgui.Create("DImageButton", self);
		self:SetHideButtonImage();
		self.hideButton:SetSize(16, 16);

		function self.hideButton.DoClick(button)
			self.record.hidden = !self.record.hidden;
			self:SetHideButtonImage();
			Clockwork.datastream:Start("SetEntryHidden", record);
		end;
	end;
end;

function PANEL:SetHideButtonImage()
	if (self.hideButton) then
		if (self.record.hidden) then
			self.hideButton:SetImage("icon16/add.png");
		else
			self.hideButton:SetImage("icon16/delete.png");
		end;
	end;
end;

function PANEL:PerformLayout()
	DPanel.PerformLayout(self);
	self:SetWide(self:GetParent():GetWide());

	self.textLabel:InvalidateLayout(true);

	self:SetTall(self.timeStampLabel:GetTall() + self.textLabel:GetTall() + self.createdByLabel:GetTall() + 12);

	if (self.hideButton) then
		self.hideButton:SetPos(self:GetWide() - 20, 4);
	end;
end;

vgui.Register("cwRecordEntry", PANEL, "DPanel");


PANEL = {};

function PANEL:Init()
	self:SetDark(true);
	self:SetAutoStretchVertical(true);
end;

function PANEL:SetText(text)
	self:SetWide(self:GetParent():GetWide());

	DLabel.SetText(self, text);

	self:SizeToContentsY();
end;

vgui.Register("cwRecordDLabel", PANEL, "DLabel");


PANEL = {};

function PANEL:Init()
	self:SetTall(30);

	function self:DoClick()
		if (PLUGIN:CanPlayerAddEntry(Clockwork.Client, self.targetKey, self.typeInitial)) then
			Derma_StringRequest("Add "..self.type, "Add a "..string.lower(self.type).." to "..self.targetName.."'s Datafile:", "", function(text)
				if (self.addPoints) then
					Derma_StrinGrequest("How many "..self.addPoints.." do you want to add to "..self.targetName.."'s Datafile?", 0, function(points)
						if (tonumber(points) and text != "") then
							if (self.callback) then
								self.callback(tonumber(points));
							end;
							Clockwork.datastream:Start("AddEntryToRecord", {self.targetKey, self.typeInitial, text, tonumber(points)});
						end;
					end, nil, "Add");
				elseif (text != "") then
					Clockwork.datastream:Start("AddEntryToRecord", {self.targetKey, self.typeInitial, text});
				end;
			end, nil, "Add");
		end;
	end;
end;

function PANEL:AskPoints(type, callback)
	self.addPoints = type;
	self.callback = callback;
end;

function PANEL:Populate(targetKey, targetName, type, initial, callback)
	self:SetText("ADD "..string.upper(type));

	self.targetKey = targetKey;
	self.targetName = targetName;
	self.type = type;
	self.typeInitial = initial or string.lower(string.sub(type, 1, 1));
end;

vgui.Register("cwRecordAddButton", PANEL, "DButton");


PANEL = {};

function PANEL:Init()
	self:SetTall(40);
	self:SetDrawBackground(false);

	self.tagLabel = vgui.Create("DLabel", self);
	self.tagLabel:SetDark(true);
	self.tagLabel:SetAutoStretchVertical(true);
	self.tagLabel:Dock(TOP);

	self.textPanel = vgui.Create("DPanel", self);
	self.textPanel:Dock(FILL);

	self.textLabel = vgui.Create("DLabel", self.textPanel);
	self.textLabel:SetDark(true);
	self.textLabel:DockMargin(4, 1, 4, 1);
	self.textLabel:Dock(FILL);
end;

function PANEL:Populate(tagLabelText, textLabelText)
	self.tagLabel:SetText(tagLabelText);
	self.textLabel:SetText(textLabelText);
end;

vgui.Register("cwRecordTextPanel", PANEL, "DPanel");


PANEL = {};

function PANEL:Init()
	self:SetHeight(40);
	self:SetDrawBackground(false);

	self.tagLabel = vgui.Create("DLabel", self);
	self.tagLabel:SetDark(true);
	self.tagLabel:SetAutoStretchVertical(true);
	self.tagLabel:Dock(TOP);

	self.textPanel = vgui.Create("DPanel", self);
	self.textPanel:Dock(FILL);

	self.textButton = vgui.Create("DLabel", self.textPanel);
	self.textButton:SetDrawBackground(false);
	self.textButton:SetDark(true);
	self.textButton:DockMargin(4, 1, 4, 1);
	self.textButton:Dock(FILL);

	function self.textButton.DoClick(button)
		if (IsValid(self.menuPanel)) then
			self.menuPanel:Remove();
		end;

		if (!self.statusList) then
			return;
		end;

		self.menuPanel = vgui.Create("DMenu");
		self.menuPanel:SetPos(gui.MouseX(), gui.MouseY());

		local lastLevel;
		local option;
		for k, v in ipairs(self.statusList) do
			if (PLUGIN:CanPlayerChangeCivilStatus(Clockwork.Client, self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, v.uniqueID)) then
				if (!lastLevel) then
					lastLevel = v.level;
				elseif (lastLevel != v.level) then
					self.menuPanel:AddSpacer();
					lastLevel = v.level;
				end;

				option = self.menuPanel:AddOption(v.name, function()
					self:ValueSelected(k);
				end);
				if (v.icon) then
					option:SetIcon("icon16/"..v.icon..".png");
				end;
			end;
		end;

		self.menuPanel:MakePopup();
	end;
end;

function PANEL:Think()
	if (self.dataFile and (self.dataFile.civilStatus != self.selected or
		self.dataFile.data.lt != self.lt or self.dataFile.vp != self.vp)) then

		self.selected = self.dataFile.civilStatus == "" and nil or self.dataFile.civilStatus;
		self.vp = self.dataFile.vp or 0;
		self.lt = self.dataFile.data.lt or 0;

		self:SetButtonText();
	end;
end;

function PANEL:Populate(labelText, targetKey, targetFaction, dataFile)
	self.tagLabel:SetText(labelText);

	self.targetKey = targetKey;
	self.targetFaction = targetFaction;
	self.statusList = PLUGIN:GetCivilStatusList(targetFaction).list;

	if (PLUGIN:CanPlayerChangeCivilStatus(Clockwork.Client, targetKey, targetFaction)) then
		self.textButton:SetMouseInputEnabled(true);
	end;

	self.dataFile = dataFile;
end;

function PANEL:SetButtonText()
	self.selectedStatus = PLUGIN:GetStatus(self.statusList, self.vp, self.lt);
	self.textButton:SetText(self.selectedStatus.name);
end;

function PANEL:ValueSelected(key)
	if (PLUGIN:CanPlayerChangeCivilStatus(Clockwork.Client, self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, self.statusList[key].uniqueID)) then
		Clockwork.datastream:Start("SetCivilStatus", {self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, self.statusList[key].uniqueID, self.statusList[key].name});
		local newSelected = self.statusList[key].uniqueID;
		local tier = string.match(data[4], "loyalist(%d+)");
		if (tier) then
			self.dataFile.data.lt = tonumber(tier);
			self.dataFile.civilStatus = "";
		else
			if (PLUGIN.defaultCivilStatus[newSelected]) then
				self.dataFile.data.lt = 0;
				self.dataFile.civilStatus = "";
			else
				self.dataFile.civilStatus = newSelected;
			end;
		end;
	end;
end;

function PANEL:OnRemove()
	if (IsValid(self.menuPanel)) then
		self.menuPanel:Remove();
	end;
end;

vgui.Register("cwCivilStatusPanel", PANEL, "DPanel");



PANEL = {};

function PANEL:Init()
	self:SetHeight(40);
	self:SetDrawBackground(false);

	self.tagLabel = vgui.Create("DLabel", self);
	self.tagLabel:SetDark(true);
	self.tagLabel:SetAutoStretchVertical(true);
	self.tagLabel:Dock(TOP);

	self.textPanel = vgui.Create("DPanel", self);
	self.textPanel:Dock(FILL);

	self.textButton = vgui.Create("DLabel", self.textPanel);
	self.textButton:SetDrawBackground(false);
	self.textButton:SetDark(true);
	self.textButton:DockMargin(4, 1, 4, 1);
	self.textButton:Dock(FILL);

	function self.textButton.DoClick(button)
		if (IsValid(self.menuPanel)) then
			self.menuPanel:Remove();
		end;

		if (!self.statusList) then
			return;
		end;

		self.menuPanel = vgui.Create("DMenu");
		self.menuPanel:SetPos(gui.MouseX(), gui.MouseY());

		local lastLevel;
		local option;
		for k, v in ipairs(self.statusList) do
			if (PLUGIN:CanPlayerChangeSocEndStatus(Clockwork.Client, self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, v.uniqueID)) then
				if (!lastLevel) then
					lastLevel = v.level;
				elseif (lastLevel != v.level) then
					self.menuPanel:AddSpacer();
					lastLevel = v.level;
				end;

				option = self.menuPanel:AddOption(v.name, function()
					self:ValueSelected(k);
				end);
				if (v.icon) then
					option:SetIcon("icon16/"..v.icon..".png");
				end;
			end;
		end;

		self.menuPanel:MakePopup();
	end;
end;

function PANEL:Think()
	if (self.dataFile and (self.dataFile.civilStatus != self.selected or
		self.dataFile.data.lt != self.lt or self.dataFile.vp != self.vp)) then

		self.selected = self.dataFile.civilStatus == "" and nil or self.dataFile.civilStatus;
		self.vp = self.dataFile.vp or 0;
		self.lt = self.dataFile.data.lt or 0;

		self:SetButtonText();
	end;
end;

function PANEL:Populate(labelText, targetKey, targetFaction, dataFile)
	self.tagLabel:SetText(labelText);

	self.targetKey = targetKey;
	self.targetFaction = targetFaction;
	self.statusList = PLUGIN:GetSocEndStatusList(targetFaction).list;

	if (PLUGIN:CanPlayerChangeSocEndStatus(Clockwork.Client, targetKey, targetFaction)) then
		self.textButton:SetMouseInputEnabled(true);
	end;

	self.dataFile = dataFile;
end;

function PANEL:SetButtonText()
	self.selectedStatus = PLUGIN:GetStatus(self.statusList, self.vp, self.lt);
	self.textButton:SetText(self.selectedStatus.name);
end;

function PANEL:ValueSelected(key)
	if (PLUGIN:CanPlayerChangeSocEndStatus(Clockwork.Client, self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, self.statusList[key].uniqueID)) then
		Clockwork.datastream:Start("SetSocEndStatus", {self.targetKey, self.targetFaction, self.selectedStatus.uniqueID, self.statusList[key].uniqueID, self.statusList[key].name});
		local newSelected = self.statusList[key].uniqueID;
		local tier = string.match(data[4], "loyalist(%d+)");
		if (tier) then
			self.dataFile.data.lt = tonumber(tier);
			self.dataFile.civilStatus = "";
		else
			if (PLUGIN.defaultSocEndStatus[newSelected]) then
				self.dataFile.data.lt = 0;
				self.dataFile.civilStatus = "";
			else
				self.dataFile.civilStatus = newSelected;
			end;
		end;
	end;
end;

function PANEL:OnRemove()
	if (IsValid(self.menuPanel)) then
		self.menuPanel:Remove();
	end;
end;

vgui.Register("cwSocEndStatusPanel", PANEL, "DPanel");