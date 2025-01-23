local PLUGIN = {}
PLUGIN.Name = "Play Timer"
PLUGIN.Description = "Provides the number of seconds each player has played on the server."
PLUGIN.Author = "_Undefined"

PLUGIN.Hooks = {
	PlayerInitialSpawn = function(ply)
		ply._NeroTimer = tonumber(ply:GetPData("NERO_PlayTimer", 0))
	end,
	
	Initialize = function()
		timer.Create("NERO_PlayTimer", 1, 0, function()
			for _, ply in pairs(player.GetAll()) do
				MsgN("Setting " .. ply:Nick() .. "'s PlayTime to " .. ply:GetPlayTime() + 1)
				ply:SetPlayTime(ply:GetPlayTime() + 1)
			end
		end)

		timer.Create("NERO_PlayTimer", 30, 0, function()
			for _, ply in pairs(player.GetAll()) do
				ply:SetPData("NERO_PlayTimer", ply:GetPlayTime())
			end
		end)
	end
}

PLUGIN.Extend = {
	Player = {
		GetPlayTime = function(self)
			return self._NeroTimer or 0
		end,
		
		SetPlayTime = function(self, seconds)
			self._NeroTimer = seconds
		end
	}
}

NERO:RegisterPlugin(PLUGIN)