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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_colt1911.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_colt1911.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/colt1911/usp1.wav" );

SWEP.PrintName 				= "Colt 1911";
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

SWEP.Primary.MaxAmmoClip 	= 7;
SWEP.Primary.AmmoString 	= " 9mm rounds";
SWEP.Primary.AmmoType 		= 1;
SWEP.Primary.Delay 			= 0.1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2.756;

SWEP.Primary.IronSightPos = Vector( 1.75, 0.68, -2.14 );
SWEP.Primary.IronSightAng = Angle( -0.13, -0, -0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 7, -7, 1 ) 
SWEP.IconFOV		= 4
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Colt 1911";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/draw.wav" ) );
	self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/slideback.wav" ) );
	timer.Simple( 0.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/magout.wav" ) );
	end );
	timer.Simple( 1.228, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/magin1.wav" ) );
	end );
	timer.Simple( 1.628, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/magin2.wav" ) );
	end );
	timer.Simple( 2.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/sliderelease.wav" ) );
	end );
	timer.Simple( 2.285, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/slidefor.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/draw.wav" ) );
	timer.Simple( 0.54, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/sliderelease.wav" ) );
	end );
	timer.Simple( 0.54, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/colt1911/slidefor.wav" ) );
	end );
	
end