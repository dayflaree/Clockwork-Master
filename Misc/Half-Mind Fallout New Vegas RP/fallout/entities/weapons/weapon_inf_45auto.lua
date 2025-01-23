AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Colt 1911A1"
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_1911.mdl"
SWEP.WorldModel 	= "models/weapons/w_lazarus_1911.mdl"
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "pistol"
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -7.34, 0, 0 );

SWEP.AimPos = Vector( -4.88, 2.3, 0 );
SWEP.AimAng = Angle( -1.46, 0.03, 1.5 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 7;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_45Pistol.Single";
SWEP.Primary.Damage			= 29;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.36;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "A single-action handgun. This high-calibre weapon packs a lot of punch in a small package.";
SWEP.W = 2;
SWEP.H = 2;
SWEP.BasePrice = 1200;
SWEP.ItemCategory = CATEGORY_SECONDARYWEAPON;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -4, 293, 5 );
SWEP.FOV = 2;
SWEP.LookAt = Vector( 1, 93, 4 );
SWEP.ItemAmmo = "ammo_45acp";