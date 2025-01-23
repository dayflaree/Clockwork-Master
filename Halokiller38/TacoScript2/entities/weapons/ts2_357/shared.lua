 if ( SERVER ) then 
   
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
   


SWEP.WorldModel = "models/weapons/w_357.mdl";
SWEP.ViewModel = "models/weapons/v_357.mdl";

SWEP.PrintName = "Magnum .357";
SWEP.TS2Desc = "A standard revolver";


SWEP.Price = 3500;

 SWEP.Primary.Recoil			= .4
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .8
 SWEP.Primary.RecoverTime = .3

 SWEP.Primary.Sound = Sound( "Weapon_357.Single" );

 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 6;
 SWEP.Primary.DefaultClip = 24;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = 1;
 SWEP.Primary.Damage = 11;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos 	= Vector( -5.625, 2.55, 0 )
SWEP.Primary.IronSightAng 	= Vector( .385, 0, 1 )
 
   
SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 15.0, 0.0 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;
 
SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 4, 8, 0 )
SWEP.IconFOV = 18
   
  SWEP.ReloadSound = "";