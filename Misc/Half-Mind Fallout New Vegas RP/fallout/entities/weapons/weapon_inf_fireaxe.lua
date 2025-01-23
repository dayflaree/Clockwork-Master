AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Fireaxe";
SWEP.Slot 			= 2;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_m_fireaxe.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_m_fireaxe.mdl";

SWEP.HoldType = "melee2";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = true;
SWEP.DrawUseAnim = true;

SWEP.HolsterPos = Vector( 0, -4.13, 0 );
SWEP.HolsterAng = Angle( 0, 6.57, -0.18 );

SWEP.AimPos = Vector( -3.03, 3.52, 1.5 );
SWEP.AimAng = Angle( 1.5, 9.69, -15.3 );

SWEP.PrimaryAttackAct = {
	"swing_e_w",
	"swing_ne_w",
	"swing_se_w",
	"swing_sw_e",
	"swing_w_e",
};
SWEP.MissAnim = {
	"swing_e_w",
	"swing_ne_w",
	"swing_se_w",
	"swing_sw_e",
	"swing_w_e",
};

SWEP.Melee = true;

SWEP.IdleAct = "deploy";

SWEP.Primary.ClipSize 		= -1;
SWEP.Primary.DefaultClip 	= -1;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Damage			= 25;

SWEP.Description = "A fireaxe from a by-gone era. Sturdy wooden handle with a sharp axe-head.";
SWEP.W = 4;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( 89, 112, 519 );
SWEP.FOV = 3;
SWEP.LookAt = Vector( 54, 70, 326 );

SWEP.MissDelay				= 0.7;
SWEP.HitDelay				= 0.5;
SWEP.Length					= 50;
SWEP.SwingSound				= "Weapon_Crowbar.Single";
SWEP.HitWallSound			= "Weapon_Fireaxe.Melee_Hit";
SWEP.HitFleshSound			= "Weapon_Fireaxe.Melee_Hit_Flesh";