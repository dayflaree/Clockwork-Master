if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
end 

 	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   

SWEP.Price = 1500;

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"
SWEP.Primary.Sound			= Sound("Weapons/deagle/deagle-1.wav")

SWEP.PrintName = "Desert Eagle";
SWEP.TS2Desc = "Huge 50.cal Pistol";

 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4

 SWEP.Primary.HighPowered = true;
 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 8;
 SWEP.Primary.DefaultClip = 32;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .09;
 SWEP.Primary.Damage = 20;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( 5.142, 2.6068, -2.629 );
SWEP.Primary.IronSightAng = Vector( 0 , 0 , 0 );
   
SWEP.Primary.HolsteredPos = Vector( 0.8931,  -1.5349, -7.9634  );
SWEP.Primary.HolsteredAng = Vector( 35.3605, 0, 4.9116 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 2, -114, 7 ) 
SWEP.IconLookAt = Vector( 7, 5, 2 ) 
SWEP.IconFOV = 7

SWEP.ReloadSound = "";