--[[
	Free Clockwork!
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "kurozael";
ENT.PrintName = "Shipment";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Index");
end;

-- A function to get the entity's item table.
function ENT:GetItemTable()
	if (CLIENT) then
		local index = self:GetDTInt("Index");
		
		if (index != 0) then
			return Clockwork.item:FindByID(index);
		end;
	end;
	
	return self.cwItemTable;
end;