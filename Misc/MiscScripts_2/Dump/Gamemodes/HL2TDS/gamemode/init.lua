require("datastream")

AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function GM:Initialize()
	
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	ply:CrosshairDisable()
end

function GM:SetupMove(ply, mv)
	mv:SetMoveAngles(Angle(0, 0, 0))
end

function GM:OnNPCKilled(npc, killer, weapon)
	local ent = ents.Create("tds_pickup")
	ent:SetPos(npc:GetPos() + Vector(0, 0, 50))
	ent:Spawn()
end

function GM:Think()
	-- for _, ply in pairs(player.GetAll()) do
		-- local n = ents.FindByClassInSphere("npc_zombie", ply:GetPos(), 300)
		
		-- if n and #n < 1 then
			-- MsgN("Creating zombie...")
			-- local npc = ents.Create("npc_zombie")
			-- local r = (VectorRand() * 300)
			-- r.z = 0
			-- npc:SetPos(ply:GetPos() + r)
			-- npc:Spawn()
		-- end
	-- end
end