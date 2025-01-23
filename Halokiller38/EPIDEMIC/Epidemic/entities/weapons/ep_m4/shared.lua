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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_m4.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_m4.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m4/xm1014-1.wav" );

SWEP.PrintName 				= "M4";
SWEP.EpiDesc 				= "Shotgun";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= .9;
SWEP.Primary.Damage			= 5;
SWEP.Primary.NumShots		= 8;

SWEP.EpiHoldType 			= "SHOTGUN";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 8;
SWEP.Primary.AmmoString 	= " 18mm rounds";
SWEP.Primary.AmmoType 		= 2;
SWEP.Primary.Delay 			= 0.25;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.08, 0.08, 0.08 );
SWEP.ShotgunReload = true;

SWEP.Primary.IronSightPos = Vector( 5.15, 2.15, -4.08 );
SWEP.Primary.IronSightAng = Angle( -0.19, 0.73, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.MuzzleDepth 			= 30;

SWEP.BreaksDoors = true;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 8, 0, 2 ) 
SWEP.IconFOV		= 7
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M4";
SWEP.HeavyWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.066, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m4/xm1014_insertshell.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 0.205, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/glock19/slideback.wav" ) );
	end );
	
end