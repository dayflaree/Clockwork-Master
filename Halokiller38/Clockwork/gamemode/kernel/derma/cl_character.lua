--[[
	Free Clockwork!
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (!Clockwork.theme:Call("PreCharacterMenuInit", self)) then
		local smallTextFont = Clockwork.option:GetFont("menu_text_small");
		local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
		local hugeTextFont = Clockwork.option:GetFont("menu_text_huge");
		local scrH = ScrH();
		local scrW = ScrW();
		
		self:SetPos(0, 0);
		self:SetSize(scrW, scrH);
		self:SetDrawOnTop(false);
		self:SetPaintBackground(false);
		self:SetMouseInputEnabled(true);
		
		self.titleLabel = vgui.Create("cwLabelButton", self);
		self.titleLabel:SetDisabled(true);
		self.titleLabel:SetFont(hugeTextFont);
		self.titleLabel:SetText(string.upper(Clockwork.schema:GetName()));
		self.titleLabel:SetSize(512, 64);
		self.titleLabel:SetPos((scrW / 2) - (self.titleLabel:GetWide() / 2), scrH * 0.4);
		
		local schemaLogo = Clockwork.option:GetKey("schema_logo");
		
		self.subLabel = vgui.Create("cwLabelButton", self);
		self.subLabel:SetDisabled(true);
		self.subLabel:SetFont(smallTextFont);
		self.subLabel:SetText(string.upper(Clockwork.schema:GetDescription()));
		self.subLabel:SizeToContents();
		
		if (schemaLogo == "") then
			self.titleLabel:SetVisible(true);
			self.subLabel:SetPos((scrW / 2) - (self.subLabel:GetWide() / 2), self.titleLabel.y + self.titleLabel:GetTall() + 8);
		else
			self.titleLabel:SetVisible(false);
			self.subLabel:SetPos(self.titleLabel.x + (self.titleLabel:GetWide() / 2) - (self.subLabel:GetWide() / 2), self.titleLabel.y + self.titleLabel:GetTall() + 8);
		end;
		
		self.authorLabel = vgui.Create("cwLabelButton", self);
		self.authorLabel:SetDisabled(true);
		self.authorLabel:SetFont(tinyTextFont);
		self.authorLabel:SetText("DEVELOPED BY "..string.upper(Clockwork.schema:GetAuthor()));
		self.authorLabel:SizeToContents();
		self.authorLabel:SetPos(self.subLabel.x + (self.subLabel:GetWide() - self.authorLabel:GetWide()), self.subLabel.y + self.subLabel:GetTall() + 4);
		
		self.createButton = vgui.Create("cwLabelButton", self);
		self.createButton:SetFont(smallTextFont);
		self.createButton:SetText("NEW");
		self.createButton:FadeIn(0);
		self.createButton:SetCallback(function(panel)
			if (table.Count(Clockwork.character:GetAll()) >= Clockwork.player:GetMaximumCharacters()) then
				return Clockwork.character:SetFault("You cannot create any more characters!");
			end;
			
			Clockwork.character:ResetCreationInfo();
			Clockwork.character:OpenNextCreationPanel();
		end);
		self.createButton:SizeToContents();
		self.createButton:SetMouseInputEnabled(true);
		self.createButton:SetPos(scrW * 0.25, 16);
		
		self.loadButton = vgui.Create("cwLabelButton", self);
		self.loadButton:SetFont(smallTextFont);
		self.loadButton:SetText("LOAD");
		self.loadButton:FadeIn(0);
		self.loadButton:SetCallback(function(panel)
			self:OpenPanel("cwCharacterList", nil, function(panel)
				Clockwork.character:RefreshPanelList();
			end);
		end);
		self.loadButton:SizeToContents();
		self.loadButton:SetMouseInputEnabled(true);
		self.loadButton:SetPos(scrW * 0.75, 16);
		
		self.disconnectButton = vgui.Create("cwLabelButton", self);
		self.disconnectButton:SetFont(smallTextFont);
		self.disconnectButton:SetText("LEAVE");
		self.disconnectButton:FadeIn(0);
		self.disconnectButton:SetCallback(function(panel)
			if (Clockwork.Client:HasInitialized() and !Clockwork.character:IsMenuReset()) then
				Clockwork.character:SetPanelOpen(false);
			else
				RunConsoleCommand("disconnect");
			end;
		end);
		self.disconnectButton:SizeToContents();
		self.disconnectButton:SetPos((scrW / 2) - (self.disconnectButton:GetWide() / 2), 16);
		self.disconnectButton:SetMouseInputEnabled(true);
		
		self.previousButton = vgui.Create("cwLabelButton", self);
		self.previousButton:SetFont(tinyTextFont);
		self.previousButton:SetText("PREVIOUS");
		self.previousButton:SetCallback(function(panel)
			if (!Clockwork.character:IsCreationProcessActive()) then
				local activePanel = Clockwork.character:GetActivePanel();
				
				if (activePanel and activePanel.OnPrevious) then
					activePanel:OnPrevious();
				end;
			else
				Clockwork.character:OpenPreviousCreationPanel()
			end;
		end);
		self.previousButton:SizeToContents();
		self.previousButton:SetMouseInputEnabled(true);
		self.previousButton:SetPos((scrW * 0.2) - (self.previousButton:GetWide() / 2), scrH * 0.9);
		
		self.nextButton = vgui.Create("cwLabelButton", self);
		self.nextButton:SetFont(tinyTextFont);
		self.nextButton:SetText("NEXT");
		self.nextButton:SetCallback(function(panel)
			if (!Clockwork.character:IsCreationProcessActive()) then
				local activePanel = Clockwork.character:GetActivePanel();
				
				if (activePanel and activePanel.OnNext) then
					activePanel:OnNext();
				end;
			else
				Clockwork.character:OpenNextCreationPanel()
			end;
		end);
		self.nextButton:SizeToContents();
		self.nextButton:SetMouseInputEnabled(true);
		self.nextButton:SetPos((scrW * 0.8) - (self.nextButton:GetWide() / 2), scrH * 0.9);
		
		self.cancelButton = vgui.Create("cwLabelButton", self);
		self.cancelButton:SetFont(tinyTextFont);
		self.cancelButton:SetText("CANCEL");
		self.cancelButton:SetCallback(function(panel)
			self:ReturnToMainMenu();
		end);
		self.cancelButton:SizeToContents();
		self.cancelButton:SetMouseInputEnabled(true);
		self.cancelButton:SetPos((scrW * 0.5) - (self.cancelButton:GetWide() / 2), scrH * 0.9);
		
		self.characterModel = vgui.Create("cwCharacterModel", self);
		self.characterModel:SetSize(512, 512);
		self.characterModel:SetAlpha(0);
		self.characterModel:SetModel("models/error.mdl");
		self.createTime = SysTime();
		
		Clockwork.theme:Call("PostCharacterMenuInit", self)
	end;
end;

-- A function to fade in the model panel.
function PANEL:FadeInModelPanel(model)
	local panel = Clockwork.character:GetActivePanel();
	local x, y = ScrW() - self.characterModel:GetWide() - 8, 16;
	
	if (panel) then
		x, y = panel.x + panel:GetWide() - 16, panel.y - 80;
	end;
	
	self.characterModel:SetPos(x, y);
	
	if (self.characterModel:FadeIn(0)) then
		self:SetModelPanelModel(model);
		
		return true;
	else
		return false;
	end;
end;

-- A function to fade out the model panel.
function PANEL:FadeOutModelPanel()
	self.characterModel:FadeOut(0);
end;

-- A function to set the model panel's model.
function PANEL:SetModelPanelModel(model)
	if (self.characterModel.currentModel != model) then
		self.characterModel.currentModel = model;
		self.characterModel:SetModel(model);
	end;
end;

-- A function to return to the main menu.
function PANEL:ReturnToMainMenu()
	local panel = Clockwork.character:GetActivePanel();
	
	if (panel) then
		panel:FadeOut(0, function()
			Clockwork.character.activePanel = nil;
				panel:Remove();
			self:FadeInTitle();
		end);
	else
		self:FadeInTitle();
	end;
	
	self:FadeOutModelPanel();
	self:FadeOutNavigation();
end;

-- A function to fade out the navigation.
function PANEL:FadeOutNavigation()
	self.previousButton:FadeOut(0);
	self.cancelButton:FadeOut(0);
	self.nextButton:FadeOut(0);
end;

-- A function to fade in the navigation.
function PANEL:FadeInNavigation()
	self.previousButton:FadeIn(0);
	self.cancelButton:FadeIn(0);
	self.nextButton:FadeIn(0);
end;

-- A function to fade out the title.
function PANEL:FadeOutTitle()
	self.subLabel:FadeOut(0);
	self.titleLabel:FadeOut(0);
	self.authorLabel:FadeOut(0);
end;

-- A function to fade in the title.
function PANEL:FadeInTitle()
	self.subLabel:FadeIn(0);
	self.titleLabel:FadeIn(0);
	self.authorLabel:FadeIn(0);
end;

-- A function to open a panel.
function PANEL:OpenPanel(vguiName, childData, Callback)
	if (!Clockwork.theme:Call("PreCharacterMenuOpenPanel", self, vguiName, childData, Callback)) then
		local panel = Clockwork.character:GetActivePanel();
		
		if (panel) then
			panel:FadeOut(0, function()
				panel:Remove(); self.childData = childData;
				
				Clockwork.character.activePanel = vgui.Create(vguiName, self);
				Clockwork.character.activePanel:SetAlpha(0);
				Clockwork.character.activePanel:FadeIn(0);
				Clockwork.character.activePanel:MakePopup();
				Clockwork.character.activePanel:SetPos(ScrW() * 0.2, ScrH() * 0.275);
				
				if (Callback) then
					Callback(Clockwork.character.activePanel);
				end;
				
				if (childData) then
					Clockwork.character.activePanel.bIsCreationProcess = true;
					Clockwork.character:FadeInNavigation();
				end;
			end);
		else
			self.childData = childData;
			
			Clockwork.character.activePanel = vgui.Create(vguiName, self);
			Clockwork.character.activePanel:SetAlpha(0);
			Clockwork.character.activePanel:FadeIn(0);
			Clockwork.character.activePanel:MakePopup();
			Clockwork.character.activePanel:SetPos(ScrW() * 0.2, ScrH() * 0.275);
			
			if (Callback) then
				Callback(Clockwork.character.activePanel);
			end;
			
			if (childData) then
				Clockwork.character.activePanel.bIsCreationProcess = true;
				Clockwork.character:FadeInNavigation();
			end;
		end;
		
		Clockwork.theme:Call("PostCharacterMenuOpenPanel", self);
		
		self:FadeOutModelPanel();
		self:FadeOutTitle();
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint()
	if (!Clockwork.theme:Call("PreCharacterMenuPaint", self)) then
		local schemaLogo = Clockwork.option:GetKey("schema_logo");
		local subLabelAlpha = self.subLabel:GetAlpha();
		
		if (schemaLogo != "" and subLabelAlpha > 0) then
			if (!self.logoTextureID) then
				self.logoTextureID = surface.GetTextureID(schemaLogo);
			end;
			
			surface.SetDrawColor(255, 255, 255, math.min(self:GetAlpha(), subLabelAlpha));
			surface.SetTexture(self.logoTextureID);
			surface.DrawTexturedRect(self.titleLabel.x, self.titleLabel.y, 512, 64);
		end;
		
		Clockwork.theme:Call("PostCharacterMenuPaint", self)
	end;
	
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local colorWhite = Clockwork.option:GetColor("white");
	local scrW, scrH = ScrW(), ScrH();
	local height = (self.createButton.y * 2) + self.createButton:GetTall();
	local x, y = x, 0;
	
	Clockwork:DrawSimpleGradientBox(0, 0, y, scrW, height, Color(0, 0, 0, 100));
	
	surface.SetDrawColor(255, 255, 255, 200);
	surface.DrawRect(0, y + height, scrW, 1);
	
	if (Clockwork.character:IsCreationProcessActive()) then
		local creationPanels = Clockwork.character:GetCreationPanels();
		local numCreationPanels = #creationPanels;
		local creationProgress = Clockwork.character:GetCreationProgress();
		local progressHeight = 20;
		local creationInfo = Clockwork.character:GetCreationInfo();
		local progressY = y + height + 1;
		
		Clockwork:DrawSimpleGradientBox(0, 0, progressY, scrW, progressHeight, Color(75, 75, 75, 100));
			for i = 1, numCreationPanels do
				surface.SetDrawColor(255, 255, 255, 150);
				surface.DrawRect((scrW / numCreationPanels) * i, progressY, 1, progressHeight);
			end;
		Clockwork:DrawSimpleGradientBox(0, 0, progressY, (scrW / 100) * creationProgress, progressHeight, colorTargetID);
		
		if (creationProgress > 0 and creationProgress < 100) then
			surface.SetDrawColor(255, 255, 255, 200);
			surface.DrawRect((scrW / 100) * creationProgress, progressY, 1, progressHeight);
		end;
		
		for i = 1, numCreationPanels do
			local Condition = creationPanels[i].Condition;
			local textX = (scrW / numCreationPanels) * (i - 0.5);
			local textY = progressY + (progressHeight / 2);
			local color = Color(colorWhite.r, colorWhite.g, colorWhite.b, 200);
			
			if (Condition and !Condition(creationInfo)) then
				color = Color(colorWhite.r, colorWhite.g, colorWhite.b, 100);
			end;
			
			Clockwork:DrawSimpleText(creationPanels[i].friendlyName, textX, textY, color, 1, 1);
		end;
		
		surface.SetDrawColor(255, 255, 255, 200);
		surface.DrawRect(0, progressY + progressHeight, scrW, 1);
	end;
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	if (!Clockwork.theme:Call("PreCharacterMenuThink", self)) then
		local characters = table.Count(Clockwork.character:GetAll());
		local bIsLoading = Clockwork.character:IsPanelLoading();
		local schemaLogo = Clockwork.option:GetKey("schema_logo");
		local activePanel = Clockwork.character:GetActivePanel();
		local fault = Clockwork.character:GetFault();
		
		if (Clockwork.plugin:Call("ShouldDrawCharacterBackgroundBlur")) then
			Clockwork:RegisterBackgroundBlur(self, self.createTime);
		else
			Clockwork:RemoveBackgroundBlur(self);
		end;
		
		if (self.characterModel) then
			if (!self.characterModel.currentModel
			or self.characterModel.currentModel == "models/error.mdl") then
				self.characterModel:SetAlpha(0);
			end;
		end;
		
		if (!Clockwork.character:IsCreationProcessActive()) then
			if (activePanel) then
				if (activePanel.GetNextDisabled
				and activePanel:GetNextDisabled()) then
					self.nextButton:SetDisabled(true);
				else
					self.nextButton:SetDisabled(false);
				end;
				
				if (activePanel.GetPreviousDisabled
				and activePanel:GetPreviousDisabled()) then
					self.previousButton:SetDisabled(true);
				else
					self.previousButton:SetDisabled(false);
				end;
			end;
		else
			local previousPanelInfo = Clockwork.character:GetPreviousCreationPanel();
			
			if (previousPanelInfo) then
				self.previousButton:SetDisabled(false);
			else
				self.previousButton:SetDisabled(true);
			end;
			
			self.nextButton:SetDisabled(false);
		end;
		
		if (schemaLogo == "") then
			self.titleLabel:SetVisible(true);
		else
			self.titleLabel:SetVisible(false);
		end;
		
		if (characters == 0 or bIsLoading) then
			self.loadButton:SetDisabled(true);
		else
			self.loadButton:SetDisabled(false);
		end;
		
		if (characters >= Clockwork.player:GetMaximumCharacters()
		or Clockwork.character:IsPanelLoading()) then
			self.createButton:SetDisabled(true);
		else
			self.createButton:SetDisabled(false);
		end;
		
		if (Clockwork.Client:HasInitialized() and !Clockwork.character:IsMenuReset()) then
			self.disconnectButton:SetText("CANCEL");
			self.disconnectButton:SizeToContents();
		else
			self.disconnectButton:SetText("LEAVE");
			self.disconnectButton:SizeToContents();
		end;
		
		if (self.animation) then
			self.animation:Run();
		end;
		
		self:SetSize(ScrW(), ScrH());
		
		Clockwork.theme:Call("PostCharacterMenuThink", self)
	end;
end;

vgui.Register("cwCharacterMenu", PANEL, "DPanel");

--[[
	Add a hook to control clicking outside of the active panel.
--]]

hook.Add("VGUIMousePressed", "Clockwork.character:VGUIMousePressed", function(panel, code)
	local characterPanel = Clockwork.character:GetPanel();
	local activePanel = Clockwork.character:GetActivePanel();
	
	if (Clockwork.character:IsPanelOpen() and activePanel
	and characterPanel == panel) then
		activePanel:MakePopup();
	end;
end);

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("");
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	self.selectedIdx = 1;
	self.characterPanels = {};
	self.isCharacterList = true;
	
	Clockwork.character:FadeInNavigation()
end;

-- Called when the panel is painted.
function PANEL:Paint() end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to clear the panel's panels.
function PANEL:Clear()
	for k, v in ipairs(self.characterPanels) do
		v:Remove();
	end;
	
	self.characterPanels = {};
end;

-- A function to add a panel to the panel.
function PANEL:AddPanel(panel)
	table.insert(self.characterPanels, panel);
end;

-- Called to get whether the previous button is disabled.
function PANEL:GetPreviousDisabled()
	return (self.characterPanels[self.selectedIdx - 1] == nil);
end;

-- Called to get whether the next button is disabled.
function PANEL:GetNextDisabled()
	return (self.characterPanels[self.selectedIdx + 1] == nil);
end;

-- A function to get the panel's character panels.
function PANEL:GetCharacterPanels()
	return self.characterPanels;
end;

-- A function to get the panel's selected model.
function PANEL:GetSelectedModel()
	return self.characterPanels[self.selectedIdx];
end;

-- A function to manage a panel's targets.
function PANEL:ManageTargets(panel, position, alpha)
	if (!panel.TargetPosition) then
		panel.TargetPosition = position;
	end;
	
	if (!panel.TargetAlpha) then
		panel.TargetAlpha = alpha;
	end;
	
	local moveSpeed = math.abs(panel.TargetPosition - position) * 2;
	local interval = moveSpeed * FrameTime();
	
	panel.TargetPosition = math.Approach(panel.TargetPosition, position, interval);
	panel.TargetAlpha = math.Approach(panel.TargetAlpha, alpha, interval);
	panel:SetAlpha(panel.TargetAlpha);
	panel:SetPos(panel.TargetPosition, 0);
end;

-- A function to set the panel's selected index.
function PANEL:SetSelectedIdx(index)
	self.selectedIdx = index;
end;

-- Called when the previous button is pressed.
function PANEL:OnPrevious()
	self.selectedIdx = math.max(self.selectedIdx - 1, 1);
	self:MakePopup();
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	self.selectedIdx = math.min(self.selectedIdx + 1, #self.characterPanels);
	self:MakePopup();
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then self.animation:Run(); end;
	
	while (self.selectedIdx > #self.characterPanels) do
		self.selectedIdx = self.selectedIdx - 1;
	end;
	
	if (self.selectedIdx == 0) then self.selectedIdx = 1; end;
	
	if (self.characterPanels[self.selectedIdx]) then
		local centerPanel = self.characterPanels[self.selectedIdx];
			centerPanel:SetActive(true);
		self:ManageTargets(centerPanel, (self:GetWide() / 2) - (centerPanel:GetWide() / 2), 255);
		
		local rightX = centerPanel.x + centerPanel:GetWide() + 16;
		local leftX = centerPanel.x - 16;
		
		for i = self.selectedIdx - 1, 1, -1 do
			local previousPanel = self.characterPanels[i];
			
			if (previousPanel) then
				previousPanel:SetActive(false);
					self:ManageTargets(previousPanel, leftX - previousPanel:GetWide(), (255 / self.selectedIdx) * i);
				leftX = previousPanel.x - 16;
			end;
		end;
		
		for k, v in ipairs(self.characterPanels) do
			if (k > self.selectedIdx) then
				v:SetActive(false);
					self:ManageTargets(v, rightX, (255 / ((#self.characterPanels + 1) - self.selectedIdx)) * ((#self.characterPanels + 1) - k));
				rightX = v.x + v:GetWide() + 16;
			end;
		end;
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetPos(0, (ScrH() / 2) - 256);
	self:SetSize(ScrW(), 512);
end;

vgui.Register("cwCharacterList", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local buttonsList = {};
	local customData = self:GetParent().customData;
	local colorWhite = Clockwork.option:GetColor("white");
	local buttonX = 20;
	local buttonY = 0;
	
	for k, v in pairs(customData) do
		self[k] = v;
	end;
	
	self.buttonPanels = {};
	self:SetPaintBackground(false);
	
	self.nameLabel = vgui.Create("cwLabelButton", self);
	self.nameLabel:SetDisabled(true);
	self.nameLabel:SetFont(smallTextFont);
	self.nameLabel:SetText(string.upper(self.name));
	self.nameLabel:SizeToContents();
	
	self.factionLabel = vgui.Create("cwLabelButton", self);
	self.factionLabel:SetDisabled(true);
	self.factionLabel:SetFont(tinyTextFont);
	self.factionLabel:SetText(string.upper(self.faction));
	self.factionLabel:SizeToContents();
	self.factionLabel:SetPos(0, self.nameLabel:GetTall() + 8);
	
	self.characterModel = vgui.Create("cwCharacterModel", self);
	self.characterModel:SetModel(self.model);
	self.characterModel:SetPos(0, self.factionLabel.y + self.factionLabel:GetTall() + 8);
	self.characterModel:SetSize(256, 256);
	buttonY = self.characterModel.y + self.characterModel:GetTall() + 8;
	
	self.useButton = vgui.Create("DImageButton", self);
	self.useButton:SetToolTip("Use this character.");
	self.useButton:SetImage("gui/silkicons/check_on");
	self.useButton:SetSize(16, 16);
	self.useButton:SetPos(0, buttonY);
	
	self.deleteButton = vgui.Create("DImageButton", self);
	self.deleteButton:SetToolTip("Delete this character.");
	self.deleteButton:SetImage("gui/silkicons/check_off");
	self.deleteButton:SetSize(16, 16);
	self.deleteButton:SetPos(20, buttonY);
	
	Clockwork.plugin:Call("GetCustomCharacterButtons", self.characterTable, buttonsList);
	
	for k, v in pairs(buttonsList) do
		local button = vgui.Create("DImageButton", self);
			buttonX = buttonX + 20;
			button:SetToolTip(v.toolTip);
			button:SetImage(v.image);
			button:SetSize(16, 16);
			button:SetPos(buttonX, buttonY);
		table.insert(self.buttonPanels, button);
		
		-- Called when the button is clicked.
		function button.DoClick(button)
			local function Callback()
				Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = k});
			end;
			
			if (!v.OnClick or v.OnClick(Callback) != false) then
				Callback();
			end;
		end;
	end;
	
	-- Called when the button is clicked.
	function self.useButton.DoClick(spawnIcon)
		Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = "use"});
	end;
	
	-- Called when the button is clicked.
	function self.deleteButton.DoClick(spawnIcon)
		Clockwork:AddMenuFromData(nil, {
			["Yes"] = function()
				Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = "delete"});
			end,
			["No"] = function() end
		});
	end;
	
	local modelPanel = self.characterModel:GetModelPanel();
	
	-- Called when the character model is clicked.
	function modelPanel.DoClick(modelPanel)
		local activePanel = Clockwork.character:GetActivePanel();
		
		if (activePanel:GetSelectedModel() == self) then
			local options = {};
			local panel = Clockwork.character:GetPanel();
			
			options["Use"] = function()
				Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = "use"});
			end;
			
			options["Delete"] = {};
			options["Delete"]["No"] = function() end;
			options["Delete"]["Yes"] = function()
				Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = "delete"});
			end;
			
			Clockwork.plugin:Call("GetCustomCharacterOptions", self.characterTable, options, menu);
			
			Clockwork:AddMenuFromData(nil, options, function(menu, key, value)
				menu:AddOption(key, function()
					Clockwork:StartDataStream("InteractCharacter", {characterID = self.characterID, action = value});
				end);
			end);
		else
			for k, v in ipairs(activePanel:GetCharacterPanels()) do
				if (v == self) then
					activePanel:SetSelectedIdx(k);
				end;
			end;
		end;
	end;
	
	local maxWidth = math.max(buttonX, 200);
	
	if (self.nameLabel:GetWide() > maxWidth) then
		maxWidth = self.nameLabel:GetWide();
	end;
	
	if (self.factionLabel:GetWide() > maxWidth) then
		maxWidth = self.factionLabel:GetWide();
	end;
	
	self.characterModel:SetPos((maxWidth / 2) - 128, self.characterModel.y);
	self.factionLabel:SetPos((maxWidth / 2) - (self.factionLabel:GetWide() / 2), self.factionLabel.y);
	self.nameLabel:SetPos((maxWidth / 2) - (self.nameLabel:GetWide() / 2), self.nameLabel.y);
	self:SetSize(maxWidth, buttonY + 32);
	
	local buttonAddX = ((maxWidth / 2) - (buttonX / 2)) - 10;
		self.useButton:SetPos(self.useButton.x + buttonAddX, self.useButton.y);
		self.deleteButton:SetPos(self.deleteButton.x + buttonAddX, self.deleteButton.y);
	for k, v in ipairs(self.buttonPanels) do
		v:SetPos(v.x + buttonAddX, v.y);
	end;
end;

-- A function to set whether the panel is active.
function PANEL:SetActive(bActive)
	if (bActive) then
		self.nameLabel:OverrideTextColor(Clockwork.option:GetColor("information"));
	else
		self.nameLabel:OverrideTextColor(false);
	end;
end;

-- Called each frame.
function PANEL:Think()
	local informationColor = Clockwork.option:GetColor("information");
	local toolTip = Clockwork.plugin:Call("GetCharacterPanelToolTip", self, self.faction, self.characterTable);
	local details = Clockwork:MarkupTextWithColor("[Details]", informationColor);
	
	details = Clockwork:AddMarkupLine(details, self.details or "This character has no details to display.");
	
	if (toolTip and toolTip != "") then
		details = Clockwork:AddMarkupLine(details, "[Information]", informationColor);
		details = Clockwork:AddMarkupLine(details, toolTip);
	end;
	
	self.characterModel:SetDetails(details);
end;
	
vgui.Register("cwCharacterPanel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetPaintBackground(false);
	
	self.modelPanel = vgui.Create("DModelPanel", self);
	self.modelPanel:SetAmbientLight(Color(255, 255, 255, 255));
	Clockwork:CreateMarkupToolTip(self.modelPanel);
	
	-- Called when the entity should be laid out.
	function self.modelPanel.LayoutEntity(modelPanel, entity)
		modelPanel:RunAnimation();
		entity:ClearPoseParameters();
	end;
end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
		
		return true;
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
		self:SetVisible(true);
		
		return true;
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to set the alpha of the panel.
function PANEL:SetAlpha(alpha)
	local color = self.modelPanel:GetColor();
	self.modelPanel:SetColor(Color(color.r, color.g, color.b, alpha));
end;

-- A function to get the alpha of the panel.
function PANEL:GetAlpha(alpha)
	return self.modelPanel:GetColor().a;
end;

-- Called each frame.
function PANEL:Think()
	local entity = self.modelPanel.Entity;
	
	if (IsValid(entity)) then
		entity:SetPos(Vector(0, 0, 0));
	end;
	
	if (self.animation) then
		self.animation:Run();
	end;
	
	self:InvalidateLayout(true);
end;

-- A function to get the panel's model panel.
function PANEL:GetModelPanel()
	return self.modelPanel;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.modelPanel:SetSize(self:GetWide(), self:GetTall());
end;

-- A function to set the model details.
function PANEL:SetDetails(details)
	self.modelPanel:SetMarkupToolTip(details);
end;

-- A function to set the model.
function PANEL:SetModel(model)

	self.modelPanel:SetModel(model);

	local entity = ents.Create("prop_physics");
		entity:SetAngles(Angle(0, 0, 0));
		entity:SetPos(Vector(0, 0, 0));
		entity:SetModel(model);
		entity:Spawn();
		entity:Activate();
	entity:PhysicsInit(SOLID_VPHYSICS);
	
	local obbCenter = entity:OBBCenter()
		obbCenter.z = obbCenter.z * 1.09;
	local distance = entity:BoundingRadius() * 1.2;
	
	self.modelPanel:SetLookAt(obbCenter)
	self.modelPanel:SetCamPos(
		obbCenter + Vector(distance * 1.56, distance * 0.31, distance * 0.4)
	);
	
	entity:Remove()
	
	if (IsValid(self.modelPanel.Entity)) then
		local sequence = self.modelPanel.Entity:LookupSequence("idle");
		local menuSequence = Clockwork.animation:GetMenuSequence(model, true);
		local leanBackAnims = {"LineIdle01", "LineIdle02", "LineIdle03"};
		local leanBackAnim = self.modelPanel.Entity:LookupSequence(leanBackAnims[math.random(1, #leanBackAnims)]);
		
		if (leanBackAnim > 0) then
			sequence = leanBackAnim;
		end;
		
		if (menuSequence) then
			menuSequence = self.modelPanel.Entity:LookupSequence(menuSequence);
			
			if (menuSequence > 0) then
				sequence = menuSequence;
			end;
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("Wave");
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("idle_unarmed");
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("idle1");
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("walk_all");
		end;
		
		self.modelPanel.Entity:ResetSequence(sequence);
	end;
end;
	
vgui.Register("cwCharacterModel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local colorWhite = Clockwork.option:GetColor("white");
	local colorTargetID = Clockwork.option:GetColor("target_id");
	
	self:SetSize(self:GetWide(), 16);
	self.totalPoints = 0;
	self.maximumPoints = 0;
	self.attributeTable = nil;
	self.attributePanels = {};
	self:SetPaintBackground(false);
	
	Clockwork:CreateMarkupToolTip(self);
	
	self.addButton = vgui.Create("DImageButton", self);
	self.addButton:SetMaterial("gui/silkicons/add");
	self.addButton:SizeToContents();
	
	-- Called when the button is clicked.
	function self.addButton.DoClick(imageButton)
		self:AddPoint();
	end;
	
	self.removeButton = vgui.Create("DImageButton", self);
	self.removeButton:SetMaterial("gui/silkicons/exclamation");
	self.removeButton:SizeToContents();
	
	-- Called when the button is clicked.
	function self.removeButton.DoClick(imageButton)
		self:RemovePoint();
	end;
	
	self.pointsUsed = vgui.Create("DPanel", self);
	self.pointsUsed:SetPos(self.addButton:GetWide() + 8, 0);
	Clockwork:CreateMarkupToolTip(self.pointsUsed);
	
	self.pointsLabel = vgui.Create("DLabel", self);
	self.pointsLabel:SetText("N/A");
	self.pointsLabel:SetTextColor(colorWhite);
	self.pointsLabel:SizeToContents();
	self.pointsLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	Clockwork:CreateMarkupToolTip(self.pointsLabel);
	
	-- Called when the panel should be painted.
	function self.pointsUsed.Paint(pointsUsed)
		local color = Color(100, 100, 100, 255);
		local width = math.Clamp((pointsUsed:GetWide() / self.attributeTable.maximum) * self.totalPoints, 0, pointsUsed:GetWide());
		
		if (color) then
			color.r = math.min(color.r - 25, 255);
			color.g = math.min(color.g - 25, 255);
			color.b = math.min(color.b - 25, 255);
		end;
		
		Clockwork:DrawSimpleGradientBox(2, 0, 0, pointsUsed:GetWide(), pointsUsed:GetTall(), color);
		
		if (self.totalPoints > 0 and self.totalPoints < self.attributeTable.maximum) then
			Clockwork:DrawSimpleGradientBox(0, 2, 2, width - 4, pointsUsed:GetTall() - 4, colorTargetID);
				surface.SetDrawColor(255, 255, 255, 200);
			surface.DrawRect(width, 0, 1, pointsUsed:GetTall());
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self.pointsUsed:SetSize(self:GetWide() - (self.pointsUsed.x * 2), 16);
	self.pointsLabel:SetText(self.attributeTable.name);
	self.pointsLabel:SetPos(self:GetWide() / 2 - self.pointsLabel:GetWide() / 2, self:GetTall() / 2 - self.pointsLabel:GetTall() / 2);
	self.pointsLabel:SizeToContents();
	self.addButton:SetPos(self.pointsUsed.x + self.pointsUsed:GetWide() + 8, 0);
	
	local informationColor = Clockwork.option:GetColor("information");
	local attributeName = self.attributeTable.name;
	local attributeMax = self.totalPoints.."/"..self.attributeTable.maximum;
	local markupToolTip = Clockwork:MarkupTextWithColor(
		"["..attributeName..", "..attributeMax.."]", informationColor
	);
	
	markupToolTip = markupToolTip.."\n"..self.attributeTable.description;
	
	self:SetMarkupToolTip(markupToolTip);
	self.pointsUsed:SetMarkupToolTip(markupToolTip);
	self.pointsLabel:SetMarkupToolTip(markupToolTip);
end;

-- A function to add a point.
function PANEL:AddPoint()
	local pointsUsed = self:GetPointsUsed();
	
	if (pointsUsed + 1 <= self.maximumPoints) then
		self.totalPoints = self.totalPoints + 1;
	end;
end;

-- A function to remove a point.
function PANEL:RemovePoint()
	self.totalPoints = math.max(self.totalPoints - 1, 0);
end;

-- A function to get the total points.
function PANEL:GetTotalPoints()	
	return self.totalPoints;
end;

-- A function to get the points used.
function PANEL:GetPointsUsed()
	local pointsUsed = 0;
	
	for k, v in ipairs(self.attributePanels) do
		pointsUsed = pointsUsed + v:GetTotalPoints();
	end;
	
	return pointsUsed;
end;

-- A function to get the panel's attribute ID.
function PANEL:GetAttributeID()
	return self.attributeTable.uniqueID;
end;

-- A function to set the panel's attribute panels.
function PANEL:SetAttributePanels(attributePanels)
	self.attributePanels = attributePanels;
end;

-- A function to set the panel's attribute table.
function PANEL:SetAttributeTable(attributeTable)
	self.attributeTable = attributeTable;
end;

-- A function to set the panel's maximum points.
function PANEL:SetMaximumPoints(maximumPoints)
	self.maximumPoints = maximumPoints;
end;
	
vgui.Register("cwCharacterAttribute", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.info = Clockwork.character:GetCreationInfo();
	
	local maximumPoints = Clockwork.config:Get("default_attribute_points"):Get();
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local factionTable = Clockwork.faction:Get(self.info.faction);
	local attributes = {};
	
	self:ShowCloseButton(false);
	self.lblTitle:SetVisible(false);
	self:SetDraggable(false);
	
	if (factionTable.attributePointsScale) then
		maximumPoints = math.Round(maximumPoints * factionTable.attributePointsScale);
	end;
	
	if (factionTable.maximumAttributePoints) then
		maximumPoints = factionTable.maximumAttributePoints;
	end;
	
	self.attributesForm = vgui.Create("DForm");
	self.attributesForm:SetName(Clockwork.option:GetKey("name_attributes"));
	self.attributesForm:SetPadding(4);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:SetDrawBackground(false);
	self.panelList:EnableVerticalScrollbar();
	
	for k, v in pairs(Clockwork.attribute:GetAll()) do
		attributes[#attributes + 1] = v;
	end;
	
	table.sort(attributes, function(a, b)
		return a.name < b.name;
	end);
	
	self.attributePanels = {};
	self.info.attributes = {};
	self.helpText = self.attributesForm:Help("You can spend "..maximumPoints.." more point(s).");
	
	for k, v in pairs(attributes) do
		if (v.characterScreen) then
			local characterAttribute = vgui.Create("cwCharacterAttribute", self.attributesForm);
				characterAttribute:SetAttributeTable(v);
				characterAttribute:SetMaximumPoints(maximumPoints);
				characterAttribute:SetAttributePanels(self.attributePanels);
			self.attributesForm:AddItem(characterAttribute);
			
			self.attributePanels[#self.attributePanels + 1] = characterAttribute;
		end;
	end;
	
	self.maximumPoints = maximumPoints;
	self.panelList:AddItem(self.attributesForm);
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	for k, v in ipairs(self.attributePanels) do
		self.info.attributes[v:GetAttributeID()] = v:GetTotalPoints();
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint() end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.helpText) then
		local pointsLeft = self.maximumPoints;
		
		for k, v in ipairs(self.attributePanels) do
			pointsLeft = pointsLeft - v:GetTotalPoints();
		end;
		
		self.helpText:SetText("You can spend "..pointsLeft.." more point(s).");
	end;
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(0, 0, 0, 0);
	self:SetSize(512, math.min(self.panelList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageFour", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.info = Clockwork.character:GetCreationInfo();
	
	self:ShowCloseButton(false);
	self.lblTitle:SetVisible(false);
	self:SetDraggable(false);
	
	self.classesForm = vgui.Create("DForm");
	self.classesForm:SetName("Classes");
	self.classesForm:SetPadding(4);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:SetDrawBackground(false);
	self.panelList:EnableVerticalScrollbar();
	
	for k, v in pairs(Clockwork.class:GetAll()) do
		if (v.characterScreen and (v.factions and table.HasValue(v.factions, self.info.faction))) then
			self.classTable = v;
			self.overrideData = {
				information = "Select this to make it your character's default class.",
				Callback = function()
					self.info.class = v.index;
				end
			};
			self.classForm:AddItem(vgui.Create("cwClassesItem", self));
		end;
	end;
	
	self.panelList:AddItem(self.classForm);
end;

-- Called when the panel is painted.
function PANEL:Paint() end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (!self.info.class or !Clockwork.class:Get(self.info.class)) then
		Clockwork.character:SetFault("You did not choose a class, or the class that you chose is not valid!");
		return false;
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(0, 0, 0, 0);
	self:SetSize(512, math.min(self.panelList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageThree", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local panel = Clockwork.character:GetPanel();
	
	self:ShowCloseButton(false);
	self.lblTitle:SetVisible(false);
	self:SetDraggable(false);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:SetDrawBackground(false);
	self.panelList:EnableVerticalScrollbar();
	
	self.overrideModel = nil;
	self.bSelectModel = nil;
	self.bPhysDesc = (Clockwork.command:Get("CharPhysDesc") != nil);
	self.info = Clockwork.character:GetCreationInfo();
	
	if (!Clockwork.faction.stored[self.info.faction].GetModel) then
		self.bSelectModel = true;
	end;
	
	local genderModels = Clockwork.faction.stored[self.info.faction].models[string.lower(self.info.gender)];
	
	if (genderModels and #genderModels == 1) then
		self.bSelectModel = false;
		self.overrideModel = genderModels[1];
		
		if (!panel:FadeInModelPanel(self.overrideModel)) then
			panel:SetModelPanelModel(self.overrideModel);
		end;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		self.nameForm = vgui.Create("DForm");
		self.nameForm:SetPadding(4);
		self.nameForm:SetName("Name");
		
		if (Clockwork.faction.stored[self.info.faction].useFullName) then
			self.fullNameTextEntry = self.nameForm:TextEntry("Full Name");
		else
			self.forenameTextEntry = self.nameForm:TextEntry("First Name");
			self.surnameTextEntry = self.nameForm:TextEntry("Last Name");
		end;
	end;
	
	if (self.bSelectModel or self.bPhysDesc) then
		self.appearanceForm = vgui.Create("DForm");
		self.appearanceForm:SetPadding(4);
		self.appearanceForm:SetName("Appearance");
		
		if (self.bPhysDesc and self.bSelectModel) then
			self.appearanceForm:Help("Write a physical description for your character in full English, and select an appropriate model.");
		elseif (self.bPhysDesc) then
			self.appearanceForm:Help("Write a physical description for your character in full English.");
		end;
		
		if (self.bPhysDesc) then
			self.physDescTextEntry = self.appearanceForm:TextEntry("Description");
		end;
		
		if (self.bSelectModel) then
			self.modelItemsList = vgui.Create("DPanelList", self);
				self.modelItemsList:SetPadding(4);
				self.modelItemsList:SetSpacing(16);
				self.modelItemsList:EnableHorizontal(true);
				self.modelItemsList:EnableVerticalScrollbar(true);
			self.appearanceForm:AddItem(self.modelItemsList);
		end;
	end;
	
	if (self.nameForm) then
		self.panelList:AddItem(self.nameForm);
	end;
	
	if (self.appearanceForm) then
		self.panelList:AddItem(self.appearanceForm);
	end;
	
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local lowerGender = string.lower(self.info.gender);
	local spawnIcon = nil;
	
	for k, v in pairs(Clockwork.faction.stored) do
		if (v.name == self.info.faction) then
			if (self.modelItemsList and v.models[lowerGender]) then
				for k2, v2 in pairs(v.models[lowerGender]) do
					spawnIcon = Clockwork:CreateCustomSpawnIcon(self);
					spawnIcon:SetModel(v2);
					
					-- Called when the spawn icon is clicked.
					function spawnIcon.DoClick(spawnIcon)
						if (self.selectedSpawnIcon) then
							self.selectedSpawnIcon:SetColor(nil);
						end;
						
						spawnIcon:SetColor(colorTargetID);
						
						if (!panel:FadeInModelPanel(v2)) then
							panel:SetModelPanelModel(v2);
						end;
						
						self.selectedSpawnIcon = spawnIcon;
						self.selectedModel = v2;
					end;
					
					self.modelItemsList:AddItem(spawnIcon);
				end;
			end;
		end;
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (self.overrideModel) then
		self.info.model = self.overrideModel;
	else
		self.info.model = self.selectedModel;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		if (IsValid(self.fullNameTextEntry)) then
			self.info.fullName = self.fullNameTextEntry:GetValue();
			
			if (self.info.fullName == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;
		else
			self.info.forename = self.forenameTextEntry:GetValue();
			self.info.surname = self.surnameTextEntry:GetValue();
			
			if (self.info.forename == "" or self.info.surname == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;
			
			if (string.find(self.info.forename, "[%p%s%d]") or string.find(self.info.surname, "[%p%s%d]")) then
				Clockwork.character:SetFault("Your forename and surname must not contain punctuation, spaces or digits!");
				return false;
			end;
			
			if (!string.find(self.info.forename, "[aeiou]") or !string.find(self.info.surname, "[aeiou]")) then
				Clockwork.character:SetFault("Your forename and surname must both contain at least one vowel!");
				return false;
			end;
			
			if (string.len(self.info.forename) < 2 or string.len(self.info.surname) < 2) then
				Clockwork.character:SetFault("Your forename and surname must both be at least 2 characters long!");
				return false;
			end;
			
			if (string.len(self.info.forename) > 16 or string.len(self.info.surname) > 16) then
				Clockwork.character:SetFault("Your forename and surname must not be greater than 16 characters long!");
				return false;
			end;
		end;
	end;
	
	if (self.bSelectModel and !self.info.model) then
		Clockwork.character:SetFault("You did not choose a model, or the model that you chose is not valid!");
		return false;
	end;
	
	if (self.bPhysDesc) then
		local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
			self.info.physDesc = self.physDescTextEntry:GetValue();
		if (string.len(self.info.physDesc) < minimumPhysDesc) then
			Clockwork.character:SetFault("The physical description must be at least "..minimumPhysDesc.." characters long!");
			return false;
		end;
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint() end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(0, 0, 0, 0);
	
	if (IsValid(self.modelItemsList)) then
		self.modelItemsList:SetTall(256);
	end;
	
	self:SetSize(512, math.min(self.panelList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageTwo", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local factions = {};
	
	for k, v in pairs(Clockwork.faction.stored) do
		if (!v.whitelist or Clockwork.character:IsWhitelisted(v.name)) then
			if (!Clockwork.faction:HasReachedMaximum(k)) then
				factions[#factions + 1] = v.name;
			end;
		end;
	end;
	
	table.sort(factions, function(a, b)
		return a < b;
	end);
	
	self:ShowCloseButton(false);
	self.lblTitle:SetVisible(false);
	self:SetDraggable(false);
	self.forcedFaction = nil;
	self.info = Clockwork.character:GetCreationInfo();
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:SetDrawBackground(false);
	
	self.settingsForm = vgui.Create("DForm");
	self.settingsForm:SetName("Settings");
	self.settingsForm:SetPadding(4);
	
	if (#factions > 1) then
		self.settingsForm:Help("The faction defines the overall character and can most likely be unchanged.");
		self.factionMultiChoice = self.settingsForm:MultiChoice("Faction");
		self.factionMultiChoice:SetEditable(false);
		
		-- Called when an option is selected.
		self.factionMultiChoice.OnSelect = function(multiChoice, index, value, data)
			for k, v in pairs(Clockwork.faction.stored) do
				if (v.name == value) then
					if (IsValid(self.genderMultiChoice)) then
						self.genderMultiChoice:Clear();
					else
						self.genderMultiChoice = self.settingsForm:MultiChoice("Gender");
						self.genderMultiChoice:SetEditable(false);
					end;
					
					if (v.singleGender) then
						self.genderMultiChoice:AddChoice(v.singleGender);
					else
						self.genderMultiChoice:AddChoice(GENDER_FEMALE);
						self.genderMultiChoice:AddChoice(GENDER_MALE);
					end;
					
					Clockwork.CurrentFactionSelected = {self, value};
					
					break;
				end;
			end;
		end;
	elseif (#factions == 1) then
		for k, v in pairs(Clockwork.faction.stored) do
			if (v.name == factions[1]) then
				self.genderMultiChoice = self.settingsForm:MultiChoice("Gender");
				self.genderMultiChoice:SetEditable(false);
				
				if (v.singleGender) then
					self.genderMultiChoice:AddChoice(v.singleGender);
				else
					self.genderMultiChoice:AddChoice(GENDER_FEMALE);
					self.genderMultiChoice:AddChoice(GENDER_MALE);
				end;
				
				Clockwork.CurrentFactionSelected = {self, v.name};
				self.forcedFaction = v.name;
				
				break;
			end;
		end;
	end;
	
	if (self.factionMultiChoice) then
		for k, v in pairs(factions) do
			self.factionMultiChoice:AddChoice(v);
		end;
	end;
	
	self.panelList:AddItem(self.settingsForm);
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (IsValid(self.genderMultiChoice)) then
		local faction = self.forcedFaction;
		local gender = self.genderMultiChoice.TextEntry:GetValue();
		
		if (!faction and self.factionMultiChoice) then
			faction = self.factionMultiChoice.TextEntry:GetValue();
		end;
		
		for k, v in pairs(Clockwork.faction.stored) do
			if (v.name == faction) then
				if (Clockwork.faction:IsGenderValid(faction, gender)) then
					self.info.faction = faction;
					self.info.gender = gender;
					return true;
				end;
			end;
		end;
	end;
	
	Clockwork.character:SetFault("You did not choose a faction or the one you have chosen is not valid!");
	return false;
end;

-- Called when the panel is painted.
function PANEL:Paint() end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(0, 0, 0, 0);
	self:SetSize(512, math.min(self.panelList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageOne", PANEL, "DFrame");

usermessage.Hook("cwCharacterRemove", function(msg)
	local characters = Clockwork.character:GetAll();
	
	if (table.Count(characters) > 0) then
		local characterID = msg:ReadShort();
		
		if (characters[characterID]) then
			characters[characterID] = nil;
			
			if (!Clockwork.character:IsPanelLoading()) then
				Clockwork.character:RefreshPanelList();
			end;
			
			if (Clockwork.character:GetPanelList()) then
				if (table.Count(characters) == 0) then
					Clockwork.character:GetPanel():ReturnToMainMenu();
				end;
			end;
		end;
	end;
end);

Clockwork:HookDataStream("SetWhitelisted", function(data)
	local whitelisted = Clockwork.character:GetWhitelisted();
	
	for k, v in pairs(whitelisted) do
		if (v == data[1]) then
			if (!data[2]) then
				whitelisted[k] = nil;
				
				return;
			end;
		end;
	end;
	
	if (data[2]) then
		whitelisted[#whitelisted + 1] = data[1];
	end;
end);

Clockwork:HookDataStream("CharacterAdd", function(data)
	Clockwork.character:GetAll()[data.characterID] = data;
	
	if (!Clockwork.character:IsPanelLoading()) then
		Clockwork.character:RefreshPanelList();
	end;
end);

Clockwork:HookDataStream("CharacterMenu", function(data)
	if (data == CHARACTER_MENU_LOADED) then
		if (Clockwork.character:GetPanel()) then
			Clockwork.character:SetPanelLoading(false);
			Clockwork.character:RefreshPanelList();
		end;
	elseif (data == CHARACTER_MENU_CLOSE) then
		Clockwork.character:SetPanelOpen(false);
	elseif (data == CHARACTER_MENU_OPEN) then
		Clockwork.character:SetPanelOpen(true);
	end;
end);

usermessage.Hook("cwCharacterOpen", function(msg)
	Clockwork.character:SetPanelOpen(true);
	
	if (msg:ReadBool()) then
		Clockwork.character.isMenuReset = true;
	end;
end);

usermessage.Hook("cwCharacterFinish", function(msg)
	if (msg:ReadBool()) then
		Clockwork.character:SetPanelMainMenu();
		Clockwork.character:SetPanelOpen(false, true);
		Clockwork.character:SetFault(nil);
	else
		Clockwork.character:SetFault(msg:ReadString());
	end;
end);

Clockwork.character:RegisterCreationPanel("Persuasion", "cwCharacterStageOne");

Clockwork.character:RegisterCreationPanel("Description", "cwCharacterStageTwo");

Clockwork.character:RegisterCreationPanel("Default Class", "cwCharacterStageThree", function(info)
	local classTable = Clockwork.class:GetAll();
	
	if (table.Count(classTable) > 0) then
		for k, v in pairs(classTable) do
			if (v.characterScreen and (v.factions
			and table.HasValue(v.factions, info.faction))) then
				return true;
			end;
		end;
	end;
	
	return false;
end);

Clockwork.character:RegisterCreationPanel(Clockwork.option:GetKey("name_attributes"), "cwCharacterStageFour", function(info)
	local attributeTable = Clockwork.attribute:GetAll();
	
	if (table.Count(attributeTable) > 0) then
		for k, v in pairs(attributeTable) do
			if (v.characterScreen) then
				return true;
			end;
		end;
	end;
	
	return false;
end);