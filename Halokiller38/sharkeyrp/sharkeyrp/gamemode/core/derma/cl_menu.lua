RP.menu = {};

local PANEL = {};

function PANEL:Init()
	self.menuOffset = 0;
	self:SetVisible(false);
	self:SetSize(ScrW(), ScrH());
	self:SetPos(0, 0);
	self:AddButton("Close", function()
		RP:ScoreboardHide();
	end);
	self:AddMenu("Inventory", "rpInventory");
	self:AddMenu("Jobs", "rpJobs");
	self:AddMenu("Player List", "rpScoreboard");
	//self:AddMenu("Settings", "rpSettings");
end;

function PANEL:Rebuild()
	
end;

function PANEL:PerformLayout()

end;

function PANEL:AddMenu(name, panel)
	if (!self.menus) then
		self.menus = {};
	end;
	
	local menuObj = vgui.Create(panel, self);
	menuObj.isOpen = false;
	menuObj:SetVisible(false);
	menuObj:ShowCloseButton(false);
	menuObj:SetTitle(name);
	menuObj:MakePopup();
	menuObj:SetPos((ScrW()/2) - (menuObj:GetWide()/2) + self.menuOffset, (ScrH()/2) - (menuObj:GetTall()/2) + self.menuOffset);
	self.menuOffset = self.menuOffset + 25;
	self.menus[name] = menuObj;
	
	self:AddButton(name, function()
		self:ToggleMenu(name);
	end);
end;

function PANEL:ToggleMenu(name)
	if (self.menus[name]) then
		local menuTable = self.menus[name];
		if (menuTable.isOpen) then
			menuTable:SetVisible(false);
			menuTable.isOpen = false;
		else
			menuTable:SetVisible(true);
			menuTable:MakePopup();
			menuTable.isOpen = true;
		end;
	end;
end;

function PANEL:AddButton(text, Callback)
	if (!self.buttons) then
		self.buttons = {};
		self.buttonX = 15;
	end;
	
	local buttonObj = vgui.Create("rpButton", self);	
	buttonObj:SetPos(self.buttonX, 5);
	buttonObj:SetValue(text);
	buttonObj.Callback = Callback;
	
	self.buttons[text] = buttonObj;
	
	self.buttonX = self.buttonX + buttonObj:GetWide() + 30;
end;

function PANEL:Show()
	self:SetVisible(true);
	gui.EnableScreenClicker(true);
	if (RP.menu.lastMousePos) then
		gui.SetMousePos(RP.menu.lastMousePos.x, RP.menu.lastMousePos.y);
	end;
end;

function PANEL:Hide()
	self:SetVisible(false);
	RP.menu.lastMousePos = {};
	local x, y = gui.MousePos();
	RP.menu.lastMousePos.x = x;
	RP.menu.lastMousePos.y = y;
	gui.EnableScreenClicker(false);
end;

local gradient = surface.GetTextureID("VGUI/gradient_down");
local quadObj = {
	texture = gradient,
	color = Color(0, 0, 0, 150),
	x = 0,
	y = 0,
	w = ScrW(),
	h = 50
};
function PANEL:Paint()
	Derma_DrawBackgroundBlur(self, 5);
	draw.TexturedQuad(quadObj);
end;

vgui.Register("rpMenu", PANEL);