
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

SWEP.WorldModel = "models/weapons/w_rif_g36f.mdl";
SWEP.ViewModel = "models/weapons/v_rif_g36c.mdl";

SWEP.PrintName = "G36C";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 10000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .5
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 9
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 90;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
 SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.IronSightPos = Vector( 5.9647, 2.0889, -5.2693 );
SWEP.Primary.IronSightAng = Vector(-0.8609, 0, -0.2417 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 200, 78, 6 ) 
SWEP.IconLookAt = Vector( 19, 5, -1 ) 
SWEP.IconFOV = 5;

SWEP.ReloadSound = "";


   