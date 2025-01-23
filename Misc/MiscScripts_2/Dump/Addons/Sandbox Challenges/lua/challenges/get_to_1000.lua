challenge.Register("get_to_1000", {
	Name = "Get to 1000",
	Description = "Get to a height of 1000 units off the ground, using no vehicles, tools, or weapons, and no noclip!",
	
	CanPlayerStart = function(ply)
		return ply:GetPos().z < 100, ply:GetPos().z < 100 and "" or "You must be on the ground to start!"
	end,
	
	CanPlayerEnd = function(ply)
		
	end,
	
	PlayerStart = function(ply)
		MsgN("Started challenge!")
	end,
	
	PlayerFinish = function(ply)
		MsgN("Finished challenge!")
	end,
	
	PlayerEnd = function(ply)
		MsgN("Ended challenge!")
	end,
	
	Hooks = {
		CanTool = function() return false end,
		PlayerSpawnProp = function() return true end,
		PlayerSpawnSENT = function() return false end,
		PlayerSpawnSWEP = function() return false end,
		PlayerSpawnVehicle = function() return false end,
		PlayerSpawnNPC = function() return false end,
		PlayerNoClip = function() return false end,
		
		HUDPaint = function()
			draw.SimpleTextOutlined(math.Round(LocalPlayer():GetPos().z), "ScoreboardText", 50, 20, Color(255, 255, 255, 255), 2, 2, 1, Color(0, 0, 0, 255))
		end
	},
	
	Think = function(ply)
		return ply:GetPos().z >= 1000
	end
})