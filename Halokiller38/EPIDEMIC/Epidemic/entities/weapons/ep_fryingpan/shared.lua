if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" )
 
 end 

 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   
if( CLIENT ) then

	SWEP.DrawCrosshair = false;

end

SWEP.HoldType = "pistol";


SWEP.ViewModel      = "models/weapons/melee/v_frying_pan.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_frying_pan.mdl"

SWEP.PrintName = "Frying Pan";
SWEP.EpiDesc = "Make bacon.";

SWEP.Primary.Damage			= 38

SWEP.EpiHoldType = "FIST";

SWEP.Primary.AmmoType = -1;

SWEP.DegradeAmt 			= 2;
SWEP.HealthAmt 				= 100;

SWEP.Primary.IronSightPos = Vector( 0, 0, -4.06 );
SWEP.Primary.IronSightAng = Angle( 34.55, -10.64, -9.61 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth = 2;
SWEP.ItemHeight = 2;

SWEP.Tier = 2;

SWEP.Primary.Delay = 1;

SWEP.IconCamPos = Vector( 0, -200, 0 ) 
SWEP.IconLookAt = Vector( 0, 0, 7 ) 
SWEP.IconFOV = 7
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 50;
SWEP.NicePhrase = "a frying pan";
SWEP.HeavyWeight = true;
SWEP.Melee = true;

SWEP.L4D = true;

SWEP.SwingSounds =
{

	"weapons/necropolis/basebat/swing_miss1.wav",
	"weapons/necropolis/basebat/swing_miss2.wav",

}

SWEP.HitWorldSounds =
{

	"weapons/necropolis/fryingpan/pan_impact_world1.wav",
	"weapons/necropolis/fryingpan/pan_impact_world2.wav",
	"weapons/necropolis/fryingpan/pan_impact_world3.wav",

}

SWEP.HitWorldVol_Low = 75;
SWEP.HitWorldVol_High = 75;

SWEP.HitBodSounds =
{

	"weapons/necropolis/fryingpan/melee_frying_pan_01.wav",
	"weapons/necropolis/fryingpan/melee_frying_pan_02.wav",
	"weapons/necropolis/fryingpan/melee_frying_pan_03.wav",
	"weapons/necropolis/fryingpan/melee_frying_pan_04.wav",

}

SWEP.HitBodVol_Low = 75;
SWEP.HitBodVol_High = 80;

SWEP.Anims =
{

	ACT_VM_HITLEFT,
	ACT_VM_PRIMARYATTACK,

}
   