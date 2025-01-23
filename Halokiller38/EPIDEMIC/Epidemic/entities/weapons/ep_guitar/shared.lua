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


SWEP.ViewModel      = "models/weapons/melee/v_electric_guitar.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_electric_guitar.mdl"

SWEP.PrintName = "Electric Guitar";
SWEP.EpiDesc = "Play concerts for your friends.";

SWEP.Primary.Damage			= 38

SWEP.EpiHoldType = "FIST";

SWEP.Primary.AmmoType = -1;

SWEP.DegradeAmt 			= 2;
SWEP.HealthAmt 				= 100;

SWEP.Primary.IronSightPos = Vector( 0, 0, -4.06 );
SWEP.Primary.IronSightAng = Angle( 36.01, -10.64, -9.61 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth = 4;
SWEP.ItemHeight = 2;

SWEP.Tier = 2;

SWEP.Primary.Delay = 1;

SWEP.IconCamPos = Vector( -46, -91, -158 ) 
SWEP.IconLookAt = Vector( 0, 0, 1 ) 
SWEP.IconFOV = 9
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 50;
SWEP.NicePhrase = "a guitar";
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

	"weapons/necropolis/guitar/guitar_hit_world_01.wav",
	"weapons/necropolis/guitar/guitar_hit_world_02.wav",
	"weapons/necropolis/guitar/guitar_hit_world_03.wav",
	"weapons/necropolis/guitar/guitar_hit_world_04.wav",
	"weapons/necropolis/guitar/guitar_hit_world_05.wav",

}

SWEP.HitBodSounds =
{

	"weapons/necropolis/guitar/melee_guitar_01.wav",
	"weapons/necropolis/guitar/melee_guitar_02.wav",
	"weapons/necropolis/guitar/melee_guitar_03.wav",
	"weapons/necropolis/guitar/melee_guitar_04.wav",
	"weapons/necropolis/guitar/melee_guitar_05.wav",
	"weapons/necropolis/guitar/melee_guitar_07.wav",
	"weapons/necropolis/guitar/melee_guitar_08.wav",
	"weapons/necropolis/guitar/melee_guitar_10.wav",
	"weapons/necropolis/guitar/melee_guitar_11.wav",
	"weapons/necropolis/guitar/melee_guitar_12.wav",
	"weapons/necropolis/guitar/melee_guitar_13.wav",
	"weapons/necropolis/guitar/melee_guitar_14.wav",

}

SWEP.HitBodVol_Low = 75;
SWEP.HitBodVol_High = 80;

SWEP.Anims =
{

	ACT_VM_HITLEFT,
	ACT_VM_PRIMARYATTACK,

}
   