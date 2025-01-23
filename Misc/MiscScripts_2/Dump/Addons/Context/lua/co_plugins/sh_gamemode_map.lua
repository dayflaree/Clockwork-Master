local PLUGIN = {}

PLUGIN.Name = "Gamemode & Map Changing"

if CLIENT then
	CONTEXT.Maps = {}
	CONTEXT.Gamemodes = {}
		
	datastream.Hook("Context_Maps_GMs", function(handler, id, encoded, decoded)
		CONTEXT.Maps = decoded.maps
		CONTEXT.Gamemodes = decoded.gms
	end)
end

PLUGIN.Menu = {
	World = {
		function(menu)
			local times = {{"Now", 0}, {"30 Seconds", 30}, {"1 Minute", 60}, {"3 Minutes", 180}, {"5 Minutes", 300}}
			local mmenu = menu:AddSubMenu("Change Map/Gamemode"):SetIcon("picture_edit")
			
			if #CONTEXT.Maps < 1 or #CONTEXT.Gamemodes < 1 then
				mmenu:AddOption("**Reopen Menu**", RunCommand("get_maps_gms"))
				return
			end
			
			for k, map in pairs(CONTEXT.Maps) do
				gmmenu = mmenu:AddSubMenu(map)
				
				for k, gm in pairs(CONTEXT.Gamemodes) do
					local tmenu = gmmenu:AddSubMenu(gm)
					for _, time in pairs(times) do
						tmenu:AddOption(time[1], function() RunCommand("change_map_gm", map, gm, time[2]) end)
					end
				end
			end
		end
	}
}

PLUGIN.Commands = {
	change_map_gm = function(ply, args)
		local map = args[1]
		local gm = args[2]
		local timeout = args[3]
		CONTEXT.Notify(nil, ply, " changed to '" .. gm .. "' on '" .. map .. "'! (TODO: Time/countdown)")
		game.ConsoleCommand("changegamemode " .. map .. " " .. gm .. "\n")
	end,
	
	get_maps_gms = function(ply, args)
		local data = {}
		data.maps = {}
		data.gms = {}
		
		local allMaps = file.Find("../maps/gm_*.bsp")
		for _, map in pairs(allMaps) do
			local mapname = string.gsub(string.lower(map), ".bsp", "")
			table.insert(data.maps, mapname)
		end
		
		data.gms = file.FindDir("../gamemodes/*")
		
		datastream.StreamToClients(ply, "Context_Maps_GMs", data)
	end
}

CONTEXT:RegisterPlugin(PLUGIN)