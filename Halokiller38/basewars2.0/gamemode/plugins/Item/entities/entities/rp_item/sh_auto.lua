ENT.Type = "anim";
ENT.Base = "base_gmodentity";
 
ENT.PrintName		= "RP Item";
ENT.Author			= "Spencer";

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "itemID");
end;