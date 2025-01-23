
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";
	
if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	SWEP.DrawCrosshair = false;

end

 	SWEP.ViewModelFlip		= true
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound			= Sound( "weapons/riflecrack.wav" )

SWEP.ViewModel			= "models/weapons/v_rif_tar.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_tar.mdl"

SWEP.PrintName = "TAR 21";
SWEP.TS2Desc = "Donator Weapon";

SWEP.Price = 12000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .4
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 12
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 120;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;

SWEP.Primary.IronSightPos = Vector( 3.4498,  0.9548, -4.9258 );
SWEP.Primary.IronSightAng = Vector(0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 94, -31, 4 );
SWEP.IconLookAt = Vector( -200, 51, -14 );
SWEP.IconFOV = 12;

SWEP.ReloadSound = "";


   