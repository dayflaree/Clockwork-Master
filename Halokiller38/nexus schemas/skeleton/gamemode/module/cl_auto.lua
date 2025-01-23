--[[
Name: "cl_auto.lua".
Product: "Skeleton".
--]]


RESISTANCE:IncludePrefixed("sh_auto.lua");

--[[
	The good thing about resistance modules and plugins, is that any function
	created like PLUGIN:Function or MODULE:Function is automatically hooked
	as a Garry's Mod hook (but only if that hook exists). For example:
		function MODULE:PlayerSpawn(player)
		end;
--]]