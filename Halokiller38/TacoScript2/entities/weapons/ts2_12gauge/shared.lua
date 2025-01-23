
if( SERVER ) then

AddCSLuaFile( "shared.lua" ) 

end 
SWEP.HoldType = "pistol";

SWEP.Base = "ts2_base_shotgun";

SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= true 

SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_Shotgun.Single" )

SWEP.PrintName = "SPAS 12 Shotgun";
SWEP.TS2Desc = "Shoot shots.";

SWEP.Price = 6000;

SWEP.ShotgunReload = true;

SWEP.Primary.Recoil			= .3
SWEP.Primary.RecoilAdd			= .2
SWEP.Primary.RecoilMin = .3
SWEP.Primary.RecoilMax = 1

SWEP.Primary.ViewPunchMul = 70;
SWEP.Primary.Damage			= 9
SWEP.Primary.NumShots		= 9 

SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 18;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .05, .05, 0 );

SWEP.Primary.IronSightPos = Vector( -9.0, 4.0, -5.0 );
SWEP.Primary.IronSightAng = Vector( -.5, -1.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;


SWEP.IconCamPos = Vector( 8, 58, 50 ) 
SWEP.IconLookAt = Vector( 1, 0, 0 ) 
SWEP.IconFOV = 12