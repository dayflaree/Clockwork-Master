local PLUGIN = {}
PLUGIN.Name = "CExec"
PLUGIN.Description = "Allows commands to be run on clients."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { CExec = "Run CExec commands" }

PLUGIN.Comands = {
	CExec = function(ply, players, command)
		NERO:FindPlayers(players).Call("ConCommand", command)
		NERO:Notify(NOTIFY_ADMINS, ply, " executed '", command, "' on ", NERO:FindPlayers(players))
	end
}

NERO:RegisterPlugin(PLUGIN)