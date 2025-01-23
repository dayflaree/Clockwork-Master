--[[--
	-- Generic Incomplete Gamemode --
	
	File: cl_player_extension.lua
	Purpose: Extends the Player metatable clientside to provide attitional functions.
	Created: 18th August 2010 By: _Undefined
--]]--

local Player = FindMetaTable("Player")

function Player:GetSetting(key)
	return self[key] or false
end