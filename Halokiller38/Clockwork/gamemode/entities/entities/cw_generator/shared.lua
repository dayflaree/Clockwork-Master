--[[
	Free Clockwork!
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Model = "models/props_combine/combine_mine01.mdl";
ENT.Author = "kurozael";
ENT.PrintName = "Generator";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Power");
end;

-- A function to get the entity's power.
function ENT:GetPower()
	return self:GetDTInt("Power");
end;