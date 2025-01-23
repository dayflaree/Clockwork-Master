local PLUGIN = {}

PLUGIN.Name = "Last Visit Time"
PLUGIN.Purpose = "Prints when a player last visited and with what name."
PLUGIN.Command = "visit"
PLUGIN.Help = "ea visit <username/part>"

function PLUGIN.HandleCommand(ply, args)
	local found = EA:FindPlayer(ply, args[1])
	if not found then return end
	
	PLUGIN.PrintVisitTime(found, ply)
end

function PLUGIN.PrintVisitTime(found, ply)
	if not ply then
		ply = player.GetAll()
	end
	
	local visittime = found:GetProperty("VisitTime")
	local visitname = found:GetProperty("VisitName")
	
	if not visitname then
		PLUGIN.SaveVisitTime(found)
	end
	
	EA.Notify(ply, found:Nick() .. " was last seen " .. os.ago(visittime) .. " as '" .. visitname .. "'!")
end
EA:RegisterHook("PlayerInitialSpawn", "VisitTime", PLUGIN.PrintVisitTime)

function PLUGIN.SaveVisitTime(ply)
	ply:SetProperty("VisitTime", os.time())
	ply:SetProperty("VisitName", ply:Nick())
	ply:SaveProperties()
end
EA:RegisterHook("PlayerDisconnected", "SaveVisitTime", PLUGIN.SaveVisitTime)

EA:RegisterPlugin(PLUGIN)