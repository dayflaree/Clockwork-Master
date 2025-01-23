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

SWEP.ViewModel				= "models/weapons/v_rif_m4a1.mdl";
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl";

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Single" );

SWEP.PrintName 				= "M4A1";
SWEP.EpiDesc 				= "Silenced carbine";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "RIFLE";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 30

SWEP.Primary.MaxAmmoClip 	= 30;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 0.075;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 3.054;

SWEP.Primary.IronSightPos = Vector( 5.92, 0.98, -2.01 );
SWEP.Primary.IronSightAng = Angle( 3, 1.27, 3.73 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 12, 0, 2 ) 
SWEP.IconFOV		= 9
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M4A1";
SWEP.HeavyWeight 	= true;
