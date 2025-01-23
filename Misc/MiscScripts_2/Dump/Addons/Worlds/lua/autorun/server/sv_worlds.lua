AddCSLuaFile("autorun/client/cl_worlds.lua")

// Entity extensions.
local Entity = FindMetaTable("Entity")

function Entity:SetWorld(world)
	self:SetNWInt("world", world)
end

function Entity:GetWorld()
	return self:GetNWInt("world")
end

// Hooks
function ShouldCollide(ent1, ent2)
	return ent1:GetWorld() == ent2:GetWorld() or ent1:IsWorld() or ent2:IsWorld()
end
hook.Add("ShouldCollide", "WorldsShouldCollide", ShouldCollide)

function Creation1(ply, ent)
	ent:SetWorld(ply:GetWorld())
end
hook.Add("PlayerSpawnedSENT", "WorldsPlayerSpawnedSENT", Creation1)
hook.Add("PlayerSpawnedVehicle", "WorldsPlayerSpawnedVehicle", Creation1)

function Creation2(ply, mdl, ent)
	ent:SetWorld(ply:GetWorld())
end
hook.Add("PlayerSpawnedProp", "WorldsPlayerSpawnedProp", Creation2)
hook.Add("PlayerSpawnedEffect", "WorldsPlayerSpawnedEffect", Creation2)
hook.Add("PlayerSpawnedRagdoll", "WorldsPlayerSpawnedRagdoll", Creation2)

function SetPlayerWorld(ply)
	ply:SetWorld(0)
end
hook.Add("PlayerInitialSpawn", "WorldsPlayerInitialSpawn", SetPlayerWorld)