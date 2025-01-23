--[[
		uBer
File: sh_functions.lua
--]]

--[[A function to include a directory within the gamemode.]]--
function GM:IncludeDirectory(directory)
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs( g_File.FindInLua(directory.."*.lua") ) do
		Msg("Including: "..v.."\n");
		GM:IncludePrefixed(directory..v);
	end;
end;

--[[A function to include a file based on its prefix.]]--
function GM:IncludePrefixed(fileName)
	if (string.find(fileName, "sv_") and !SERVER) then
		return;
	end;
	
	if (string.find(fileName, "sh_") and SERVER) then
		AddCSLuaFile(fileName);
	elseif (string.find(fileName, "cl_") and SERVER) then
		AddCSLuaFile(fileName);
		
		return;
	end;
	
	include(fileName);
end;

--[[A function to return the gamemode's name.]]--
function GM:GamemodeName()
	return self.Name;
end;