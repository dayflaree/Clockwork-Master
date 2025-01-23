local PLUGIN = {}

PLUGIN.Name = "Visit Time"
PLUGIN.Description = "Saves how long a player has been on the server and when they were last on."

PLUGIN.Commands = {
	visittime = function(ply, args)
		
	end
}

PLUGIN.Hooks = {
	PlayerInitialSpawn = function(ply)
		local time = ply:GetPData("context_lastseen_time", false)
		local nick = ply:GetPData("context_lastseen_nick", false)
		local joins = ply:GetPData("context_joins", false)
		
		local str = ""
		
		if time and nick and joins then
			str = " was last seen " .. ago(time) .. " as '" .. nick .. "', and has joined " .. joins .. " times!"
		else
			str = " has joined for the first time!"
		end
		
		timer.Simple(1, function() CONTEXT.Notify(nil, ply, str) end)
	end,
	
	PlayerDisconnected = function(ply)
		ply:SetPData("context_lastseen_time", os.time())
		ply:SetPData("context_lastseen_nick", ply:Nick())
		ply:SetPData("context_joins", (ply:GetPData("context_joins") or 0) + 1)
	end
}

CONTEXT:RegisterPlugin(PLUGIN)

function plural(num)
	if num != 1 then
		return "s"
	end
	return ""
end

function ago(timestamp)
	if not timestamp then return end
	
	diff = os.time() - timestamp
	if diff < 60 then return diff .. " second" .. plural(diff) .. " ago" end
	diff = math.Round(diff / 60)
	if diff < 60 then return diff .. " minute" .. plural(diff) .. " ago" end
	diff = math.Round(diff / 60)
	if diff < 24 then return diff .. " hour" .. plural(diff) .. " ago" end
	diff = math.Round(diff / 24)
	if diff < 7 then return diff .. " day" .. plural(diff) .. " ago" end
	diff = math.Round(diff / 7)
	if diff < 4 then return diff .. " week" .. plural(diff) .. " ago" end
	
	return os.date("%d %B %Y", timestamp)
end