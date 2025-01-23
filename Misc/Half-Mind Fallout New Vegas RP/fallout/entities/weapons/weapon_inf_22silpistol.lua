AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= ".22 Pistol";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_22silenced.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_22silenced.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "pistol";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -8.57, 0, 0 );

SWEP.AimPos = Vector( -4.82, 2.41, 0 );
SWEP.AimAng = Angle( -1.38, 0, 0 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 16;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_22Pistol.Single";
SWEP.Primary.Damage			= 9;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.3; // Divide one by the attacks per second value on the wiki, and put that number here. round it.
SWEP.Primary.ViewPunch		= Angle( -0.8, 0, 0 ); // how much recoil. the first value is "up"

SWEP.Description = "A small, sleek handgun with an integrated suppressor that uses .22LR ammunition. It has an integrated suppressor and could easily fit in your pocket, making it the perfect holdout weapon. "; // Description
SWEP.W = 2;
SWEP.H = 2;
SWEP.BasePrice = 300;
SWEP.ItemCategory = CATEGORY_SECONDARYWEAPON;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( 4, 218, 21 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 3, 18, 5 );
SWEP.ItemAmmo = "ammo_22lr";