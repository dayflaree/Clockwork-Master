--[[
Name: "sh_auto.lua".
Product: "Severance".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "kuropixel";
ENT.PrintName = "Belongings";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	nexus.entity.RegisterSharedVars( self, {
		{"sh_Name", NWTYPE_STRING}
	} );
end;