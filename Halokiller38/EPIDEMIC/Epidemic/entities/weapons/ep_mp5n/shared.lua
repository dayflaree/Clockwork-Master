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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_mp5navy.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_mp5navy.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/mp5navy/mp5-1.wav" );

SWEP.PrintName 				= "MP5 Navy";
SWEP.EpiDesc 				= "Automatic";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.MuzzleDepth 			= 30;

SWEP.EpiHoldType 			= "RIFLE";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 30;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.075;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 2.7;

SWEP.Primary.IronSightPos = Vector( 3.25, 1.5, -3.25 );
SWEP.Primary.IronSightAng = Angle( -0, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 7, 23, 2 ) 
SWEP.IconFOV		= 6
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an MP5";
SWEP.HeavyWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.705, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/mp5navy/mp5_boltpull.wav" ) );
	end );
	timer.Simple( 1.48, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/mp5navy/mp5_clipout.wav" ) );
	end );
	timer.Simple( 1.97, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/mp5navy/mp5_clipin.wav" ) );
	end );
	timer.Simple( 2.61, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/mp5navy/mp5_boltslap.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 11/37.26, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/mp5navy/mp5_safety.wav" ) );
	end );
	
end