
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

  	SWEP.HoldType = "pistol";
 
 SWEP.Base = "ts2_base_shotgun";
 
if( CLIENT ) then

	SWEP.ViewModelFlip		= false;
	SWEP.CSMuzzleFlashes	= true;
end	

 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.ViewModel			= "models/weapons/v_boomstickyo.mdl"
SWEP.WorldModel			= "models/weapons/w_doublebarrel.mdl"
SWEP.Primary.Sound			= Sound( "Weapons/xm1014/XM1014-1.wav" )

SWEP.PrintName = "Double Barrelled Shotgun";
SWEP.TS2Desc = "And this.....is my BOOMSTICK!";

SWEP.Price = 1600;

SWEP.ShotgunReload = true;

 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = 1
 
 SWEP.Primary.ViewPunchMul = 20;
 SWEP.Primary.Damage			= 8
 SWEP.Primary.NumShots		= 12 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 2;
SWEP.Primary.DefaultClip = 30;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 0.9;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
SWEP.Primary.Spread =  Vector( .04, .04, .04);

 SWEP.Primary.IronSightPos = Vector( -2.75, 1.6548, -7.3008 );
 SWEP.Primary.IronSightAng = Vector( 0.5892, 0, -0.1397 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -2.0, -5.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 0.0, 50.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 26, 94, 50 ) 
SWEP.IconLookAt = Vector( 6, 6, 5 ) 
SWEP.IconFOV = 8

   