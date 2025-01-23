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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_mosin.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_mosin.mdl";

SWEP.Primary.SoundTab		= { Sound( "weapons/necropolis/mosin/k98_shoot.wav" ), Sound( "weapons/necropolis/mosin/k98_shoot2.wav" ) };

SWEP.PrintName 				= "Mosin";
SWEP.EpiDesc 				= "Rifle";

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

SWEP.MuzzleDepth 			= 30;

SWEP.Primary.MaxAmmoClip 	= 5;
SWEP.Primary.AmmoString 	= " 7.62mm rounds";
SWEP.Primary.AmmoType 		= 4;
SWEP.Primary.Delay 			= 1.286;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 2.933;

SWEP.Primary.IronSightPos = Vector( -4.87, 1.8, -0.68 );
SWEP.Primary.IronSightAng = Angle( 1.45, 1.63, -4.31 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, 50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 2, 0, 2 ) 
SWEP.IconFOV		= 10
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a Mosin";
SWEP.HeavyWeight 	= true;

function SWEP:OnPrimarySound( seq )
	
	timer.Simple( 0.433, function()
		self.Owner:EmitSound( "Weapon_Scout.Bolt" );
	end );
	
end

function SWEP:OnReloadSound()
	
	timer.Simple( 0.433, function()
		self.Owner:EmitSound( "Weapon_Scout.Clipout" );
	end );
	timer.Simple( 1.233, function()
		self.Owner:EmitSound( "Weapon_Scout.Clipin" );
	end );
	timer.Simple( 1.733, function()
		self.Owner:EmitSound( "Weapon_Scout.Bolt" );
	end );
	
end