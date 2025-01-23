
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

  	SWEP.ViewModelFlip		= true;	  
 SWEP.Base = "ts2_base_shotgun";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.ViewModel			= "models/weapons/v_mega_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_remmy_fix.mdl"
SWEP.Primary.Sound			= Sound( "Weapons/shotgun.wav" )

SWEP.PrintName = "Remington 12 Gauge";
SWEP.TS2Desc = "Old fashioned pump shotgun";

SWEP.Price = 4000;


SWEP.ShotgunReload = true;

 SWEP.Primary.Recoil			= .3
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = 1
 
 SWEP.Primary.ViewPunchMul = 30;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 9 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 30;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
SWEP.Primary.Spread =  Vector( .04, .04, .04);

 SWEP.Primary.IronSightPos = Vector( 4.3888, 2.331, -5.9595 );
 SWEP.Primary.IronSightAng = Vector( 0.5892, 0, -0.1397 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;


SWEP.IconCamPos = Vector( 8, 58, 50 ) 
SWEP.IconLookAt = Vector( 1, 0, 0 ) 
SWEP.IconFOV = 12

   