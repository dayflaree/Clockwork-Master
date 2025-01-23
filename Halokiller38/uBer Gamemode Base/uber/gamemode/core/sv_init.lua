--[[
		uBer
File: init.lua
--]]

AddCSLuaFile("sh_init.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_functions.lua");
AddCSLuaFile("cl_good_hud.lua");

include("sh_init.lua");
include("sh_functions.lua");
include("cl_good_hud.lua");

local database = {}

function GM:Initialize()
	database = lib_mysql_MakeConnection(lib_config_Process(self.Name));   //Making a connection to the mysql server.
end;