

SWEP.PrintName			= "ADMIN WEAPON"					// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 5							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_admin.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_admin")
end