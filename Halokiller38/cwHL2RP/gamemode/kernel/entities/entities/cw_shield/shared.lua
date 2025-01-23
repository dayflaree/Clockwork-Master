ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Spencer";
ENT.PrintName = "Combine Shield";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "locked");
end;

-- A function to get whether the entity is locked.
function ENT:IsLocked()
	return self:GetDTBool("locked");
end;

function ENT:PhysicsCollide(data, physobj)
	local entity = data.HitEntity;
	if (entity:IsWorld()) then
		return true;
	end;
	
	return false;
end;
	