--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF:IncludePrefixed("sh_networking.lua");
SF:IncludePrefixed("sv_database.lua");
SF:IncludePrefixed("sv_auto.lua");
SF:IncludePrefixed("cl_auto.lua");
SF:IncludePrefixed("sh_plugin.lua");

SF:IncludeDirectory("core/libraries", true);
SF:IncludeDirectory("core/derma", true);
SF:IncludeDirectory("core/autorun", true);

local themeFolder = SF:GetThemeFolder();
		
if (themeFolder and type(themeFolder) == "string") then
	SF.plugin:Include(themeFolder.."/gamemode/theme", true);
end;