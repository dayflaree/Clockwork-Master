AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "12.7mm Pistol";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/view/c_lazarus_127pistol.mdl";
SWEP.WorldModel 	= "models/weapons/w_lazarus_127mm.mdl";
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

SWEP.Primary.ClipSize 		= 7;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_10mm.Single";
SWEP.Primary.Damage			= 40;
SWEP.Primary.Force			= 5;
SWEP.Primary.Accuracy		= 0.07;
SWEP.Primary.Delay			= 0.3;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "A SIG-Sauer 14mm, rechambered for 12.7mm ammunition. It's smooth curves and boxy trigger give it a peculiar look, however it seems like a reliable weapon for anyone fairing the wastes.";
SWEP.W = 2;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.BasePrice = 3800;
SWEP.ItemCategory = CATEGORY_SECONDARYWEAPON;
SWEP.CamPos = Vector( -3, 64, 5 );
SWEP.FOV = 15;
SWEP.LookAt = Vector( 18, -135, 2 );
SWEP.ItemAmmo = "ammo_127mm";

SWEP.ZombieRadius			= 2000;