local PLUGIN = {}
PLUGIN.Name = "Data Saving"
PLUGIN.Description = "Saves data over restarts and crashes."
PLUGIN.Author = "_Undefined"

PLUGIN.Data = {}

PLUGIN.Hooks = {
	Initialize = function()
		PLUGIN.Data = glon.decode(file.Read("nero/data.txt")) or {}
	end,
	
	Shutdown = function()
		file.Write("nero/data.txt", glon.encode(PLUGIN.Data))
	end
}

PLUGIN.Extend = {
	NERO = {
		Get = function(key, default)
			return PLUGIN.Data[key] or default or nil
		end,
		
		Set = function(key, value)
			PLUGIN.Data[key] = value
		end
	}
}

timer.Create("NERO_DataSaving", 10, 0, PLUGIN.Hooks.Shutdown)

NERO:RegisterPlugin(PLUGIN)