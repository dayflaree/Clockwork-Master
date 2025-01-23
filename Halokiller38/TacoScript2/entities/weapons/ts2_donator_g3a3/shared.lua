
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

SWEP.ViewModel			= "models/weapons/v_g3a_rifle.mdl"
SWEP.WorldModel			= "models/weapons/w_g3a3_rif.mdl"

SWEP.PrintName = "G3A3 Rifle";
SWEP.TS2Desc = "Donator weapon";


SWEP.Price = 9500;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 14
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
 

SWEP.Primary.IronSightPos = Vector( -2.4417, 2.0743, -3.7113  );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, -153, 31 ) 
SWEP.IconLookAt = Vector( 0, 18, -5 ) 
SWEP.IconFOV = 6


SWEP.ReloadSound = "";


   