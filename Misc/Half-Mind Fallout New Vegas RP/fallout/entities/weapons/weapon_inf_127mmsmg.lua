AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "12.7mm SMG";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_127mmsmg.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_127mmsmg.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -8.81, 39.15, -9.81 );

SWEP.AimPos = Vector( -6.86, 1.96, 0 );
SWEP.AimAng = Angle( -1.47, 0.01, -3.49 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 20;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_127mmSMG.Single";
SWEP.Primary.Damage			= 36;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -3, 0, 0 );

SWEP.Description = "A 12.7mm submachine gun. Hefty, heavy, big, bulky, loud, and powerful.";
SWEP.W = 3;
SWEP.H = 2;
SWEP.BasePrice = 5000;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 9, 65, -5 );
SWEP.FOV = 19;
SWEP.LookAt = Vector( 2, -132, 26 );
SWEP.ItemAmmo = "ammo_127mm";

SWEP.ZombieRadius			= 1500;