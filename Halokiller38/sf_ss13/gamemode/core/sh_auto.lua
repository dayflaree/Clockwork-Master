--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF:IncludePrefixed("sh_networking.lua");
SF:IncludePrefixed("sh_database.lua");
SF:IncludePrefixed("sv_auto.lua");
SF:IncludePrefixed("cl_auto.lua");
SF:IncludeDirectory("core/libraries", true);
SF:IncludeDirectory("core/derma", true);
SF:IncludeDirectory("core/autorun", true);

SF:IncludeDirectory("core/tiles", true);
SF:IncludeDirectory("core/objs", true);

-- ENUMS
SF_PLAYER = 5001;
SF_ATMOS = 5002;