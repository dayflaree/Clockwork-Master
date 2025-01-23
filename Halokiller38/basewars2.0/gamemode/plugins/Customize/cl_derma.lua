local PLUGIN = PLUGIN;

local PANEL = {};

function PANEL:Init()
	self.categoryList = vgui.Create("DPanelList", self);
	self:Build();
end;

function PANEL:OnMenuOpened()
	self:Build()
end

function PANEL:Build()
	self.categoryList:Clear();
	self.categoryList:StretchToParent(4, 4, 4, 4);
	self.categoryList:SetDrawBackground(false);
	self.categoryList:SetSpacing(2);
	self.categoryList:SetPadding(2);
	self.categoryList:SetAutoSize(true);
	
	//Combobox
	local modelPanel = vgui.Create("DPanelList", self.categoryList);
		modelPanel:EnableHorizontal(true);
		modelPanel:SetDrawBackground(false);
		modelPanel:SetSpacing(2);
		modelPanel:SetPadding(2);
		modelPanel:SetAutoSize(true);
		
		for k, v in pairs(PLUGIN.Models) do
			local itemIcon = vgui.Create("SpawnIcon", modelPanel)
			itemIcon:SetModel(v)
			itemIcon:SetToolTip(v);
			itemIcon.DoClick = function() 
				RP.Command:Run("CustomizeModel", v);
			end;
			itemIcon.PaintOver = function()
				if (string.lower(RP.Client:GetModel()) == string.lower(v)) then
					surface.SetDrawColor(0, 255, 0, 25);
					surface.DrawRect(0, 0, 64, 64);
				end;
			end;
			modelPanel:AddItem(itemIcon);
		end;
	
	self.categoryList:AddItem(modelPanel);
	
	self.categoryList:InvalidateLayout(true);
	self:InvalidateLayout(true);
end;

function PANEL:PerformLayout()
	self.categoryList:StretchToParent(4, 4, 4, 4);

	self:SetSize(RP.menu.width, math.min(self.categoryList.pnlCanvas:GetTall() + 8, RP.menu.height));
end;

vgui.Register("rpCustomize", PANEL, "DPanel");
