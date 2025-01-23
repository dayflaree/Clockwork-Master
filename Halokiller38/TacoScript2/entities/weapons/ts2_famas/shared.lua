
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
 	SWEP.HoldType = "pistol";
	
if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true;
	SWEP.ViewModelFlip	= false	;
	SWEP.ViewModelFOV		= 83;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "weapons/kriss.wav" );

SWEP.WorldModel = "models/weapons/w_rif_famas.mdl";
SWEP.ViewModel = "models/weapons/v_rif_famas.mdl";

SWEP.PrintName = "Famas";
SWEP.TS2Desc = "French Millitary Standard Issue Rifle";

SWEP.Price = 4500;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 8
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

SWEP.Primary.IronSightPos = Vector(-4.6397, 1.1646, -3.3678 );
SWEP.Primary.IronSightAng = Vector(0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 94, -31, 4 );
SWEP.IconLookAt = Vector( -200, 51, -14 );
SWEP.IconFOV = 12;

SWEP.ReloadSound = "";


   