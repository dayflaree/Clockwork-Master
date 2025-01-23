AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "M1928A1 Thompson";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_45autosmg.mdl";
SWEP.WorldModel 	= "models/weapons/w_45autosmg.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0.89, -0.27, -3.68 );
SWEP.HolsterAng = Angle( -7.95, 34.58, 0 );	

SWEP.AimPos = Vector( -6.68, 2.77, 1.58 );
SWEP.AimAng = Angle( -2.13, -0.13, -3.87 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_45AutoSMG.Single";
SWEP.Primary.Damage			= 25;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.075;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 );

SWEP.Description = "A .45 ACP submachine gun from early American history. It has a 30 round stick magazine.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.BasePrice = 3200;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 0, 627, 7 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 0, 427, 7 );
SWEP.ItemAmmo = "ammo_45acp";

SWEP.ZombieRadius			= 1500;