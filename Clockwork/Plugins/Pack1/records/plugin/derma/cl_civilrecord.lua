
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

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(800, 480);
	self:Center();

	self:SetTitle("Civil Record");

	self.notesPanel = vgui.Create("cwRecordListPanel", self);
	self.notesPanel:SetWide(260);
	self.notesPanel:SetTagLabelText("NOTES");
	self.notesPanel:Dock(LEFT);

	self.commendationsPanel = vgui.Create("cwRecordListPanel", self);
	self.commendationsPanel:SetWide(260);
	self.commendationsPanel:SetTagLabelText("COMMENDATIONS");
	self.commendationsPanel:Dock(FILL);

	self.violationsPanel = vgui.Create("cwRecordListPanel", self);
	self.violationsPanel:SetWide(260);
	self.violationsPanel:SetTagLabelText("VIOLATIONS");
	self.violationsPanel:Dock(RIGHT);

	self.namePanel = vgui.Create("cwRecordTextPanel", self);
	self.notesPanel:AddPanelToTop(self.namePanel);

	self.civilStatusPanel = vgui.Create("cwCivilStatusPanel", self);
	self.commendationsPanel:AddPanelToTop(self.civilStatusPanel);

	self.socEndStatusPanel = vgui.Create("cwSocEndStatusPanel", self);
	self.commendationsPanel:AddPanelToTop(self.socEndStatusPanel);
end;

-- A function to update the VP's
function PANEL.AddVP(vp)
	PANEL.dataFile.vp = PANEL.dataFile.vp + vp;
end;

-- A function to populate the panel.
function PANEL:PopulateRecords(targetKey, targetName, records, addButtons)
	if (addButtons) then
		if (PLUGIN:CanPlayerAddEntry(Clockwork.Client, targetKey, PLUGIN.types.note)) then
			self.notesButton = vgui.Create("cwRecordAddButton");
			self.notesButton:Populate(targetKey, targetName, "Note", PLUGIN.types.note);
			self.notesPanel:AddPanelToBottom(self.notesButton);
		end;
		
		if (PLUGIN:CanPlayerAddEntry(Clockwork.Client, targetKey, PLUGIN.types.commendation)) then
			self.commendationsButton = vgui.Create("cwRecordAddButton");
			self.commendationsButton:Populate(targetKey, targetName, "Commendation", PLUGIN.types.commendation);
			self.commendationsPanel:AddPanelToBottom(self.commendationsButton);
		end;

		if (PLUGIN:CanPlayerAddEntry(Clockwork.Client, targetKey, PLUGIN.types.violation)) then
			self.violationsButton = vgui.Create("cwRecordAddButton");
			self.violationsButton:Populate(targetKey, targetName, "Violation", PLUGIN.types.violation);
			self.violationsButton:AskPoints("Verdict", self.AddVP);
			self.violationsPanel:AddPanelToBottom(self.commendationsButton);
		end;
	end;

	for k, record in ipairs(records) do
		self:AddData(record);
	end;
end;

function PANEL:PopulateData(targetKey, targetName, targetFaction, dataFile)
	self.dataFile = dataFile;

	self:SetTitle(targetName.."'s Datafile");
	self.namePanel:Populate("Name", targetName);
	self.civilStatusPanel:Populate("Civil Status", targetKey, targetFaction, dataFile);
	self.socEndStatusPanel:Populate("Civil Status", targetKey, targetFaction, dataFile);
end;

-- A function to add a record to the panel
function PANEL:AddData(data, redoChildren)
	if (data.type == PLUGIN.types.note or data.type == PLUGIN.types.civilStatus) then
		self.notesPanel:AddItem(data, redoChildren);
	elseif (data.type == PLUGIN.types.socEndStatus or data.type == PLUGIN.types.commendation) then
		self.commendationsPanel:AddItem(data, redoChildren);
	elseif (data.type == PLUGIN.types.socEndStatus or data.type == PLUGIN.types.violation) then
		self.violationsPanel:AddItem(data, redoChildren);
	end;
end;

function PANEL:OnClose()
	gui.EnableScreenClicker(false);
end;

vgui.Register("cwLoyalistRecord", PANEL, "DFrame");