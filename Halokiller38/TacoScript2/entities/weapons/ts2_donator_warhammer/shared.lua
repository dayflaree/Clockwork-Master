
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 	SWEP.HoldType = "pistol";
 
 SWEP.Base = "ts2_base_shotgun";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   	SWEP.ViewModelFlip		= true;
SWEP.ViewModel			= "models/weapons/v_shot_warham.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_warham.mdl"
SWEP.Primary.Sound			= Sound( "Weapons/warhammer.wav" )

SWEP.PrintName = "Warhammer Assault Shotgun";
SWEP.TS2Desc = "Heavy Duty Terminator Beastage Kit";

SWEP.Price = 12000;

SWEP.ShotgunReload = true;

 SWEP.Primary.Recoil			= .4
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = 1
 
 SWEP.Primary.ViewPunchMul = 70;
 SWEP.Primary.Damage			= 24
 SWEP.Primary.NumShots		= 12 
 
 SWEP.TS2HoldType = "SHOTGUN";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 20;
SWEP.Primary.DefaultClip = 160;
SWEP.Primary.Ammo = "buckshot";
SWEP.Primary.Delay = 0.4;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
SWEP.Primary.Spread =  Vector( .04, .04, .04);

 SWEP.Primary.IronSightPos = Vector( 2.0243, 0.6977, -6.8995 );
 SWEP.Primary.IronSightAng = Vector( 0, 0, -0.0928 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;


SWEP.IconCamPos = Vector( 8, 58, 50 ) 
SWEP.IconLookAt = Vector( 1, 0, 0 ) 
SWEP.IconFOV = 12

   