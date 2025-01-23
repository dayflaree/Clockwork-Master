if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
end 
  	SWEP.HoldType = "pistol";
	
if( CLIENT ) then

	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.Primary.Sound = Sound( "weapons/pistol/pistol_fire3.wav" );

SWEP.PrintName = "HK USP";
SWEP.TS2Desc = ".45 Calibre Match Pistol";


SWEP.Price = 1000;

 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.HighPowered = false;
 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 12;
 SWEP.Primary.DefaultClip = 60;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .09;
 SWEP.Primary.Damage = 9;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( -5.7411, 3.8564, -12.9267 );
SWEP.Primary.IronSightAng = Vector( 0.9646, -1.2923, 1.3809 );
   
SWEP.Primary.HolsteredPos = Vector( 1.9673, -6.8455, -13.966 );
SWEP.Primary.HolsteredAng = Vector( 32.9939, 0, -3.1862 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( -100, 30, 0 )   
SWEP.IconLookAt = Vector( 3, -1, -1 ) 
SWEP.IconFOV = 7

SWEP.ReloadSound = "";