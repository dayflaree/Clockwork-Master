local PLUGIN = {}

PLUGIN.Name = "Player Titles"
PLUGIN.Purpose = "Sets titles for players."
PLUGIN.Flag = "A"
PLUGIN.Command = "title"
PLUGIN.Help = "ea title <username/part> <title>"

function PLUGIN.HandleCommand(ply, args)
	found = EA:FindPlayer(args[1])
	title = args[2] or ""
	if not found then return end
	
	found:SetProperty("Title", title, true)
end

EA:RegisterPlugin(PLUGIN)