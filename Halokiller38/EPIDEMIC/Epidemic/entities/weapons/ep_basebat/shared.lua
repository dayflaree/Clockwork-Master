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


SWEP.ViewModel      = "models/weapons/melee/v_bat.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_bat.mdl"

SWEP.PrintName = "Baseball Bat";
SWEP.EpiDesc = "Used for hitting baseballs.";

SWEP.Primary.Damage			= 38

SWEP.EpiHoldType = "FIST";

SWEP.Primary.AmmoType = -1;

SWEP.DegradeAmt 			= 2;
SWEP.HealthAmt 				= 100;

SWEP.Primary.IronSightPos = Vector( 0, 0, -9.22 );
SWEP.Primary.IronSightAng = Angle( 30.23, 0, -0 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth = 4;
SWEP.ItemHeight = 1;

SWEP.Tier = 2;

SWEP.Primary.Delay = 1;

SWEP.IconCamPos = Vector( 0, -200, 0 ) 
SWEP.IconLookAt = Vector( 0, 0, 16 ) 
SWEP.IconFOV = 10
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 50;
SWEP.NicePhrase = "a baseball bat";
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

	"weapons/necropolis/basebat/bat_impact_world1.wav",
	"weapons/necropolis/basebat/bat_impact_world2.wav",

}

SWEP.HitBodSounds =
{

	"weapons/necropolis/basebat/melee_cricket_bat_01.wav",
	"weapons/necropolis/basebat/melee_cricket_bat_02.wav",
	"weapons/necropolis/basebat/melee_cricket_bat_03.wav",

}

SWEP.HitBodVol_Low = 75;
SWEP.HitBodVol_High = 80;

SWEP.Anims =
{

	ACT_VM_HITCENTER,
	ACT_VM_HITLEFT,
	ACT_VM_HITRIGHT,

}
   