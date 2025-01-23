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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_makarov.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_makarov.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/makarov/fiveseven-1.wav" );

SWEP.PrintName 				= "Makarov PM";
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

SWEP.Primary.MaxAmmoClip 	= 8;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2.342;

SWEP.Primary.IronSightPos = Vector( 2.71, 1.38, -3.36 );
SWEP.Primary.IronSightAng = Angle( 0.16, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 0, 0, -2 ) 
SWEP.IconFOV		= 3
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Makarov";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/clipout.wav" ) );
	end );
	timer.Simple( 1.228, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/clipin1.wav" ) );
	end );
	timer.Simple( 1.628, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/clipin2.wav" ) );
	end );
	timer.Simple( 2.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/slideforward.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 17/45, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/slideback.wav" ) );
	end );
	timer.Simple( 26/45, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/makarov/slideforward.wav" ) );
	end );
  
end