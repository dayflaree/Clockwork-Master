local PLUGIN = {}

PLUGIN.Name = "Admin Chat"
PLUGIN.Purpose = "Lets admins talk to each other."
PLUGIN.Help = "@ <text>"

function PLUGIN.PlayerSay(ply, cmd, args)
	if string.sub(text, 1, 1) == "@" then
		for k, v in pairs(player.ByFlag("A")) do
			string.sub(text, 3)
		end
		return ""
	end
end
EA:RegisterHook("PlayerSay", "Commands", PLUGIN.PlayerSay)

EA:RegisterPlugin(PLUGIN)