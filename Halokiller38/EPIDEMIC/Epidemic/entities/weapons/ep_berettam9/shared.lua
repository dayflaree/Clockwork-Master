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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_m9.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_m9.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m9/fiveseven-1.wav" );

SWEP.PrintName 				= "Beretta M9";
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
SWEP.Primary.ReloadDelay 	= 2.4;

SWEP.Primary.IronSightPos = Vector( 2.78, 1.54, -3.95 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 6, 7, 2 ) 
SWEP.IconFOV		= 4
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Beretta M9";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.286, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/clipout.wav" ) );
	end );
	timer.Simple( 1.228, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/clipin1.wav" ) );
	end );
	timer.Simple( 1.628, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/clipin2.wav" ) );
	end );
	timer.Simple( 2.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/SlideForward.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.485, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/SlideBack.wav" ) );
	end );
	timer.Simple( 0.742, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m9/SlideForward.wav" ) );
	end );
  
end