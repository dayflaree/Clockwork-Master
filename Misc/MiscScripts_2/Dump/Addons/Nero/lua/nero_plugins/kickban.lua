local PLUGIN = {}
PLUGIN.Name = "Kick & Ban"
PLUGIN.Description = "Provides a system for kicking and banning players."
PLUGIN.Author = "_Undefined"
PLUGIN.Dependencies = { "datasaving" }
PLUGIN.Permissions = { Kick = "Kick Players", Ban = "Ban Players", PermaBan = "Permaban Players" }

PLUGIN.KickReasons = NERO:Get("kick_reasons", { "Kicked!", "Minge", "Idiot" })
PLUGIN.BanReasons = NERO:Get("ban_reasons", { "Banned!", "Asshole", "Fail", "Get out" })

PLUGIN.Commands = {
	Kick = function(ply, players, reason)
		NERO:FindPlayers(players):Call("Kick", reason)
		NERO:Notify(NOTIFY_ADMIN, ply, " kicked ", players, " with reason '", reason, "'")
	end,
	
	Ban = function(ply, players, duration, reason)
		NERO:FindPlayers(players):Call("Ban", tonumber(duration), reason)
	end,
	
	PermaBan = function(ply, players, reason)
		NERO:FindPlayers(players):Call("Ban", 0, reason)
	end
}

PLUGIN.Menu = {
	Player = {
		Kick = function(menu, ply)
			for _, reason in pairs(PLUGIN.KickReasons) do
				menu:AddOption(reason, function()
					RunConsoleCommand("nero", "kick", ply:UniqueID(), reason)
				end)
			end
			
			menu:AddSpacer()
			
			menu:AddOption("Custom...", function()	
				Derma_StringRequest("Kick " .. ply:Nick(), "Why do you want to kick " .. ply:Nick() .. "?", "", function(text)
					RunConsoleCommand("nero", "kick", ply:UniqueID(), text)
					table.insert(PLUGIN.KickReasons, text)
					NERO:Set("kick_reasons", PLUGIN.KickReasons)
				end)
			end)
		end,
		
		Ban = function(menu)
			
		end
	}
}

NERO:RegisterPlugin(PLUGIN)