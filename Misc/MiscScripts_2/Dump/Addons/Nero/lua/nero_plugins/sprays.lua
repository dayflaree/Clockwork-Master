local PLUGIN = {}
PLUGIN.Name = "Sprays"
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { ShowSprayNames = "Show Spray Names" }

PLUGIN.Sprays = {}

PLUGIN.Hooks = {
	PlayerInitialSpawn = function(ply)
		if ply:HasPermission(PLUGIN.Permissions.ShowSprayNames) then
			ply:Send("sprays", PLUGIN.Sprays)
		end
	end,
	
	PlayerSpray = function(ply)
		local pos = ply:GetEyeTrace().HitPos
		NERO:FindPlayers(NERO:FindPlayersWithPermission(PLUGIN.Permissions.ShowSprayNames)):Call("Send", "spray", ply, pos)
		PLUGIN.Sprays[ply] = pos
	end,
	
	HUDPaint = function()
		for ply, pos in pairs(PLUGIN.Sprays) do 
			if pos:Distance(LocalPlayer():GetEyeTrace().HitPos) < 48 then
				local scrpos = pos:ToScreen()
				draw.SimpleTextOutlined("Sprayed by: " .. ply:Nick(), "Trebuchet24", scrpos.x, scrpos.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
				break
			end
		end
	end
}

PLUGIN.DataHooks = {
	spray = function(um)
		local ply = um:ReadEntity()
		local pos = um:ReadVector()
		PLUGIN.Sprays[ply] = pos
	end,
	
	sprays = function(data)
		PLUGIN.Sprays = data
	end
}

NERO:RegisterPlugin(PLUGIN)