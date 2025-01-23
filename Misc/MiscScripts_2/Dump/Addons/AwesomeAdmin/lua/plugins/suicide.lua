local PLUGIN = {
	Name = "Suicide",
	Permissions = {
		can_suicide = "Player Can Suicide"
	}
	
	Hooks = {
		CanPlayerSuicide = function(ply)
			if ply:HasPermission("can_suicide") then
				return true
			end
		end
	}
}