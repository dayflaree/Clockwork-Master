--[[
	The plugin library is inspired by Cloud Sixteen's "SF" gamemode

	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.plugin = {};
SF.plugin.hooks = {};
SF.plugin.stored = {};
SF.plugin.buffer = {};
SF.plugin.modules = {};

if (SERVER) then
	function SF.plugin:SetUnloaded(name, isUnloaded)
		local plugin = self:Get(name);
		
		if (plugin and plugin != SF.theme) then
			if (isUnloaded) then
				self.unloaded[plugin.folderName] = true;
			else
				self.unloaded[plugin.folderName] = nil;
			end;
			
			SF:SavethemeData("plugins", self.unloaded);
			
			return true;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is disabled.
	function SF.plugin:IsDisabled(name, bFolder)
		if (!bFolder) then
			local plugin = self:Get(name);
			
			if (plugin and plugin != SF.theme) then
				for k, v in pairs(self.unloaded) do
					local unloaded = self:Get(k);
					
					if (unloaded and unloaded != SF.theme
					and plugin.folderName != unloaded.folderName) then
						if ( table.HasValue(unloaded.plugins, plugin.folderName) ) then
							return true;
						end;
					end;
				end;
			end;
		elseif (name != "theme") then
			for k, v in pairs(self.unloaded) do
				local unloaded = self:Get(k);
				
				if (unloaded and unloaded != SF.theme and name != unloaded.folderName) then
					if ( table.HasValue(unloaded.plugins, name) ) then
						return true;
					end;
				end;
			end;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is unloaded.
	function SF.plugin:IsUnloaded(name, bFolder)
		if (!bFolder) then
			local plugin = self:Get(name);
			
			if (plugin and plugin != SF.theme) then
				return (self.unloaded[plugin.folderName] == true);
			end;
		elseif (name != "theme") then
			return (self.unloaded[name] == true);
		end;
		
		return false;
	end;
else
	SF.plugin.override = {};
	
	-- A function to set whether a plugin is unloaded.
	function SF.plugin:SetUnloaded(name, isUnloaded)
		local plugin = self:Get(name);
		
		if (plugin) then
			self.override[plugin.folderName] = isUnloaded;
		end;
	end;
	
	-- A function to get whether a plugin is disabled.
	function SF.plugin:IsDisabled(name, bFolder)
		if (!bFolder) then
			local plugin = self:Get(name);
			
			if (plugin and plugin != SF.theme) then
				for k, v in pairs(self.unloaded) do
					local unloaded = self:Get(k);
					
					if (unloaded and unloaded != SF.theme and plugin.folderName != unloaded.folderName) then
						if ( table.HasValue(unloaded.plugins, plugin.folderName) ) then
							return true;
						end;
					end;
				end;
			end;
		elseif (name != "theme") then
			for k, v in pairs(self.unloaded) do
				local unloaded = self:Get(k);
				
				if (unloaded and unloaded != SF.theme
				and name != unloaded.folderName) then
					if ( table.HasValue(unloaded.plugins, name) ) then
						return true;
					end;
				end;
			end;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is unloaded.
	function SF.plugin:IsUnloaded(name, bFolder)
		if (!bFolder) then
			local plugin = self:Get(name);
			
			if (plugin and plugin != SF.theme) then
				if (self.override[plugin.folderName] != nil) then
					return self.override[plugin.folderName];
				end;
				
				return (self.unloaded[plugin.folderName] == true);
			end;
		elseif (name != "theme") then
			if (self.override[name] != nil) then
				return self.override[name];
			end;
			
			return (self.unloaded[name] == true);
		end;
		
		return false;
	end;
end;

-- A function to call the cached hook.
function SF.plugin:CallCachedHook(name, callGamemodeHook, ...)
	local cachedHooks = self:CacheHook(name);
	
	for k, v in ipairs(cachedHooks) do
		local value = v.Callback(v.plugin, ...);
		
		if (value != nil) then
			return value;
		end;
	end;
	
	if (SF.theme) then
		if (SF.theme[name] and type( SF.theme[name] ) == "function") then
			local value = SF.theme[name](SF.theme, ...);
			
			if (value != nil) then
				return value;
			end;
		end;
	end;
	
	if (callGamemodeHook) then
		if (SF[name] and type( SF[name] ) == "function") then
			local value = SF[name](SF, ...);
			
			if (value != nil) then
				return value;
			end;
		end;
	end;
end;

-- A function to get whether a hook is cached.
function SF.plugin:IsHookCached(name)
	return self.hooks[name] != nil;
end;

-- A function to cache a hook.
function SF.plugin:CacheHook(name)
	if ( !self:IsHookCached(name) ) then
		if ( !self.hooks[name] ) then
			self.hooks[name] = {};
		end;
		
		for k, v in pairs(self.modules) do
			if (v[name] and type( v[name] ) == "function") then
				local hooks = self.hooks[name];
				
				hooks[#hooks + 1] = {
					Callback = v[name],
					plugin = v
				};
			end;
		end;
		
		for k, v in pairs(self.stored) do
			if (SF.theme != v) then
				if (v[name] and type( v[name] ) == "function") then
					local hooks = self.hooks[name];
					
					hooks[#hooks + 1] = {
						Callback = v[name],
						plugin = v
					};
				end;
			end;
		end;
	end;
	
	return self.hooks[name];
end;

-- A function to register a new plugin.
function SF.plugin:Register(plugin)
	self.stored[plugin.name] = plugin;
	self.stored[plugin.name].plugins = {};
	self.buffer[plugin.folderName] = plugin;
	
	for k, v in pairs( file.Find(plugin.directory.."/plugins/*", LUA_PATH) ) do
		if (v != ".." and v != ".") then
			table.insert( self.stored[plugin.name].plugins, string.lower(v) );
		end;
	end;

	self:IncludePlugins(plugin.directory);
	self:IncludeExtras(plugin.directory);
end;

-- A function to include a plugin's entities.
function SF.plugin:IncludeEntities(directory)
	for k, v in pairs( file.FindDir(directory.."/entities/entities/*", LUA_PATH) ) do
		if (v != ".." and v != ".") then
			ENT = {Type = "anim"};
			
			if (SERVER) then
				include(directory.."/entities/entities/"..v.."/sv_auto.lua");
			elseif ( file.Exists("lua_temp/"..directory.."/entities/entities/"..v.."/cl_auto.lua", "GAME")
			or file.Exists("gamemodes/"..directory.."/entities/entities/"..v.."/cl_auto.lua", "GAME") ) then
				include(directory.."/entities/entities/"..v.."/cl_auto.lua");
			end;
			
			scripted_ents.Register(ENT, v); ENT = nil;
		end;
	end;
end;

-- A function to include a plugin's effects.
function SF.plugin:IncludeEffects(directory)
	for k, v in pairs( file.FindDir(directory.."/entities/effects/*", LUA_PATH) ) do
		if (v != ".." and v != ".") then
			if (SERVER) then
				if ( file.Exists("gamemodes/"..directory.."/entities/effects/"..v.."/cl_auto.lua", "GAME") ) then
					AddCSLuaFile(directory.."/entities/effects/"..v.."/cl_auto.lua");
				end;
			elseif ( file.Exists("lua_temp/"..directory.."/entities/effects/"..v.."/cl_auto.lua", "GAME")
			or file.Exists("gamemodes/"..directory.."/entities/effects/"..v.."/cl_auto.lua", "GAME") ) then
				EFFECT = {};
				
				include(directory.."/entities/effects/"..v.."/cl_auto.lua");
				
				effects.Register(EFFECT, v); EFFECT = nil;
			end;
		end;
	end;
end;

-- A function to include a plugin's weapons.
function SF.plugin:IncludeWeapons(directory)
	for k, v in pairs( file.FindDir(directory.."/entities/weapons/*", LUA_PATH)) do
		if (v != ".." and v != ".") then
			SWEP = { Base = "weapon_base", Primary = {}, Secondary = {} };
			
			if (SERVER) then
				if ( file.Exists("gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua", "GAME") ) then
					include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
					AddCSLuaFile(directory.."/entities/weapons/"..v.."/sh_auto.lua");
				end;
			elseif ( file.Exists("lua_temp/"..directory.."/entities/weapons/"..v.."/sh_auto.lua", "GAME")
			or file.Exists("gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua", "GAME") ) then
				include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
			end;
			
			weapons.Register(SWEP, v); SWEP = nil;
		end;
	end;
end;

-- A function to include a plugin's libraries.
function SF.plugin:IncludeLibraries(directory)
	for k, v in pairs( file.Find(directory.."/libraries/*.lua", LUA_PATH) ) do
		SF:IncludePrefixed(directory.."/libraries/"..v);
	end;
end;
-- A function to include a plugin's derma.
function SF.plugin:IncludeDerma(directory)
	for k, v in pairs( file.Find(directory.."/derma/*", LUA_PATH) ) do
		if (v != ".." and v != ".") then
			if (SERVER) then
				if ( file.Exists("gamemodes/"..directory.."/derma/"..v, "GAME") ) then
					AddCSLuaFile(directory.."/derma/"..v);
				end;
			elseif ( file.Exists("lua_temp/"..directory.."/derma/"..v, "GAME")
			or file.Exists("gamemodes/"..directory.."/derma/"..v, "GAME") ) then
				include(directory.."/derma/"..v);
			end;
		end;
	end;
end;

-- A function to include a plugin's aurawatch.
function SF.plugin:IncludeAutorun(directory)
	for k, v in pairs( file.Find(directory.."/autorun/*.lua", LUA_PATH) ) do
		SF:IncludePrefixed(directory.."/autorun/"..v);
	end;
end;

-- A function to include a plugin's plugins.
function SF.plugin:IncludePlugins(directory)
	if ( string.find(directory, "/theme") ) then
		directory = string.gsub(directory, "/theme", "");
	end;
	
	for k, v in pairs( file.Find(directory.."/plugins/*", LUA_PATH) ) do
		if (v != ".." and v != ".") then
			if (CLIENT) then
				if ( file.IsDir("lua_temp/"..directory.."/plugins/"..v, "GAME") ) then
					self:Include(directory.."/plugins/"..v);
				end;
			elseif ( file.IsDir("gamemodes/"..directory.."/plugins/"..v, "GAME") ) then
				self:Include(directory.."/plugins/"..v);
			end;
		end;
	end;
end;


-- A function to include a plugin's extras.
function SF.plugin:IncludeExtras(directory)
	self:IncludeEffects(directory);
	self:IncludeWeapons(directory);
	self:IncludeEntities(directory);
	self:IncludeLibraries(directory);
	self:IncludeDerma(directory);
	self:IncludeAutorun(directory);
end;

-- A function to include a plugin.
function SF.plugin:Include(directory, theme)
	local explodeDir = string.Explode("/", directory);
	local folderName = explodeDir[#explodeDir];
	
	PLUGIN_FOLDERNAME = string.lower(folderName);
	PLUGIN_DIRECTORY = string.lower(directory);
	PLUGIN = nil;
	
	if (SERVER) then
		if (!theme) then
			PLUGIN = self:New();
		else
			SF.theme = self:New();
		end;
		
		if ( file.Exists("gamemodes/"..directory.."/sh_info.lua", "GAME") ) then
			include(directory.."/sh_info.lua");
			AddCSLuaFile(directory.."/sh_info.lua");
		else
			ErrorNoHalt("SF -> the "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;
		
		local isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
		local isDisabled = self:IsDisabled(PLUGIN_FOLDERNAME, true);
		
		if (theme) then
			isUnloaded = false;
			isDisabled = false;
		end;
		
		if (!isUnloaded and !isDisabled) then
			if ( file.Exists("gamemodes/"..directory.."/sv_auto.lua", "GAME") ) then
				include(directory.."/sv_auto.lua");
			end;
		end;
		
		if ( file.Exists("gamemodes/"..directory.."/cl_auto.lua", "GAME") ) then
			AddCSLuaFile(directory.."/cl_auto.lua");
		end;
	else
		if (!theme) then
			PLUGIN = self:New();
		else
			SF.theme = self:New();
		end;
		
		if ( file.Exists("lua_temp/"..directory.."/sh_info.lua", "GAME") ) then
			include(directory.."/sh_info.lua");
		else
			ErrorNoHalt("SF -> the "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;
		
		local isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
		local isDisabled = self:IsDisabled(PLUGIN_FOLDERNAME, true);
		
		if (theme) then
			isUnloaded = false;
			isDisabled = false;
		end;
		
		if (!isUnloaded and !isDisabled) then
			if ( file.Exists("lua_temp/"..directory.."/cl_auto.lua", "GAME") ) then
				include(directory.."/cl_auto.lua");
			end;
		end;
	end;
	
	if (theme and SF.theme) then
		self:Register(SF.theme);
	elseif (PLUGIN) then
		self:Register(PLUGIN);
		
		PLUGIN = nil;
	end;
end;

-- A function to create a new plugin.
function SF.plugin:New()
	local pluginTable = {
		directory = PLUGIN_DIRECTORY,
		folderName = PLUGIN_FOLDERNAME
	};
	
	pluginTable.GetDescription = function(pluginTable)
		return pluginTable.description;
	end;
	
	pluginTable.GetAuthor = function(pluginTable)
		return pluginTable.author;
	end;
	
	pluginTable.GetName = function(pluginTable)
		return pluginTable.name;
	end;
	
	return pluginTable;
end;

-- A function to call a function for all plugins.
function SF.plugin:Call(name, ...)
	return self:CallCachedHook(name, true, ...);
end;

-- A function to get a plugin.
function SF.plugin:Get(name)
	return self.stored[name] or self.buffer[name];
end;

-- A function to add a table as a module.
function SF.plugin:Add(name, module)
	self.modules[name] = module;
end;