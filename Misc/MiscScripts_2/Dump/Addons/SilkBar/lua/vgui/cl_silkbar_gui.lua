local users = "gui/silkicons/group"
local maps = "gui/silkicons/world"
local gamemodes = "gui/silkicons/joystick"
local notices = "gui/silkicons/newspaper"
local server = "gui/silkicons/server"
local info = "gui/silkicons/information"
local options = "gui/silkicons/wrench"

local PANEL = {}

function PANEL:Init()

	//usersBt.DoClick = function()
	//	Msg("You clicked the button!\n")
	//end

	local usersBt = vgui.Create("DImageButton", self)
	usersBt:SetImage(users)
	usersBt:SetSize(16, 16)
	usersBt:SetPos(5, 19)
	usersBt:SetToolTip("Users")
	usersBt.DoClick = function(btn)
		self.usersMenu = DermaMenu()
		self.usersMenu:SetParent("usersBt")
		for k, v in pairs(player.GetAll()) do
			local usersSubMenu = self.usersMenu:AddSubMenu(v:Nick())
				usersSubMenu:AddOption("Kick", function() RunConsoleCommand("ass_kickplayer", v:UniqueID()) end)
				usersSubMenu:AddOption("Ban", function() PChat("You banned "..v:Nick().."\n") end)
				usersSubMenu:AddOption("CExec", function() Derma_StringRequest( "Client Exec", "What command do you wish to run?", "", function(strTextOut) v:ConCommand(strTextOut) end) end)
		end
		
		self.usersMenu:Open()
	end
	
	local mapsBt = vgui.Create("DImageButton", self)
	mapsBt:SetImage(maps)
	mapsBt:SetSize(16, 16)
	mapsBt:SetPos(25, 19)
	mapsBt:SetToolTip("Maps")
	mapsBt.DoClick = function(btn)
		self.mapsMenu = DermaMenu()
		self.mapsMenu:SetParent("mapsBt")
		
		local allMaps = file.Find("../maps/gm_*.bsp")
		for k, v in pairs(allMaps) do
			self.mapsMenu:AddOption(string.gsub(string.lower( v ), ".bsp", ""), function() PChat("You clicked "..string.gsub(string.lower( v ), ".bsp", "").."\n") end)
		end

		self.mapsMenu:Open()
	end
	
	local gamemodesBt = vgui.Create("DImageButton", self)
	gamemodesBt:SetImage(gamemodes)
	gamemodesBt:SetSize(16, 16)
	gamemodesBt:SetPos(45, 19)
	gamemodesBt:SetToolTip("Gamemodes")
	gamemodesBt.DoClick = function(btn)
		self.gamemodesMenu = DermaMenu()
		self.gamemodesMenu:SetParent("mapsBt")
		
		local allGamemodes = file.FindDir("../gamemodes/*")
		for k, v in pairs(allGamemodes) do
			self.gamemodesMenu:AddOption(v, function() PChat("You clicked "..v.."\n") end)
		end

		self.gamemodesMenu:Open()
	end
	
	local noticesBt = vgui.Create("DImageButton", self)
	noticesBt:SetImage(notices)
	noticesBt:SetSize(16, 16)
	noticesBt:SetPos(65, 19)
	noticesBt:SetToolTip("Notices")
	
	local serverBt = vgui.Create("DImageButton", self)
	serverBt:SetImage(server)
	serverBt:SetSize(16, 16)
	serverBt:SetPos(85, 19)
	serverBt:SetToolTip("Server Settings")
	
	local infoBt = vgui.Create("DImageButton", self)
	infoBt:SetImage(info)
	infoBt:SetSize(16, 16)
	infoBt:SetPos(105, 19)
	infoBt:SetToolTip("Info")
	
	local optionsBt = vgui.Create("DImageButton", self)
	optionsBt:SetImage(options)
	optionsBt:SetSize(16, 16)
	optionsBt:SetPos(280, 19)
	optionsBt:SetToolTip("Options")
	

end

function PANEL:Paint()

	draw.RoundedBox(8, 0, 0, 300, 40, Color(0, 0, 0, 100))

end

function PANEL:PerformLayout()
 	 
 	self:SetSize(300, 40)
 	self:SetPos(ScrW() / 2 - 150, -15)

end

function PANEL:ApplySchemeSettings()

end

vgui.Register("SilkBar", PANEL, "Panel")