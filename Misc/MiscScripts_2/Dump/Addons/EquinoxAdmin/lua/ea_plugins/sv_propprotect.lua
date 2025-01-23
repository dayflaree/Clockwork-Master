local PLUGIN = {}

PLUGIN.Name = "Prop Protection"
PLUGIN.Purpose = "Allows/Disallows players to touch/use other players props."
PLUGIN.Flag = "C"
PLUGIN.Command = "pp"
PLUGIN.Help = "ea pp add/del/clear [<username/part>]"

function PLUGIN.HandleCommand(ply, args)
	if args[1] == "add" then
		local found = EA.FindPlayer(ply, args[2])
		if not found then return end
	elseif args[1] == "del" then
		local found = EA:FindPlayer(ply, args[2])
		if not found then return end
	elseif args[1] == "clear" then
		
	end
end

EA:RegisterPlugin(PLUGIN)