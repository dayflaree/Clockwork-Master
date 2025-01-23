--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

require("glon");

SF = GM;

SF.Name = "Slidefuse Base";
SF.Author = "Spencer Sharkey";
SF.Email = "spencer@sf-n.com";
SF.Website = "Slidefuse.net"
SF.Folder = "slidefuse/gamemode";



hook.OriginalCall = hook.Call;

function hook.Call(name, gamemode, ...)
	if (CLIENT) then
		if (!IsValid(SF.Client)) then
			SF.Client = LocalPlayer();
		end;
	end;

	local value = nil;

	if (SF.modules) then
		for k, v in pairs(SF.modules) do
			if (v[name]) then
				value = v[name](v, ...);
			end;
		end;
	end;

	if (value == nil) then
		return hook.OriginalCall(name, gamemode or SF, ...);
	else
		return value;
	end;
end;

-- A function to call a hook in a module
function SF:Call(name, ...)
	hook.Call(name, SF, ...);
end;

-- A function to include files in a directory.
function SF:IncludeDirectory(directory, bFromBase)
	if (bFromBase) then
		directory = self.Folder.."/"..directory;
	end;
	
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs(file.Find(directory.."*.lua", LUA_PATH)) do
	//for k, v in pairs(file.FindInLua(directory.."*.lua")) do
		self:IncludePrefixed(directory..v);
	end;
end;

-- A function to include a prefixed file.
function SF:IncludePrefixed(fileName)
	local isShared = (string.find(fileName, "sh_") or string.find(fileName, "shared.lua"));
	local isClient = (string.find(fileName, "cl_") or string.find(fileName, "cl_init.lua"));
	local isServer = (string.find(fileName, "sv_"));
	
	if (isServer and !SERVER) then
		return;
	end;
	
	if (isShared and SERVER) then
		AddCSLuaFile(fileName);
	elseif (isClient and SERVER) then
		AddCSLuaFile(fileName);
		return;
	end;
	
	include(fileName);
end;

-- A function called to create a module
function SF:DefineModule(name, moduleObject)
	if (!self.modules) then
		self.modules = {};
	end;

	self.modules[name] = moduleObject;

	return self.modules[name];
end;

SF:IncludePrefixed("core/sh_auto.lua");
SF:IncludePrefixed("core/sv_auto.lua");
SF:IncludePrefixed("core/cl_auto.lua");