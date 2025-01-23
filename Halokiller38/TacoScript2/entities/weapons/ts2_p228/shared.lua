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
   


SWEP.ViewModel			= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"
SWEP.Primary.Sound			= Sound("Weapons/P228/p228-1.wav")

SWEP.PrintName = "Sig p228";
SWEP.TS2Desc = "Modern 9MM Pistol";

SWEP.Price = 1200;

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
 SWEP.Primary.Damage = 8;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( 4.7663, 2.9179, -4.4479 );
SWEP.Primary.IronSightAng = Vector( -0.5786, 0.0153, 0.4948 );
   
SWEP.Primary.HolsteredPos = Vector( 0.8931,  -1.5349, -7.9634  );
SWEP.Primary.HolsteredAng = Vector( 35.3605, 0, 4.9116 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 3, 8, 0 )
SWEP.IconFOV = 18

SWEP.ReloadSound = "";