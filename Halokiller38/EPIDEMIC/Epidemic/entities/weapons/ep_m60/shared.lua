if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" );
	
end 

SWEP.Base = "ep_base";

SWEP.Spawnable			= false;
SWEP.AdminSpawnable		= false;

if( CLIENT ) then
	
	SWEP.ViewModelFlip = false;
	SWEP.DrawCrosshair = false;

end

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_m60.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_m60.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m60/m249-1.wav" );

SWEP.PrintName 				= "M60";
SWEP.EpiDesc 				= "SAW";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 15;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "RIFLE";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 30;

SWEP.Primary.MaxAmmoClip 	= 100;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.09, 0.09, 0.09 );
SWEP.Primary.ReloadDelay 	= 5.23;

SWEP.Primary.IronSightPos = Vector( -5.84, 2.54, 3.29 );
SWEP.Primary.IronSightAng = Angle( 1.03, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, 50.0, -10.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 8, 0, 3 ) 
SWEP.IconFOV		= 9
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M60";
SWEP.HeavyWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.833, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_boxout.wav" ) );
	end );
	timer.Simple( 2.1, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_coverup.wav" ) );
	end );
	timer.Simple( 3.4, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_boxin.wav" ) );
	end );
	timer.Simple( 4.1, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_chain.wav" ) );
	end );
	timer.Simple( 4.9, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_coverdown.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.416, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_coverup.wav" ) );
	end );
	timer.Simple( 0.5, function()
		self.Owner:EmitSound( Sound( "weapons/m249/m249_coverdown.wav" ) );
	end );
  
end