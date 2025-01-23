--[[
	Free Clockwork!
--]]

Clockwork.plugin = Clockwork:NewLibrary("Plugin");
Clockwork.plugin.stored = {};
Clockwork.plugin.buffer = {};
Clockwork.plugin.modules = {};

if (SERVER) then
	function Clockwork.plugin:SetUnloaded(name, isUnloaded)
		local plugin = self:FindByID(name);
		
		if (plugin and plugin != Clockwork.schema) then
			if (isUnloaded) then
				self.unloaded[plugin.folderName] = true;
			else
				self.unloaded[plugin.folderName] = nil;
			end;
			
			Clockwork:SaveSchemaData("plugins", self.unloaded);
			return true;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is disabled.
	function Clockwork.plugin:IsDisabled(name, bFolder)
		if (!bFolder) then
			local plugin = self:FindByID(name);
			
			if (plugin and plugin != Clockwork.schema) then
				for k, v in pairs(self.unloaded) do
					local unloaded = self:FindByID(k);
					
					if (unloaded and unloaded != Clockwork.schema
					and plugin.folderName != unloaded.folderName) then
						if (table.HasValue(unloaded.plugins, plugin.folderName)) then
							return true;
						end;
					end;
				end;
			end;
		else
			for k, v in pairs(self.unloaded) do
				local unloaded = self:FindByID(k);
				
				if (unloaded and unloaded != Clockwork.schema and name != unloaded.folderName) then
					if (table.HasValue(unloaded.plugins, name)) then
						return true;
					end;
				end;
			end;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is unloaded.
	function Clockwork.plugin:IsUnloaded(name, bFolder)
		if (!bFolder) then
			local plugin = self:FindByID(name);
			
			if (plugin and plugin != Clockwork.schema) then
				return (self.unloaded[plugin.folderName] == true);
			end;
		else
			return (self.unloaded[name] == true);
		end;
		
		return false;
	end;
else
	Clockwork.plugin.override = {};
	
	-- A function to set whether a plugin is unloaded.
	function Clockwork.plugin:SetUnloaded(name, isUnloaded)
		local plugin = self:FindByID(name);
		
		if (plugin) then
			self.override[plugin.folderName] = isUnloaded;
		end;
	end;
	
	-- A function to get whether a plugin is disabled.
	function Clockwork.plugin:IsDisabled(name, bFolder)
		if (!bFolder) then
			local plugin = self:FindByID(name);
			
			if (plugin and plugin != Clockwork.schema) then
				for k, v in pairs(self.unloaded) do
					local unloaded = self:FindByID(k);
					
					if (unloaded and unloaded != Clockwork.schema
					and plugin.folderName != unloaded.folderName) then
						if (table.HasValue(unloaded.plugins, plugin.folderName)) then
							return true;
						end;
					end;
				end;
			end;
		else
			for k, v in pairs(self.unloaded) do
				local unloaded = self:FindByID(k);
				
				if (unloaded and unloaded != Clockwork.schema
				and name != unloaded.folderName) then
					if (table.HasValue(unloaded.plugins, name)) then
						return true;
					end;
				end;
			end;
		end;
		
		return false;
	end;
	
	-- A function to get whether a plugin is unloaded.
	function Clockwork.plugin:IsUnloaded(name, bFolder)
		if (!bFolder) then
			local plugin = self:FindByID(name);
			
			if (plugin and plugin != Clockwork.schema) then
				if (self.override[plugin.folderName] != nil) then
					return self.override[plugin.folderName];
				end;
				
				return (self.unloaded[plugin.folderName] == true);
			end;
		else
			if (self.override[name] != nil) then
				return self.override[name];
			end;
			
			return (self.unloaded[name] == true);
		end;
		
		return false;
	end;
end;

-- A function to register a new plugin.
function Clockwork.plugin:Register(pluginTable)
	self.buffer[pluginTable.folderName] = pluginTable;
	self.stored[pluginTable.name] = pluginTable;
	self.stored[pluginTable.name].plugins = {};
	
	for k, v in pairs(_file.FindInLua(pluginTable.baseDir.."/plugins/*")) do
		if (v != ".." and v != ".") then
			table.insert(self.stored[pluginTable.name].plugins, v);
		end;
	end;
	
	if (!self:IsUnloaded(pluginTable)) then
		self:IncludeExtras(pluginTable.kernelDir);
		
		if (CLIENT and Clockwork.schema != pluginTable) then
			pluginTable.helpID = Clockwork.directory:AddCode("Plugins", [[
				<div class="cwInfoTitle">
					]]..string.upper(pluginTable:GetName())..[[
				</div>
				<div class="cwInfoText">
					<div class="cwInfoTip">
						developed by ]]..pluginTable:GetAuthor()..[[
					</div>
					]]..pluginTable:GetDescription()..[[
				</div>
			]], true, pluginTable:GetAuthor());
		end;
	end;

	self:IncludePlugins(pluginTable.baseDir);
	
	if (pluginTable == Clockwork.schema) then
		Clockwork:InitializeKernel();
	end;
end;

-- A function to include a plugin's entities.
function Clockwork.plugin:IncludeEntities(directory)
	for k, v in pairs(_file.FindInLua(directory.."/entities/entities/*")) do
		if (v != ".." and v != ".") then
			ENT = {Type = "anim", Folder = directory.."/entities/entities/"..v};
			
			if (SERVER) then
				if (file.Exists("../gamemodes/"..directory.."/entities/entities/"..v.."/init.lua")) then
					include(directory.."/entities/entities/"..v.."/init.lua");
				elseif (file.Exists("../gamemodes/"..directory.."/entities/entities/"..v.."/shared.lua")) then
					include(directory.."/entities/entities/"..v.."/shared.lua");
				end;
				
				if (file.Exists("../gamemodes/"..directory.."/entities/entities/"..v.."/cl_init.lua")) then
					AddCSLuaFile(directory.."/entities/entities/"..v.."/cl_init.lua");
				end;
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/entities/"..v.."/cl_init.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/entities/"..v.."/cl_init.lua")) then
				include(directory.."/entities/entities/"..v.."/cl_init.lua");
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/entities/"..v.."/shared.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/entities/"..v.."/shared.lua")) then
				include(directory.."/entities/entities/"..v.."/shared.lua");
			end;
			
			scripted_ents.Register(ENT, v); ENT = nil;
		end;
	end;
end;

-- A function to include a plugin's effects.
function Clockwork.plugin:IncludeEffects(directory)
	for k, v in pairs(_file.FindInLua(directory.."/entities/effects/*")) do
		if (v != ".." and v != ".") then
			if (SERVER) then
				if (_file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/cl_init.lua")) then
					AddCSLuaFile(directory.."/entities/effects/"..v.."/cl_init.lua");
				elseif (_file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/init.lua")) then
					AddCSLuaFile(directory.."/entities/effects/"..v.."/init.lua");
				end;
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/effects/"..v.."/cl_init.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/cl_init.lua")) then
				EFFECT = {Folder = directory.."/entities/effects/"..v};
					include(directory.."/entities/effects/"..v.."/cl_init.lua");
				effects.Register(EFFECT, v); EFFECT = nil;
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/effects/"..v.."/init.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/effects/"..v.."/init.lua")) then
				EFFECT = {Folder = directory.."/entities/effects/"..v};
					include(directory.."/entities/effects/"..v.."/init.lua");
				effects.Register(EFFECT, v); EFFECT = nil;
			end;
		end;
	end;
end;

-- A function to include a plugin's weapons.
function Clockwork.plugin:IncludeWeapons(directory)
	for k, v in pairs(_file.FindInLua(directory.."/entities/weapons/*")) do
		if (v != ".." and v != ".") then
			SWEP = { Folder = directory.."/entities/weapons/"..v, Base = "weapon_base", Primary = {}, Secondary = {} };
			
			if (SERVER) then
				if (file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/init.lua")) then
					include(directory.."/entities/weapons/"..v.."/init.lua");
				elseif (file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/shared.lua")) then
					include(directory.."/entities/weapons/"..v.."/shared.lua");
				end;
				
				if (file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/cl_init.lua")) then
					AddCSLuaFile(directory.."/entities/weapons/"..v.."/cl_init.lua");
				end;
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/weapons/"..v.."/cl_init.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/cl_init.lua")) then
				include(directory.."/entities/weapons/"..v.."/cl_init.lua");
			elseif (_file.Exists("../lua_temp/"..directory.."/entities/weapons/"..v.."/shared.lua")
			or _file.Exists("../gamemodes/"..directory.."/entities/weapons/"..v.."/shared.lua")) then
				include(directory.."/entities/weapons/"..v.."/shared.lua");
			end;
			
			weapons.Register(SWEP, v); SWEP = nil;
		end;
	end;
end;

-- A function to include a plugin's plugins.
function Clockwork.plugin:IncludePlugins(directory)
	for k, v in pairs(_file.FindInLua(directory.."/plugins/*")) do
		if (v != ".." and v != ".") then
			if (CLIENT) then
				if (_file.IsDir("../lua_temp/"..directory.."/plugins/"..v)) then
					self:Include(directory.."/plugins/"..v);
				end;
			elseif (_file.IsDir("../gamemodes/"..directory.."/plugins/"..v)) then
				self:Include(directory.."/plugins/"..v);
			end;
		end;
	end;
end;

-- A function to include a plugin's extras.
function Clockwork.plugin:IncludeExtras(directory)
	self:IncludeEffects(directory);
	self:IncludeWeapons(directory);
	self:IncludeEntities(directory);
	
	for k, v in pairs(_file.FindInLua(directory.."/libraries/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/libraries/"..v);
	end;

	for k, v in pairs(_file.FindInLua(directory.."/directory/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/directory/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/system/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/system/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/factions/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/factions/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/classes/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/classes/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/attributes/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/attributes/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/items/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/items/"..v);
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."/derma/*.lua")) do
		Clockwork:IncludePrefixed(directory.."/derma/"..v);
	end;
end;

-- A function to find a plugin by an ID.
function Clockwork.plugin:FindByID(identifier)
	return self.stored[identifier] or self.buffer[identifier];
end;

-- A function to include a plugin.
function Clockwork.plugin:Include(directory, bIsSchema)
	local explodeDir = string.Explode("/", directory);
	local folderName = explodeDir[#explodeDir];
	
	PLUGIN_BASE_DIR = directory;
	PLUGIN_KERNEL_DIR = PLUGIN_BASE_DIR.."/kernel";
	PLUGIN_FOLDERNAME = folderName;
	
	if (bIsSchema) then
		Clockwork.schema = self:New();
		return;
	end;
	
	if (SERVER) then
		PLUGIN = self:New();
		
		if (_file.Exists("../gamemodes/"..directory.."/sh_info.lua")) then
			include(directory.."/sh_info.lua");
			AddCSLuaFile(directory.."/sh_info.lua");
		else
			ErrorNoHalt("[Clockwork] The "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;
		
		local isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
		local isDisabled = self:IsDisabled(PLUGIN_FOLDERNAME, true);
		
		if (bIsSchema) then
			isUnloaded = false;
			isDisabled = false;
		end;
		
		if (!isUnloaded and !isDisabled) then
			if (_file.Exists("../gamemodes/"..directory.."/sh_init.lua")) then
				include(directory.."/sh_init.lua");
				AddCSLuaFile(directory.."/sh_init.lua");
			end;
		end;
	else
		PLUGIN = self:New();
		
		if (_file.Exists("../lua_temp/"..directory.."/sh_info.lua")) then
			include(directory.."/sh_info.lua");
		else
			ErrorNoHalt("[Clockwork] The "..PLUGIN_FOLDERNAME.." plugin has no sh_info.lua.");
		end;
		
		local isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
		local isDisabled = self:IsDisabled(PLUGIN_FOLDERNAME, true);
		
		if (bIsSchema) then
			isUnloaded = false;
			isDisabled = false;
		end;
		
		if (!isUnloaded and !isDisabled) then
			if (_file.Exists("../lua_temp/"..directory.."/sh_init.lua")) then
				include(directory.."/sh_init.lua");
			end;
		end;
	end;
	
	if (PLUGIN) then
		PLUGIN:Register();
		PLUGIN = nil;
	end;
end;

-- A function to create a new plugin.
function Clockwork.plugin:New()
	local pluginTable = {
		description = "An undescribed plugin or schema.",
		folderName = PLUGIN_FOLDERNAME,
		kernelDir = PLUGIN_KERNEL_DIR,
		baseDir = PLUGIN_BASE_DIR,
		version = 1.0,
		author = "Unknown",
		name = "Unknown"
	};
	
	pluginTable.GetDescription = function(pluginTable)
		return pluginTable.description;
	end;
	
	pluginTable.GetKernelDir = function(pluginTable)
		return pluginTable.kernelDir;
	end;
	
	pluginTable.GetBaseDir = function(pluginTable)
		return pluginTable.baseDir;
	end;
	
	pluginTable.GetVersion = function(pluginTable)
		return pluginTable.version;
	end;
	
	pluginTable.GetAuthor = function(pluginTable)
		return pluginTable.author;
	end;
	
	pluginTable.GetName = function(pluginTable)
		return pluginTable.name;
	end;
	
	pluginTable.Register = function(pluginTable)
		self:Register(pluginTable);
	end;
	
	return pluginTable;
end;

-- A function to run the plugin hooks.
function Clockwork.plugin:RunHooks(name, bGamemode, ...)
	for k, v in pairs(self.modules) do
		if (v[name]) then
			local value = v[name](v, ...);
			
			if (value != nil) then
				return value;
			end;
		end;
	end;
	
	for k, v in pairs(self.stored) do
		if (Clockwork.schema != v and v[name]) then
			local value = v[name](v, ...);
			
			if (value != nil) then
				return value;
			end;
		end;
	end;
	
	if (Clockwork.schema[name]) then
		local value = Clockwork.schema[name](Clockwork.schema, ...);
		
		if (value != nil) then
			return value;
		end;
	end;
	
	if (bGamemode and Clockwork[name]) then
		local value = Clockwork[name](Clockwork, ...);
		
		if (value != nil) then
			return value;
		end;
	end;
end;

-- A function to call a function for all plugins.
function Clockwork.plugin:Call(name, ...)
	return self:RunHooks(name, true, ...);
end;

-- A function to add a table as a module.
function Clockwork.plugin:Add(name, moduleTable)
	self.modules[name] = moduleTable;
end;

if (CLIENT) then
	local unloadedPlugins = CW_SCRIPT_SHARED.unloadedPlugins;
		if (unloadedPlugins) then
			Clockwork.plugin.unloaded = unloadedPlugins;
		else
			Clockwork.plugin.unloaded = {};
		end;
	CW_SCRIPT_SHARED.unloadedPlugins = nil;
else
	Clockwork.plugin.unloaded = Clockwork:RestoreSchemaData("plugins");
	
	if (Clockwork.plugin.unloaded) then
		CW_SCRIPT_SHARED.unloadedPlugins = Clockwork.plugin.unloaded;
	end;
end;