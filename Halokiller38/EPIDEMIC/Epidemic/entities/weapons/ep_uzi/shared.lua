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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_uzi.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_uzi.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/uzi/mac10-1.wav" );

SWEP.PrintName 				= "IMI Uzi";
SWEP.EpiDesc 				= "Automatic";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "PISTOL";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 32;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 2.857;

SWEP.Primary.IronSightPos = Vector( 2.1, 0.96, -3.05 );
SWEP.Primary.IronSightAng = Angle( 1.72, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 10, 0, 2 ) 
SWEP.IconFOV		= 6
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an Uzi";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.314, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/uzi/mac10_clipout.wav" ) );
	end );
	timer.Simple( 1.08, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/uzi/mac10_clipin.wav" ) );
	end );
	timer.Simple( 1.97, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/uzi/mac10_boltpull.wav" ) );
	end );
	
end