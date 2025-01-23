local AA = {}

function CreateAA()
	AA.GUI = vgui.Create("DPropertySheet")
	AA.GUI:SetSize(700, 250)
	AA.GUI:SetPos(ScrW() + 10, ScrH() - 400)
	
	-- ClientsSheet
	local ClientsSheet = vgui.Create("DPanel")
	ClientsSheet:SetSize(690, 240)
	
	local ClientsList = vgui.Create("DListView", ClientsSheet)
	ClientsList:SetPos(5, 5)
	ClientsList:SetSize(ClientsSheet:GetWide() - 10, ClientsSheet:GetTall() - 10)
	ClientsList:SetMultiSelect(true)
	ClientsList:AddColumn("Name")
	ClientsList.DoDoubleClick = function()
		
	end
	
	for k, ply in pairs(player.GetAll()) do
		ClientsList:AddLine(ply:Nick())
	end
	
	-- RanksSheet
	local RanksSheet = vgui.Create("DPanel")
	RanksSheet:SetSize(690, 240)
	
	local RanksList = vgui.Create("DListView", RanksSheet)
	RanksList:SetPos(5, 5)
	RanksList:SetSize(RanksSheet:GetWide() - 10, RanksSheet:GetTall() - 10)
	RanksList:SetMultiSelect(true)
	RanksList:AddColumn("Name")
	RanksList.DoDoubleClick = function()
		
	end
	
	for k, ply in pairs(player.GetAll()) do
		RanksList:AddLine(ply:Nick())
	end
	
	-- SettingsSheet
	local SettingsSheet = vgui.Create("DPanel")
	SettingsSheet:SetSize(690, 240)
	
	-- PluginsSheet
	local PluginsSheet = vgui.Create("DPanel")
	PluginsSheet:SetSize(690, 240)
	
	local PluginsList = vgui.Create("DListView", PluginsSheet)
	PluginsList:SetPos(5, 5)
	PluginsList:SetSize(PluginsSheet:GetWide() - 10, PluginsSheet:GetTall() - 10)
	PluginsList:SetMultiSelect(true)
	PluginsList:AddColumn("Name"):SetMaxWidth(120)
	PluginsList:AddColumn("Description"):SetMinWidth(64)
	PluginsList:AddColumn("Status"):SetMaxWidth(80)
	PluginsList:AddColumn("Author"):SetMaxWidth(100)
	
	--for k, plugin in pairs(AA.Plugins) do
		
	--end
	
	AA.GUI:AddSheet("Clients", ClientsSheet, "gui/silkicons/user", false, false, "Manage Users")
	AA.GUI:AddSheet("Ranks", RanksSheet, "gui/silkicons/group", false, false, "Manage Ranks")
	AA.GUI:AddSheet("Settings", SettingsSheet, "gui/silkicons/wrench", false, false, "Manage Settings")
	AA.GUI:AddSheet("Plugins", PluginsSheet, "gui/silkicons/plugin", false, false, "Manage Plugins")
	
	local AnchorButton = vgui.Create("DImageButton", AA.GUI)
	AnchorButton:SetMaterial("gui/silkicons/anchor")
	AnchorButton:SetSize(16, 16)
	AnchorButton:SetPos((ScrW() / 2) + (AA.GUI:GetWide() / 2) - 37, ScrH() - 400)
	AnchorButton.DoClick = function()
		AA.GUI.Anchor = not AA.GUI.Anchor or true
	end
end

concommand.Add("+awesomeadmin", function(ply, cmd, args)
	if not AA.GUI then CreateAA() end
	AA.GUI:MoveTo((ScrW() / 2) - (AA.GUI:GetWide() / 2), ScrH() - 400, 0.1, 0, 0.1)
	
	gui.EnableScreenClicker(true)
	
	if AA.MousePosX and AA.MousePosY then
		gui.SetMousePos(AA.MousePosX, AA.MousePosY)
	end
end)

concommand.Add("-awesomeadmin", function(ply, cmd, args)
	if AA.GUI and not AA.GUI.Anchor then
		AA.MousePosX, AA.MousePosY = gui.MousePos()
		gui.EnableScreenClicker(false)
		AA.GUI:MoveTo(ScrW() + 10, ScrH() - 400, 0.1, 0, 0.1)
	end
end)