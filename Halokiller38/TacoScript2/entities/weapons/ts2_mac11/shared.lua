
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
   


SWEP.Primary.Sound = Sound( "Weapons/usp/usp_unsil-1.wav" );

SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl";
SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl";

SWEP.PrintName = "Mac 11";
SWEP.TS2Desc = "A small sub-machine gun";

SWEP.Price = 3800;


 SWEP.Primary.Recoil			= .2
 SWEP.Primary.RecoilAdd			= .2
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 6 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 32;
SWEP.Primary.DefaultClip = 130;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .06;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

SWEP.Primary.IronSightPos = Vector(6.5197, 2.933, -4.5831);
SWEP.Primary.IronSightAng = Vector(0.5993, 5.3269, 8.7508);


SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 2;

SWEP.IconCamPos = Vector( 5, -86, 5 ) 
SWEP.IconLookAt = Vector( 6, 0, 0 ) 
SWEP.IconFOV = 14

SWEP.ReloadSound = "";

   