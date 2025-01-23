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

SWEP.ViewModel				= "models/weapons/v_snip_awp.mdl";
SWEP.WorldModel				= "models/weapons/w_snip_awp.mdl";

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" );

SWEP.PrintName 				= "AI AWP";
SWEP.EpiDesc 				= "Sniper rifle";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 20;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "RIFLE";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 53

SWEP.Primary.MaxAmmoClip 	= 10;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.0, 0.0, 0.0 );
SWEP.Primary.ReloadDelay 	= 2.75;

SWEP.Primary.IronSightPos = Vector( 5.59, 2.08, -6.64 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 14, 0, 1 )
SWEP.IconFOV		= 11
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an AWP";
SWEP.HeavyWeight 	= true;

SWEP.Scoped = true;
SWEP.Zoom = 15;
SWEP.VariableZoom = true;
