
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 

 end 

  	SWEP.HoldType = "pistol";
	
if( CLIENT ) then

	
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "weapons/ar1/ar1_dist1.wav" );

SWEP.WorldModel = "models/weapons/w_srifle.mdl";
SWEP.ViewModel = "models/weapons/v_srifle.mdl";

SWEP.PrintName = "AR2";
SWEP.TS2Desc = "Overwatch standard pulse rifle";

SWEP.Price = 5000;

 SWEP.Primary.Recoil			= .3 
 SWEP.Primary.RecoilAdd			= .1
 SWEP.Primary.RecoilMin = .2
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 14
 SWEP.Primary.NumShots		= 1 
 
 
 SWEP.TS2HoldType = "RIFLE";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 150;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .03, .03, .03 );
 SWEP.Primary.ReloadDelay = 2.3;
 
 --[[
 SWEP.Primary.IronSightPos = Vector( 6.05, 2.4, -4.0 );
 SWEP.Primary.IronSightAng = Vector( 2.7, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, -50.0, 0.0 );
]]--

SWEP.Primary.IronSightPos = Vector( -5.8, 2.2, -2.0 );
SWEP.Primary.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.Primary.HolsteredPos = Vector( 0.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( 0.0, 40.0, 0.0 );

 SWEP.ItemWidth = 3;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 11, -163, 5 );
SWEP.IconLookAt = Vector( 11, 7, -1 );
SWEP.IconFOV = 7;

SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav";


function SWEP:ShootBullet( damage, num_bullets, aimcone )
 
	local bullet = {}
	bullet.Num 		= num_bullets;
	bullet.Src 		= self.Owner:GetShootPos();
	bullet.Dir 		= self.Owner:GetAimVector();
	bullet.Spread 	= Vector( aimcone, aimcone, 0 );
	bullet.Tracer	= 1;
        bullet.TracerName = "Tracer";
	bullet.Force	= 1;
	bullet.Damage	= SWEP.Primary.Damage;
	bullet.AmmoType = "Pistol";

	self.Owner:FireBullets( bullet );
 
	self:ShootEffects();
 
end
   