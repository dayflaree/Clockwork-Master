--[[
		uBer
File: sv_config.lua
--]]


local data = {};
	data[1] = '127.0.0.1';
	data[2] = 'username';
	data[3] = 'password';
	data[4] = 'database';


--[[A function to process creating/reading/checking the config file.]]--
function lib_config_Process(gamemode)
	//Check if the config file exists.
	if (lib_config_Exists(gamemode)) then
		local config = lib_config_Read(gamemode);
		config = lib_config_Parse('read',config);
		return config;
	else
		lib_config_Create(lib_config_Parse('write',data),gamemode);
		return lib_config_Read(gamemode);
	end;
end;

--[[A function to create the initial config file.]]--
function lib_config_Create(str,gamemode)
	if lib_config_Exists(gamemode) then return end;
	file.Write("uBer/"..gamemode.."/config.txt", str);
end;

--[[A function to check if a config file exists.]]--
function lib_config_Exists(gamemode)
	return file.Exists("uBer/"..gamemode.."/config.txt");
end;

--[[A function to read the config file.]]--
function lib_config_Read(gamemode)
	return file.Read("uBer/"..gamemode.."/config.txt");
end;

--[[A function to parse the data from the config file.]]--
function lib_config_Parse(method,config)
	if method == 'read' then
		return util.KeyValuesToTable(config);
	elseif method == 'write' then
		return util.TableToKeyValues(config)
	end
end;
