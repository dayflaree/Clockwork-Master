local PLUGIN = {}

PLUGIN.Name = "Kick"
PLUGIN.Purpose = "Kicks a player."
PLUGIN.Flag = "M"
PLUGIN.Command = "kick"
PLUGIN.Help = "ea kick <username/part>"

function PLUGIN.HandleCommand(ply, args)
	local found = EA.FindPlayer(ply, args[1])
	if not found then return end
end

EA:RegisterPlugin(PLUGIN)