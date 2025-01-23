AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Kitchen Knife";
SWEP.Slot 			= 2;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_m_kitchenknife.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_m_kitchenknife.mdl";

SWEP.HoldType = "melee2";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = true;
SWEP.DrawUseAnim = true;

SWEP.HolsterPos = Vector( 0, -4.13, 0 );
SWEP.HolsterAng = Angle( 0, 6.57, -0.18 );

SWEP.AimPos = Vector( -4.05, 0, 0 );
SWEP.AimAng = Angle( 0, 0, -27.91 );

SWEP.PrimaryAttackAct = {
	"attack_e_w",
	"attack_ne_sw",
	"attack_w_e",
};
SWEP.MissAnim = {
	"attack_e_w",
	"attack_ne_sw",
	"attack_w_e",
};

SWEP.Melee = true;

SWEP.IdleAct = "deploy";

SWEP.Primary.ClipSize 		= -1;
SWEP.Primary.DefaultClip 	= -1;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Damage			= 20;

SWEP.Description = "A kitchen knife. Pretty common among the ruins of the Old World.";
SWEP.W = 1;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -16, 256, 47 );
SWEP.FOV = 5;
SWEP.LookAt = Vector( -3, 59, 17 );

SWEP.MissDelay				= 0.4;
SWEP.HitDelay				= 0.2;
SWEP.Length					= 40;
SWEP.SwingSound				= "Weapon_KitchenKnife.Miss";
SWEP.HitWallSound			= "Weapon_KitchenKnife.Melee_Hit";
SWEP.HitFleshSound			= "Weapon_KitchenKnife.Melee_Hit_Flesh";