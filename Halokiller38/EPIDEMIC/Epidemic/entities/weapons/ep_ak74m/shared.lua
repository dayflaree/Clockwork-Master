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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_ak74m.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_ak74m.mdl";

SWEP.Primary.Sound			= Sound( "weapons/ak47/ak47-1.wav" );

SWEP.PrintName 				= "AK-74M";
SWEP.EpiDesc 				= "Semi-automatic";

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

SWEP.Primary.MaxAmmoClip 	= 30;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 0.0924;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 2.455;

SWEP.Primary.IronSightPos = Vector( 3.07, 1.2, -3.41 );
SWEP.Primary.IronSightAng = Angle( -0.2, 0.29, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 8, 0, 1 ) 
SWEP.IconFOV		= 9
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an AK-74M";
SWEP.HeavyWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.513, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/clip.out.wav" ) );
	end );
	timer.Simple( 1.138, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/clip.in.wav" ) );
	end );
	timer.Simple( 1.785, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/bolt.pull.wav" ) );
	end );
	timer.Simple( 1.919, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/bolt.rel.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.089, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/bolt.pull.wav" ) );
	end );
	timer.Simple( 0.2, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74m/bolt.rel.wav" ) );
	end );
	
end