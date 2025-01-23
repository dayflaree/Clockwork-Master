// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_sniper"
SWEP.HoldType 			= "ar2"
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_arc3.mdl"
SWEP.WorldModel			= "models/weapons/w_arc3.mdl"
SWEP.ViewModelFOV		= 70
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("newsstrp/arcnew.wav")
SWEP.Primary.Recoil		= 0.4
SWEP.Primary.Damage		= 26
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay 		= 0.13
SWEP.Primary.ClipSize		= 45					// Size of a clip
SWEP.Primary.DefaultClip	= 45					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "effect_mad_shell_rifle"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0
--[[
SWEP.IronSightsPos = Vector(0, 0, -1.331)
SWEP.IronSightsAng = Vector(0, 50.269, 0)
]]--

SWEP.IronSightsPos = Vector(-9.839, -8.494, 0.648)
SWEP.IronSightsAng = Vector(0, 0, 2.43)
SWEP.RunArmOffset 		= Vector(0, 0, -1.331)
SWEP.RunArmAngle 			= Vector(0, 50.269, 0)

SWEP.ScopeZooms			= {6}

