local servers = {
	{ Name = "Build Server", IP = "111.222.111.222" }
}

if SERVER then
	local Player = FindMetaTable("Player")
	
	function Player:Connect(ip)
		umsg.Start("server_portal", self)
			umsg.String(ip)
		umsg.End()
	end
else
	umsg.hook("server_portal_menu", function(um)
		sp_menu = vgui.Create("DFrame")
		sp_menu:SetSize(300, 400)
		sp_menu:SetTitle("Server Portal")
		sp_menu:SetVisible(true)
		sp_menu:SetDraggable(true)
		sp_menu:ShowCloseButton(true)
		sp_menu:MakePopup()
		sp_menu:Center()
		
		local i = 0
		
		for k, v in pairs(servers) do
			s_button = vgui.Create("DButton")
			s_button:SetText(v.Name)
			s_button.DoClick = function()
				LocalPlayer():ConCommand('connect ' .. v.IP) 
			end
		end
	end)
end