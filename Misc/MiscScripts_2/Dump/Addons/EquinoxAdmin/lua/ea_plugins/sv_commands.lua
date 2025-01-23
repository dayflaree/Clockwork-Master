local PLUGIN = {}

PLUGIN.Name = "Commands"
PLUGIN.Purpose = "Creates a single concommand and chat handle to handle the 'command' functions for all the plugins."

function PLUGIN.CommandHandler(ply, cmd, args)
	for _, P in pairs(EA.Plugins) do
		if P.Command == args[1] then
			if not P.Flag or ply:HasFlag(P.Flag) then
				table.remove(args, 1)
				P.HandleCommand(ply, args)
				return true
			end
		end
	end
	return false
end
concommand.Add("ea", PLUGIN.CommandHandler)

function PLUGIN.PlayerSay(ply, text, teamonly, dead)
	if string.sub(text, 1, 3) == "!ea" then
		local args = string.Explode(" ", string.sub(text, 5))
		PLUGIN.CommandHandler(ply, "ea", args)
		return ""
	end
end
EA:RegisterHook("PlayerSay", "Commands", PLUGIN.PlayerSay)

EA:RegisterPlugin(PLUGIN)