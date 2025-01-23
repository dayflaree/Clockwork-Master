
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 

  	SWEP.HoldType = "pistol";
	
 SWEP.Base = "ts2_base_shotgun";
 	SWEP.ViewModelFlip		= true;	  
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.ViewModel			= "models/weapons/v_shot_strike.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_strike.mdl"
SWEP.Primary.Sound			= Sound("weapons/ar2/npc_ar2_altfire.wav")

SWEP.PrintName = "Striker Riot Shotgun";
SWEP.TS2Desc = "Drum-Mag Combat Shotgun";

SWEP.Price = 4500;


SWEP.ShotgunReload = true;

 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = 1
 
 SWEP.Primary.ViewPunchMul = 20;
 SWEP.Primary.Damage			= 8
 SWEP.Primary.NumShots		= 12 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 12;
SWEP.Primary.DefaultClip = 60;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 0.9;
SWEP.Primary.Automatic = false;
SWEP.Primary.SpreadCone = Vector( .05, .05, .05 );
SWEP.Primary.Spread =  Vector( .04, .04, .04);

 SWEP.Primary.IronSightPos = Vector( 3.8113, 3.3059, 0 );
 SWEP.Primary.IronSightAng = Vector( -1.8785, 3.2049, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;


SWEP.IconCamPos = Vector( 8, 58, 50 ) 
SWEP.IconLookAt = Vector( 1, 0, 0 ) 
SWEP.IconFOV = 12

   