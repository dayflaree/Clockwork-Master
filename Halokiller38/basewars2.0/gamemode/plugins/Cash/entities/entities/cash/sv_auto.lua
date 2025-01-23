--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/Money.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(player, caller)
	if (!self.used) then
		player:GiveCash(self:GetNWInt("amount"));
		self.used = true;
		self:Remove();
	end;
end;

function ENT:Touch(ent)
	if (!self.touched) then
		if (ent:GetClass() == "cash" and !ent:GetNWBool("pendingRemoval")) then
			self:SetNWBool("pendingRemoval", true);
			ent:SetNWInt("amount", self:GetNWInt("amount") + ent:GetNWInt("amount"));
			self:Remove();
			self.touched = true;
		end;
	end;
end;