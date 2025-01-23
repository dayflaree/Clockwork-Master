local PLUGIN = {};

surface.CreateFont("Arial", 40, 700, true, false, "simple_menu_large", false, false, 0);
surface.CreateFont("Arial", 24, 600, true, false, "simple_menu_main", false, false, 0);
surface.CreateFont("Arial", 16, 500, true, false, "simple_menu_small", false, false, 0);

RP.menu.items = {};
RP.menu.width = ScrW() / 1.5;
RP.menu.height = ScrH() / 1.5;

-- Draws some simple text.
function RP.menu:DrawSimpleText(text, font, x, y, color, alignX, alignY, shadowless)
	x = math.Round(x);
	y = math.Round(y);
	
	if (!shadowless) then
		local outlineColor = Color( 0, 0, 0, math.min(200, color.a) );
		
		draw.SimpleText(text, font, x + -1, y + -1, outlineColor, alignX, alignY);
		draw.SimpleText(text, font, x + -1, y + 1, outlineColor, alignX, alignY);
		draw.SimpleText(text, font, x + 1, y + -1, outlineColor, alignX, alignY);
		draw.SimpleText(text, font, x + 1, y + 1, outlineColor, alignX, alignY);
	end;
	
	local width, height = draw.SimpleText(text, font, x, y, color, alignX, alignY);
	
	if (height == 0) then
		height = draw.GetFontHeight(font);
	end;
	
	-- Return the y position.
	return y + height + 2;
end;

-- Add a new menu panel.
function RP.menu:AddNew(title, panel, icon)
	table.insert(self.items, {title = title, panel = panel, icon = icon});
end;

RP.menu:AddNew("Party", "RP_party_manager", "gui/silkicons/users");
RP.menu:AddNew("Inventory", "rpInventory", "gui/silkicons/basket");
RP.menu:AddNew("Manufacturing", "rpStore", "gui/silkicons/basket");
RP.menu:AddNew("Settings", "rpSettings", "gui/silkicons/users");
RP.menu:AddNew("Scoreboard", "rpScoreboard", "gui/silkicons/users");

-- Create the menu panel.
function RP.menu:Create(open)
	self.panel = vgui.Create("rp_menu");
	
	if (open) then
		self.panel:SetOpen(true);
	end;
end;

-- Opens or closes the menu.
function RP.menu:SetOpen(bool)
	if (!self.panel) then
		self:Create(bool);
	else
		self.panel:SetOpen(bool);
	end;
end;

-- Toggles the menu.
function RP.menu:Toggle()
	if (self.open) then
		self:SetOpen(false);
	else
		self:SetOpen(true);
	end;
end;

-- Gets the current active panel.
function RP.menu:GetActivePanel()
	if (self.panel) then
		return self.panel.activePanel;
	else
		return false, "Panel not created";
	end;
end;

hook.Add("VGUIMousePressed", "RP.mmenu.VGUIMousePressed", function(panel, code)
	local activePanel = RP.menu:GetActivePanel();
	local menuPanel = RP.menu.panel;
	
	if (RP.menu.open and activePanel and menuPanel == panel) then
		menuPanel:OpenRadial();
	end;
end);

RP:DataHook("rpShowMenu", function(data)
	RP.menu:SetOpen(true);
end);

RP:DataHook("rpHideMenu", function(data)
	RP.menu:SetOpen(false);
end);

function RP:ScoreboardShow()
	RP.menu:SetOpen(true);
end;

function RP:ScoreboardHide()
	RP.menu:SetOpen(false);
end;
