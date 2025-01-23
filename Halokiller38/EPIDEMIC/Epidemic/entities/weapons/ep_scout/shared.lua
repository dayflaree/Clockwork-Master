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

SWEP.ViewModel				= "models/weapons/v_snip_scout.mdl";
SWEP.WorldModel				= "models/weapons/w_snip_scout.mdl";

SWEP.Primary.Sound			= Sound( "Weapon_Scout.Single" );

SWEP.PrintName 				= "Steyr Scout";
SWEP.EpiDesc 				= "Sniper rifle";

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

SWEP.MuzzleDepth 			= 53

SWEP.Primary.MaxAmmoClip 	= 10;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 1.286;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 2.486;

SWEP.Primary.IronSightPos = Vector( 4.99, 2.48, -10.29 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 12, 0, 2 )
SWEP.IconFOV		= 9
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a scout";
SWEP.HeavyWeight 	= true;

SWEP.Scoped = true;
SWEP.VariableZoom = true;
