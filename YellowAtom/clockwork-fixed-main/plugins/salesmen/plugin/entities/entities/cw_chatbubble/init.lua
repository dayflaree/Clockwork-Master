
Clockwork.kernel:IncludePrefixed("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/extras/info_speech.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end
