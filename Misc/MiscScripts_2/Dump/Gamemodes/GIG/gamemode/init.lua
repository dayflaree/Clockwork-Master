--[[--
	-- Generic Incomplete Gamemode --
	
	File: init.lua
	Purpose: Runs functions from other serverside files.
	Created: 18th August 2010 By: _Undefined
--]]--

require("datastream")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_player_extension.lua")
AddCSLuaFile("cl_inventory.lua")
AddCSLuaFile("cl_mission.lua")

include("shared.lua")
include("sv_player_extension.lua")
include("sv_inventory.lua")
include("sv_mission.lua")

function GM:Think()
	-- self:MissionThink()
end

function GM:Initialize()
	self.BaseClass.Initialize(self)
	
	-- self:LoadMissions()
end