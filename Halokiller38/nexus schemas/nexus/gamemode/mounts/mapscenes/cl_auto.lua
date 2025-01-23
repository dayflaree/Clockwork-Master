--[[
Name: "cl_auto.lua".
Product: "Nexus".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

NEXUS:HookDataStream("MapScene", function(data)
	MOUNT.mapScene = data;
end);