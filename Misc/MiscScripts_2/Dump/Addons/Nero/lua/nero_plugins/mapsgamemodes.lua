local PLUGIN = {}
PLUGIN.Name = "Maps & Gamemodes"
PLUGIN.Description = "Provides a way of changing the map and gamemode with an optional delay."
PLUGIN.Author = "_Undefined"
PLUGIN.Dependencies = { "datatransfer" }
PLUGIN.Permissions = { GetMaps = "Get Maps", ChangeMap = "Change Map" }

PLUGIN.Maps = {}
PLUGIN.Gamemodes = {}

PLUGIN.CurrentCountdown = false

PLUGIN.Hooks = {
	PlayerInitialSpawn = function(ply)
		if ply:HasPermission(PLUGIN.Permissions.GetMaps) then
			PLUGIN.Commands.GetMaps(ply)
		end
		
		--if PLUGIN.CurrentCountdown then
		--	ply:Send("changemap_countdown", PLUGIN.CurrentCountdown.Map, PLUGIN.CurrentCountdown.Started, PLUGIN.CurrentCountdown.Seconds)
		--end
	end
}

PLUGIN.Commands = {
	GetMaps = function(ply)
		local maps = {}
		local gamemodes = {}
		
		for _, map in pairs(file.Find("../maps/*.bsp")) do
			table.insert(PLUGIN.Maps, map)
		end

		for _, gm in pairs(file.FindDir("../gamemodes/*")) do
			table.insert(PLUGIN.Gamemodes, gm)
		end
		
		ply:Send("maps_gamemodes", {Maps = PLUGIN.Maps, Gamemodes = PLUGIN.Gamemodes})
	end,
	
	ChangeMap = function(ply, map, delay, gm)
		
	end
}

PLUGIN.DataHooks = {
	maps_gamemodes = function(data)
		PLUGIN.Maps = data.Maps
		PLUGIN.Gamemodes = data.Gamemodes
	end,
	
	changemap_countdown = function(um)
		local delay = um:ReadLong()
		-- create vgui here
	end
}

PLUGIN.Menu = {
	Gamemode = {
		["Change Map"] = function(menu)
			for _, map in pairs(PLUGIN.Maps) do
				local mapmenu = menu:AddSubMenu(map)
				for _, gm in pairs(PLUGIN.Gamemodes) do
					local gmmenu = mapmenu:AddSubMenu(gm)
					for delay, str in pairs({[0] = "Now", [60] = "1 Minute", [180] = "3 Minutes", [300] = "5 Minutes"}) do
						gmmenu:AddOption(str, function() RunConsoleCommand("nero", "changemap", map, gm, delay) end)
					end
				end
			end
		end
	}
}

NERO:RegisterPlugin(PLUGIN)