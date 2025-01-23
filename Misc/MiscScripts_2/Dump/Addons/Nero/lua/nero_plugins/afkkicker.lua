local PLUGIN = {}
PLUGIN.Name = "AFK Kicker"
PLUGIN.Description = "Kicks players who are away for a certain length of time."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { NotAFKKicked = "Not AFK Kicked" }

PLUGIN.KickDelay = 5 -- Delay in minutes before kicking

PLUGIN.Hooks = {
	KeyPress = function(ply, key)
		--if not ply:HasPermission(PLUGIN.Permissions.NotAFKKicked) then
			timer.Create("NERO_AFK_" .. ply:Nick(), 60 * PLUGIN.KickDelay, 1, function()
				ply:Kick("AFK for " .. PLUGIN.KickDelay .. " minutes")
			end)
		--end
	end
}

NERO:RegisterPlugin(PLUGIN)