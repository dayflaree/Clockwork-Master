--[[
	Free Clockwork!
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle(Clockwork.storage:GetName());
	//self:SetBackgroundBlur(false);
	self:SetDeleteOnClose(false);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
			self:Close(); self:Remove();
			gui.EnableScreenClicker(false);
		Clockwork:RunCommand("StorageClose");
	end;
	
	self.containerPanel = vgui.Create("DPanelList", self);
 	self.containerPanel:SetPadding(2);
 	self.containerPanel:SetSpacing(25);
 	self.containerPanel:SizeToContents();
 	self.containerPanel:EnableVerticalScrollbar();

	self.inventoryPanel = vgui.Create("DPanelList", self);
 	self.inventoryPanel:SetPadding(2);
 	self.inventoryPanel:SetSpacing(25);
 	self.inventoryPanel:SizeToContents();
 	self.inventoryPanel:EnableVerticalScrollbar();

	-- self.propertySheet = vgui.Create("DPropertySheet", self);
	-- self.propertySheet:AddSheet("Container", self.containerPanel, "gui/silkicons/box", nil, nil, "View items in the container.");
	-- self.propertySheet:AddSheet(Clockwork.option:GetKey("name_inventory"), self.inventoryPanel, "gui/silkicons/application_view_tile", nil, nil, "View items in your inventory.");

	Clockwork:SetNoticePanel(self);
end;

-- A function to rebuild a panel.
function PANEL:RebuildPanel(panel, storageType, usedWeight, weight, cash, inventory)
	panel:Clear(true);
	
	local opposite = "";
	if (storageType == "Inventory") then
		opposite = "Container";
	else
		opposite = "Inventory";
	end;
	
		panel.cash = cash;
		panel.weight = weight;
		panel.usedWeight = usedWeight;
		panel.inventory = inventory;
		panel.storageType = storageType;
	Clockwork.plugin:Call("PlayerStorageRebuilding", panel);
	
	local label = vgui.Create("cwInfoText", self);
		label:SetText(storageType.."'s Items");
		label:SetInfoColor("green");
	panel:AddItem(label);
	
	local categories = {};
	local usedWeight = (cash * Clockwork.config:Get("cash_weight"):Get());
	
	if (Clockwork.storage:GetNoCashWeight()) then
		usedWeight = 0;
	end;
	
	for k, v in pairs(panel.inventory) do
		for k2, v2 in pairs(v) do
			if ((storageType == "Container" and Clockwork.storage:CanTakeFrom(v2))
			or (storageType == "Inventory" and Clockwork.storage:CanGiveTo(v2))) then
				local itemCategory = v2("category");
				
				if (itemCategory) then
					categories[itemCategory] = categories[itemCategory] or {};
					categories[itemCategory][#categories[itemCategory] + 1] = v2;
					usedWeight = usedWeight + math.max(v2("storageWeight", v2("weight")), 0);
				end;
			end;
		end;
	end;
	
	if (!panel.usedWeight) then
		panel.usedWeight = usedWeight;
	end;
	
	Clockwork.plugin:Call(
		"PlayerStorageRebuilt", panel, categories
	);
	
	local numberWang = nil;
	local cashForm = nil;
	local button = nil;
	
	if (Clockwork.config:Get("cash_enabled"):Get() and panel.cash > 0) then
		numberWang = vgui.Create("DNumberWang", panel);
		cashForm = vgui.Create("DForm", panel);
		button = vgui.Create("DButton", panel);
		button:SetText("Transfer "..Clockwork.option:GetKey("name_cash").." to "..opposite);
		button.Stretch = true;
		
		-- Called when the button is clicked.
		function button.DoClick(button)
			local cashName = Clockwork.option:GetKey("name_cash");
			
			if (storageType == "Inventory") then
				Clockwork:RunCommand("StorageGive"..string.gsub(cashName, "%s", ""), numberWang:GetValue());
			else
				Clockwork:RunCommand("StorageTake"..string.gsub(cashName, "%s", ""), numberWang:GetValue());
			end;
		end;
		
		numberWang.Stretch = true;
		numberWang:SetValue(panel.cash);
		numberWang:SetMinMax(0, panel.cash);
		numberWang:SetDecimals(0);
		numberWang:SizeToContents();
		
		cashForm:SetPadding(5);
		cashForm:SetName(storageType.." "..Clockwork.option:GetKey("name_cash"));
		cashForm:AddItem(numberWang);
		cashForm:AddItem(button);

		
	end;

	if (cashForm) then
		panel:AddItem(cashForm);	
	end;
	

	
	-- if (panel.usedWeight > 0) then
		-- local informationForm = vgui.Create("DForm", panel);
			-- informationForm:SetPadding(5);
			-- informationForm:SetName(storageType.." Weight");
			
		-- panel:AddItem(informationForm);
	-- end;	
	
	if (table.Count(categories) > 0) then
	
		local inventoryForm = vgui.Create("DForm", panel);
			inventoryForm:SetName(storageType);
			inventoryForm:SetPadding(4);
		panel:AddItem(inventoryForm);
		
		local panelList = vgui.Create("DPanelList", panel);
			panelList:EnableHorizontal(true);
			panelList:SetAutoSize(true);
			panelList:SetPadding(4);
			panelList:SetSpacing(4);
		inventoryForm:AddItem(vgui.Create("cwStorageWeight", panel));
		inventoryForm:AddItem(panelList);
		
		for k, v in pairs(categories) do
			for k2, v2 in pairs(v) do
				panel.itemData = {itemTable = v2, storageType = panel.storageType};
				panelList:AddItem(vgui.Create("cwStorageItem", panel));
			end;
		end;

		local label = vgui.Create("cwInfoText", self);
			label:SetText("Click on item's icon to transfer it to the "..opposite);
			label:SetInfoColor("blue");
		inventoryForm:AddItem(label);
	end;	
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()


	self:RebuildPanel(self.containerPanel, "Container", nil,
		Clockwork.storage:GetWeight(),
		Clockwork.storage:GetCash(),
		Clockwork.storage:GetInventory()
	);
	
	local inventory = Clockwork.inventory:GetClient();
	local maxWeight = Clockwork.player:GetMaxWeight();
	local weight = Clockwork.inventory:CalculateWeight(inventory);
	local cash = Clockwork.player:GetCash();
	
	self:RebuildPanel(self.inventoryPanel, "Inventory",
		weight, maxWeight, cash, inventory
	);
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(scrW * 0.75, scrH * 0.80);
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2));
	
	if (IsValid(self.inventoryPanel)) then
		if (Clockwork.player:GetCash() != self.inventoryPanel.cash) then
			self:Rebuild();
		end;
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	-- self.containerPanel:SetPos(0, 0);
	-- self.containerPanel:SetSize(self:GetWide()/2, self:GetTall());
	
	self.containerPanel:StretchToParent((self:GetWide()/2) + 2, 27, 5, 5);
	self.inventoryPanel:StretchToParent(5, 27, (self:GetWide()/2) + 3, 5);
	
	-- self.inventoryPanel:SetPos(self:GetWide()/2, 0);
	-- self.inventoryPanel:SetSize(self:GetWide()/2, self:GetTall());
	
	derma.SkinHook("Layout", "Frame", self);
end;

vgui.Register("cwStorage", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData;
	
	self:SetSize(48, 48);
	self.itemTable = itemData.itemTable;
	self.storageType = itemData.storageType;
	self.spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (self.storageType == "Inventory") then
			Clockwork:RunCommand("StorageGiveItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
		else
			Clockwork:RunCommand("StorageTakeItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
		end;
	end;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
		self.spawnIcon:SetModel(model, skin);
		self.spawnIcon:SetToolTip("");
		self.spawnIcon:SetIconSize(48);
	self.cachedInfo = {model = model, skin = skin};
end;

-- Called each frame.
function PANEL:Think()
	self.spawnIcon:SetMarkupToolTip( Clockwork.item:GetMarkupToolTip(self.itemTable) );
	self.spawnIcon:SetColor(self.itemTable("color"));
	
	--[[ Check if the model or skin has changed and update the spawn icon. --]]
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	
	if (model != self.cachedInfo.model or skin != self.cachedInfo.skin) then
		self.spawnIcon:SetModel(model, skin);
		self.cachedInfo.model = model
		self.cachedInfo.skin = skin;
	end;
end;

vgui.Register("cwStorageItem", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local colorWhite = Clockwork.option:GetColor("white");
	
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);
	self.panel = self:GetParent();
	
	self.weight = vgui.Create("DLabel", self);
	self.weight:SetText("N/A");
	self.weight:SetTextColor(colorWhite);
	self.weight:SizeToContents();
	self.weight:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	
	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsed)
		local maximumWeight = self.panel.weight or 0;
		local usedWeight = self.panel.usedWeight or 0;
		
		local color = Color(100, 100, 100, 255);
		local width = math.Clamp((spaceUsed:GetWide() / maximumWeight) * usedWeight, 0, spaceUsed:GetWide());
		local red = math.Clamp((255 / maximumWeight) * usedWeight, 0, 255) ;
		
		local red = math.Clamp( (255 / maximumWeight) * usedWeight, 0, 255);
		local green = math.Clamp( (-1*(255 / maximumWeight) * usedWeight) + 255, 0, 255);
		
		if (color) then
			color.r = math.min(color.r - 25, 255);
			color.g = math.min(color.g - 25, 255);
			color.b = math.min(color.b - 25, 255);
		end;
		
		Clockwork:DrawSimpleGradientBox(0, 0, 0, spaceUsed:GetWide(), spaceUsed:GetTall(), color);
		Clockwork:DrawSimpleGradientBox(0, 0, 0, width, spaceUsed:GetTall(), Color(red, green, 0, 255));
	end;
end;

-- Called each frame.
function PANEL:Think()
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
	self.weight:SetText((self.panel.usedWeight or 0).."/"..(self.panel.weight or 0).."kg");
	self.weight:SetPos(self:GetWide() / 2 - self.weight:GetWide() / 2, self:GetTall() / 2 - self.weight:GetTall() / 2);
	self.weight:SizeToContents();
end;
	
vgui.Register("cwStorageWeight", PANEL, "DPanel");

usermessage.Hook("cwStorageStart", function(msg)
	if (Clockwork.storage:IsStorageOpen()) then
		CloseDermaMenus();
		
		Clockwork.storage.panel:Close();
		Clockwork.storage.panel:Remove();
	end;
	
	gui.EnableScreenClicker(true);
	
	Clockwork.storage.noCashWeight = msg:ReadBool();
	Clockwork.storage.inventory = {};
	Clockwork.storage.weight = Clockwork.config:Get("default_inv_weight"):Get();
	Clockwork.storage.entity = msg:ReadEntity();
	Clockwork.storage.name = msg:ReadString();
	Clockwork.storage.cash = 0;
	
	Clockwork.storage.panel = vgui.Create("cwStorage");
	Clockwork.storage.panel:Rebuild();
	Clockwork.storage.panel:MakePopup();
end);

usermessage.Hook("cwStorageCash", function(msg)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.storage.cash = msg:ReadLong();
		Clockwork.storage:GetPanel():Rebuild();
	end;
end);


usermessage.Hook("cwStorageWeight", function(msg)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.storage.weight = msg:ReadFloat();
		Clockwork.storage:GetPanel():Rebuild();
	end;
end);

usermessage.Hook("cwStorageClose", function(msg)
	if (Clockwork.storage:IsStorageOpen()) then
		CloseDermaMenus();
		
		Clockwork.storage:GetPanel():Close();
		Clockwork.storage:GetPanel():Remove();
		
		gui.EnableScreenClicker(false);
		
		Clockwork.storage.inventory = nil;
		Clockwork.storage.weight = nil;
		Clockwork.storage.entity = nil;
		Clockwork.storage.name = nil;
	end;
end);

Clockwork:HookDataStream("StorageTake", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.inventory:RemoveUniqueID(
			Clockwork.storage.inventory, data.uniqueID, data.itemID
		);
		
		Clockwork.storage:GetPanel():Rebuild();
	end;
end);

Clockwork:HookDataStream("StorageGive", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		local itemTable = Clockwork.item:FindByID(data.index);
		
		if (itemTable) then
			for k, v in ipairs(data.itemList) do
				Clockwork.inventory:AddInstance(
					Clockwork.storage.inventory,
					Clockwork.item:CreateInstance(data.index, v.itemID, v.data)
				);
			end;
			
			Clockwork.storage:GetPanel():Rebuild();
		end;
	end;
end);