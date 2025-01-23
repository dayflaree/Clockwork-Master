
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
   


SWEP.Primary.Sound = Sound( "Weapons/usp/usp_unsil-1.wav" );

SWEP.WorldModel = "models/weapons/w_smg2.mdl";
SWEP.ViewModel = "models/weapons/v_smg2.mdl";

SWEP.PrintName = "MP5K";
SWEP.TS2Desc = "Compact MP5 for CQB and crew use";

SWEP.Price = 3800;


 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 8 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 32;
SWEP.Primary.DefaultClip = 64;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

SWEP.Primary.IronSightPos   = Vector( -6.435, 2.55, -11 );
SWEP.Primary.IronSightAng   = Vector( 0, 0, 0 );


SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 50, -107, 5 ) 
SWEP.IconLookAt = Vector( 0, 0, 0 ) 
SWEP.IconFOV = 13

SWEP.ReloadSound = "";

   