
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "weapons/kriss.wav" );

SWEP.WorldModel = "models/weapons/w_smg4.mdl";
SWEP.ViewModel = "models/weapons/v_smg4.mdl";

SWEP.PrintName = "M4 RIS Rifle";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 6000;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 9
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = true;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 400;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.Primary.IronSightPos = Vector( -4.1842, 1.5686 , -8.1373 );
SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 3, -45, -10 ) 
SWEP.IconLookAt = Vector( 1, -7, -2 )
SWEP.IconFOV = 20;




   