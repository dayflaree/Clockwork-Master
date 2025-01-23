if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 

end 

 	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.ViewModel			= "models/weapons/v_smg_m_93r.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_m_93r.mdl"
SWEP.Primary.Sound			= Sound("Weapon_usp.Single")

SWEP.PrintName = "M93R Autoloader";
SWEP.TS2Desc = "Millitary Automatic Sidearm";

SWEP.Price = 4500;

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
 SWEP.Primary.Damage = 5;
 SWEP.Primary.Automatic = true;
 
 SWEP.TS2HoldType = "PISTOL";

 SWEP.Primary.SpreadCone = Vector( .04, .04, .04 );

SWEP.Primary.IronSightPos = Vector( 1.626, 1.2307 , 0 );
SWEP.Primary.IronSightAng = Vector( 0 , 0 , 0 );
 
   
SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 15.0, 0.0 );
   
SWEP.ItemWidth = 1;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 14, -46, 7 )  
SWEP.IconLookAt = Vector( 5, 8, 0 )
SWEP.IconFOV = 18
