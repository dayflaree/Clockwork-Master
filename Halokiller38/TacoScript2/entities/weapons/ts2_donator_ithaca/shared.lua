
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";
	
SWEP.ViewModelFlip		= true;
 
 SWEP.Base = "ts2_base_shotgun";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.ViewModel			= "models/weapons/v_shot_winch1300.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_winch1300.mdl"
SWEP.Primary.Sound			= Sound( "Weapons/shotgun.wav" )

SWEP.PrintName = "Ithaca 37 Shotgun";
SWEP.TS2Desc = "Donator Weapon";

SWEP.Price = 7000;

SWEP.ShotgunReload = true;

 SWEP.Primary.Recoil			= .3
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = 1
 
 SWEP.Primary.ViewPunchMul = 30;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 12 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 18;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
SWEP.Primary.Spread =  Vector( .04, .04, .04);

 SWEP.Primary.IronSightPos = Vector( 3.1517, 1.6706, -1.9604 );
 SWEP.Primary.IronSightAng = Vector( 0, 0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -2.0 -5.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 0.0, 50.0);

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, 45, 86 ) 
SWEP.IconLookAt = Vector( 7, 16, 32 ) 
SWEP.IconFOV = 6

   