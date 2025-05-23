// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_base_sniper"

SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil		= 1
SWEP.Primary.Damage		= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.007
SWEP.Primary.Delay 		= 0.08

SWEP.Primary.ClipSize		= 30					// Size of a clip
SWEP.Primary.DefaultClip	= 30					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "AirboatGun"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.IronSightsPos 		= Vector (6.6539, -11.2899, 2.6928)
SWEP.IronSightsAng 		= Vector (0, 0, 0)
SWEP.RunArmOffset 		= Vector (-2.6657, 0, 3.5)
SWEP.RunArmAngle 			= Vector (-20.0824, -20.5693, 0)

SWEP.ScopeZooms			= {5}

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/sg552/sg552-1.wav")
end