local PLUGIN = {}

PLUGIN.Name = "Plugin Help"
PLUGIN.Purpose = "Prints the Purpose and Help for a plugin to a player."
PLUGIN.Command = "help"
PLUGIN.Help = "ea help <plugin name>"

function PLUGIN.HandleCommand(ply, args)
	
end

EA:RegisterPlugin(PLUGIN)