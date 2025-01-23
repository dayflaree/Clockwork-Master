--[[--
	-- Generic Incomplete Gamemode --
	
	File: cl_init.lua
	Purpose: Runs functions from other clientside files.
	Created: 18th August 2010 By: _Undefined
--]]--

require("datastream")

include("shared.lua")
include("cl_player_extension.lua")
include("cl_inventory.lua")
include("cl_mission.lua")

function PlayerSetting(handler, id, encoded, decoded)
	local ply = decoded.ply
	
	ply[decoded.key] = decoded.value
end
datastream.Hook("PlayerSetting", PlayerSetting)

function GM:Initialize()
	self.BaseClass.Initialize(self)
end