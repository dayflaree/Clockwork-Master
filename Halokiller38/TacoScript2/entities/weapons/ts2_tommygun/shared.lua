
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";
 
if( CLIENT ) then
	
	SWEP.CSMuzzleFlashes	= true;
	SWEP.ViewModelFlip		= false;	
	SWEP.ViewModelFOV		= 60;	
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Price = 100;

SWEP.Primary.Sound = Sound( "Weapons/usp/usp_unsil-1.wav" );

SWEP.ViewModel			= "models/weapons/v_tommy_gun.mdl"
SWEP.WorldModel			= "models/weapons/w_thompsonm1a1.mdl"

SWEP.PrintName = "Thompson M1A1";
SWEP.TS2Desc = "World War 2 / 'Nam Era SMG";


 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 6 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 180;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

SWEP.Primary.IronSightPos   = Vector(-3.9476, 2.6243, -3.9129);
SWEP.Primary.IronSightAng   = Vector(0.2824, 0, 0.1465);

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 15, -108, 0 ); 
SWEP.IconLookAt = Vector( 5, 20, 4 ); 
SWEP.IconFOV = 12

SWEP.ReloadSound = "";

   