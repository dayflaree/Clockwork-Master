
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
  SWEP.ViewModelFlip		= true    
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "Weapons/usp/usp_unsil-1.wav" );

SWEP.WorldModel = "models/weapons/w_scar.mdl";
SWEP.ViewModel = "models/weapons/v_scar.mdl";

SWEP.PrintName = "SCAR-MOD Compact";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 12500;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 180;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 

SWEP.Primary.IronSightPos = Vector( 2.9876, 0.5766, -5.5041 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( -1.0781, -0.9194, -3.7345  );
SWEP.Primary.HolsteredAng = Vector( -15.7989, 16.7488, -58.2352  );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 105, 0 ) 
SWEP.IconLookAt = Vector( 7, 0, 1 )
SWEP.IconFOV = 10;

SWEP.ReloadSound = "";


   