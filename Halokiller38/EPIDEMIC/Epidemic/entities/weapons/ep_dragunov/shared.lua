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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_dragunov.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_dragunov.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/dragunov/dragunov-1.wav" );

SWEP.PrintName 				= "Dragunov";
SWEP.EpiDesc 				= "Russian sniper rifle";

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

SWEP.Primary.MaxAmmoClip 	= 10;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 0.333;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0, 0, 0 );
SWEP.Primary.ReloadDelay 	= 4.766;

SWEP.Primary.IronSightPos = Vector( 3.28, 0.25, -2.73 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 16, 0, 2 ) 
SWEP.IconFOV		= 9
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Dragunov";
SWEP.HeavyWeight 	= true;

SWEP.Scoped = true;

function SWEP:OnReloadSound()
	
	timer.Simple( 1, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/clipout.wav" ) );
	end );
	timer.Simple( 1.966, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/clipin.wav" ) );
	end );
	timer.Simple( 3.5, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/slideforward.wav" ) );
	end );
	timer.Simple( 4, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/slideback.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.333, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/slideback.wav" ) );
	end );
	timer.Simple( 0.6, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/dragunov/slideforward.wav" ) );
	end );
	
end