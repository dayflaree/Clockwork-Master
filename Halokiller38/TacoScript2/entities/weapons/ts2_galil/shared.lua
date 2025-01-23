
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
   
SWEP.Primary.Sound = Sound( "Weapons/fal.wav" );

SWEP.WorldModel = "models/weapons/w_rif_galil.mdl";
SWEP.ViewModel = "models/weapons/v_rif_galil.mdl";

SWEP.PrintName = "Israeli Galil Rifle";
SWEP.TS2Desc = "Israeli Millitary Issue Rifle";

SWEP.Price = 4000;

 SWEP.Primary.Recoil			= .4 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 12
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 150;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .03, .03, .03 );
SWEP.Primary.ReloadDelay = 2.3;

SWEP.Primary.IronSightPos = Vector( -5.1383, 2.2242, -8.8488 );
SWEP.Primary.IronSightAng = Vector( 0.0724, 0, 0.1386 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 94, -200, 7 ) 
SWEP.IconLookAt = Vector( -51, 154, -3 ) 
SWEP.IconFOV = 5;

SWEP.ReloadSound = "";


   