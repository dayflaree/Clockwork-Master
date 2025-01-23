NERO = {}
NERO.__index = NERO

NERO.Plugins = {}

function NERO:RegisterPlugin(PLUGIN)
	if self.Plugins[PLUGIN.Name] then MsgN("[NERO] Plugin '" .. PLUGIN.Name .. "' already loaded, skipping...") return end
	
	--MsgN("[NERO] Loading plugin '" .. PLUGIN.Name .. "'...")
	self.Plugins[PLUGIN.Name] = PLUGIN
	
	if PLUGIN.Hooks then
		for name, func in pairs(PLUGIN.Hooks) do
			-- MsgN("-> Hooking " .. name)
			hook.Add(name, PLUGIN.Name .. "_" .. name, function(...)
				PLUGIN = PLUGIN
				func(...)
			end)
		end
	end
	
	if PLUGIN.Extend then
		for name, tbl in pairs(PLUGIN.Extend) do
			local mt = FindMetaTable(name)
			if mt then
				for func_name, func in pairs(tbl) do
					--MsgN("-> Extending " .. name .. " with " .. tostring(func_name))
					mt[func_name] = func
				end
			elseif name == "NERO" then
				for func_name, func in pairs(tbl) do
					--MsgN("-> Extending NERO with " .. tostring(func_name))
					NERO[func_name] = func
				end
			end
		end
	end
end

function NERO:FindPlayers(anything)
	local PT = {}
	PT.__index = PT
	
	PT.Players = {}
	
	function PT:Add(ply)
		self.Players[ply] = ply
	end
	
	function PT:Call(func_name, ...)
		if _R.Player[func_name] then
			for _, ply in pairs(self.Players) do
				if IsValid(ply) and ply:IsPlayer() then
					ply[func_name](ply, unpack({...}))
				end
			end
		end
		return self
	end
	
	function PT:First(func_name, ...)
		if _R.Player[func_name] then
			local ply = table.GetFirstValue(self.Players)
			return ply[func_name](ply, unpack({...}))
		end
	end
	
	function PT:__tostring()
		if #self.Players == 0 then
			return ""
		elseif #self.Players == 1 then
			return self.Players[1]:Nick()
		else
			local last = self.Players[#self.Players]
			local ret = ""
			return table.concat(self.Players, ", ", #self.Players - 1) .. " and " .. last
		end
	end
	
	if type(anything) == "Player" then
		PT:Add(anything)
	elseif type(anything) == "table" then
		for _, ply in pairs(anything) do
			PT:Add(ply)
		end
	elseif type(anything) == "string" then
		if anything == "*" then
			for _, ply in pairs(player.GetAll()) do
				PT:Add(ply)
			end
		else
			local parts = string.Explode(" ", anything)
			for _, part in pairs(parts) do
				for _, ply in pairs(player.GetAll()) do
					if string.find(string.lower(ply:Nick()), string.lower(part), 1, false) then
						PT:Add(ply)
					end
				end
			end
		end
	end
	
	return PT
end

function NERO:FindPlayersWithPermission(perm)
	local tbl = {}
	
	for _, ply in pairs(player.GetAll()) do
		if ply:HasPermission(perm) then
			table.insert(tbl, ply)
		end
	end
	
	return tbl
end

NOTIFY_OWNER = 1
NOTIFY_ADMIN = 2
NOTIFY_ALL = 3

function NERO:Notify(to, ...)
	local RF = RecipientFilter()
	
	if type(to) == "number" then
		if to == NOTIFY_OWNER then
			for _, ply in pairs(player.GetAll()) do
				if ply:HasRank("Owner") then
					RF:AddPlayer(ply)
				end
			end
		elseif to == NOTIFY_ADMIN then
			for _, ply in pairs(player.GetAll()) do
				if ply:HasRank("Admin") then
					RF:AddPlayer(ply)
				end
			end
		elseif to == NOTIFY_ALL then
			RF:AddAllPlayers()
		end
	else
		for _, ply in pairs(NERO:FindPlayers(to).Players) do
			RF:AddPlayer(ply)
		end
	end
	
	datastream.StreamToClients(RF, "Nero_Notify", {...})
end