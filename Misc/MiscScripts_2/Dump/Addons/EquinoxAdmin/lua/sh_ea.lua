function EA.Notify(ply, text)
	if SERVER then
		local players = {}
		if type(ply) == "Player" then
			table.insert(players, ply)
		elseif type(ply) == "table" then
			for k, v in pairs(ply) do
				table.insert(players, v)
			end
		elseif ply == true then
			for k, v in pairs(player.GetAll()) do
				table.insert(players, v)
			end
		else
			Msg("[EA] "..tostring(text).."\n")
		end
		
		if #players < 1 then return end
		
		local RF = RecipientFilter()
		for k, v in pairs(players) do
			RF:AddPlayer(v)
		end
		
		umsg.Start("EA_Notify", RF)
			umsg.String(tostring(text))
		umsg.End()
	else
		chat.AddText(Color(255, 120, 0, 255), "[EA] ", Color(255, 255, 255, 255), tostring(ply))
	end
end

function EA:FindPlayer(ply, info)
	// We pass ply so this function can return messages to the player, rather than having to check what it returns and run something based on that.
	for k, p in pairs(player.GetAll()) do
		if p:SteamID() == info then
			return p
		elseif p:UniqueID() == info then
			return p
		elseif p:UserID() == info then
			return p
		elseif string.find(string.lower(p:Nick()), string.lower(info)) then
			return p
		end
		MsgN("Found player: "..p:Nick())
	end
	self:Notify(ply, "The player you specified was not found.")
	return false
end

EA.Plugins = {}

function EA:RegisterPlugin(PLUGIN)
	if SERVER then
		flag = EA:GetConfig(PLUGIN.Name .. "_Flag")
		if flag then
			PLUGIN.Flag = flag
		end
	end
	table.insert(self.Plugins, PLUGIN)
end

function EA:RegisterHook(h, name, func)
	hook.Add(h, name, func)
end