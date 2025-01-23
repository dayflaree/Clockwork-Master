--[[
Name: "sh_auto.lua".
Product: "Half-Life 2".
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Dazzle Modifications";
ENT.PrintName = "Vending Machine";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;

-- A function to get the entity's stock.
function ENT:GetStock()
	return self:GetSharedVar("sh_Stock");
end;

-- Called when the entity initializes.
function ENT:SharedInitialize()
	resistance.entity.RegisterSharedVars( self, {
		{"sh_Action", NWTYPE_BOOL},
		{"sh_Stock", NWTYPE_NUMBER},
		{"sh_Flash", NWTYPE_NUMBER}
	} );
end;