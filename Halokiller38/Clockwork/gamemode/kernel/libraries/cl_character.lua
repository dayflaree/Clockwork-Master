--[[
	Free Clockwork!
--]]

Clockwork.character = Clockwork:NewLibrary("Character");
Clockwork.character.stored = {};
Clockwork.character.whitelisted = {};
Clockwork.character.creationPanels = {};

-- A function to register a creation panel.
function Clockwork.character:RegisterCreationPanel(friendlyName, vguiName, Condition)
	local newIndex = #Clockwork.character.creationPanels + 1;
	
	Clockwork.character.creationPanels[newIndex] = {};
	Clockwork.character.creationPanels[newIndex].index = newIndex;
	Clockwork.character.creationPanels[newIndex].vguiName = vguiName;
	Clockwork.character.creationPanels[newIndex].Condition = Condition;
	Clockwork.character.creationPanels[newIndex].friendlyName = friendlyName;
end;

-- A function to get the previous character creation panel.
function Clockwork.character:GetPreviousCreationPanel()
	local info = self:GetCreationInfo();
	local index = info.index - 1;
	
	while (self.creationPanels[index]) do
		local panelInfo = self.creationPanels[index];
		
		if (!panelInfo.Condition
		or panelInfo.Condition(info)) then
			return panelInfo;
		end;
		
		index = index - 1;
	end;
end;

-- A function to get the next character creation panel.
function Clockwork.character:GetNextCreationPanel()
	local info = self:GetCreationInfo();
	local index = info.index + 1;
	
	while (self.creationPanels[index]) do
		local panelInfo = self.creationPanels[index];
		
		if (!panelInfo.Condition
		or panelInfo.Condition(info)) then
			return panelInfo;
		end;
		
		index = index + 1;
	end;
end;

-- A function to reset the character creation info.
function Clockwork.character:ResetCreationInfo()
	self:GetPanel().info = {index = 0};
end;

-- A function to get the character creation info.
function Clockwork.character:GetCreationInfo()
	return self:GetPanel().info;
end;

-- A function to get the creation progress as a percentage.
function Clockwork.character:GetCreationProgress()
	return (100 / #self.creationPanels) * self:GetCreationInfo().index;
end;

-- A function to get whether the creation process is active.
function Clockwork.character:IsCreationProcessActive()
	local activePanel = self:GetActivePanel();
	
	if (activePanel and activePanel.bIsCreationProcess) then
		return true;
	else
		return false;
	end;
end;

-- A function to open the previous character creation panel.
function Clockwork.character:OpenPreviousCreationPanel()
	local previousPanel = self:GetPreviousCreationPanel();
	local activePanel = self:GetActivePanel();
	local panel = self:GetPanel();
	local info = self:GetCreationInfo();
	
	if (info.index > 0 and activePanel and activePanel.OnPrevious
	and activePanel:OnPrevious() == false) then
		return;
	end;
	
	if (previousPanel) then
		info.index = previousPanel.index;
		panel:OpenPanel(previousPanel.vguiName, info);
	end;
end;

-- A function to open the next character creation panel.
function Clockwork.character:OpenNextCreationPanel()
	local activePanel = self:GetActivePanel();
	local nextPanel = self:GetNextCreationPanel();
	local panel = self:GetPanel();
	local info = self:GetCreationInfo();
	
	if (info.index > 0 and activePanel and activePanel.OnNext
	and activePanel:OnNext() == false) then
		return;
	end;
	
	if (!nextPanel) then
		Clockwork.plugin:Call(
			"PlayerAdjustCharacterCreationInfo", self:GetActivePanel(), info
		);
		Clockwork:StartDataStream("CreateCharacter", info);
	else
		info.index = nextPanel.index;
		panel:OpenPanel(nextPanel.vguiName, info);
	end;
end;

-- A function to get the creation panels.
function Clockwork.character:GetCreationPanels()
	return self.creationPanels;
end;

-- A function to get the active panel.
function Clockwork.character:GetActivePanel()
	if (IsValid(self.activePanel)) then
		return self.activePanel;
	end;
end;

-- A function to set whether the character panel is loading.
function Clockwork.character:SetPanelLoading(loading)
	self.loading = loading;
end;

-- A function to get whether the character panel is loading.
function Clockwork.character:IsPanelLoading()
	return self.isLoading;
end;

-- A function to get the character panel list.
function Clockwork.character:GetPanelList()
	local panel = self:GetActivePanel();
	
	if (panel and panel.isCharacterList) then
		return panel;
	end;
end;

-- A function to get the whitelisted factions.
function Clockwork.character:GetWhitelisted()
	return self.whitelisted;
end;

-- A function to get whether the local player is whitelisted for a faction.
function Clockwork.character:IsWhitelisted(faction)
	return table.HasValue(self:GetWhitelisted(), faction);
end;

-- A function to get the local player's characters.
function Clockwork.character:GetAll()
	return self.stored;
end;

-- A function to get the character fault.
function Clockwork.character:GetFault()
	return self.fault;
end;

-- A function to set the character fault.
function Clockwork.character:SetFault(fault)
	if (type(fault) == "string") then
		Clockwork:AddCinematicText(fault, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
	end;
	
	self.fault = fault;
end;

-- A function to get the character panel.
function Clockwork.character:GetPanel()
	return self.panel;
end;

-- A function to fade in the navigation.
function Clockwork.character:FadeInNavigation()
	if (IsValid(self.panel)) then
		self.panel:FadeInNavigation();
	end;
end;

-- A function to refresh the character panel list.
function Clockwork.character:RefreshPanelList()
	local factionScreens = {};
	local factionList = {};
	local panelList = self:GetPanelList();
	
	if (panelList) then
		panelList:Clear();
		
		for k, v in pairs(self:GetAll()) do
			local faction = Clockwork.plugin:Call("GetPlayerCharacterScreenFaction", v);
			if (!factionScreens[faction]) then factionScreens[faction] = {}; end;
			
			factionScreens[faction][#factionScreens[faction] + 1] = v;
		end;
		
		for k, v in pairs(factionScreens) do
			table.sort(v, function(a, b)
				return Clockwork.plugin:Call("CharacterScreenSortFactionCharacters", k, a, b);
			end);
			
			factionList[#factionList + 1] = {name = k, characters = v};
		end;
		
		table.sort(factionList, function(a, b)
			return a.name < b.name;
		end);
		
		for k, v in pairs(factionList) do
			for k2, v2 in pairs(v.characters) do
				panelList.customData = {
					name = v2.name,
					model = v2.model,
					banned = v2.banned,
					faction = v.name,
					details = v2.details,
					characterID = v2.characterID,
					characterTable = v2
				};
				
				v2.panel = vgui.Create("cwCharacterPanel", panelList);
				
				if (IsValid(v2.panel)) then
					panelList:AddPanel(v2.panel);
				end;
			end;
		end;
	end;
end;

-- A function to get whether the character panel is open.
function Clockwork.character:IsPanelOpen()
	return self.isOpen;
end;

-- A function to set the character panel to the main menu.
function Clockwork.character:SetPanelMainMenu()
	local panel = self:GetPanel();
	
	if (panel) then
		panel:ReturnToMainMenu();
	end;
end;

-- A function to set whether the character panel is polling.
function Clockwork.character:SetPanelPolling(polling)
	self.isPolling = polling;
end;

-- A function to get whether the character panel is polling.
function Clockwork.character:IsPanelPolling()
	return self.isPolling;
end;

-- A function to get whether the character menu is reset.
function Clockwork.character:IsMenuReset()
	return self.isMenuReset;
end;

-- A function to set whether the character panel is open.
function Clockwork.character:SetPanelOpen(open, bReset)
	local panel = self:GetPanel();
	
	if (!open) then
		if (!bReset) then
			self.isOpen = false;
		else
			self.isOpen = true;
		end;
		
		if (panel) then
			panel:SetVisible(self:IsPanelOpen());
		end;
	elseif (panel) then
		panel:SetVisible(true);
		panel.createTime = SysTime();
		self.isOpen = true;
	else
		self:SetPanelPolling(true);
	end;
	
	gui.EnableScreenClicker(self:IsPanelOpen());
end;