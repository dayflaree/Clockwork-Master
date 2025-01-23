
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
   
SWEP.Primary.Sound = Sound( "npc/strider/strider_minigun.wav" );

SWEP.ViewModel			= "models/weapons/v_binachi_rifle.mdl"
SWEP.WorldModel			= "models/weapons/w_bianchi.mdl"

SWEP.PrintName = "Binachi FA-6";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 20000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 100;
SWEP.Primary.DefaultClip = 400;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.Primary.IronSightPos = Vector( -4.5747, 2.2365, -5.047 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

 SWEP.ItemWidth = 4;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, -157, 0 ) 
SWEP.IconLookAt = Vector( 5, 0, 0 ) 
SWEP.IconFOV = 6


SWEP.ReloadSound = "";


   