
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFlip		= true
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "Weapons/rifle.wav" );

SWEP.ViewModel			= "models/weapons/v_rif_rtak.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_rtak.mdl"

SWEP.PrintName = "R-TAK Rifle";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 12000;

 SWEP.Primary.Recoil			= .3 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 120;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.IronSightPos = Vector( 2.9184, 0.879, -5.6825 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 ); 
 
SWEP.Primary.HolsteredPos = Vector( -0.9938, -4.0558, 0.4117 );
SWEP.Primary.HolsteredAng = Vector( -11.0076, -47.7384, 10.586 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 200, 61, 17 ) 
SWEP.IconLookAt = Vector( 0, 2, -2 ) 
SWEP.IconFOV = 6


SWEP.ReloadSound = "";


   