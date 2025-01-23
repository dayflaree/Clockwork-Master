AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Service Rifle";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/lazarus/c_servicerifle.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_survivalist.mdl";
SWEP.ViewModelFlip	= false;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "ar2";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0.89, -0.27, -3.68 );
SWEP.HolsterAng = Angle( -7.95, 34.58, 0 );	

SWEP.AimPos = Vector( -6.85, 1.43, -0.89 );
SWEP.AimAng = Angle( -1.12, 0, -4.01 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_ServiceRifle.Single";
SWEP.Primary.Damage			= 25;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.05;
SWEP.Primary.Delay			= 0.075;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 );

SWEP.Description = "A standard issue Service Rifle.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.BasePrice = 1800;
SWEP.ItemCategory = CATEGORY_PRIMARYWEAPON;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 0, 627, 7 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 0, 427, 7 );
SWEP.ItemAmmo = "ammo_556mm";

SWEP.ZombieRadius			= 1500;