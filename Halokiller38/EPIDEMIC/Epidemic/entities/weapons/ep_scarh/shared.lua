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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_scar.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_scar.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/scar/m4a1-1.wav" );

SWEP.PrintName 				= "SCAR-H";
SWEP.EpiDesc 				= "Automatic";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "RIFLE";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 30;

SWEP.Primary.MaxAmmoClip 	= 20;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 0.096;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 1.966;

SWEP.Primary.IronSightPos = Vector( 2.96, 0.81, -3.01 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, 50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 9, 0, 2 ) 
SWEP.IconFOV		= 8
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a SCAR";
SWEP.HeavyWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.543, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/scar/m4a1_clipout.wav" ) );
	end );
	timer.Simple( 1.208, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/scar/m4a1_clipin.wav" ) );
	end );
	timer.Simple( 1.54, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/scar/m4a1_magtap.wav" ) );
	end );
	timer.Simple( 2.144, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/scar/m4a1_boltrelease.wav" ) );
	end );
	
end