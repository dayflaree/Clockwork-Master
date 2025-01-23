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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_p226.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_p226.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/p226/P228-1.wav" );

SWEP.PrintName 				= "P226";
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

SWEP.Primary.MaxAmmoClip 	= 12;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2.38;

SWEP.Primary.IronSightPos = Vector( 3.72, 2.37, -3.61 );
SWEP.Primary.IronSightAng = Angle( 0.41, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 6, 14, 2 ) 
SWEP.IconFOV		= 4
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a P226";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/p226/slideback.wav" ) );
	timer.Simple( 0.38, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak47/clipout.wav" ) );
	end );
	timer.Simple( 1.11, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak47/clipin.wav" ) );
	end );
	timer.Simple( 1.72, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak47/sliderelease.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 10/41.61, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/p226/slideback.wav" ) );
	end );
	timer.Simple( 20/41.61, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/p226/slideforward.wav" ) );
	end );
	
end