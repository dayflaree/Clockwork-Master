local PLUGIN = {}

PLUGIN.Name = "Log To File"

PLUGIN.Log = function(name, text)
	-- Log to file
	if not file.Exists("context/" .. name .. ".txt") then
		
	end
end

CONTEXT:RegisterPlugin(PLUGIN)