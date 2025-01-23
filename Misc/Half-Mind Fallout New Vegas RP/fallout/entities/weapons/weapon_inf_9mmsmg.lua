AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "9mm SMG";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_9mm_smg.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_9mmsmg.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -12.87, 0, 0 );

SWEP.AimPos = Vector( -4.86, 0, 0 );
SWEP.AimAng = Angle( -1.44, 0, -0.26 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_9mmSMG.Single";
SWEP.Primary.Damage			= 14;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 );

SWEP.Description = "A compact 9mm sub-machine gun. This firearm could easily fit inside of your jacket, and is a choice covert weapon.";
SWEP.W = 3;
SWEP.H = 2;
SWEP.BasePrice = 800;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 9, 65, -5 );
SWEP.FOV = 19;
SWEP.LookAt = Vector( 2, -132, 26 );
SWEP.ItemAmmo = "ammo_9mm";