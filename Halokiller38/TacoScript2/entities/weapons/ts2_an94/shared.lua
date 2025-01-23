
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 

  	SWEP.HoldType = "pistol";
 
if( CLIENT ) then

	
	SWEP.ViewModelFlip		= false	
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "Weapons/sg550/sg550-1.wav" );

SWEP.WorldModel = "models/weapons/w_rif_an94.mdl";
SWEP.ViewModel = "models/weapons/v_rif_an94k.mdl";

SWEP.PrintName = "AN-94 Rifle";
SWEP.TS2Desc = "Advanced Russian Rifle";

SWEP.Price = 3400;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 4;
 SWEP.Primary.Damage			= 14
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = true;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 160;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
 SWEP.Primary.ReloadDelay = 2.3;
 
 SWEP.Primary.IronSightPos = Vector( -4.0231, 2.4265, -4.9019 );
 SWEP.Primary.IronSightAng = Vector( -1.0299, 0, -0.1072 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 11, 7, -1 );
SWEP.IconFOV = 7;

SWEP.ReloadSound = "";


   