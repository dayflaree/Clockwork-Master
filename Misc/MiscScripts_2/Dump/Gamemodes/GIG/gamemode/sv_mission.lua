--[[--
	-- Generic Incomplete Gamemode --
	
	File: sv_mission.lua
	Purpose: Provides the serverside functions for the missions system.
	Created: 18th August 2010 By: _Undefined
--]]--

GM.Missions = {}

function GM:RegisterMission(tbl)
	-- _Undefined: tbl.id is from the mission_id field in sql.
	table.insert(self.Missions, tbl.id, tbl)
	return tbl.id -- Might be useful somewhere I guess.
end

function GM:GetMission(id)
	if not id then return end
	return self.Missions[id]
end

function GM:MissionThink()
	-- This function will run the functions of every current mission that a player is in.
	
	-- _Undefined: Missions per player or players per mission? YOU decide.
	
	-- Missions per player.
	for k, ply in pairs(player.GetAll()) do
		if ply:GetActiveMission() then
			ply:GetActiveMission().Think(ply) -- _Undefined: Pass ply so the function doesn't need to find the player.
		end
	end
	
	/*
	for k, v in pairs(self.ActiveMissions) do
		for k, m in pairs(self.ActiveMissions) do
			m.Think()
		end
	end
	*/
end

