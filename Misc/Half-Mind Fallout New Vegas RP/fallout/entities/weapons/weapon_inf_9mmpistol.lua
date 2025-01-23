AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "9mm Pistol";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_9mm_pistol.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_9mm.mdl"
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "pistol";
SWEP.HoldTypeHolster = "pistol";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -10.32, 0, 0 );

SWEP.AimPos = Vector( -4.87, 2.15, 1.5 );
SWEP.AimAng = Angle( -1.33, -0.07, -0.07 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 13;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_9mm.Single";
SWEP.Primary.Damage			= 16;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.3;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 ); // how much recoil. the first value is "up"

SWEP.Description = "The classic 9mm pistol. Everyone from NCR troopers to degenerate raiders can be seen toting this commonplace firearm."
SWEP.W = 2;
SWEP.H = 2;
SWEP.BasePrice = 250;
SWEP.ItemCategory = CATEGORY_SECONDARYWEAPON;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -19, 195, 5 );
SWEP.FOV = 5;
SWEP.LookAt = Vector( 3, -3, 4 );
SWEP.ItemAmmo = "ammo_9mm";