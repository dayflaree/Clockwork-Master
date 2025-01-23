
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

SWEP.ViewModel			= "models/weapons/v_mosin.mdl"
SWEP.WorldModel			= "models/weapons/w_mosin.mdl"

SWEP.PrintName = "Mosin Rifle";
SWEP.TS2Desc = "Ancient battle rifle";

SWEP.Price = 4500;

 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 40
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 5;
SWEP.Primary.DefaultClip = 50;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .6;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .001, .001, .001 );
SWEP.Primary.ReloadDelay = 2.3;
 

SWEP.Primary.IronSightPos = Vector( -5.0069, 1.9907, -8.818  );
SWEP.Primary.IronSightAng = Vector( 1.6526, 1.8193, -3.7435 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 105, 0 ) 
SWEP.IconLookAt = Vector( 7, 0, 1 )
SWEP.IconFOV = 10;

SWEP.ReloadSound = "";


   