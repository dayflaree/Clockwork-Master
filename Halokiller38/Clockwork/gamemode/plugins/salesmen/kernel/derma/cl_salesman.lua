--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local salesmanName = Clockwork.salesman:GetName();
	
	self:SetTitle(salesmanName);
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
		self:Close(); self:Remove();
		
		Clockwork:StartDataStream( "SalesmanAdd", {
			showChatBubble = Clockwork.salesman.showChatBubble,
			buyInShipments = Clockwork.salesman.buyInShipments,
			priceScale = Clockwork.salesman.priceScale,
			factions = Clockwork.salesman.factions,
			physDesc = Clockwork.salesman.physDesc,
			buyRate = Clockwork.salesman.buyRate,
			classes = Clockwork.salesman.classes,
			stock = Clockwork.salesman.stock,
			model = Clockwork.salesman.model,
			sells = Clockwork.salesman.sells,
			cash = Clockwork.salesman.cash,
			text = Clockwork.salesman.text,
			buys = Clockwork.salesman.buys,
			name = Clockwork.salesman.name
		} );
		
		Clockwork.salesman.priceScale = nil;
		Clockwork.salesman.factions = nil;
		Clockwork.salesman.classes = nil;
		Clockwork.salesman.physDesc = nil;
		Clockwork.salesman.buyRate = nil;
		Clockwork.salesman.stock = nil;
		Clockwork.salesman.model = nil;
		Clockwork.salesman.sells = nil;
		Clockwork.salesman.buys = nil;
		Clockwork.salesman.items = nil;
		Clockwork.salesman.text = nil;
		Clockwork.salesman.cash = nil;
		Clockwork.salesman.name = nil;
		
		gui.EnableScreenClicker(false);
	end;
	
	self.sellsPanel = vgui.Create("DPanelList");
 	self.sellsPanel:SetPadding(2);
 	self.sellsPanel:SetSpacing(3);
 	self.sellsPanel:SizeToContents();
	self.sellsPanel:EnableVerticalScrollbar();
	
	self.buysPanel = vgui.Create("DPanelList");
 	self.buysPanel:SetPadding(2);
 	self.buysPanel:SetSpacing(3);
 	self.buysPanel:SizeToContents();
	self.buysPanel:EnableVerticalScrollbar();
	
	self.itemsPanel = vgui.Create("DPanelList");
 	self.itemsPanel:SetPadding(2);
 	self.itemsPanel:SetSpacing(3);
 	self.itemsPanel:SizeToContents();
	self.itemsPanel:EnableVerticalScrollbar();
	
	self.settingsPanel = vgui.Create("DPanelList");
 	self.settingsPanel:SetPadding(2);
 	self.settingsPanel:SetSpacing(3);
 	self.settingsPanel:SizeToContents();
	self.settingsPanel:EnableVerticalScrollbar();
	
	self.settingsForm = vgui.Create("DForm");
	self.settingsForm:SetPadding(4);
	self.settingsForm:SetName("Settings");
	self.settingsPanel:AddItem(self.settingsForm);
	
	self.showChatBubble = self.settingsForm:CheckBox("Show chat bubble.");
	self.buyInShipments = self.settingsForm:CheckBox("Buy items in shipments.");
	self.priceScale = self.settingsForm:TextEntry("What amount to scale prices by.");
	self.physDesc = self.settingsForm:TextEntry("The physical description of the salesman.");
	self.buyRate = self.settingsForm:NumSlider("Percentage of price loss from selling.", nil, 1, 100, 0);
	self.stock = self.settingsForm:NumSlider("The default stock of each item (-1 for infinate stock).", nil, -1, 100, 0);
	self.model = self.settingsForm:TextEntry("The model of the salesman.");
	self.cash = self.settingsForm:NumSlider("Starting cash of the salesman (-1 for infinate cash).", nil, -1, 1000000, 0);
	
	self.showChatBubble:SetValue(Clockwork.salesman.showChatBubble == true);
	self.buyInShipments:SetValue(Clockwork.salesman.buyInShipments == true);
	self.priceScale:SetValue(Clockwork.salesman.priceScale);
	self.physDesc:SetValue(Clockwork.salesman.physDesc);
	self.buyRate:SetValue(Clockwork.salesman.buyRate);
	self.stock:SetValue(Clockwork.salesman.stock);
	self.model:SetValue(Clockwork.salesman.model);
	self.cash:SetValue(Clockwork.salesman.cash);
	
	self.responsesForm = vgui.Create("DForm");
	self.responsesForm:SetPadding(4);
	self.responsesForm:SetName("Responses");
	self.settingsForm:AddItem(self.responsesForm);
	
	self.noSaleText = self.responsesForm:TextEntry("When the player cannot trade with them.");
	self.noStockText = self.responsesForm:TextEntry("When the salesman does not have an item in stock.");
	self.needMoreText = self.responsesForm:TextEntry("When the player cannot afford the item.");
	self.cannotAffordText = self.responsesForm:TextEntry("When the salesman cannot afford the item.");
	self.doneBusinessText = self.responsesForm:TextEntry("When the player is done doing trading.");
	
	if (!Clockwork.salesman.text.noSale) then
		self.noSaleText:SetValue("I cannot trade my inventory with you!");
	else
		self.noSaleText:SetValue(Clockwork.salesman.text.noSale);
	end;
	
	if (!Clockwork.salesman.text.noStock) then
		self.noStockText:SetValue("I do not have that item in stock!");
	else
		self.noStockText:SetValue(Clockwork.salesman.text.noStock);
	end;
	
	if (!Clockwork.salesman.text.needMore) then
		self.needMoreText:SetValue("You can't afford to buy that from me!");
	else
		self.needMoreText:SetValue(Clockwork.salesman.text.needMore);
	end;
	
	if (!Clockwork.salesman.text.cannotAfford) then
		self.cannotAffordText:SetValue("I can't afford to buy that item from you!");
	else
		self.cannotAffordText:SetValue(Clockwork.salesman.text.cannotAfford);
	end;
	
	if (!Clockwork.salesman.text.doneBusiness) then
		self.doneBusinessText:SetValue("Thanks for doing business, see you soon!");
	else
		self.doneBusinessText:SetValue(Clockwork.salesman.text.doneBusiness);
	end;
	
	self.factionsForm = vgui.Create("DForm");
	self.factionsForm:SetPadding(4);
	self.factionsForm:SetName("Factions");
	self.settingsForm:AddItem(self.factionsForm);
	self.factionsForm:Help("Leave these unchecked to allow all factions to buy and sell.");
	
	self.classesForm = vgui.Create("DForm");
	self.classesForm:SetPadding(4);
	self.classesForm:SetName("Classes");
	self.settingsForm:AddItem(self.classesForm);
	self.classesForm:Help("Leave these unchecked to allow all classes to buy and sell.");
	
	self.classBoxes = {};
	self.factionBoxes = {};
	
	for k, v in pairs(Clockwork.faction.stored) do
		self.factionBoxes[k] = self.factionsForm:CheckBox(v.name);
		self.factionBoxes[k].OnChange = function(checkBox)
			if ( checkBox:GetChecked() ) then
				Clockwork.salesman.factions[k] = true;
			else
				Clockwork.salesman.factions[k] = nil;
			end;
		end;
		
		if ( Clockwork.salesman.factions[k] ) then
			self.factionBoxes[k]:SetValue(true);
		end;
	end;
	
	for k, v in pairs(Clockwork.class.stored) do
		self.classBoxes[k] = self.classesForm:CheckBox(v.name);
		self.classBoxes[k].OnChange = function(checkBox)
			if ( checkBox:GetChecked() ) then
				Clockwork.salesman.classes[k] = true;
			else
				Clockwork.salesman.classes[k] = nil;
			end;
		end;
		
		if ( Clockwork.salesman.classes[k] ) then
			self.factionBoxes[k]:SetValue(true);
		end;
	end;
	
	self.propertySheet = vgui.Create("DPropertySheet", self);
	self.propertySheet:AddSheet("Sells", self.sellsPanel, "gui/silkicons/box", nil, nil, "View items that "..salesmanName.." sells.");
	self.propertySheet:AddSheet("Buys", self.buysPanel, "gui/silkicons/add", nil, nil, "View items that "..salesmanName.." buys.");
	self.propertySheet:AddSheet("Items", self.itemsPanel, "gui/silkicons/application_view_tile", nil, nil, "View possible items for trading.");
	self.propertySheet:AddSheet("Settings", self.settingsPanel, "gui/silkicons/check_on", nil, nil, "View possible items for trading.");
	
	Clockwork:SetNoticePanel(self);
end;

-- A function to rebuild a panel.
function PANEL:RebuildPanel(panel, typeName, inventory)
	panel:Clear(true);
	panel.typeName = typeName;
	panel.inventory = inventory;
	
	Clockwork.plugin:Call("PlayerSalesmanRebuilding", panel);
	
	local categories = {};
	local items = {};
	
	for k, v in pairs(panel.inventory) do
		local itemTable = Clockwork.item:FindByID(k);
		
		if (itemTable) then
			local category = itemTable.category;
			
			if (category) then
				items[category] = items[category] or {};
				items[category][#items[category] + 1] = {k, v};
			end;
		end;
	end;
	
	for k, v in pairs(items) do
		categories[#categories + 1] = {
			category = k,
			items = v
		};
	end;
	
	Clockwork.plugin:Call("PlayerSalesmanRebuilt", panel, categories);
	
	if (table.Count(categories) > 0) then
		for k, v in pairs(categories) do
			local categoryForm = vgui.Create("DForm", panel);
				categoryForm:SetName(v.category);
				categoryForm:SetPadding(4);
			panel:AddItem(categoryForm);
			
			local panelList = vgui.Create("DPanelList", panel);
				panelList:SetAutoSize(true);
				panelList:SetPadding(4);
				panelList:SetSpacing(4);
			categoryForm:AddItem(panelList);
			
			table.sort(v.items, function(a, b)
				return Clockwork.item.stored[ a[1] ].name < Clockwork.item.stored[ b[1] ].name;
			end);
			
			for k2, v2 in pairs(v.items) do
				panel.currentItem = v2[1];
				panelList:AddItem( vgui.Create("cwSalesmanItem", panel) );
			end;
		end;
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self:RebuildPanel( self.sellsPanel, "Sells",
		Clockwork.salesman:GetSells()
	);
	
	self:RebuildPanel( self.buysPanel, "Buys",
		Clockwork.salesman:GetBuys()
	);
	
	self:RebuildPanel( self.itemsPanel, "Items",
		Clockwork.salesman:GetItems()
	);
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:SetSize(scrW * 0.5, scrH * 0.75);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
	
	Clockwork.salesman.text.doneBusiness = self.doneBusinessText:GetValue();
	Clockwork.salesman.text.cannotAfford = self.cannotAffordText:GetValue();
	Clockwork.salesman.text.needMore = self.needMoreText:GetValue();
	Clockwork.salesman.text.noStock = self.noStockText:GetValue();
	Clockwork.salesman.text.noSale = self.noSaleText:GetValue();
	Clockwork.salesman.showChatBubble = (self.showChatBubble:GetChecked() == true);
	Clockwork.salesman.buyInShipments = (self.buyInShipments:GetChecked() == true);
	Clockwork.salesman.physDesc = self.physDesc:GetValue();
	Clockwork.salesman.buyRate = self.buyRate:GetValue();
	Clockwork.salesman.stock = self.stock:GetValue();
	Clockwork.salesman.model = self.model:GetValue();
	Clockwork.salesman.cash = self.cash:GetValue();
	
	local priceScale = self.priceScale:GetValue();
	Clockwork.salesman.priceScale = tonumber(priceScale) or 1;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.propertySheet:StretchToParent(4, 28, 4, 4);
	self.settingsPanel:StretchToParent(0, 0, 0, 0);
	self.sellsPanel:StretchToParent(0, 0, 0, 0);
	self.itemsPanel:StretchToParent(0, 0, 0, 0);
	self.buysPanel:StretchToParent(0, 0, 0, 0);
	
	derma.SkinHook("Layout", "Frame", self);
end;

vgui.Register("cwSalesman", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(32, 32);
	
	self.typeName = self:GetParent().typeName;
	self.itemTable = table.Copy( Clockwork.item:FindByID(self:GetParent().currentItem) );
	
	if (self.itemTable.OnInitialize) then
		self.itemTable:OnInitialize(self, "SALESMAN");
	end;

	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetPos(36, 2);
	
	self.infoLabel = vgui.Create("DLabel", self);
	self.infoLabel:SetPos(36, 2);
	
	self.spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
	self.spawnIcon:SetColor(self.itemTable.color);
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (self.itemTable.OnPanelSelected) then
			self.itemTable:OnPanelSelected(self, "SALESMAN");
		end;
		
		if (self.typeName == "Items") then
			if ( self.itemTable.cost == 0 and Clockwork.config:Get("cash_enabled"):Get() ) then
				local cashName = Clockwork.option:GetKey("name_cash");
				
				Clockwork:AddMenuFromData( nil, {
					["Buys"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to be bought for?", "", function(text)
							Clockwork.salesman.buys[self.itemTable.uniqueID] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Sells"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to sell for?", "", function(text)
							Clockwork.salesman.sells[self.itemTable.uniqueID] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Both"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to sell for?", "", function(sellPrice)
							Derma_StringRequest(cashName, "How much do you want the item to be bought for?", "", function(buyPrice)
								Clockwork.salesman.sells[self.itemTable.uniqueID] = tonumber(sellPrice) or true;
								Clockwork.salesman.buys[self.itemTable.uniqueID] = tonumber(buyPrice) or true;
								Clockwork.salesman:GetPanel():Rebuild();
							end);
						end);
					end
				} );
			else
				Clockwork:AddMenuFromData( nil, {
					["Buys"] = function()
						Clockwork.salesman.buys[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Sells"] = function()
						Clockwork.salesman.sells[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Both"] = function()
						Clockwork.salesman.sells[self.itemTable.uniqueID] = true;
						Clockwork.salesman.buys[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end
				} );
			end;
		elseif (self.typeName == "Sells") then
			Clockwork.salesman.sells[self.itemTable.uniqueID] = nil;
			Clockwork.salesman:GetPanel():Rebuild();
		elseif (self.typeName == "Buys") then
			Clockwork.salesman.buys[self.itemTable.uniqueID] = nil;
			Clockwork.salesman:GetPanel():Rebuild();
		end;
	end;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	
	self.spawnIcon:SetModel(model, skin);
	self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetIconSize(32);
end;

-- Called each frame.
function PANEL:Think()
	local description = self.itemTable.description;
	local priceScale = 1;
	local toolTip = "";
	local amount = 0;
	
	if (self.typeName == "Sells") then
		if ( Clockwork.salesman:BuyInShipments() ) then
			amount = self.itemTable.batch;
		else
			amount = 1;
		end;
		
		priceScale = Clockwork.salesman:GetPriceScale();
	elseif (self.typeName == "Buys") then
		priceScale = Clockwork.salesman:GetBuyRate() / 100;
	end;
	
	local actualAmount = math.max(amount, 1);
	local cashInfo = "Unset";
	local name = self.itemTable.name;
	
	if (amount > 1) then
		name = amount.." "..self.itemTable.plural;
	elseif (amount == 1) then
		name = amount.." "..name;
	end;
	
	if (self.typeName == "Sells" and Clockwork.salesman.stock != -1) then
		name = "["..Clockwork.salesman.stock.."] "..name;
	end;
	
	if ( Clockwork.config:Get("cash_enabled"):Get() ) then
		if (self.itemTable.cost != 0) then
			cashInfo = FORMAT_CASH( (self.itemTable.cost * priceScale) * actualAmount );
		else
			cashInfo = "Free";
		end;
		
		local overrideCash = Clockwork.salesman.sells[self.itemTable.uniqueID];
		
		if (type(overrideCash) == "number") then
			cashInfo = FORMAT_CASH(overrideCash * actualAmount);
		end;
	else
		cashInfo = "Free";
	end;
	
	if (self.itemTable.OnPanelThink) then
		self.itemTable:OnPanelThink(self, "SALESMAN");
	end;
	
	if (self.itemTable.GetClientSideName) then
		if ( self.itemTable:GetClientSideName() ) then
			name = actualAmount.." "..self.itemTable:GetClientSideName();
		end;
	end;
	
	if (self.itemTable.GetClientSideDescription) then
		if ( self.itemTable:GetClientSideDescription() ) then
			description = self.itemTable:GetClientSideDescription();
		end;
	end;
	
	if (self.itemTable.toolTip) then
		self.spawnIcon:SetToolTip( Clockwork.config:Parse(description).."\n"..Clockwork.config:Parse(self.itemTable.toolTip) );
	else
		self.spawnIcon:SetToolTip( Clockwork.config:Parse(description) );
	end;
	
	self.nameLabel:SetText(name);
	self.nameLabel:SizeToContents();
	self.infoLabel:SetText(cashInfo);
	self.infoLabel:SizeToContents();
	self.infoLabel:SetPos( self.infoLabel.x, 30 - self.infoLabel:GetTall() );
end;

vgui.Register("cwSalesmanItem", PANEL, "DPanel");