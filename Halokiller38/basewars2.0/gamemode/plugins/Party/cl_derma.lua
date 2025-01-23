--========================
--	Party System - Derma
--========================
local PANEL = {};

function PANEL:Init()
	self:SetSize(150, 0);
	self:SetPos(10, ScrH() / 2);
	self.items = {};
	self.titleHeight = 0;
	
	self:Rebuild();
end;

function PANEL:Rebuild()
	if (#RP.party.invites <= 0) then
		self:Remove();
	end;
	
	for k,v in ipairs(self.items) do	
		v:Remove();
		self.items[k] = nil;
	end;
	
	for k,v in ipairs(RP.party.invites) do
		local panel = vgui.Create("DPanel", self);
		panel:SetSize(self:GetWide(), 44);
		local y = 0;
		panel.Paint = function(panel)
			surface.SetFont("party_main");
			local newW, newH = surface.GetTextSize(v.host.."'s party");
			self:SetWide(math.max(newW + 24, 150));
			
			RP.menu:DrawSimpleText(math.Round((v.timeout or 0) - CurTime()), "party_main", self:GetWide() - 20, 0, Color(150, 150, 255, 255), 0, 0, false);
			y = RP.menu:DrawSimpleText(v.host.."'s party", "party_main", 4, 0, Color(150, 150, 200, 255), 0, 0, false);
			surface.SetDrawColor(20, 20, 20, 255);
			surface.DrawLine(0, panel:GetTall() - 1, self:GetWide(), panel:GetTall() - 1);
			surface.SetDrawColor(200, 200, 200, 255);
			surface.DrawLine(0, panel:GetTall() - 2, self:GetWide(), panel:GetTall() - 2);
		end;
		
		local accept = vgui.Create("RP_textButton", panel);
		local decline = vgui.Create("RP_textButton", panel);
		
		accept:SetText("Accept", "party_main");
		decline:SetText("Decline", "party_main");
		
		accept:SetPos(panel:GetWide() / 2 - (accept:GetWide() + decline:GetWide()) / 2, y + accept:GetTall());
		decline:SetPos(panel:GetWide() / 2 - (accept:GetWide() + decline:GetWide()) / 2 + accept:GetWide(), y + decline:GetTall());
		
		function accept:onPressed()
			RP:DataStream("partyAccept", {v.id});
		end;
		function decline:onPressed()
			RP:DataStream("partyDecline", {v.id});
		end;
		
		table.insert(self.items, panel);
	end;
	
	self:InvalidateLayout(true);
end;

function PANEL:Paint()
	self.titleHeight = RP.menu:DrawSimpleText("Invites", "party_title", 0, 0, Color(255, 255, 255, 255), 0, 0, false);
	surface.SetDrawColor(20, 20, 20, 255);
	surface.DrawLine(0, self.titleHeight, self:GetWide(), self.titleHeight);
	surface.SetDrawColor(200, 200, 200, 255);
	surface.DrawLine(0, self.titleHeight + 1, self:GetWide(), self.titleHeight + 1);
end;

function PANEL:Think()
	self:InvalidateLayout(true);
end;

function PANEL:PerformLayout()
	local y = self.titleHeight + 4;
	
	for k,v in ipairs(self.items) do
		v:SetPos(0, y);
		y = y + v:GetTall() + 4;
	end;
	
	self:SetTall(y + 4);
	self:SetPos(10, ScrH() / 2 - self:GetTall() / 2);
end;

vgui.Register("RP_party_invites", PANEL, "DPanel");

local PANEL = {};

function PANEL:Init()
	self:SetSize(math.min(RP.menu.width, 256), RP.menu.height);

	self.itemsList = vgui.Create("DPanelList", self);
	self.itemsList:SizeToContents();
	self.itemsList:SetPadding(2);
	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4,4,12,44);
	self.itemsList:EnableVerticalScrollbar();
	
	RP.party.managerPanel = self;
	
	self:Rebuild();
end;

function PANEL:Rebuild()
	self.itemsList:Clear();
	
	if (#RP.party.curParty > 0) then
		local partyPos = 1;
		for k,v in ipairs(RP.party.curParty) do
			if (v == LocalPlayer()) then
				partyPos = k;
			end;
			
			self.curPlayer = v;
			local panel = vgui.Create("RP_party_manager_player", self);
			
			self.itemsList:AddItem(panel);
		end;
		
		local leaveButton = vgui.Create("DButton", self);
		leaveButton:SetText("End Party");
		if (partyPos != 1) then
			leaveButton:SetText("Leave Party");
		end;
		leaveButton.DoClick = function()
			RunConsoleCommand("rp", "partyLeave");
		end;
		
		self.itemsList:AddItem(leaveButton);
	else
		-- invite to party button
		local inviteButton = vgui.Create("DButton", self);
		inviteButton:SetText("Invite to party");
		inviteButton.DoClick = function()			
			local players = player.GetAll();
			
			table.sort(players, function(a,b)
				return a:GetName() < b:GetName();
			end);
			
			table.remove(players, table.KeyFromValue(players, LocalPlayer()));
			
			if (#players > 0) then
				local menu = DermaMenu();
				
				for k,v in ipairs(players) do
					menu:AddOption(v:GetName(), function()
						RunConsoleCommand("rp", "invite", v:SteamID());
					end);
				end;
				
				menu:Open();
			end;
		end;
		
		self.itemsList:AddItem(inviteButton);
	end;
	
	self.itemsList:InvalidateLayout(true);
	self:InvalidateLayout(true)
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if RP.menu:GetActivePanel() == self then
		self:Rebuild()
	end
end

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

function PANEL:PerformLayout()
	self.itemsList:StretchToParent(4, 4, 4, 4);
	
	self:SetSize( math.min(RP.menu.width, 256), math.min(self.itemsList.pnlCanvas:GetTall() + 8, RP.menu.height) );
	
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, 50);
end;

function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("RP_party_manager", PANEL, "DPanel");

local PANEL = {};

function PANEL:Init()
	self:SetSize(RP.menu.width, 60);
	self.player = self:GetParent().curPlayer;
	
	self.icon = vgui.Create("SpawnIcon", self);
	self.icon:SetIconSize(32);
	self.icon:SetModel(self.player:GetModel());
	self.icon:SetToolTip();
	self.icon.DoClick = function()
		local menu = DermaMenu();
		
		menu:AddOption("Kick "..self.player:GetName(), function()
			RunConsoleCommand("rp", "partyKick", self.player:SteamID());
		end);
		if (RP.party.curParty[1] == LocalPlayer()) then
			menu:AddOption("Make Leader", function()
				RunConsoleCommand("rp", "partyLeader", self.player:SteamID());
			end);
		end;
		
		menu:Open();
	end;
	
	if (RP.party.curParty[1] == self.player) then
		self.leaderIcon = vgui.Create("DImage", self);
		self.leaderIcon:SetImage("gui/silkicons/star");
		self.leaderIcon:SizeToContents();
	end;
	
	self.name = vgui.Create("DLabel", self);
	self.name:SetText(self.player:GetName());
	self.name:SizeToContents();
	
	self.health = vgui.Create("DPanel", self);
	self.health:SetSize(math.min(self:GetWide() - 60, 200), 16);
	self.health.Paint = function(panel)
		local mul = math.TimeFraction(0, 100, self.player:Health());
		surface.SetDrawColor(20, 20, 20, 255);
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall());
		
		surface.SetDrawColor(150 - 150 * mul, 150 * mul, 0, 255);
		surface.DrawRect(1, 1, panel:GetWide() * mul - 2, panel:GetTall() - 2);
		
		if (self.player:Health() <= 10) then
			local a = 255 * math.sin(CurTime());
			
			surface.SetDrawColor(255, 255, 255, a);
			surface.DrawRect(1, 1, panel:GetWide() - 2, panel:GetTall() - 2);
		end;
		
		RP.menu:DrawSimpleText("Health", "Default", panel:GetWide() / 2, panel:GetTall() / 2, Color(255, 255, 255, 255), 1, 1, true);
	end;
	
	self.static = vgui.Create("DPanel", self);
	self.static:SetSize(math.min(self:GetWide() - 60, 200), 16);
	self.static.Paint = function(panel)
		local mul = math.TimeFraction(0, 100, 100);
		surface.SetDrawColor(20, 20, 20, 255);
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall());
		
		surface.SetDrawColor(200, 150, 0, 255);
		surface.DrawRect(1, 1, panel:GetWide() * mul - 2, panel:GetTall() - 2);
		
		RP.menu:DrawSimpleText("Static", "Default", panel:GetWide() / 2, panel:GetTall() / 2, Color(255, 255, 255, 255), 1, 1, true);
	end;
end;

function PANEL:PerformLayout()
	self.icon:SetPos(4, 4);
	self.name:SetPos(40, 4);
	self.health:SetPos(40, 20);
	self.static:SetPos(40, 40);
	
	if (self.leaderIcon) then
		self.leaderIcon:SetPos(12, 40);
	end;
end;

function PANEL:PaintOver()
	if (RP.party.curParty[1] == self.player) then
		surface.SetDrawColor(200, 200, 255, 255);
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall());
	end;
end;

vgui.Register("RP_party_manager_player", PANEL, "DPanel");
