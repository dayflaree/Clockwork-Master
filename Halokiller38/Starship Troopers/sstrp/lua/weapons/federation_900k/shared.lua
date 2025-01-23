// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_sniper"
SWEP.HoldType 			= "ar2"
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_rif_fw900.mdl"
SWEP.WorldModel			= "models/weapons/w_900k.mdl"
SWEP.ViewModelFOV		= 70
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("newsstrp/900knew.wav")
SWEP.Primary.Recoil		= 2
SWEP.Primary.Damage		= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay 		= 0.25

SWEP.Primary.ClipSize		= 10					// Size of a clip
SWEP.Primary.DefaultClip	= 40					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_rifle"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0
--[[
SWEP.IronSightsPos = Vector(2.16, -5.639, 0.079)
SWEP.IronSightsAng = Vector(0, 66.662, 0)
]]--

SWEP.IronSightsPos = Vector(-4.189, -0.019, 1.95)
SWEP.IronSightsAng = Vector(0, 0, -0.987)
SWEP.RunArmOffset 		= Vector(2.16, -5.639, 0.079)
SWEP.RunArmAngle 			= Vector(0, 66.662, 0)

SWEP.ScopeZooms			= {8}

