--[[
Name: "sh_auto.lua".
Product: "Day One".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "kurozael";
ENT.PrintName = "Radio";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	blueprint.entity.RegisterSharedVars( self, {
		{"sh_Frequency", NWTYPE_STRING},
		{"sh_Off", NWTYPE_BOOL}
	} );
end;

-- A function to get whether the entity is off.
function ENT:IsOff()
	return self:GetSharedVar("sh_Off");
end;