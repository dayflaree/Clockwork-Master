
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.ViewModelFlip		= true		
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV 		= 60;	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
 SWEP.Primary.Sound = Sound( "Weapons/fal.wav" ); 

SWEP.ViewModel			= "models/weapons/v_m14.mdl"
SWEP.WorldModel			= "models/weapons/w_m14.mdl"

SWEP.PrintName = "M14 EBR-MOD";
SWEP.TS2Desc = "Donator weapon";


SWEP.Price = 12000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 22
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 120;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 0.09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .001, .001, .001 );
 SWEP.Primary.ReloadDelay = 2;
 
SWEP.Primary.IronSightPos = Vector( 5.0363, 0.9078, -7.4349 );
SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 2;

SWEP.IconCamPos = Vector( 49, -200, 200 );
SWEP.IconLookAt = Vector( 14, 5, 7 ) 
SWEP.IconFOV = 7;

SWEP.HUDAmmo = "556x45mm";
SWEP.IsPrimary = true;
SWEP.Stock = 4;
SWEP.Price = 12500;

