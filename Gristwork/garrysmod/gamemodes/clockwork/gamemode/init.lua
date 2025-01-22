--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

--[[ 
	Require the fileio module.
--]]
require("fileio");

--[[
	Initialize the shared variable table. 
--]]
CW_SCRIPT_SHARED = {
	schemaFolder = engine.ActiveGamemode()
};

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("external/von.lua");
AddCSLuaFile("external/pon.lua");

--[[
	Include Vercas's and Penguin's serialization library
	and the Clockwork kernel. --]]
include("external/von.lua");
include("external/pon.lua");
include("clockwork/framework/sv_kernel.lua");