--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ENT.Type = "anim";
ENT.Base = "base_anim";
ENT.Author = "kurozael";
ENT.PrintName = "Salesman";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("String", 0, "Name");
	self:DTVar("String", 1, "PhysDesc");
end;
