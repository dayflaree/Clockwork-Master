local PLUGIN = {}

PLUGIN.Name = "Kick & Ban"

PLUGIN.Menu = {
	Player = {
		function(menu, ply)
			local kmenu = menu:AddSubMenu("Kick")
			
			local reasons = CONTEXT:GetConfigItem("kick_reasons", {"Kicked!"})
			for _, reason in pairs(reasons) do
				kmenu:AddOption(reason, function() RunCommand("kick", ply:EntIndex(), reason) end)
			end
			
			kmenu:AddSpacer()
			kmenu:AddOption("Custom...", function() Derma_StringRequest("Kick reason", "Why are you kicking this player?", "", function(text)
				table.insert(reasons, text)
				CONTEXT:SetConfigItem("kick_reasons", reasons)
				RunCommand("kick", ply:EntIndex(), text)
			end) end)
		end,
		
		function(menu, ply)
			local bmenu = menu:AddSubMenu("Ban")
			
			local reasons = CONTEXT:GetConfigItem("ban_reasons", {"Banned!"})
			for _, reason in pairs(reasons) do
				rmenu = bmenu:AddSubMenu(reason)
				rmenu:AddOption("Permanent", function() RunCommand("ban", ply:EntIndex(), "0", reason) end)
				rmenu:AddOption("1 Minute", function() RunCommand("ban", ply:EntIndex(), "1", reason) end)
				rmenu:AddOption("1 Hour", function() RunCommand("ban", ply:EntIndex(), "60", reason) end)
				rmenu:AddOption("1 Day", function() RunCommand("ban", ply:EntIndex(), "1440", reason) end)
				rmenu:AddOption("1 Week", function() RunCommand("ban", ply:EntIndex(), "10080", reason) end)
				rmenu:AddOption("1 Month", function() RunCommand("ban", ply:EntIndex(), "43830", reason) end)
			end
		end,
		
		function(menu, ply)
			menu:AddSpacer()
		end
	}
}

PLUGIN.Commands = {
	kick = function(ply, args)
		local to_kick = Entity(args[1])
		local reason = table.concat(args, " ", 2)
		
		if to_kick and to_kick:IsValid() and to_kick:IsPlayer() then
			CONTEXT.Notify(nil, ply, " kicked ", to_kick, " (" .. reason .. ")")
		end
	end,
	
	ban = function(ply, args)
		local to_ban = Entity(args[1])
		local length = args[2]
		local reason = table.concat(args, " ", 3)
		
		local lengths = {
			[0] = "Forever",
			[1] = "1 Minute",
			[60] = "1 Hour",
			[1140] = "1 Day",
			[10080] = "1 Week",
			[43830] = "1 Month"
		}
		
		if to_ban and to_ban:IsValid() and to_ban:IsPlayer() then
			CONTEXT.Notify(nil, ply, " banned ", to_ban, " for " .. lengths[length] .. " (" .. reason .. ")")
		end
	end
}

CONTEXT:RegisterPlugin(PLUGIN)