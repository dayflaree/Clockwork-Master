AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Hunting Rifle";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/lazarus/c_huntingrifle.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_huntingrifle.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0.89, -0.27, -3.68 );
SWEP.HolsterAng = Angle( -7.95, 34.58, 0 );	

SWEP.AimPos = Vector( -3.46, 1.05, -1.26 );
SWEP.AimAng = Angle( -0.22, 0.08, 0.1 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 10;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_HuntingRifle.Single";
SWEP.Primary.ReloadSound 	= "Weapon_HuntingRifle.Reload";
SWEP.Primary.Damage			= 35;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.025;
SWEP.Primary.Delay			= 1;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "An old hunting rifle that has seen a lot of action, and taken a lot of abuse.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.BasePrice = 1500;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 0, 627, 7 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 0, 427, 7 );
SWEP.ItemAmmo = "ammo_308";

SWEP.ZombieRadius			= 1500;