local MODULE = {}

MODULE.Name = "RCON"
MODULE.Author = "_Undefined"
MODULE.Created = "29th April 2009"
MODULE.Stub = "rcon"
MODULE.Icon = "application_xp_terminal"
MODULE.Flags = { "rcon" }

if (SERVER) then
	function MODULE.RCon(by, command)
		if (SB_HasAccess(by, "rcon")) then
			SB_Action("Player "..by:Nick().." ran '"..command.."'!")
			RunConsoleCommand(command)
		end
	end
	concommand.Add("SB_RCon", MODULE.RCon)
end

if (CLIENT) then
	function MODULE.AddMenu()
		SB_AddMenuItem(MENU_SERVER, "Rcon", MODULE.RCon)
	end
end

//AddSilkModule(MODULE)