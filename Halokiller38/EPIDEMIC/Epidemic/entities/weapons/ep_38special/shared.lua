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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_38special.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_38special.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/38special/deagle-1.wav" );

SWEP.PrintName 				= ".38 Special";
SWEP.EpiDesc 				= "Revolver";

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

SWEP.Primary.MaxAmmoClip 	= 6;
SWEP.Primary.AmmoString 	= " .38 rounds";
SWEP.Primary.AmmoType 		= 6;
SWEP.Primary.Delay 			= 0.4;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.015, 0.015, 0.015 );
SWEP.Primary.ReloadDelay 	= 2.2;

SWEP.Primary.IronSightPos = Vector( 2.82, 1.56, -4.01 );
SWEP.Primary.IronSightAng = Angle( 0.2, 0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng 	= Angle( -25, 0, 0 );

SWEP.ItemWidth 		= 2;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 5, 17, 2 ) 
SWEP.IconFOV		= 3
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a .38";
SWEP.LightWeight 	= true;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.733, function()
		self.Owner:EmitSound( "BaseCombatWeapon.WeaponDrop" );
	end );
	
end