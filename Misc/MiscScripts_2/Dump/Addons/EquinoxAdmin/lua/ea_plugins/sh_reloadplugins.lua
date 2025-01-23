local PLUGIN = {}

PLUGIN.Name = "Reload Plugins"
PLUGIN.Purpose = "Reloads all plugins."
PLUGIN.FLAG = "O"
PLUGIN.Command = "plugins"
PLUGIN.Help = "ea plugins"

EA.Strings.PluginsReloaded = "All plugins reloaded."

function PLUGIN.HandleCommand(ply, args)
	EA.Plugins = {}
	
	for _, filename in pairs(file.FindInLua("ea_plugins/*.lua")) do
		include("ea_plugins/"..filename)
	end
	
	if SERVER then
		EA:Notify(ply, EA.Strings.PluginsReloaded)
	end
end

EA:RegisterPlugin(PLUGIN)