
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 
 
  	SWEP.HoldType = "pistol";
 
if( CLIENT ) then
	
	SWEP.CSMuzzleFlashes	= true;
	SWEP.ViewModelFlip		= true;	
	SWEP.ViewModelFOV		= 60;	
	SWEP.DrawCrosshair = false;

end

 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   


SWEP.Primary.Sound = Sound( "Weapons/mp5navy/mp5-1.wav" );

SWEP.ViewModel			= "models/weapons/v_mp40smg.mdl"
SWEP.WorldModel			= "models/weapons/w_mp_40.mdl"

SWEP.PrintName = "MP40";
SWEP.TS2Desc = "World War 2 Relic";

SWEP.Price = 4000;


 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = .5;
 SWEP.Primary.Damage			= 7 
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 180;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( 0.03, 0.03, 0.03 );

SWEP.Primary.IronSightPos   = Vector(3.3938, 2.6628, -3.3569);
SWEP.Primary.IronSightAng   = Vector(2.6326, 0, -0.0459);

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 15, -108, 0 ); 
SWEP.IconLookAt = Vector( 5, 20, 4 ); 
SWEP.IconFOV = 12

SWEP.ReloadSound = "";

   