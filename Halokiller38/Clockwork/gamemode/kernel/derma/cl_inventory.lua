--[[
	Free Clockwork!
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	self:SetTitle(Clockwork.option:GetKey("name_inventory"));
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.inventoryList = vgui.Create("DPanelList", self);
 	self.inventoryList:SetPadding(2);
 	self.inventoryList:SetSpacing(3);
 	self.inventoryList:SizeToContents();
 	self.inventoryList:EnableVerticalScrollbar();

	Clockwork.inventory.panel = self;
	Clockwork.inventory.panel:Rebuild();
end;

-- A function to handle unequipping for the panel.
function PANEL:HandleUnequip(itemTable)
	if (itemTable.OnHandleUnequip) then
		itemTable:OnHandleUnequip(
		function(arguments)
			if (arguments) then
				Clockwork:StartDataStream(
					"UnequipItem", {itemTable("uniqueID"), itemTable("itemID"), arguments}
				);
			else
				Clockwork:StartDataStream(
					"UnequipItem", {itemTable("uniqueID"), itemTable("itemID")}
				);
			end;
		end);
	else
		Clockwork:StartDataStream(
			"UnequipItem", {itemTable("uniqueID"), itemTable("itemID")}
		);
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.inventoryList:Clear(true);
	
	local label = vgui.Create("cwInfoText", self);
		label:SetText("To view an item's options, click on its spawn icon.");
		label:SetInfoColor("blue");
	self.inventoryList:AddItem(label);
	
	self.weightForm = vgui.Create("DForm", self);
	self.weightForm:SetPadding(4);
	self.weightForm:SetName("Weight");
	self.weightForm:AddItem(vgui.Create("cwInventoryWeight", self));
	
	local equipCategories = {};
	local invCategories = {};
	
	for k, v in pairs(Clockwork.Client:GetWeapons()) do
		local itemTable = Clockwork.item:GetByWeapon(v);
		
		if (itemTable and itemTable.HasPlayerEquipped
		and itemTable:HasPlayerEquipped(Clockwork.Client, true)) then
			local itemCategory = itemTable("equippedCategory", itemTable("category"));
			equipCategories[itemCategory] = equipCategories[itemCategory] or {};
			equipCategories[itemCategory][#equipCategories[itemCategory] + 1] = itemTable;
		end;
	end;
	
	for k, v in pairs(Clockwork.inventory:GetClient()) do
		for k2, v2 in pairs(v) do
			local itemCategory = v2("category");
			
			if (v2.HasPlayerEquipped and v2:HasPlayerEquipped(Clockwork.Client, false)) then
				itemCategory = v2("equippedCategory", itemCategory);
				equipCategories[itemCategory] = equipCategories[itemCategory] or {};
				equipCategories[itemCategory][#equipCategories[itemCategory] + 1] = v2;
			else
				invCategories[itemCategory] = invCategories[itemCategory] or {};
				invCategories[itemCategory][#invCategories[itemCategory] + 1] = v2;
			end;
		end;
	end;
	
	Clockwork.plugin:Call("PlayerInventoryRebuilt", self, invCategories);
	
	if (self.weightForm) then
		self.inventoryList:AddItem(self.weightForm);
	end;
	
	if (table.Count(equipCategories) > 0) then
		self.equippedForm = vgui.Create("DForm", self);
		self.equippedForm:SetName("CURRENT EQUIPMENT");
		self.equippedForm:SetPadding(4);
		
		local panelList = vgui.Create("DPanelList", self);
			panelList:EnableHorizontal(true);
			panelList:SetAutoSize(true);
			panelList:SetPadding(4);
			panelList:SetSpacing(4);
		self.equippedForm:AddItem(panelList);
		
		for k, v in pairs(equipCategories) do
			for k2, v2 in ipairs(v) do
				local itemData = {
					itemTable = v2, OnPress = function()
						self:HandleUnequip(v2);
					end
				};
				
				self.itemData = itemData;
				panelList:AddItem(vgui.Create("cwInventoryItem", self)) ;
			end;
		end;
		
		self.inventoryList:AddItem(self.equippedForm);
	end;
	
	if (table.Count(invCategories) > 0) then
		self.inventoryForm = vgui.Create("DForm", self);
		self.inventoryForm:SetName(Clockwork.option:GetKey("name_inventory"));
		self.inventoryForm:SetPadding(4);
		
		local panelList = vgui.Create("DPanelList", self);
			panelList:EnableHorizontal(true);
			panelList:SetAutoSize(true);
			panelList:SetPadding(4);
			panelList:SetSpacing(4);
		self.inventoryForm:AddItem(panelList);
		
		for k, v in pairs(invCategories) do
			for k2, v2 in ipairs(v) do
				local itemData = {
					itemTable = v2
				};
				
				self.itemData = itemData;
				panelList:AddItem(vgui.Create("cwInventoryItem", self)) ;
			end;
		end;
		
		self.inventoryList:AddItem(self.inventoryForm);
	end;

	self.inventoryList:InvalidateLayout(true);
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
	self.inventoryList:StretchToParent(4, 28, 4, 4);
	
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

vgui.Register("cwInventory", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 48);
	
	local customData = self:GetParent().customData or {};
	local toolTip = "";
	
	if (customData.information) then
		if (type(customData.information) == "number") then
			customData.information = customData.information.."kg";
		end;
	end;
	
	if (customData.description) then
		toolTip = Clockwork.config:Parse(customData.description);
	end;
	
	if (toolTip == "") then
		toolTip = nil;
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
	
vgui.Register("cwInventoryCustom", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local destroyName = Clockwork.option:GetKey("name_destroy");
	local itemData = self:GetParent().itemData;
	local dropName = Clockwork.option:GetKey("name_drop");
	local useName = Clockwork.option:GetKey("name_use");
	
	self:SetSize(48, 48);
	self.itemTable = itemData.itemTable;
	self.spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
	
	if (!itemData.OnPress) then
		self.spawnIcon.OpenMenu = function(spawnIcon)
			if (self.itemTable.OnHandleRightClick) then
				local functionName = self.itemTable:OnHandleRightClick();
				
				if (functionName and functionName != "Use") then
					local customFunctions = self.itemTable("customFunctions");
					
					if (customFunctions and table.HasValue(customFunctions, functionName)) then
						if (self.itemTable.OnCustomFunction) then
							self.itemTable:OnCustomFunction(v);
						end;
					end;
					
					Clockwork:RunCommand(
						"InvAction", string.lower(functionName), self.itemTable("uniqueID"), self.itemTable("itemID")
					);
					spawnIcon.animPress:Start(0.2);
					
					return;
				end;
			end;
			
			if (self.itemTable.OnUse) then
				if (self.itemTable.OnHandleUse) then
					self.itemTable:OnHandleUse(function()
						Clockwork:RunCommand("InvAction", "use", self.itemTable("uniqueID"), self.itemTable("itemID"));
					end);
				else
					Clockwork:RunCommand("InvAction", "use", self.itemTable("uniqueID"), self.itemTable("itemID"));
				end;
				
				spawnIcon.animPress:Start(0.2);
			end;
		end;
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (itemData.OnPress) then
			itemData.OnPress();
			return;
		end;
		
		local customFunctions = self.itemTable("customFunctions");
		local itemFunctions = {};
		
		if (self.itemTable.OnUse) then
			itemFunctions[#itemFunctions + 1] = self.itemTable("useText", useName);
		end;
		
		if (self.itemTable.OnDrop) then
			itemFunctions[#itemFunctions + 1] = self.itemTable("dropText", dropName);
		end;
		
		if (self.itemTable.OnDestroy) then
			itemFunctions[#itemFunctions + 1] = self.itemTable("destroyText", destroyName);
		end;
		
		if (customFunctions) then
			for k, v in ipairs(customFunctions) do
				itemFunctions[#itemFunctions + 1] = v;
			end;
		end;
		
		if (self.itemTable.OnEditFunctions) then
			self.itemTable:OnEditFunctions(itemFunctions);
		end;
		
		Clockwork.plugin:Call("PlayerAdjustItemFunctions", self.itemTable, itemFunctions);
		Clockwork:ValidateTableKeys(itemFunctions);
		
		table.sort(itemFunctions, function(a, b) return a < b; end);
		
		if (#itemFunctions > 0) then
			local itemMenu = DermaMenu();
				Clockwork.plugin:Call("PlayerAdjustItemMenu", self.itemTable, itemMenu, itemFunctions);
				
				for k, v in pairs(itemFunctions) do
					local useText = self.itemTable("useText", "Use");
					local dropText = self.itemTable("dropText", "Drop");
					local destroyText = self.itemTable("destroyText", "Destroy");
					
					if ((!useText and v == "Use") or (useText and v == useText)) then
						itemMenu:AddOption(v, function()
							if (self.itemTable) then
								if (self.itemTable.OnHandleUse) then
									self.itemTable:OnHandleUse(function()
										Clockwork:RunCommand(
											"InvAction", "use", self.itemTable("uniqueID"), self.itemTable("itemID")
										);
									end);
								else
									Clockwork:RunCommand(
										"InvAction", "use", self.itemTable("uniqueID"), self.itemTable("itemID")
									);
								end;
							end;
						end);
					elseif ((!dropText and v == "Drop") or (dropText and v == dropText)) then
						itemMenu:AddOption(v, function()
							if (self.itemTable) then
								Clockwork:RunCommand(
									"InvAction", "drop", self.itemTable("uniqueID"), self.itemTable("itemID")
								);
							end;
						end);
					elseif ((!destroyText and v == "Destroy") or (destroyText and v == destroyText)) then
						local subMenu = itemMenu:AddSubMenu(v);
						
						subMenu:AddOption("Yes", function()
							if (self.itemTable) then
								Clockwork:RunCommand(
									"InvAction", "destroy", self.itemTable("uniqueID"), self.itemTable("itemID")
								);
							end;
						end);
						
						subMenu:AddOption("No", function() end);
					else
						if (self.itemTable.OnCustomFunction) then
							self.itemTable:OnCustomFunction(v);
						end;
						
						itemMenu:AddOption(v, function()
							if (self.itemTable) then
								Clockwork:RunCommand(
									"InvAction", v, self.itemTable("uniqueID"), self.itemTable("itemID")
								);
							end;
						end);
					end;
				end;
			itemMenu:Open();
		end;
	end;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
		self.spawnIcon:SetModel(model, skin);
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

vgui.Register("cwInventoryItem", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local maximumWeight = Clockwork.player:GetMaxWeight();
	local colorWhite = Clockwork.option:GetColor("white");
	
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);
	
	self.weight = vgui.Create("DLabel", self);
	self.weight:SetText("N/A");
	self.weight:SetTextColor(colorWhite);
	self.weight:SizeToContents();
	self.weight:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	
	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsed)
		local usedWeight = Clockwork.inventory:CalculateWeight(
			Clockwork.inventory:GetClient()
		);
		local maximumWeight = Clockwork.player:GetMaxWeight();
		
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
	local inventoryWeight = Clockwork.inventory:CalculateWeight(
		Clockwork.inventory:GetClient()
	);
	
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
	self.weight:SetText(inventoryWeight.."/"..Clockwork.player:GetMaxWeight().."kg");
	self.weight:SetPos(self:GetWide() / 2 - self.weight:GetWide() / 2, self:GetTall() / 2 - self.weight:GetTall() / 2);
	self.weight:SizeToContents();
end;
	
vgui.Register("cwInventoryWeight", PANEL, "DPanel");