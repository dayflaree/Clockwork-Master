--[[
	Context Admin Mod
	_Undefined
	050110
	Clientside menu's etc.
]]--

hook.Add("Initialize", "ModMenus", function()
	function DMenuOption:SetIcon(icon)
		self.Icon = surface.GetTextureID("gui/silkicons/" .. icon)
	end
	
	function DMenuOption:PaintOver()
		if self.Icon then
			surface.SetTexture(self.Icon) 
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(2, 1, 16, 16)
		end
	end
	
	function DMenu:SetIcon(icon)
		if self.ParentMenu then
			self.ParentMenu:SetIcon(icon)
		end
		
		return self
	end
	
	function DMenu:AddOption(text, func)
		local pnl = vgui.Create("DMenuOption", self)
		pnl:SetText(text)
		if func then pnl.DoClick = func end
		
		self:AddPanel(pnl)
		
		return pnl
	end
	
	function DMenu:AddSubMenu(text, func)
		local SubMenu = DermaMenu(self)
		SubMenu:SetVisible(false)
		SubMenu:SetParent(self)
		
		local pnl = vgui.Create("DMenuOption", self)
		pnl:SetSubMenu(SubMenu)
		pnl:SetText(text)
		if func then pnl.DoClick = func end
		
		self:AddPanel(pnl)
		
		SubMenu.ParentMenu = pnl
		
		return SubMenu
	end
end)

function RunCommand(command, ...)
	RunConsoleCommand("co", command, ...)
end

function CONTEXT:OpenMenu(ply, cmd, args)
	local tr = LocalPlayer():GetEyeTrace()
	
	local menu = DermaMenu()
	
	if tr.HitWorld then
		self:WorldMenu(menu)
	elseif tr.Entity and tr.Entity:IsValid() then
		local ent = tr.Entity
		if ent:IsPlayer() then
			self:PlayerMenu(menu, ent)
		else
			self:EntityMenu(menu, ent)
		end
	end
	menu:Open()
	
	self.Menu = menu
end
concommand.Add("+context", function() CONTEXT:OpenMenu(ply, cmd, args) end)

function CONTEXT:CloseMenu(ply, cmd, args)
	self.Menu:Remove()
end
concommand.Add("-context", function() CONTEXT:CloseMenu(ply, cmd, args) end)

function CONTEXT:WorldMenu(menu)
	pmenu = menu:AddSubMenu("Players"):SetIcon("user")
	for _, ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			self:PlayerMenu(pmenu:AddSubMenu(ply:Nick()), ply)
		end
	end
	
	wmenu = menu:AddSubMenu(GAMEMODE.Name):SetIcon("world")
	for k, PLUGIN in pairs(CONTEXT.Plugins) do
		if PLUGIN.Menu and PLUGIN.Menu.World and #PLUGIN.Menu.World then
			for _, func in pairs(PLUGIN.Menu.World) do
				func(wmenu)
			end
		end
	end
end

function CONTEXT:PlayerMenu(menu, ply)
	for _, ply in pairs(player.GetAll()) do
		for _, PLUGIN in pairs(CONTEXT.Plugins) do
			if PLUGIN.Menu and PLUGIN.Menu.Player and #PLUGIN.Menu.Player then
				for _, func in pairs(PLUGIN.Menu.Player) do
					func(menu, ply)
				end
			end
		end
	end
end

function CONTEXT:EntityMenu(menu, ent)
	for k, PLUGIN in pairs(CONTEXT.Plugins) do
		if PLUGIN.Menu and PLUGIN.Menu.Entity and #PLUGIN.Menu.Entity then
			for k, func in pairs(PLUGIN.Menu.Entity) do
				func(menu, ent)
			end
		end
	end
end

datastream.Hook("ChatPrint", function(handler, id, encoded, decoded)
	chat.AddText(Color(255, 255, 255), unpack(decoded))
end)