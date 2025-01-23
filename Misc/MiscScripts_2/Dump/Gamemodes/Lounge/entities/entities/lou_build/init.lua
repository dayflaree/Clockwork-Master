AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then return end
	dissolverTarget = "dissolve"..self:EntIndex()
	ent:SetKeyValue("targetname", dissolverTarget)
	dissolver = ents.Create("env_entity_dissolver")
	dissolver:SetKeyValue("dissolvetype", 3)
	dissolver:SetKeyValue("magnitude", 0)
	dissolver:SetPos(ent:GetPos())
	dissolver:Spawn()
	dissolver:Fire("Dissolve", dissolverTarget, 0)
	dissolver:Fire("kill", "", 0.1)
end

function ENT:Touch(ent)
	if not ent:IsPlayer() then return end
	ply = ent
	if ply:Team() != TEAM_BUILD then
		GAMEMODE:SetPlayer(ply, TEAM_BUILD)
	end
end
