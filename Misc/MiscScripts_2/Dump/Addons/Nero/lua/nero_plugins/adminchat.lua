local PLUGIN = {}
PLUGIN.Name = "Admin Chat"
PLUGIN.Description = "Allows admins to talk to each other."
PLUGIN.Author = "_Undefined"
PLUGIN.Permissions = { AdminChat = "Receive admin chat" }

PLUGIN.Hooks = {
	PlayerSay = function(ply, text, teamonly, dead)
		if string.sub(text, 1, 1) == "@" then
			NERO:Notify(NERO:FindPlayersWithPermission(PLUGIN.Permissions.AdminChat), Color(255, 55, 0), "[A] ", ply, Color(255, 255, 255), ": ", string.sub(text, 2))
		end
	end,
}

NERO:RegisterPlugin(PLUGIN)