surface.CreateFont("Arial", math.min(math.max(ScreenScale(14 / 2.62467192), math.min(14, 16)), 14), 700, true, false, "rpInventoryFont");

RP.menu = {};

local PANEL = {};
local HOVER_MAT = Material("vgui/spawnmenu/hover");

function PANEL:Init()
	self:SetVisible(false);
	self:SetSize(ScrW()*0.5, ScrH()*0.75);
	self:SetSizable(true);
	self:SetMinimumSize(500, math.Clamp(ScrH()*0.75, 0, ScrH()-50));
	self:ShowCloseButton(false);
	self:SetPos((ScrW()/2)-self:GetWide()/2, (ScrH()/2)-self:GetTall()/2);
	
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
	
	self:PerformLayout();
end;


function PANEL:Rebuild()
	if (RP.item.database != false) then
		self.categoryList:Clear();
		local categories = {};

		for k, v in pairs(RP.Item.database) do
			local itemTable = RP.item:Get(k);
			if (itemTable) then
				if (!categories[itemTable.category]) then
					categories[itemTable.category] = {};
				end;
				categories[itemTable.category][itemTable.uniqueID] = table.Copy(itemTable);
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

					local borderColor = Color(255, 0, 0);
					if (RP.Client:CanAfford(itemPrice)) then
						borderColor = Color(0, 255, 0);
					end;
					
					if (self.currentItem == itemID) then
						surface.SetDrawColor(Color(0, 255, 0, 50));
						surface.DrawRect(0, 0, 48, 48);
					end;
				
					HOVER_MAT:SetMaterialVector("$color", Vector(borderColor.r / 255, borderColor.g / 255, borderColor.b / 255));
					HOVER_MAT:SetMaterialFloat("$alpha", 0.5);
					surface.SetDrawColor(borderColor.r, borderColor.g, borderColor.b, 122);
					surface.SetMaterial(HOVER_MAT);
					self:DrawTexturedRect();
					HOVER_MAT:SetMaterialFloat("$alpha", 1);
					HOVER_MAT:SetMaterialVector("$color", Vector(1, 1, 1));
				
					surface.SetDrawColor(20, 20, 20, 200);
					surface.DrawRect(0, self:GetTall()-18, self:GetWide(), 18);
					
					local font = "DefaultSmall";
					if (string.len(itemName) >= 10) then
						font = "HudHintTextSmall";
					end;
					
					draw.SimpleText(itemName, font, self:GetWide()/2, self:GetTall()-10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

				end;				
				self.categoryList:AddItem(self.categories[k][itemID]);
			end;
		end;
	end;
end;

function PANEL:PerformLayout()
	self.categoryList:StretchToParent(4, 26, 300, 4);
	self.rightPane:StretchToParent(self.categoryList:GetWide()+8, 26, 4, 4);
	
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
	
	if (self.currentItem and RP.item:Get(self.currentItem)) then
		self:SetPane(self.currentItem)
	end;
end;

function PANEL:SetPane(itemID)
	local itemData = RP.item:Get(itemID);
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
		buttonPanel.useButton:SetSize(self.rightPane:GetWide(), 30);
		buttonPanel.useButton:SetText(useText);
		buttonPanel.useButton.DoClick = function()
			RP.command:Run("OrderItem", itemData.uniqueID);
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

vgui.Register("rpInventory", PANEL, "DFrame");
	