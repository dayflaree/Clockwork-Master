if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" );
	
end 

SWEP.Base = "ep_base";

SWEP.Spawnable			= false;
SWEP.AdminSpawnable		= false;

if( CLIENT ) then
	
	SWEP.ViewModelFlip = true;
	SWEP.DrawCrosshair = false;

end

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_5946.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_5946.mdl";

SWEP.Primary.Sound			= Sound( "weapons/p228/P228-1.wav" );

SWEP.PrintName 				= "S&W model 5946";
SWEP.EpiDesc 				= "Semi-automatic";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .5;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "PISTOL";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 14;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 1.71;

SWEP.Primary.IronSightPos = Vector( 3.28, 1.75, -3.38 );
SWEP.Primary.IronSightAng = Angle( 1.02, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 6, 0, 2 ) 
SWEP.IconFOV		= 4
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a 5946";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/5946/glock_clipout.wav" ) );
	timer.Simple( 0.7, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/5946/glock_clipin.wav" ) );
	end );
	timer.Simple( 1.53, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/5946/glock_sliderelease.wav" ) );
	end );
	
end