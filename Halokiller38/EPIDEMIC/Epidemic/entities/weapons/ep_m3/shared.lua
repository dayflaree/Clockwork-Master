if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" );
	
end 

SWEP.Base = "ep_base";

SWEP.Spawnable			= false;
SWEP.AdminSpawnable		= false;

if( CLIENT ) then
	
	SWEP.ViewModelFlip = true;
	SWEP.DrawCrosshair = false;

end

SWEP.ViewModel				= "models/weapons/v_shot_m3super90.mdl";
SWEP.WorldModel				= "models/weapons/w_shot_m3super90.mdl";

SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" );

SWEP.PrintName 				= "M3 Super 90";
SWEP.EpiDesc 				= "Shotgun";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 8;

SWEP.EpiHoldType 			= "SHOTGUN";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 8;
SWEP.Primary.AmmoString 	= " 18mm rounds";
SWEP.Primary.AmmoType 		= 2;
SWEP.Primary.Delay 			= 0.833;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.08, 0.08, 0.08 );
SWEP.ShotgunReload 			= true;

SWEP.Primary.IronSightPos 	= Vector( 5.73, 3.2, -0.9 );
SWEP.Primary.IronSightAng 	= Angle( 0, 0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.BreaksDoors = true;

SWEP.MuzzleDepth 	= 30;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 10, 0, 2 ) 
SWEP.IconFOV		= 8
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M3";
SWEP.HeavyWeight 	= true;
