--[[
	Context Admin Mod
	_Undefined
	050110
	Sends and includes the correct files.
]]--

if not datastream then require("datastream") end

function LoadContext()
	if SERVER then
		AddCSLuaFile("autorun/context.lua")
		AddCSLuaFile("sh_context.lua")
		AddCSLuaFile("cl_context.lua")
		
		include("sh_context.lua")
		include("sv_context.lua")
		
		for _, filename in pairs(file.FindInLua("co_plugins/*.lua")) do
			local pre = string.Left(filename, string.find(filename, "_") - 1)
			
			if pre == "sh" then
				AddCSLuaFile("co_plugins/" .. filename)
				include("co_plugins/" .. filename)
			elseif pre == "cl" then
				AddCSLuaFile("co_plugins/" .. filename)
			elseif pre == "sv" then
				include("co_plugins/" .. filename)
			end
		end
	end

	if CLIENT then
		include("sh_context.lua")
		include("cl_context.lua")
		
		for _, filename in pairs(file.FindInLua("co_plugins/*.lua")) do
			local pre = string.Left(filename, string.find(filename, "_") - 1)
			if pre == "cl" or pre == "sh" then
				include("co_plugins/" .. filename)
			end
		end
	end
end
concommand.Add("context_reload", LoadContext)

LoadContext()