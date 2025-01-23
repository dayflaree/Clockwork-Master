
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
   
SWEP.Primary.Sound = Sound( "weapons/k98_shoot2.wav" );

SWEP.ViewModel			= "models/weapons/v_rif_fnfal.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_fnfal.mdl"

SWEP.PrintName = "FN FAL Rifle";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 20000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 13
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 120;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .12;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .01, .01, .01 );
SWEP.Primary.ReloadDelay = 2.3;
 

SWEP.Primary.IronSightPos = Vector( -3.1657, 1.2841, -4.2601 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 105, 0 ) 
SWEP.IconLookAt = Vector( 7, 0, 1 )
SWEP.IconFOV = 10;

SWEP.ReloadSound = "";


   