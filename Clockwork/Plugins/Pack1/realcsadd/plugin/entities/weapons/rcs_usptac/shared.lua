if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 1.5

end

if ( CLIENT ) then
	SWEP.PrintName			= "USP-Tac"	
	SWEP.Author				= "Zak"
	SWEP.SlotPos			= 2
	SWEP.IconLetter			= "a"
	SWEP.Slot				= 1
	SWEP.ViewModelFlip		= true
	SWEP.ViewModelFOV		= 72
	SWEP.DefaultVFOV		= 50
	SWEP.NameOfSWEP			= "rcs_usptac" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.HoldType				= "pistol"
SWEP.Category				= "RealCS"
SWEP.Base					= "rcs_base_pistol"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_usp_silencer.mdl"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Sound			= Sound("weapons/m4a1/m4a1-1.wav")
SWEP.Primary.Recoil			= 0.27
SWEP.Primary.Damage			= 21.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001 --starting cone, it WILL increase to something higher, so keep it low
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.14
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.MaxReserve		= 10000
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Primary.MaxSpread		= 0.005 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle			= 0.1 --how many seconds you have to wait between each shot before the spread is at its best
SWEP.Primary.SpreadIncrease	= 0.21/15 --how much you add to the cone after each shot

SWEP.MoveSpread				= 6 --multiplier for spread when you are moving
SWEP.JumpSpread				= 8 --multiplier for spread when you are jumping
SWEP.CrouchSpread			= 0.5 --multiplier for spread when you are crouching

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.ReloadLol = Sound("Weapon_Pistol.Reload");

SWEP.IronSightsPos = Vector(-6.1, 11, 4)
SWEP.IronSightsAng = Vector(0.15, -1, 1.5)

function SWEP:RCSReloadPistol()
	self.Owner:EmitSound(self.ReloadLol)
end