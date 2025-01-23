local PLUGIN = {}
PLUGIN.Name = "Disable NoClip"
PLUGIN.Description = "Allows or diallows players from noclipping."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { DisableNoClip = "Disable NoClipping" }

PLUGIN.Hooks = {
	PlayerNoClip = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.DisableNoClip)
	end
}

NERO:RegisterPlugin(PLUGIN)