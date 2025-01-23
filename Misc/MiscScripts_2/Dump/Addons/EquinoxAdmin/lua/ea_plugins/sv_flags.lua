local PLUGIN = {}

PLUGIN.Name = "Flags"
PLUGIN.Purpose = "Flags allow/disallow access to a plugin/command."
//PLUGIN.Flag = "O"
PLUGIN.Command = "flag"
PLUGIN.Help = "ea flag add/del/addp/delp [<groupname>/<username/part>] [<flag>]"

function PLUGIN.HandleCommand(ply, args)
	if args[1] == "add" then
		flag = args[2]
		if not flag then /* error */ return end
		if PLUGIN.AddFlag(flag) then
			EA.Notify(ply, "Flag '"..flag.."' added!")
		end
	elseif args[1] == "del" then
		flag = args[2]
		if not flag then /* error */ return end
		if PLUGIN.RemoveFlag(flag) then
			EA.Notify(ply, "Flag '"..flag.."' removed!")
		end
	elseif args[1] == "addp" then
		found = EA:FindPlayer(ply, args[2])
		flag = args[3]
		if not found then MsgN("no player") return end
		if not flag or not PLUGIN.ValidFlag(flag) then /* error */ return end
		
		if found:AddFlag(flag) then
			EA.Notify(ply, "Gave "..found:Nick().." '"..flag.."' flag!")
		end
	elseif args[1] == "delp" then
		found = EA:FindPlayer(ply, args[2])
		flag = args[3]
		if not found then return end
		if not flag or not PLUGIN.ValidFlag(flag) then /* error */ return end
		
		if found:RemoveFlag(flag) then
			EA.Notify(ply, "Took '"..flag.."' flag from "..found:Nick().."!")
		end
	end
end

function PLUGIN.AddFlag(flag)
	if not flag then /* error */ return end
	
	local flags = EA:GetConfig("Flags") or {}
	table.insert(flags, flag)
	EA:SetConfig("Flags", flags)
	return true
end

function PLUGIN.RemoveFlag(flag)
	if not flag then /* error */ return end
	
	local flags = EA:GetConfig("Flags")
	if table.HasValue(flags, flag) then
		for k, v in pairs(flags) do
			if v == flag then
				table.remove(flags, flag)
			end
		end
		EA:SetConfig("Flags", flags)
	
		for k, ply in pairs(players.GetAll()) do
			if ply:HasFlag(flag) then
				ply:RemoveFlag(flag)
			end
		end
		local needsflag = {}
		for _, P in pairs(EA.Plugins) do
			if P.Flag == flag then
				table.insert(needsflag, P.Name)
			end
		end
		EA.Notify(ply, "The following plugins need their Flag setting: "..table.concat(needsflag, ", "))
		return true
	end
end

function PLUGIN.ValidFlag(flag)
	if not flag then /* error */ return end
	
	local flags = EA:GetConfig("Flags")
	if table.HasValue(flags, flag) then
		return true
	end
	return false
end

EA:RegisterPlugin(PLUGIN)

local Player = FindMetaTable("Player")

function Player:HasFlag(flag)
	if not flag then /* error */ return end
	
	local flags = self:GetProperty("Flags")
	if flags then
		if table.HasValue(flags, flag) then
			return true
		end
	end
	return false
end

function Player:AddFlag(flag)
	if not flag then /* error */ return end
	
	local flags = self:GetProperty("Flags") or {}
	if not table.HasValue(flags, flag) then
		table.insert(flags, flag)
		self:SetProperty("Flags", flags)
		self:SaveProperties()
	end
end

function Player:RemoveFlag(flag)
	if not flag then /* error */ return end
	
	local flags = self:GetProperty("Flags") or {}
	if table.HasValue(flags, flag) then
		table.remove(flags, flag)
		self:SetProperty("Flags", flags)
		self:SaveProperties()
	end
end