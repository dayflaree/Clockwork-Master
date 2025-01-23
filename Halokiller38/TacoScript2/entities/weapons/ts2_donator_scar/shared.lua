
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

SWEP.WorldModel = "models/weapons/w_scarif.mdl";
SWEP.ViewModel = "models/weapons/v_scarif.mdl";

SWEP.PrintName = "SCAR Assault Rifle";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 11000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 9
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 90;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 

SWEP.Primary.IronSightPos = Vector( -4.3058, 0.0737, -8.7806 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 105, 0 ) 
SWEP.IconLookAt = Vector( 7, 0, 1 )
SWEP.IconFOV = 10;

SWEP.ReloadSound = "";


   