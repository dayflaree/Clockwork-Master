local PLUGIN = {}
PLUGIN.Name = "No Spawning"
PLUGIN.Description = "Disallows players from doing pretty much everything in sandbox."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { NoSpawning = "Disallow Spawning Objects" }

PLUGIN.Hooks = {
	PlayerSpawnObject = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	PlayerSpawnNPC = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	PlayerSpawnSENT = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	PlayerSpawnSWEP = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	PlayerSpawnVehicle = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	CanTool = function(ply)
		return not ply:HasPermission(PLUGIN.Permissions.NoSpawning)
	end,
	SpawnMenuOpen = function()
		return not LocalPlayer():HasPermission(PLUGIN.Permissions.NoSpawning) -- reeeeeeeh
	end
}

NERO:RegisterPlugin(PLUGIN)