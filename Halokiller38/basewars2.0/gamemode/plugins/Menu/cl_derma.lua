local PANEL = {};

function PANEL:Init()
	self:SetSize(ScrW(), ScrH());
	
	self.closeButton = vgui.Create("RP_textButton", self);
	self.closeButton:SetText("Close", "simple_menu_main");
	self.closeButton:SetPos(20, 50);
	self.closeButton.onPressed = function()
		RP.menu:SetOpen(false);
	end;
	
	self.panels = {};
	self.miscAnims = {};
	
	self.globalMul = 0;
	self.targetAnimMul = 0;
	self.animMul = 0;
	
	self:Rebuild();
end;

function PANEL:Rebuild()
	for k,v in ipairs(self.panels) do
		if (v.button) then
			v.button:Remove();
		end;
		if (v.smallButton) then
			v.smallButton:Remove();
		end;
		if (v.panel) then
			v.panel:Remove()
		end;
		
		v = nil;
	end;
	
	for k,v in ipairs(RP.menu.items) do
		local panel = vgui.Create(v.panel, self);
		panel:SetPos(ScrW() + 10);
		panel:SetVisible(false);
		if (panel.OnCreated) then
			panel:OnCreated();
		end;
		
		local button = vgui.Create("RP_textButton", self);
		button:SetText(v.title, "simple_menu_large");
		button.onPressed = function()
			self:OpenPanel(panel);
		end;
		
		local smallButton = vgui.Create("RP_textButton", self);
		smallButton:SetText(v.title, "simple_menu_main");
		smallButton:SetAlpha(0);
		local x = (ScrW() / #RP.menu.items) * (k - 1) + (ScrW() / (2*#RP.menu.items)) - smallButton:GetWide() / 2;
		-- local x = #RP.menu.items * (ScrW() / 2 - k * ScrW());
		smallButton:SetPos(x, ScrH() - 50);
		smallButton:SetVisible(false);
		smallButton.onPressed = function()
			self:OpenPanel(panel);
		end;
		
		table.insert(self.panels, {panel = panel, button = button, smallButton = smallButton});
	end;
end;

function PANEL:Paint()
	-- surface.SetDrawColor(0, 0, 0, 50);
	-- surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
end;

function PANEL:HandleImplodeFinished()
	if (self.activePanel) then
		for k,v in pairs(self.panels) do
			if (v.smallButton) then
				v.smallButton:SetVisible(true);
				self:AddMiscAnim(v.smallButton, ANIM_FADEIN);
			end;
			
			if (v.button) then
				v.button:SetVisible(false);
			end;
		end;
	else
		--self:AddMiscAnim(self.closeButton, ANIM_FADEIN);
		self:SetVisible(false);
		gui.EnableScreenClicker(false);
	end;
end;

function PANEL:RunExplodeAnimation()
	local cx, cy = ScrW() / 2, ScrH() / 2;
	
	if (self.globalMul != self.targetAnimMul) then
		self.globalMul = self.globalMul + ( self.targetAnimMul - self.globalMul ) * math.Clamp( FrameTime() * 10, 0, 1 );
	end;
	
	if (math.Round(self.globalMul, 2) == 0) then
		self:HandleImplodeFinished();
		
		return false;
	end;
	
	local numMoves = 360/#RP.menu.items;
	local count = 1;
	
	for i = numMoves/2, 360 - numMoves/2, numMoves do
		self.animMul = self.animMul + ( #RP.menu.items*40 - self.animMul ) * math.Clamp( FrameTime() * 20, 0, 1 );
		
		local addX = math.sin(math.rad(i)) * self.animMul * self.globalMul;
		local addY = math.cos(math.rad(i)) * self.animMul * self.globalMul;
		
		self.panels[count].button:SetPos(cx + addX - self.panels[count].button:GetWide() / 2, cy + addY);
		self.panels[count].button:SetAlpha(255 * self.globalMul);
		
		count = count + 1;
	end;
end;

function PANEL:SetOpen(bool)
	RP.menu.open = bool;
	gui.EnableScreenClicker(bool);
	-- RP.Effect:DrawUnique("Derma Background", "menu_main", bool);
	
	if (self.activePanel) then
		if (bool) then
			self:SetVisible(true);
		else
			self:SetVisible(false);
		end;
	else
		if (bool) then
			for k,v in pairs(self.panels) do
				if (v.button) then
					v.button:SetVisible(true);
				end;
			end;
			self.targetAnimMul = 1;
			self:SetVisible(true);
		else
			self.targetAnimMul = 0;
		end;
	end;
	
	if (bool) then
		for k,v in pairs(self.panels) do
			if v.panel.OnMenuOpened then
				v.panel:OnMenuOpened();
			end;
		end;
	end;
end;

function PANEL:OpenRadial(click)
	if (self.activePanel) then
		if (self.activePanel.Exit) then
			self.activePanel:Exit();
		else
			local panel = self.activePanel;
			self:AddMiscAnim(panel, ANIM_FADEOUT, 2, function() 
				self.activePanel = nil;
				if (click) then gui.EnableScreenClicker(false); self:SetOpen(false); end;
			end);
		end;
		
		self.targetAnimMul = 1;
		
		for k,v in pairs(self.panels) do
			if (v.smallButton) then
				self:AddMiscAnim(v.smallButton, ANIM_FADEOUT);
			end;
			if (v.button) then
				if (!click) then
					v.button:SetVisible(true);
				end;
			end;
		end;
	else
		self:SetOpen(false);
	end;
end;

function PANEL:RunMiscAnimation()
	if (#self.miscAnims > 0) then
		for k,v in ipairs(self.miscAnims) do
			if (v[1]) then
				local alpha = math.Approach(v[1].alpha or 0, 255, FrameTime() * 500 * v[4]);
				
				if (v[2] == ANIM_FADEOUT) then
					alpha = math.Approach(v[1].alpha or 255, 0, FrameTime() * 500 * v[4]);
				end;
				
				v[1]:SetAlpha(alpha);
				v[1].alpha = alpha;
				
				if (v[2] == ANIM_FADEIN) then
					if (v[1].alpha >= 255) then
						if (v[3]) then
							v[3](v[1], v[2]);
						end;
						
						table.remove(self.miscAnims, k);
					end;
				else
					if (v[1].alpha <= 0) then
						v[1]:SetVisible(false);
						
						if (v[3]) then						
							v[3](v[1], v[2]);
						end;
						
						table.remove(self.miscAnims, k);
					end;
				end;
			else
				table.remove(self.miscAnims, k);
			end;
		end;
	end;
end;

function PANEL:AddMiscAnim(panel, anim, speed, callbackOnFinished)
	-- callback(panel, animType);
	
	for k,v in ipairs(self.miscAnims) do
		if (v[1] == panel and v[2] == anim) then
			return false;
		elseif (v[1] == panel and v[2] != anim) then
			v[2] = anim;
			
			return true;
		end;
	end;
	
	table.insert(self.miscAnims, {panel, anim, callbackOnFinished, speed or 1});
end;

function PANEL:Think()
	self:RunExplodeAnimation();
	self:RunMiscAnimation();
end;

function PANEL:OpenPanel(panelToOpen)
	if (self.activePanel == panelToOpen) then
		return false;
	end;
	
	if (self.activePanel) then
		if (self.activePanel.Exit) then
			self.activePanel:Exit();
		else
			local panel = self.activePanel;
			self:AddMiscAnim(panel, ANIM_FADEOUT);
		end;
	else
		self.targetAnimMul = 0;
	end;
	
	self.activePanel = panelToOpen;
	self.activePanel:SetVisible(true);
	self.activePanel:SetSize(RP.menu.width, self.activePanel:GetTall());
	if (self.activePanel.Enter) then
		self.activePanel:Enter();
	else
		self.activePanel:SetAlpha(0);
		self:AddMiscAnim(self.activePanel, ANIM_FADEIN);
		self.activePanel:SetPos(ScrW() / 2 - self.activePanel:GetWide() / 2, 50);
	end;
	if (self.activePanel.OnSelected) then
		self.activePanel:OnSelected();
	end;
	self.activePanel:MakePopup();
end;

vgui.Register("rp_menu", PANEL, "EditablePanel");
