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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_44magnum.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_44magnum.mdl";

SWEP.Primary.SoundTab		= { Sound( "weapons/necropolis/44magnum/deagle-1.wav" ), Sound( "weapons/necropolis/44magnum/deagle-2.wav" ) };

SWEP.PrintName 				= ".44 Magnum";
SWEP.EpiDesc 				= "Revolver";

SWEP.Primary.Recoil			= .3;
SWEP.Primary.RecoilAdd		= .5;
SWEP.Primary.RecoilMin 		= .3;
SWEP.Primary.RecoilMax 		= 10;

SWEP.Primary.ViewPunchMul 	= 20;
SWEP.Primary.Damage			= 15;
SWEP.Primary.NumShots		= 1;

SWEP.EpiHoldType 			= "PISTOL";

SWEP.DegradeAmt 			= 2;
SWEP.JamChance 				= 20;
SWEP.HealthAmt 				= 100;

SWEP.Primary.MaxAmmoClip 	= 6;
SWEP.Primary.AmmoString 	= " .44 rounds";
SWEP.Primary.AmmoType 		= 5;
SWEP.Primary.Delay 			= 0.457;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2.794;

SWEP.Primary.IronSightPos = Vector( 2.74, 0.89, -3.34 );
SWEP.Primary.IronSightAng = Angle( 0, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 7, 0, 2 ) 
SWEP.IconFOV		= 5
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a .44 magnum";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/44magnum/bullreload.wav" ) );
	
end

function SWEP:OnDrawSound()
	
	self.Owner:EmitSound( Sound( "weapons/necropolis/44magnum/bulldraw.wav" ) );
	
end