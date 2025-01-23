surface.CreateFont("Arial", 14, 700, true, false, "rpInventoryFont");

RP.menu = {};

local PANEL = {};

function PANEL:Init()
	RP.Inventory:Request();
	RP.Inventory.Panel = self;
	-- self:SetVisible(false);
	-- self:SetSize(ScrW()*0.5, ScrH()*0.75);
	-- self:SetSizable(true);
	-- self:SetMinimumSize(500, math.Clamp(ScrH()*0.75, 0, ScrH()-50));
	-- self:ShowCloseButton(true);
	-- self:SetTitle("Inventory");
	-- self:SetPos((ScrW()/2)-self:GetWide()/2, (ScrH()/2)-self:GetTall()/2);
	
	self.categoryList = vgui.Create("DPanelList", self);
	self.categoryList:EnableVerticalScrollbar(true);
	self.categoryList:EnableHorizontal(true);
	self.categoryList:SetSpacing(3);
	self.categoryList:SetPadding(3);
	self.categoryList:SetAutoSize(true);
	
	self.rightPane = vgui.Create("DPanelList", self);
	self.rightPane:EnableVerticalScrollbar(true);
	self.rightPane:SetSpacing(6);
	
	self.categories = {};
	
	self:Layout();

end;

function PANEL:PerformLayout()
	self:Layout();
end;

function PANEL:OnMenuOpened()
	self:Rebuild()
end

function PANEL:Rebuild()
	if (RP.Inventory:Get()) then
		self.categoryList:Clear();
		local categories = {};

		for k, v in pairs(RP.Inventory:Get()) do
			local itemTable = RP.Item:Get(k);
			if (itemTable) then
				if (!categories[itemTable.category]) then
					categories[itemTable.category] = {};
				end;
				for itemID, itemData in pairs(v) do
					categories[itemTable.category][itemID] = RP.Item:Get(itemID);
				end;
			end;
		end;
		
		for k, v in pairs(categories) do
		
			for itemID, itemData in pairs(v) do
				if (!self.categories[k]) then
					self.categories[k] = {};
				end;
				self.categories[k][itemID] = vgui.Create("SpawnIcon", self.categoryList)
				self.categories[k][itemID]:SetModel(itemData.model);	
				self.categories[k][itemID]:SetIconSize(48);
				self.categories[k][itemID]:SetToolTip(itemData.name);
				self.categories[k][itemID].DoClick = function()
					self:SetPane(itemID);
					self.currentItem = itemID;
				end;
				self.categories[k][itemID].PaintOver = function()
					if (RP.Client.primaryWeapon == itemID) then
						surface.SetDrawColor(Color(255, 0, 0, 50));
						surface.DrawRect(0, 0, 48, 48);
					elseif (RP.Client.secondaryWeapon == itemID) then
						surface.SetDrawColor(Color(255, 255, 0, 50));
						surface.DrawRect(0, 0, 48, 48);
					elseif (RP.Client.loadedEquipment and table.HasValue(RP.Client.loadedEquipment, itemID)) then
						surface.SetDrawColor(Color(0, 0, 255, 50));
						surface.DrawRect(0, 0, 48, 48);
					else
						if (self.currentItem == itemID) then
							surface.SetDrawColor(Color(0, 255, 0, 50));
							surface.DrawRect(0, 0, 48, 48);
						end;
					end;
				end;
				self.categoryList:AddItem(self.categories[k][itemID]);
			end;
		end;
	end;
	self:Layout();
end;

function PANEL:Layout()
	self:SetHeight(RP.menu.height);
	self.categoryList:StretchToParent(4, 4, 300, 4);
	self.rightPane:StretchToParent(self.categoryList:GetWide()+8, 4, 4, 4);
	
	local gradient = surface.GetTextureID("VGUI/gradient_down");
	local quadObj = {
		texture = gradient,
		color = Color(0, 0, 0, 200),
		x = 0,
		y = 0,
		w = ScrW()
	};
	function self.rightPane:Paint()
		quadObj.h = self:GetTall();
		draw.TexturedQuad(quadObj);
	end;
	
	function self.categoryList:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(50, 50, 50, 255));
	end;
	
	if (self.currentItem and RP.Item:Get(self.currentItem)) then
		self:SetPane(self.currentItem)
	end;
end;

function PANEL:SetPane(itemID)
	local itemData = RP.Item:Get(itemID);
	self.rightPane:Clear();									
		
	local titleObj = vgui.Create("DLabel");
		titleObj:SetText(itemData.name);
		titleObj:SetFont("MenuLarge");
		titleObj:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	self.rightPane:AddItem(titleObj);
	
	local modelObj = vgui.Create("DModelPanel");
		modelObj:SetSize(self.rightPane:GetWide(), self.rightPane:GetWide());
		modelObj:SetModel(itemData.model);
		
		local FOV = 15;
		if (itemData.camFOV) then
			FOV = itemData.camFOV;
		end;
		local POS = Vector(0, 0, 0);
		if (itemData.camPOS) then
			POS = itemData.camPOS;
		end;
		modelObj:SetCamPos(Vector(50, 50, 20));
		modelObj:SetFOV(FOV);
		modelObj:SetLookAt(POS);
	self.rightPane:AddItem(modelObj);	
		
		
	local textObj = vgui.Create("DPanel");
		textObj:SetSize(self.rightPane:GetWide(), self.rightPane:GetTall()-375);
		local gradient = surface.GetTextureID("VGUI/gradient_down");
		local quadObj = {
			texture = gradient,
			color = Color(0, 0, 0, 50),
			x = 0,
			y = 0,
			w = textObj:GetWide(),
			h = textObj:GetTall()
		};
		textObj.Paint = function()
			draw.TexturedQuad(quadObj)
			
			if (type(itemData.Description) == "function") then
				local currentColor = Color(255, 255, 255);
				local y = 5;
				local lastX = 5;
				for k, v in pairs(itemData:Description(RP:NewDescMeta())) do
					if (type(v) == "table") then
						currentColor = v;
					elseif (type(v) == "string") then
						if (v == "<hr>") then
							lastX = 3;
							y = y + 18;
							surface.SetDrawColor(Color(175, 175, 175));
							surface.DrawRect(lastX, y, self.rightPane:GetWide()-6, 1);
							y = y + 3;
						elseif (v == "<br>") then
							lastX = 5;
							y = y + 16 + 2;
						else
							local text = self:DoWordWrap(v, self.rightPane:GetWide()-10);
							local lines = string.Explode("<br>", text);
							for _, lineText in pairs(lines) do
								if (lastX == 5) then
									lineText = string.TrimLeft(lineText);
								end;
								surface.SetFont("rpInventoryFont");
								local w, h = surface.GetTextSize(lineText);
								draw.SimpleTextOutlined(lineText, "rpInventoryFont", lastX, y, currentColor, 0, 0, 1, Color(0, 0, 0));	
								if (!string.find(text, "<br>")) then
									lastX = lastX + w;
								else
									lastX = 5;
									y = y + h + 2;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	self.rightPane:AddItem(textObj);	
	
	local buttonPanel = vgui.Create("DPanel");
		buttonPanel:SetTall(30);
		buttonPanel.useButton = vgui.Create("DButton", buttonPanel);
		buttonPanel.useButton:SetSize(self.rightPane:GetWide()/2, 30);
		local useText = "Use";
		local useCommand = "use";
		
		if (itemData.useText) then
			useText = itemData.useText;
		end;
			if (RP.Client.primaryWeapon == itemID) then
				useText = "Unequip";
				useCommand = "unequip";
			elseif (RP.Client.secondaryWeapon == itemID) then
				useText = "Unequip";
				useCommand = "unequip";
			elseif (RP.Client.loadedEquipment and table.HasValue(RP.Client.loadedEquipment, itemID)) then
				useText = "Unequip";
				useCommand = "unequip";
			end;
		buttonPanel.useButton:SetText(useText);
		buttonPanel.useButton.DoClick = function()
			RP.Command:Run("inventory", useCommand, itemID, itemData.uniqueID);
			self:ClearPane();
		end;
		
		buttonPanel.dropButton = vgui.Create("DButton", buttonPanel);
		buttonPanel.dropButton:SetPos(self.rightPane:GetWide()/2, 0);
		buttonPanel.dropButton:SetSize(self.rightPane:GetWide()/2, 30);
		buttonPanel.dropButton:SetText("Drop");
		buttonPanel.dropButton.DoClick = function()
			RP.Command:Run("inventory", "drop", itemID, itemData.uniqueID);
			self:ClearPane();
		end;
	self.rightPane:AddItem(buttonPanel);
end;

function PANEL:ClearPane()
	self.rightPane:Clear();
	self.currentItem = "";
end;

function PANEL:DoWordWrap(text, width)
	local lines = string.Explode("<br>", text);
	for k, textSplit in pairs(lines) do
		surface.SetFont("rpInventoryFont");
		local w, h = surface.GetTextSize(textSplit)
		if (w >= width) then
			local words = string.Explode(" ", textSplit);
			local length = 0;
			local cumm = "";
			local splitChar = 0;
			local prevLength = 0;
			for k, v in pairs(words) do
				cumm = cumm.." "..v;
				length = length + string.len(v) + 1;
				local w, h = surface.GetTextSize(cumm);
				if (w >= width) then
					splitChar = prevLength;
					break;
				end;
				prevLength = prevLength + string.len(v) + 1;
			end;
			
			if (splitChar != 0) then
				textTable = string.ToTable(textSplit);
				table.insert(textTable, splitChar, "<br>");
				if (textTable[splitChar + 1] == " ") then
					textTable[splitChar + 1] = "";
				end;
				text = table.concat(textTable, "");
			end;
			
		end;
	end;
	return text;
end;

vgui.Register("rpInventory", PANEL, "DPanel");
	