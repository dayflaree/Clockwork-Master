
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "pistol";

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.ViewModelFlip		= true;

SWEP.Primary.Sound = Sound( "Weapons/silenced.wav" );

SWEP.ViewModel			= "models/weapons/v_mp9_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_mp9.mdl"

SWEP.PrintName = "MP9";
SWEP.TS2Desc = "Silenced MP9 TMP";

SWEP.Price = 3800;


 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .3
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 8 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "PISTOL";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 200;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .07;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.02, 0.02, 0.02 );

 SWEP.Primary.IronSightPos = Vector( 2.6112,  2.0278, -4.8015 );
 SWEP.Primary.IronSightAng = Vector( 0, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 50, -87, 5 ) 
SWEP.IconLookAt = Vector( 0, 0, 0 ) 
SWEP.IconFOV = 13

SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav";

   