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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_m24.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_m24.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m24/awp1.wav" );

SWEP.PrintName 				= "M24 SWS";
SWEP.EpiDesc 				= "Sniper rifle";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= 5;
SWEP.Primary.Damage			= 20;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "SNIPER";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 30;

SWEP.Primary.MaxAmmoClip 	= 5;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 1.181;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0, 0, 0 );
SWEP.Primary.ReloadDelay 	= 2.9;

SWEP.Primary.IronSightPos = Vector( 2.87, 1.79, -3.48 );
SWEP.Primary.IronSightAng = Angle( 0, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 15, 0, 2 ) 
SWEP.IconFOV		= 10
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M24";
SWEP.HeavyWeight 	= true;

SWEP.Scoped = true;
SWEP.VariableZoom = true;

function SWEP:OnPrimarySound()
	
	timer.Simple( 0.666, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_boltback.wav" ) );
	end );
	timer.Simple( 1, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_boltforward.wav" ) );
	end );
	
end

function SWEP:OnReloadSound()
	
	timer.Simple( 0.433, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_magout.wav" ) );
	end );
	timer.Simple( 1.3, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_magin.wav" ) );
	end );
	timer.Simple( 1.8, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_boltback.wav" ) );
	end );
	timer.Simple( 2.333, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m24/m24_boltforward.wav" ) );
	end );
	
end