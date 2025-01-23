--[[
Name: "sh_auto.lua".
Product: "Severance".
--]]

ENT.Base = "base_ai";
ENT.Type = "ai";
ENT.Author = "kuropixel";
ENT.Category = "Zombies";
ENT.Spawnable = false;
ENT.PrintName = "Zombie Base";
ENT.Information	= "It is the base for a zombie.";
ENT.AdminSpawnable = false;
ENT.AutomaticFrameAdvance = true;

-- Called when the entity is removed.
function ENT:OnRemove() end;

-- Called when the entity's physics collides.
function ENT:PhysicsCollide(data, physicsObject) end;

-- Called when the entity's physics are updated.
function ENT:PhysicsUpdate(physicsObject) end;

-- Called to set whether the frames should automatically advance.
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim;
end;