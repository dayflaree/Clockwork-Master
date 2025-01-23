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

SWEP.ViewModel				= "models/weapons/v_smg_p90.mdl";
SWEP.WorldModel				= "models/weapons/w_smg_p90.mdl";

SWEP.Primary.Sound			= Sound( "Weapon_P90.Single" );

SWEP.PrintName 				= "FN P90";
SWEP.EpiDesc 				= "PDW";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "SMG";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 50;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 0.066;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 3.375;

SWEP.Primary.IronSightPos = Vector( 4.59, 1.95, -4.85 );
SWEP.Primary.IronSightAng = Angle( 0, -0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 3, 0, 2 ) 
SWEP.IconFOV		= 5
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a P90";
SWEP.HeavyWeight 	= true;
