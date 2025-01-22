--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]
local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

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
	
	self:SetSize(256, 800);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

-- A function to populate the panel.
function PANEL:Populate(data)
	local colorWhite = Clockwork.option:GetColor("white");
	self:SetTitle( "ItemBuilder" );
	
	self.panelList:Clear();
	
	local nameEntry = vgui.Create("DTextEntry");
	local namelabel = vgui.Create("DLabel");
	namelabel:SetAutoStretchVertical(true);
	namelabel:SetTextColor(colorWhite);
	namelabel:SetWrap(true)
	namelabel:SetText("Enter a name for the item!");
	nameEntry:SetMultiline(false);
	nameEntry:SetHeight(25);
	nameEntry:SetText(data.name);
	self.panelList:AddItem(namelabel);
	self.panelList:AddItem(nameEntry);
	local costEntry = vgui.Create("DTextEntry");
	local costlabel = vgui.Create("DLabel");
	costlabel:SetAutoStretchVertical(true);
	costlabel:SetTextColor(colorWhite);
	costlabel:SetWrap(true)
	costlabel:SetText("Enter the cost of the item (numbers only)!");
	costEntry:SetMultiline(false);
	costEntry:SetHeight(25);
	costEntry:SetText(data.cost);
	self.panelList:AddItem(costlabel);
	self.panelList:AddItem(costEntry);
	local modelEntry = vgui.Create("DTextEntry");
	local modellabel = vgui.Create("DLabel");
	modellabel:SetAutoStretchVertical(true);
	modellabel:SetTextColor(colorWhite);
	modellabel:SetWrap(true)
	modellabel:SetText("Enter a model path for the item!");
	modelEntry:SetMultiline(false);
	modelEntry:SetHeight(25);
	modelEntry:SetText(data.model);
	self.panelList:AddItem(modellabel);
	self.panelList:AddItem(modelEntry);
	local weightEntry = vgui.Create("DTextEntry");
	local weightlabel = vgui.Create("DLabel");
	weightlabel:SetAutoStretchVertical(true);
	weightlabel:SetTextColor(colorWhite);
	weightlabel:SetWrap(true)
	weightlabel:SetText("Enter a weight value for the item (numbers only)!");
	weightEntry:SetMultiline(false);
	weightEntry:SetHeight(25);
	weightEntry:SetText(data.weight);
	self.panelList:AddItem(weightlabel);
	self.panelList:AddItem(weightEntry);
	local accessEntry = vgui.Create("DTextEntry");
	local accesslabel = vgui.Create("DLabel");
	accesslabel:SetAutoStretchVertical(true);
	accesslabel:SetTextColor(colorWhite);
	accesslabel:SetWrap(true)
	accesslabel:SetText("Enter the flag that the item can be accessed by!");
	accessEntry:SetMultiline(false);
	accessEntry:SetHeight(25);
	accessEntry:SetText(data.access);
	self.panelList:AddItem(accesslabel);
	self.panelList:AddItem(accessEntry);
	local useTextEntry = vgui.Create("DTextEntry");
	local useTextlabel = vgui.Create("DLabel");
	useTextlabel:SetAutoStretchVertical(true);
	useTextlabel:SetTextColor(colorWhite);
	useTextlabel:SetWrap(true)
	useTextlabel:SetText("Enter what the use-text of the item will be!");
	useTextEntry:SetMultiline(false);
	useTextEntry:SetHeight(25);
	useTextEntry:SetText(data.useText);
	self.panelList:AddItem(useTextlabel);
	self.panelList:AddItem(useTextEntry);
	local categoryEntry = vgui.Create("DTextEntry");
	local categorylabel = vgui.Create("DLabel");
	categorylabel:SetAutoStretchVertical(true);
	categorylabel:SetTextColor(colorWhite);
	categorylabel:SetWrap(true)
	categorylabel:SetText("Enter a category for the item!");
	categoryEntry:SetMultiline(false);
	categoryEntry:SetHeight(25);
	categoryEntry:SetText(data.category);
	self.panelList:AddItem(categorylabel);
	self.panelList:AddItem(categoryEntry);
	local descriptionEntry = vgui.Create("DTextEntry");
	local descriptionlabel = vgui.Create("DLabel");
	descriptionlabel:SetAutoStretchVertical(true);
	descriptionlabel:SetTextColor(colorWhite);
	descriptionlabel:SetWrap(true)
	descriptionlabel:SetText("Enter a description for the item!");
	descriptionEntry:SetMultiline(false);
	descriptionEntry:SetHeight(25);
	descriptionEntry:SetText(data.description);
	self.panelList:AddItem(descriptionlabel);
	self.panelList:AddItem(descriptionEntry);
	
	local button = vgui.Create("DButton");	
	local deletebutton = vgui.Create("DButton");
	deletebutton:SetText("Delete this item!");
	button:SetText("Create the item!");
	
	-- Called when the button is clicked.
	function button.DoClick(button)
		self:Close(); self:Remove();
	
		local transmitTable = {};
		transmitTable.name = nameEntry:GetValue();
		transmitTable.cost = costEntry:GetValue();
		transmitTable.model = modelEntry:GetValue();
		transmitTable.weight = weightEntry:GetValue();
		transmitTable.access = accessEntry:GetValue();
		transmitTable.useText = useTextEntry:GetValue()
		transmitTable.category = categoryEntry:GetValue()
		transmitTable.description = descriptionEntry:GetValue()

		Clockwork.datastream:Start("CreateItem", transmitTable);
		
		gui.EnableScreenClicker(false);
	end;
	
	-- Called when the button is clicked.
	function deletebutton.DoClick(deletebutton)
		if (data.customnumber) then
			self:Close(); self:Remove();
			
			Clockwork.datastream:Start("RemoveItem", data);
			
			print("[IB]"..data.name.." will be unloaded next restart!")
			gui.EnableScreenClicker(false);
		end;
	end;
	
	self.panelList:AddItem(deletebutton);
	self.panelList:AddItem(button);
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(4, 28, 4, 4);
	
	DFrame.PerformLayout(self);
end;

vgui.Register("cwCreateItem", PANEL, "DFrame");