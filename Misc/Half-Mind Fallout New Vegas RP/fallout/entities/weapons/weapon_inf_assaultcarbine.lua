AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Assault Carbine"; // Edit this to the name of the weapon.
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_assaultrifle.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_assaultcarbine.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -3.9, 39.16, 0 );

SWEP.AimPos = Vector( -6.88, 2.31, 1.5 );
SWEP.AimAng = Angle( -1.25, 0.01, -3.51 );

SWEP.Firearm = true;

SWEP.IdleAct = "idle_raw";

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_AssaultCarbine.Single";
SWEP.Primary.Damage			= 15;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -1.5, 0, 0 );

SWEP.Description = "The iconic assault carbine. Reminding you of the service rifle; while less rare this weapon is similar in it’s militaristic style, use and deadly stopping power.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.BasePrice = 4500;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( -15, 544, -23 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( -11, 344, -12 );
SWEP.ItemAmmo = "ammo_5mm";