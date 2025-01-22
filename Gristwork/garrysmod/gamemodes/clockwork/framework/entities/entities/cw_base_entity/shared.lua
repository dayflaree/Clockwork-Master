
DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "Alex Grist";
ENT.PrintName = "Base Entity";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- A function to get the entity's item table.
function ENT:GetItemTable()
	return Clockwork.entity:FetchItemTable(self);
end;