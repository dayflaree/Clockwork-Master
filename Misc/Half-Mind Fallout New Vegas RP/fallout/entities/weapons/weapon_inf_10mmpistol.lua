AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "10mm Pistol";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_10mm_pistol.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_10mm.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "pistol";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -14.09, 0, 0 );

SWEP.AimPos = Vector( -4.96, 0.79, 0 );
SWEP.AimAng = Angle( -2.21, -0.16, 0 );

SWEP.IdleAct = "idle";

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 12;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_10mm.Single";
SWEP.Primary.Damage			= 20;
SWEP.Primary.Force			= 5;
SWEP.Primary.Accuracy		= 0.07;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "An 10mm pistol, quite common among the Wastes.";
SWEP.W = 2;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.BasePrice = 800;
SWEP.ItemCategory = CATEGORY_SECONDARYWEAPON;
SWEP.CamPos = Vector( 8, 262, -13 );
SWEP.FOV = 5;
SWEP.LookAt = Vector( 5, 63, 0 );
SWEP.ItemAmmo = "ammo_10mm";

SWEP.ZombieRadius			= 2000;