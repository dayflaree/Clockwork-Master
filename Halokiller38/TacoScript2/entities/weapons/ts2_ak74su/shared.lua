
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
   
SWEP.Primary.Sound = Sound( "Weapons/ak47/ak47-1.wav" );

SWEP.WorldModel = "models/weapons/w_rif_aksu.mdl";
SWEP.ViewModel = "models/weapons/v_rif_aksu.mdl";

SWEP.PrintName = "AK74SU";
SWEP.TS2Desc = "Russian Carbine Assault Rifle";

SWEP.Price = 3200;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .6
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 9
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 60;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.IronSightPos = Vector( 1.8815, 0.4966, -5.371 );
SWEP.Primary.IronSightAng = Vector( 0.2606, 0, -0.0918 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 6, 30, -1 );
SWEP.IconFOV = 7;

SWEP.ReloadSound = "";


   