
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFlip		= false
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "Weapons/rifle.wav" );

SWEP.ViewModel			= "models/weapons/v_rif_lr300.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_lr300.mdl"

SWEP.PrintName = "LR-300 Rifle";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 12000;

 SWEP.Primary.Recoil			= .2 
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
 
SWEP.Primary.IronSightPos = Vector( -3.817, 1.7026, -6.0063 );
SWEP.Primary.IronSightAng = Vector( -0.0918, 0, 0.1632 ); 
 
SWEP.Primary.HolsteredPos = Vector( -0.9938, -4.0558, 0.4117 );
SWEP.Primary.HolsteredAng = Vector( -11.0076, -47.7384, 10.586 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 108, 48 ) 
SWEP.IconLookAt = Vector( 3, 45, 21 ) 
SWEP.IconFOV = 7


SWEP.ReloadSound = "";


   