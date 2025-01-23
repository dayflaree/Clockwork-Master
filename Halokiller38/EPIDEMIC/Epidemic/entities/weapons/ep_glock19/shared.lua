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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_glock19.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_glock19.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/glock19/fire.wav" );

SWEP.PrintName 				= "Glock 19";
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

SWEP.Primary.MaxAmmoClip 	= 15;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2;

SWEP.Primary.IronSightPos = Vector( 3.02, 1.49, -4.14 );
SWEP.Primary.IronSightAng = Angle( 0, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 6, -11, 2 ) 
SWEP.IconFOV		= 4
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Glock 19";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.066, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/slideback.wav" ) );
	end );
	timer.Simple( 0.766, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/magout.wav" ) );
	end );
	timer.Simple( 1.96, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/magin.wav" ) );
	end );
	timer.Simple( 2.63, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/sliderelease.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.205, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/slideback.wav" ) );
	end );
	
end