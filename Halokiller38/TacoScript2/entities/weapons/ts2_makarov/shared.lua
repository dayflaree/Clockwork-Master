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
   


SWEP.WorldModel = "models/weapons/w_makaro.mdl";
SWEP.ViewModel = "models/weapons/v_makaro.mdl";

SWEP.PrintName = "Makarov Pistol";
SWEP.TS2Desc = "Russian Millitary Standard Issue";

SWEP.Price = 1200;

 SWEP.Primary.Recoil			= .1
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.Sound = Sound( "Weapons/fiveseven/fiveseven-1.wav" );

 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 8;
 SWEP.Primary.DefaultClip = 80;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .09;
 SWEP.Primary.Damage = 8;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( -3.7956, 2.5957, -5.9375  );
SWEP.Primary.IronSightAng = Vector( 0 , 0 , 0 );
   
SWEP.Primary.HolsteredPos = Vector( 0.5946, 3.5118, -6.7105  );
SWEP.Primary.HolsteredAng = Vector( -24.903,  -8.167, 10.7103 );
   

SWEP.IconCamPos = Vector( -100, 30, 0 )   
SWEP.IconLookAt = Vector( 3, -1, -1 ) 
SWEP.IconFOV = 7

SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.ReloadSound = "";