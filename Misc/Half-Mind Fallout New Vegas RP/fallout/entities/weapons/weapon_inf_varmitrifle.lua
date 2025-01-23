AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Varmit Rifle";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/lazarus/c_varmitrifle.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_huntingrifle.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0.89, -0.27, -3.68 );
SWEP.HolsterAng = Angle( -7.95, 34.58, 0 );	

SWEP.AimPos = Vector( -3.73, 1.25, 0 );
SWEP.AimAng = Angle();

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 10;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_VarmitRifle.Single";
SWEP.Primary.ReloadSound 	= "Weapon_HuntingRifle.Reload";
SWEP.Primary.Damage			= 35;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.025;
SWEP.Primary.Delay			= 1;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "An old varmit rifle meant for hunting small animals.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.BasePrice = 800;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 0, 627, 7 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 0, 427, 7 );
SWEP.ItemAmmo = "ammo_556mm";

SWEP.ZombieRadius			= 1500;