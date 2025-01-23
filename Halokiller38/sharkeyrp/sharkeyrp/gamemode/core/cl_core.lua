//Called when the GM Starts
function RP:Initialize()
	self:InitCore();
	timer.Simple(2, self.inventory.Request, self);
	self:InitDerma();
end;

function RP:InitDerma()
	self.menu = vgui.Create("rpMenu");
end;

function RP:HUDPaint()
	self:DrawHUD();
end

function RP:Think()
	self:ThinkHUD();
end;

function RP:ScoreboardShow()
	self.inventory:Request();
	self.menuOpen = true;
	self.menu:Show();
end;

function RP:ScoreboardHide()
	self.menuOpen = false;
	self.menu:Hide();
end;

function RP:IsMenuOpen()
	if (self.menuOpen) then
		return true;
	end;
	return false;
end;

function RP:ToggleMenu()
	if (self:IsMenuOpen()) then
		self:ScoreboardHide();
	else
		self:ScoreboardShow();
	end;
end;

function RP:HUDShouldDraw(item)
	local hideItems = {"CHudHealth"};
	
	if (table.HasValue(hideItems, item)) then
		return false;
	end;
	return true;
end;

function RP:ModAlpha(color, alpha)
	local r = color.r;
	local g = color.g;
	local b = color.b;
	local a = math.Clamp(alpha, 0, 255);
	return Color(r, g, b, a);
end;

RP:DataHook("ToggleMenu", function(data)
	RP:ToggleMenu();
end);



/* Credits to Conna Wiles for helping out with metatables, lul */
RP.DescMeta = {};

function RP.DescMeta:Init()
	self.desc = {};
end;

function RP.DescMeta:HorizontalRule()
	table.insert(self.desc, "<hr>");
end;

function RP.DescMeta:NewLine()
	table.insert(self.desc, "<br>");
end;

function RP.DescMeta:Color(color)
	table.insert(self.desc, color);
end;

function RP.DescMeta:Text(text)
	table.insert(self.desc, text);
end;

function RP.DescMeta:Get()
	return self.desc;
end;

function RP:NewDescMeta()
	local o = {};
		setmetatable(o, self.DescMeta);
		self.DescMeta.__index = self.DescMeta;
		o:Init();
	return o;
end;

/* Item Outlines */

function RP:ItemEntityDraw(entity)
	self.outline:DrawOutline(entity, Color(255, 255, 255), false, 1.1);
end;

/* Player Death */
RP:DataHook("NetworkDeath", function(data)
	RP.Client.NextSpawn = data.NextSpawn;
end);