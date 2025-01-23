local PLUGIN = {}
PLUGIN.Name = "Disallow Suicide"
PLUGIN.Description = "Stops players from commiting suicide."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { CantSuicide = "Disallow suicide" }

PLUGIN.Hooks = {
	CanPlayerSuicide = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.CantSuicide)
	end
}

NERO:RegisterPlugin(PLUGIN)