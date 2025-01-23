
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then
	
	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound			= Sound( "Weapon_m249.Single" )

SWEP.WorldModel = 		"models/weapons/w_mach_m249para.mdl";
SWEP.ViewModel  = 		"models/weapons/v_mach_m249para.mdl";

SWEP.PrintName = "M249";
SWEP.TS2Desc = "US Millitary Support Weapon";

SWEP.Price = 9500;

 SWEP.Primary.Recoil			= .3 
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .7
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 12
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 100;
SWEP.Primary.DefaultClip = 400;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.IronSightPos = Vector(-4.4132, 1.9665, -4.1768 );
SWEP.Primary.IronSightAng = Vector( 0.7013, 0, 0.1955 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 132, 0, 0 ) 
SWEP.IconLookAt = Vector( -5, 2, -1 ) 
SWEP.IconFOV = 9;

SWEP.ReloadSound = "";


   