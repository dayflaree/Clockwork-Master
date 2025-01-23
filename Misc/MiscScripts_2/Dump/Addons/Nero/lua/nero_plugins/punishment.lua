local PLUGIN = {}
PLUGIN.Name = "Punishment"
PLUGIN.Description = "Punish players"
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { Punish = "Punish players" }

PLUGIN.Commands = {
	punish = function(ply, players, action)
		NERO:FindPlayers(players):Call(action)
	end
}

PLUGIN.Extend = {
	Player = {
		Explode = function(self)
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
				effect:SetStart(self:GetPos())
				effect:SetMagnitude(1024)
				effect:SetScale(256)
			util.Effect("Explosion", effect)
			util.BlastDamage(self, self, self:GetPos(), 150, 150)
		end,
		
		Rocket = function(self)
			
		end,
		
		Smite = function(self)
			
		end
	}
}

PLUGIN.Menu = {
	Player = {
		Punishment = function(ply, menu)
			--menu:AddOption("
		end
	}
}

NERO:RegisterPlugin(PLUGIN)