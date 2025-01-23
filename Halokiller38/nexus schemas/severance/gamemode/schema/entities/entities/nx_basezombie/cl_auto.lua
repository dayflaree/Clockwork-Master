--[[
Name: "cl_auto.lua".
Product: "Severance".
--]]

NEXUS:IncludePrefixed("sh_auto.lua");

ENT.RenderGroup = RENDERGROUP_BOTH;

-- Called when the entity's should be drawn.
function ENT:Draw()
	self.Entity:DrawModel();
end;

-- Called when the entity's should be drawn translucent.
function ENT:DrawTranslucent()
	self:Draw();
end;

-- A function to build the bone positions.
function ENT:BuildBonePositions(NumBones, NumPhysBones)
end;

-- A function to set the ragdoll bones.
function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn;
end;

-- A function to do the ragdoll's bone.
function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
end;