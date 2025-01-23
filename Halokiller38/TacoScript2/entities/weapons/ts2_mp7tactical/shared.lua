
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

  	SWEP.HoldType = "pistol";
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.Primary.Sound = Sound( "Weapons/usp/usp_unsil-1.wav" );

SWEP.WorldModel = "models/weapons/w_smg1.mdl";
SWEP.ViewModel = "models/weapons/v_smg3.mdl";

SWEP.PrintName = "MP7 Tactical RIS";
SWEP.TS2Desc = "RIS Rigged and customised MP7";

SWEP.Price = 4500;


 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .3
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 8 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 200;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .06;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.02, 0.02, 0.02 );

 SWEP.Primary.IronSightPos = Vector( -5.4157,  2.3729, -10.5088 );
 SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 50, -87, 5 ) 
SWEP.IconLookAt = Vector( 0, 0, 0 ) 
SWEP.IconFOV = 13

SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav";

   