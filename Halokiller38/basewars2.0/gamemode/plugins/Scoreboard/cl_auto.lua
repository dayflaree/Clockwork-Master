--===============
--	Scoreboard 
--===============
surface.CreateFont("Arial", 16, 600, true, false, "scoreboard_font", false, false, 0);

local PANEL = {};

function PANEL:Init()
	self:SetSize(RP.menu.width, RP.menu.height);

	self.itemsList = vgui.Create("DPanelList", self);
	self.itemsList:SizeToContents();
	self.itemsList:SetPadding(2);
	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4,4,4,4)
	self.itemsList:EnableVerticalScrollbar();
	
	self:Rebuild();
end;

function PANEL:Rebuild()
	self.itemsList:Clear();
	
	local players = player.GetAll();
	table.sort(players, function(a,b)
		return a:GetName() <= b:GetName();
	end);
	
	self.info = vgui.Create("DPanel", self);
	self.info.PaintOver = function(panel)
		local latency = 0;
		for k,v in ipairs(players) do
			latency = latency + v:Ping();
		end;
		latency = math.ceil(latency / #players);
		
		draw.SimpleText("Average latency: "..latency.." ms", "scoreboard_font", panel:GetWide() / 2, panel:GetTall() / 2,  Color(255, 255, 255, 255), 1, 1, 1, Color(0, 0, 0,255));
	end;
	self.itemsList:AddItem(self.info);
	
	for k,v in ipairs(players) do
		self.curPlayer = v;
		self.itemsList:AddItem(vgui.Create("rpScoreboard_item", self));
	end;
	
	self.itemsList:InvalidateLayout(true);
	self:InvalidateLayout(true);
end;

function PANEL:PerformLayout()
	self.itemsList:StretchToParent(4, 4, 4, 4);

	self:SetSize(RP.menu.width, math.min(self.itemsList.pnlCanvas:GetTall() + 8, RP.menu.height));
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if RP.menu:GetActivePanel() == self then
		self:Rebuild();
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

vgui.Register("rpScoreboard", PANEL, "DPanel");

local PANEL = {};

function PANEL:Init()
	self:SetSize(RP.menu.width, 40);
	self.player = self:GetParent().curPlayer;
	
	self.icon = vgui.Create("SpawnIcon", self);
	self.icon:SetModel(self.player:GetModel());
	self.icon:SetTooltip();
	self.icon:SetIconSize(32);
	
	self.avatar = vgui.Create("AvatarImage", self);
	self.avatar:SetSize(32, 32);
	self.avatar:SetPlayer(self.player);
	
	self.info = vgui.Create("DPanel", self);
	self.info:SetSize(self:GetWide() - 80, self:GetTall() - 8);
	self.info.Paint = function(panel)
		local ping = Format("Ping: %d ms", self.player:Ping());
		surface.SetFont("scoreboard_font");
		local w, h = surface.GetTextSize(ping);
		
		draw.SimpleText(self.player:GetName(), "scoreboard_font", 0, 0,  Color(255, 255, 255, 255), 0, 0, 1, Color(0, 0, 0,255));
		draw.SimpleText(ping, "scoreboard_font", panel:GetWide() - w - 8, 0,  Color(255, 255, 255, 255), 0, 0, 1, Color(0, 0, 0,255));
	end;
end;

function PANEL:PerformLayout()
	self.icon:SetPos(4, 4);
	self.avatar:SetPos(40, 4);
	self.info:SetSize(self:GetWide() - 80, self:GetTall() - 8);
	self.info:SetPos(76, 4);
end;

vgui.Register("rpScoreboard_item", PANEL, "DPanel");
