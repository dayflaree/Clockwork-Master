
if( SERVER ) then
   
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
   
SWEP.Primary.Sound = Sound( "Weapons/famas/famas-1.wav" );

SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl";
SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl";

SWEP.PrintName = "M4 Rifle";
SWEP.TS2Desc = "US Millitary Standard Issue Carbine";

SWEP.Price = 4500;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 10
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 150;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

SWEP.Primary.IronSightPos = Vector( 6.05, 1.1, 1 );
SWEP.Primary.IronSightAng = Vector( 2.2, 1.4, 4 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 11, 7, 2 );
SWEP.IconFOV = 7;

SWEP.ReloadSound = "";


   