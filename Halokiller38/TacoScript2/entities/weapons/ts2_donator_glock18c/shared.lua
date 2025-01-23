if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 
 
end 

 	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.Primary.Sound = Sound( "Weapons/silenced.wav" );
SWEP.WorldModel = "models/weapons/w_smg_glc18.mdl";
SWEP.ViewModel = "models/weapons/v_smg_glc18.mdl";


SWEP.Price = 1200;

SWEP.PrintName = "Glock 18C";
SWEP.TS2Desc = "Donator Weapon";

 SWEP.Primary.Recoil			= .1
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 SWEP.Primary.RecoverTime = .4


 SWEP.Primary.NumShots		= 1 
 SWEP.Primary.ClipSize = 30;
 SWEP.Primary.DefaultClip = 120;
 SWEP.Primary.Ammo = "pistol";
 SWEP.Primary.Delay = .08;
 SWEP.Primary.Damage = 6;
 SWEP.Primary.Automatic = true;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( 2.5548,  1.6568 , -3.9373 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );
 
   
SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 0.0, 15.0 );
   
SWEP.ItemWidth = 2;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 3, 8, 0 )
SWEP.IconFOV = 18

SWEP.ReloadSound = "";