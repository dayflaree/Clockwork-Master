local PLUGIN = {}
PLUGIN.Name = "Teleportation"
PLUGIN.Description = "Provides a way of moving or bringing players."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { Bring = "Bring Players", Send = "Send Players", Goto = "Go to Players" }

PLUGIN.Commands = {
	Bring = function(ply, players)
		NERO:FindPlayers(players):Call("SetPos", ply:GetPos())
	end,
	
	Send = function(ply, players, to)
		NERO:FindPlayers(players):Call("SetPos", NERO:FindPlayers(to):First("GetPos"))
	end,
	
	Goto = function(ply, to)
		ply:SetPos(NERO:FindPlayers(to):First("GetPos"))
	end
}

PLUGIN.Menu = {
	Player = {
		["Bring"] = function(menu)
			
		end,
		
		["Send to"] = function(menu)
			
		end,
		
		["Go to"] = function(menu)
			
		end
	}
}

NERO:RegisterPlugin(PLUGIN)