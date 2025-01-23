local PLUGIN = {
	Name = "Teams",
	Settings = {
		rank_teams = true
	},
	Permissions = {
		can_change_team_colors = "Can Change Team Colors"
	},
	
	Hooks = {
		Initialise = function()
			if AA:GetSetting("rank_teams") then
				for ID, Rank in pairs(AA.Ranks) do
					team.SetUp(ID, Rank.Name, Rank.Color)
				end
			end
		end,
		
		PlayerSpawn = function(ply)
			ply:SetTeam(ply.Rank().ID)
		end
	},
	
	Menu = {
		Ranks = {
			
		}
	}
}