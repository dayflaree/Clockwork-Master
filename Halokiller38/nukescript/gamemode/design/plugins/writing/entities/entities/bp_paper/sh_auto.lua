--[[
Name: "sh_auto.lua".
Product: "Day One".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "kurozael";
ENT.PrintName = "Paper";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	blueprint.entity.RegisterSharedVars( self, {
		{"sh_Note", NWTYPE_BOOL}
	} );
end;