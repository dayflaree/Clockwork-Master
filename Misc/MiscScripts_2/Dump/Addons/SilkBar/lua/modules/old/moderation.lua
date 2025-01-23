local MODULE = {}

MODULE.Name = "Moderation Tools" // Name of module.
MODULE.Author = "_Undefined" // Who made it.
MODULE.Created = "29th April 2009" // Date created.
MODULE.Stub = "mod" // Name that the system can refer to this module by. Single word, alpha-numeric only, no symbols.
MODULE.Icon = "wand" // Silk icon this module is represented by.
MODULE.Flags = { "kick", "ban", "permaban" } // Flags to set access for players.

MODULE.Callbacks = { "kick", "ban" }

if (SERVER) then // Only run on the server

	function MODULE.KickPlayer(to, by, reason) // Function ran when a player kicks another.
	
		if (SB_HasAccess(by, "kick")) then // Check access.
		
			SB_Action("Player "..to:Nick().." has been kicked by "..by:Nick().."!", os.time())
			RunConsoleCommand("kickid", to:UserID(), reason)
		
		end
	
	end
	concommand.Add("SB_Kick", MODULE.KickPlayer)
	
	function MODULE.BanPlayer(to, by, duration, reason) // Function ran when a player bans another.
	
		if (SB_HasAccess(by, "ban")) then // Check access.
		
			if duration < 1 or duration > 604800 then
			
				if (SB_HasAccess(by, "permaban")) then // Check access.
				
					SB_Action("Player "..to:Nick().." has been permabanned by "..by:Nick().."!", os.time())
					RunConsoleCommand("kickid", to:UserID(), "Permabanned! (" .. reason .. ")")
				
				end
			
			else
			
				SB_Action("Player "..to:Nick().." has been kicked by "..by:Nick().."!", os.time())
				RunConsoleCommand("kickid", params[1]:UserID(), "Banned for " .. time .. " minutes! (" .. reason .. ")")
			
			end
		end
	end
	concommand.Add("SB_Ban", MODULE.BanPlayer)

end

if (CLIENT) then // Only run on the Client

	function MODULE.Kick(PLAYER)
		
		if (!PLAYER:IsValid()) then return end

		RunConsoleCommand("SB_Kick", PLAYER:UniqueID(), "Kicked")

	end

	MODULE.MENU = {}
	MODULE.MENU.Kick = { "USER", "Kick", MODULE.Kick }
	MODULE.MENU.Ban = { "USER", "Ban", MODULE.Ban }

end

//AddSilkModule(MODULE) // Register this module with SilkBar.