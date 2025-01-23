EA.Config = {}

function EA:SetConfig(key, value)
	self.Config[key] = value
end

function EA:GetConfig(key)
	if not self.Config["loaded"] then
		self:ReloadConfig()
	end
	return self.Config[key] or nil
end

function EA:ReloadConfig()
	self.Config = glon.decode(file.Read("ea/config.txt")) or {}
	self.Config["loaded"] = true
end

function EA:SaveConfig()
	file.Write("ea/config.txt", glon.encode(self.Config))
end

timer.Create("EA_Config_Timer", 60, 0, function() EA:SaveConfig() end)

function string.plural(num)
	if num != 1 then
		return "s"
	end
	return ""
end

function os.ago(timestamp)
	if not timestamp then return end
	
	diff = os.time() - timestamp
	if diff < 60 then return diff .. " second" .. string.plural(diff) .. " ago" end
	diff = math.Round(diff / 60)
	if diff < 60 then return diff .. " minute" .. string.plural(diff) .. " ago" end
	diff = math.Round(diff / 60)
	if diff < 24 then return diff .. " hour" .. string.plural(diff) .. " ago" end
	diff = math.Round(diff / 24)
	if diff < 7 then return diff .. " day" .. string.plural(diff) .. " ago" end
	diff = math.Round(diff / 7)
	if diff < 4 then return diff .. " week" .. string.plural(diff) .. " ago" end
	
	return os.date("%d %B %Y", timestamp)
end