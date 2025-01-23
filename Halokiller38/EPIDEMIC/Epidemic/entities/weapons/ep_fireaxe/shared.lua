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


SWEP.ViewModel      = "models/weapons/melee/v_fireaxe.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_fireaxe.mdl"

SWEP.PrintName = "Fire Axe";
SWEP.EpiDesc = "Put out fires.";

SWEP.Primary.Damage			= 38

SWEP.EpiHoldType = "FIST";

SWEP.Primary.AmmoType = -1;

SWEP.DegradeAmt 			= 2;
SWEP.HealthAmt 				= 100;

SWEP.Primary.IronSightPos = Vector( 0, 0, -4.06 );
SWEP.Primary.IronSightAng = Angle( 34.55, -10.64, -9.61 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth = 4;
SWEP.ItemHeight = 1;

SWEP.Tier = 2;

SWEP.Primary.Delay = 1;

SWEP.IconCamPos = Vector( 0, -200, 0 ) 
SWEP.IconLookAt = Vector( 0, 0, 20 ) 
SWEP.IconFOV = 8
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 50;
SWEP.NicePhrase = "an axe";
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

	"weapons/necropolis/axe/axe_impact_world1.wav",
	"weapons/necropolis/axe/axe_impact_world2.wav",

}

SWEP.HitBodSounds =
{

	"weapons/necropolis/axe/axe_impact_flesh1.wav",
	"weapons/necropolis/axe/axe_impact_flesh2.wav",
	"weapons/necropolis/axe/axe_impact_flesh3.wav",

}

SWEP.HitBodVol_Low = 75;
SWEP.HitBodVol_High = 80;

SWEP.Anims =
{

	ACT_VM_HITLEFT,
	ACT_VM_PRIMARYATTACK,

}
   