--[[
	Most of this file was by Conna Wiles of Cloud Sixteen coded for his RP Framework. Thanks Conna for letting me use it.
	-----------------------------------------------------------------------------------------------
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]


RP.Plugin = {};
RP.Plugin.hooks = {};
RP.Plugin.stored = {};
RP.Plugin.buffer = {};
RP.Plugin.modules = {};
RP.Plugin.directory = "basewars2.0/gamemode/plugins";

-- A function to call the cached hook.
function RP.Plugin:CallCachedHook(name, callGamemodeHook, ...)
	local cachedHooks = self:CacheHook(name);
	
	for k, v in ipairs(cachedHooks) do
		local value = v.Callback(v.plugin, ...);
		
		if (value != nil) then
			return value;
		end;
	end;

	if (callGamemodeHook) then
		if (RP[name] and type(RP[name]) == "function") then
			local value = RP[name](RP, ...);
			
			if (value != nil) then
				return value;
			end;
		end;
	end;
end;

-- A function to get whether a hook is cached.
function RP.Plugin:IsHookCached(name)
	return self.hooks[name] != nil;
end;

-- A function to cache a hook.
function RP.Plugin:CacheHook(name)
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
			if (RP.Schema != v) then
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
function RP.Plugin:Register(plugin)
	RP:Log("/---Including Plugin: "..plugin.name);
	self.stored[plugin.name] = plugin;
	self.stored[plugin.name].plugins = {};
	self.buffer[plugin.folderName] = plugin;
	
	for k, v in pairs( _file.FindInLua(plugin.directory.."/plugins/*") ) do
		if (v != ".." and v != ".") then
			table.insert( self.stored[plugin.name].plugins, string.lower(v) );
		end;
	end;

	if (type(self.stored[plugin.name].Init) == "function") then
		self.stored[plugin.name]:Init();
	end;
end;

-- A function to include a plugin's entities.
function RP.Plugin:IncludeEntities(directory)
	for k, v in pairs( _file.FindInLua(directory.."/entities/entities/*") ) do
		if (v != ".." and v != ".") then
			ENT = {Type = "anim"};
			
			if (SERVER) then
				AddCSLuaFile(directory.."/entities/entities/"..v.."/cl_auto.lua");
				AddCSLuaFile(directory.."/entities/entities/"..v.."/sh_auto.lua");
				include(directory.."/entities/entities/"..v.."/sh_auto.lua");
				include(directory.."/entities/entities/"..v.."/sv_auto.lua");
			else
				include(directory.."/entities/entities/"..v.."/sh_auto.lua");
				include(directory.."/entities/entities/"..v.."/cl_auto.lua");
			end;
			
			scripted_ents.Register(ENT, v); ENT = nil;
		end;
	end;
end;

-- A function to include a plugin's effects.
function RP.Plugin:IncludeEffects(directory)
	for k, v in pairs( _file.FindInLua(directory.."/entities/effects/*") ) do
		if (v != ".." and v != ".") then
			if (SERVER) then
				if ( _file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/cl_auto.lua") ) then
					AddCSLuaFile(directory.."/entities/effects/"..v.."/cl_auto.lua");
				end;
			elseif ( _file.Exists("../lua_temp/"..directory.."/entities/effects/"..v.."/cl_auto.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/cl_auto.lua") ) then
				EFFECT = {};
				
				include(directory.."/entities/effects/"..v.."/cl_auto.lua");
				
				effects.Register(EFFECT, v); EFFECT = nil;
			end;
		end;
	end;
end;

-- A function to include a plugin's weapons.
function RP.Plugin:IncludeWeapons(directory)
	for k, v in pairs( _file.FindInLua(directory.."/entities/weapons/*") ) do
		if (v != ".." and v != ".") then
			SWEP = { Base = "weapon_base", Primary = {}, Secondary = {} };
			-- if (SERVER) then
				-- if ( _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua") ) then
					-- AddCSLuaFile(directory.."/entities/weapons/"..v.."/sh_auto.lua");
					-- include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
				-- end;
			-- elseif ( _file.Exists("../lua_temp/"..directory.."/entities/weapons/"..v.."/sh_auto.lua")
			-- or _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua") ) then
				-- include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
			-- end;
			if (SERVER) then
				if (_file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua")) then
					AddCSLuaFile(directory.."/entities/weapons/"..v.."/sh_auto.lua");
					include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
				end;
				
				if (_file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/cl_auto.lua")) then
					AddCSLuaFile(directory.."/entities/weapons/"..v.."/cl_auto.lua");
				end;

				if (_file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/sv_auto.lua")) then
					include(directory.."/entities/weapons/"..v.."/sv_auto.lua");
				end;
				
			else
				if (_file.Exists("../lua_temp/"..directory.."/entities/weapons/"..v.."/cl_auto.lua") or _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/cl_auto.lua")) then
					include(directory.."/entities/weapons/"..v.."/cl_auto.lua");
				end;
				if (_file.Exists("../lua_temp/"..directory.."/entities/weapons/"..v.."/sh_auto.lua") or _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/sh_auto.lua")) then
					include(directory.."/entities/weapons/"..v.."/sh_auto.lua");
				end;
			end;
			weapons.Register(SWEP, v); SWEP = nil;
		end;
	end;
end;

-- A function to include a plugin's plugins.
function RP.Plugin:IncludeAutorun(directory)
	for k, v in pairs( _file.FindInLua(directory.."/autorun/*") ) do
		if (v != ".." and v != ".") then
			if (CLIENT) then
				if ( _file.IsDir("../lua_temp/"..directory.."/autorun/"..v) ) then
					include(directory.."/autorun/"..v);
				end;
			elseif ( _file.IsDir("../gamemodes/"..directory.."/autorun/"..v) ) then
				AddCSLuaFile(directory.."/autorun/"..v);
				include(directory.."/autorun/"..v);
			end;
		end;
	end;
end;

-- A function to include a plugin's extras.
function RP.Plugin:IncludeExtras(directory)
	self:IncludeAutorun(directory)
	self:IncludeEffects(directory);
	self:IncludeWeapons(directory);
	self:IncludeEntities(directory);
end;

-- A function to include a plugin.
function RP.Plugin:Include(directory, schema)
	local explodeDir = string.Explode("/", directory);
	local folderName = explodeDir[#explodeDir];
	
	PLUGIN_FOLDERNAME = string.lower(folderName);
	PLUGIN_DIRECTORY = string.lower(directory);
	PLUGIN = nil;
	
	if (SERVER) then
		if (!schema) then
			PLUGIN = self:New();
		else
			RP.Schema = self:New();
		end;
		
		if ( _file.Exists("../gamemodes/"..directory.."/sh_info.lua") ) then
			include(directory.."/sh_info.lua");
			AddCSLuaFile(directory.."/sh_info.lua");
		else
			ErrorNoHalt("RP -> the "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;
		
		if ( _file.Exists("../gamemodes/"..directory.."/sv_auto.lua") ) then
			include(directory.."/sv_auto.lua");
		end;
		
		if ( _file.Exists("../gamemodes/"..directory.."/cl_auto.lua") ) then
			AddCSLuaFile(directory.."/cl_auto.lua");
		end;
	else
		if (!schema) then
			PLUGIN = self:New();
		else
			RP.Schema = self:New();
		end;
		
		if ( _file.Exists("../lua_temp/"..directory.."/sh_info.lua") ) then
			include(directory.."/sh_info.lua");
		else
			ErrorNoHalt("RP -> the "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;

		if ( _file.Exists("../lua_temp/"..directory.."/cl_auto.lua") ) then
			include(directory.."/cl_auto.lua");
		end;
	end;
	
	self:IncludeExtras(directory);
	
	if (schema and RP.Schema) then
		self:Register(RP.Schema);
	elseif (PLUGIN) then
		self:Register(PLUGIN);
		
		PLUGIN = nil;
	end;
end;

-- A function to create a new plugin.
function RP.Plugin:New()
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
function RP.Plugin:Call(name, ...)
	return self:CallCachedHook(name, true, ...);
end;

-- A function to get a plugin.
function RP.Plugin:Get(name)
	return self.stored[name] or self.buffer[name];
end;

-- A function to add a table as a module.
function RP.Plugin:Add(name, module)
	self.modules[name] = module;
end;