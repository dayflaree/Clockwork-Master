
-----------------------------------------------------
local BaseClass = baseclass.Get("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "Xenoxia + RJ";
ENT.PrintName = "Keycard Lock";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:DTVar("Float", 0, "smokeCharge");
	self:DTVar("Float", 1, "flash");
	self:DTVar("Bool", 0, "locked");
	self:DTVar("Int", 0, "level");
end;

-- A function to get whether the entity is locked.
function ENT:IsLocked()
	return self:GetDTBool(0);
end;

-- A function to get what level the entity is.
function ENT:IsLevel()
	return self:GetDTInt(0)
end;