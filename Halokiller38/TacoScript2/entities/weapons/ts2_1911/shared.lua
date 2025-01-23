if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
end 

 	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end

 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 

SWEP.ViewModel = "models/weapons/v_191145.mdl";
SWEP.WorldModel = "models/weapons/w_191145.mdl";

SWEP.PrintName = "Colt 1911";
SWEP.TS2Desc = "Old .45 calibre pistol";

SWEP.Price = 1300;

 SWEP.Primary.Recoil			= .1
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.Sound = Sound( "Weapon_deagle.Single" );

 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 8;
 SWEP.Primary.DefaultClip = 32;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .09;
 SWEP.Primary.Damage = 10;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( -3.8418, 2.0622, -11.8965 );
SWEP.Primary.IronSightAng = Vector( 0 , 0 , 0 );
   
SWEP.Primary.HolsteredPos = Vector( 0.5946, 3.5118, -6.7105  );
SWEP.Primary.HolsteredAng = Vector( -24.903,  -8.167, 10.7103 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;
   
SWEP.IconCamPos = Vector( -100, 30, 0 )   
SWEP.IconLookAt = Vector( 3, -1, -1 ) 
SWEP.IconFOV = 7

SWEP.ReloadSound = "";