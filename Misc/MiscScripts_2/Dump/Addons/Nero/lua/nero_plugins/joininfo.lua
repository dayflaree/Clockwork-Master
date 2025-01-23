local PLUGIN = {}
PLUGIN.Name = "Join Info"
PLUGIN.Description = "Displays information when a player joins."
PLUGIN.Author = "_Undefined"

PLUGIN.Hooks = {
	PlayerInitialSpawn = function(ply)
		local nick = ply:GetPData("nero_lastnick", false)
		local time = ply:GetPData("nero_lasttime", false)
		local joins = ply:GetPData("nero_joins", false)
		
		if nick and time and joins then
			NERO:Notify(NOTIFY_ALL, ply, " has joined ", joins, " time" .. plural(joins) .. " before, and was last seen ", ago(time), " ago as '", nick, "'")
		else
			NERO:Notify(NOTIFY_ALL, ply, " has joined for the first time!")
		end
	end,
	
	PlayerDisconnected = function(ply)
		ply:SetPData("nero_lastnick", ply:Nick())
		ply:SetPData("nero_lasttime", os.time())
		ply:SetPData("nero_joins", ply:GetPData("nero_joins", 0) + 1)
	end
}

function plural(num)
	return tonumber(num) == 1 and "" or "s"
end

function ago(time)
	return time -- do this
end

NERO:RegisterPlugin(PLUGIN)