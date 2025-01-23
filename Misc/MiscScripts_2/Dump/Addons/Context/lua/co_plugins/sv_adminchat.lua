local PLUGIN = {}

PLUGIN.Name = "Admin Chat"
PLUGIN.Description = "Lets admins talk to each other."

PLUGIN.Hooks = {
	PlayerSay = function(ply, text, teamonly)
		if not ply:IsAdmin() then return end
		
		if string.sub(text, 1, 2) == "!!" then
			local plys = {}
			
			for k, v in pairs(player.GetAll()) do
				if v:IsAdmin() then
					table.insert(plys, v)
				end
			end
			
			CONTEXT.Notify(plys, ply, ": ", string.sub(text, 3))
		end
	end
}

CONTEXT:RegisterPlugin(PLUGIN)