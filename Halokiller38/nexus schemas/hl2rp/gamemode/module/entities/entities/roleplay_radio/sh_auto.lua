--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Dazzle Modifications";
ENT.PrintName = "Radio";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	resistance.entity.RegisterSharedVars( self, {
		{"sh_Frequency", NWTYPE_STRING},
		{"sh_Off", NWTYPE_BOOL}
	} );
end;

-- A function to get whether the entity is off.
function ENT:IsOff()
	return self:GetSharedVar("sh_Off");
end;