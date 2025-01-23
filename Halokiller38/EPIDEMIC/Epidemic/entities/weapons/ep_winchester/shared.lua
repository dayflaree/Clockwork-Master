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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_winchester1873.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_winchester1873.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m3/m3-1.wav" );

SWEP.PrintName 				= "Winchester 1873";
SWEP.EpiDesc 				= "Rifle";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "SHOTGUN";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.MuzzleDepth 			= 30;

SWEP.Primary.MaxAmmoClip 	= 15;
SWEP.Primary.AmmoString 	= " .44 rounds";
SWEP.Primary.AmmoType 		= 5;
SWEP.Primary.Delay 			= 1.118;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.ShotgunReload 			= true;

SWEP.Primary.IronSightPos = Vector( 2.86, 1.8, -0.68 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 10, 0, 2 ) 
SWEP.IconFOV		= 10
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Winchester";
SWEP.HeavyWeight 	= true;

function SWEP:OnPrimarySound( seq )
	
	timer.Simple( 0.616, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m3/m3_pump.wav" ) );
	end );
	
end

function SWEP:OnReloadEndSound()
	
	timer.Simple( 0.134, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m3/m3_pump.wav" ) );
	end );
	
end

function SWEP:OnReloadSound()
	
	timer.Simple( 0.214, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m3/m3_insertshell.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 8/20.33, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m3/m3_hammer.wav" ) );
	end );
	
end