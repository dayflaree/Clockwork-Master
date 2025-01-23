--[[
Name: "sh_auto.lua".
Product: "Day One".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "kurozael";
ENT.PrintName = "Belongings";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	blueprint.entity.RegisterSharedVars( self, {
		{"sh_Name", NWTYPE_STRING}
	} );
end;