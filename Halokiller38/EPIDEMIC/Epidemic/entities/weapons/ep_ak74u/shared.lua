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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_ak74u.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_ak74u.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/ak74u/galil-1.wav" );

SWEP.PrintName 				= "AK-74U";
SWEP.EpiDesc 				= "Carbine";

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

SWEP.MuzzleDepth 			= 23;

SWEP.Primary.MaxAmmoClip 	= 30;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 0.085;
SWEP.Primary.Automatic 		= true;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 3.58;

SWEP.Primary.IronSightPos = Vector( -3.05, 1.43, -1.98 );
SWEP.Primary.IronSightAng = Angle( -0.76, 0.05, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, 50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 4, 0, 1 ) 
SWEP.IconFOV		= 6
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an AK-74U";
SWEP.HeavyWeight 	= true;

function SWEP:OnDrawSound()
	
	timer.Simple( 0.2, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/ak74u/galil_boltpull.wav" ) );
	end );
	
end