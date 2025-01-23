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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_m16.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_m16.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/m16/famas-1.wav" );

SWEP.PrintName 				= "M16";
SWEP.EpiDesc 				= "AR-15 based rifle";

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

SWEP.MuzzleDepth 			= 53

SWEP.Primary.MaxAmmoClip 	= 30;
SWEP.Primary.AmmoString 	= " 5.56mm rounds";
SWEP.Primary.AmmoType 		= 3;
SWEP.Primary.Delay 			= 0.075;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.02, 0.02, 0.02 );
SWEP.Primary.ReloadDelay 	= 3.4;

SWEP.Primary.IronSightPos = Vector( -3.22, 0.8, -2.02 );
SWEP.Primary.IronSightAng = Angle( 0, -0, 0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, 50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.IconCamPos 	= Vector( 0, 200, 0 )
SWEP.IconLookAt 	= Vector( 15, 0, 2 ) 
SWEP.IconFOV		= 10
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "an M16";
SWEP.HeavyWeight 	= true;

SWEP.Scoped = true;
SWEP.Zoom = 50;

function SWEP:OnReloadSound()
	
	timer.Simple( 0.533, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m16/clipout.wav" ) );
	end );
	timer.Simple( 1.266, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m16/clipin.wav" ) );
	end );
	timer.Simple( 1.733, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m16/cliptap.wav" ) );
	end );
	timer.Simple( 2.4, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/m16/boltpull.wav" ) );
	end );
	
end

function SWEP:OnChangeFireMode()
	
	if( self.FireMode == 1 ) then
		
		self.Primary.Automatic = false;
		
	else
		
		self.Primary.Automatic = true;
		
	end
	
end