
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

SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl";
SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl";

SWEP.PrintName = "HK MP5";
SWEP.TS2Desc = "High Quality Modern SMG";

SWEP.Price = 3900;


 SWEP.Primary.Recoil			= .1 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 7 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 32;
SWEP.Primary.DefaultClip = 64;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .09;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

SWEP.Primary.IronSightPos   = Vector(4.748, 1.8997, -6.8103);
SWEP.Primary.IronSightAng   = Vector(1.3693, 0, -0.0779);

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 15, -108, 0 ); 
SWEP.IconLookAt = Vector( 5, 20, 4 ); 
SWEP.IconFOV = 12

SWEP.ReloadSound = "";

   