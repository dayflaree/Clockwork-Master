if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
end 

 	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	SWEP.ViewModelFOV = 50
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.ViewModel			= "models/weapons/v_zistol.mdl"
SWEP.WorldModel			= "models/weapons/w_zistol.mdl"
SWEP.Primary.Sound			= Sound("Weapons/usp/usp_unsil-1.wav")

SWEP.PrintName = "SOCOM .45";
SWEP.TS2Desc = "Modern Specops Sidearm";

SWEP.Price = 1600;

 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.HighPowered = false;
 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 16;
 SWEP.Primary.DefaultClip = 60;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .09;
 SWEP.Primary.Damage = 9;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( -3.8844, 2.1651, -9.8495 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );
   
SWEP.Primary.HolsteredPos = Vector( 0.8931,  -1.5349, -7.9634  );
SWEP.Primary.HolsteredAng = Vector( 35.3605, 0, 4.9116 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 3, 8, 0 )
SWEP.IconFOV = 18

SWEP.ReloadSound = "";