--[[
	Context Admin Mod
	_Undefined
	050110
	Shared functions and tables.
]]--

CONTEXT = {}
CONTEXT.__index = CONTEXT

CONTEXT.Overrides = {}
CONTEXT.Plugins = {}
CONTEXT.Data = {}

NOTIFY_ALL = 1
NOTIFY_ADMINS = 2

function CONTEXT:Log(name, info)
	if not hook.Call("Log", nil, name, info) then
		-- Default Logging
	end
end

function CONTEXT.Notify(players, ...)
	if SERVER then
		if players == nil then
			for k, ply in pairs(player.GetAll()) do
				ply:ChatPrint(Color(255, 88, 88), "[CONTEXT] ", Color(255, 255, 255), ...)
			end
		elseif type(players) == "table" then
			for k, ply in pairs(players) do
				ply:ChatPrint(Color(255, 88, 88), "[CONTEXT] ", Color(255, 255, 255), ...)
			end
		elseif type(players) == "Player" then
			players:ChatPrint(Color(255, 88, 88), "[CONTEXT] ", Color(255, 255, 255), ...)
		end
	else
		chat.AddText(Color(255, 88, 88), "[CONTEXT] ", Color(255, 255, 255), ...)
	end
end

function CONTEXT:RegisterPlugin(PLUGIN)
	self.Plugins[PLUGIN.Name] = PLUGIN
	
	CONTEXT.Notify(nil, "loading plugin '" .. PLUGIN.Name .. "'...")
	
	if PLUGIN.Extend then
		for t, tab in pairs(PLUGIN.Extend) do
			local meta = FindMetaTable(t)
			
			if SERVER then
				if tab.Server then
					for name, func in pairs(tab.Server) do
						meta[name] = func
						CONTEXT.Notify(nil, "...extending " .. t .. " with " .. name)
					end
				end
			end
			
			if CLIENT then
				if tab.Client then
					for name, func in pairs(tab.Client) do
						meta[name] = func
						CONTEXT.Notify(nil, "...extending " .. t .. " with " .. name)
					end
				end
			end
			
			if tab.Shared then
				for name, func in pairs(tab.Shared) do
					meta[name] = func
					CONTEXT.Notify(nil, "...extending " .. t .. " with " .. name)
				end
			end
		end
	end
	
	if PLUGIN.Hooks then
		for name, func in pairs(PLUGIN.Hooks) do
			hook.Add(name, "CONTEXT_" .. PLUGIN.Name .. "_" .. name, func)
			CONTEXT.Notify(nil, "...hooking '" .. name .. "'")
		end
	end
	
	CONTEXT.Notify(nil, "...done")
end

function CONTEXT:GetConfigItem(key, default)
	if not default then default = false end
	
	if CONTEXT.Data and not CONTEXT.Data.Loaded then
		CONTEXT.Data = glon.decode(file.Read("context/config.txt")) or {}
		CONTEXT.Data["Loaded"] = true
	end
	
	if CONTEXT.Data then
		return CONTEXT.Data[key] or default
	end
	
	return default
end

function CONTEXT:SetConfigItem(key, value, sendtoclients)
	if not CONTEXT.Data then
		CONTEXT.Data = {}
	end
	
	CONTEXT.Data[key] = value
	
	if SERVER and sendtoclients then
		datastream.StreamToClients(player.GetAll(), "ContextConfig", {key = key, value = value})
	end
end

function CONTEXT:SaveConfig()
	file.Write("context/config.txt", glon.encode(CONTEXT.Data))
end

timer.Create("Config_Timer", 60, 0, CONTEXT.SaveConfig)

if CLIENT then
	datastream.Hook("ContextConfig", function(handler, id, encoded, decoded)
		CONTEXT.Data[decoded.key] = decoded.value
	end)
end