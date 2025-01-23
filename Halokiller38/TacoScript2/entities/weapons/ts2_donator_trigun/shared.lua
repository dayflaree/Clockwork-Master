 if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

 	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFlip		= true
	SWEP.DrawCrosshair = false;
	
 end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.ViewModel			= "models/weapons/v_azn_trigund.mdl"
SWEP.WorldModel			= "models/weapons/w_azn_trigund.mdl"
SWEP.Primary.Sound			= Sound("weapons/ar2/npc_ar2_altfire.wav")

SWEP.PrintName = "Trigun";
SWEP.TS2Desc = "Snap-Barrel Magnum";

SWEP.Price = 8500;

 SWEP.Primary.Recoil			= .3
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .8
 SWEP.Primary.RecoverTime = .3


 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 6;
 SWEP.Primary.DefaultClip = 60;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = 1;
 SWEP.Primary.Damage = 20;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos 	= Vector( 6.6029, 3.2358, -8.072 )
SWEP.Primary.IronSightAng 	= Vector( 0.8956, 0, -0.144 )
 
   
SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 15.0, 0.0 );
   
SWEP.ItemWidth = 2;
SWEP.ItemHeight = 2;
 
SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 3, 8, 0 )
SWEP.IconFOV = 18
   
  SWEP.ReloadSound = "";