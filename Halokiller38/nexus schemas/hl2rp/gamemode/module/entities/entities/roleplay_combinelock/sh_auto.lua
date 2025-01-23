--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Dazzle Modifications";
ENT.PrintName = "Combine Lock";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	resistance.entity.RegisterSharedVars( self, {
		{"sh_SmokeCharge", NWTYPE_NUMBER},
		{"sh_Locked", NWTYPE_BOOL},
		{"sh_Flash", NWTYPE_NUMBER}
	} );
end;