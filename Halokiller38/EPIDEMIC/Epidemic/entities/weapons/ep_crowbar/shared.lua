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


SWEP.ViewModel      = "models/weapons/melee/v_crowbar.mdl"
SWEP.WorldModel   = "models/weapons/necropolis/w_models/w_crowbar.mdl"

SWEP.PrintName = "Crowbar";
SWEP.EpiDesc = "Gordon Freeman reference.";

SWEP.Primary.Damage			= 38

SWEP.EpiHoldType = "FIST";

SWEP.Primary.AmmoType = -1;

SWEP.DegradeAmt 			= 2;
SWEP.HealthAmt 				= 100;

SWEP.Primary.IronSightPos = Vector( 0, 0, -9.22 );
SWEP.Primary.IronSightAng = Angle( 63.95, 0, 0 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Angle( 0.0, -50.0, 0.0 );

SWEP.Tier = 2;

SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.Primary.Delay = 1;

SWEP.IconCamPos = Vector( 0, -200, 0 ) 
SWEP.IconLookAt = Vector( 0, 0, 13 ) 
SWEP.IconFOV = 6
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 50;
SWEP.NicePhrase = "a crowbar";
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
   