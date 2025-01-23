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

SWEP.ViewModel				= "models/weapons/necropolis/v_models/v_spas12.mdl";
SWEP.WorldModel				= "models/weapons/necropolis/w_models/w_spas12.mdl";

SWEP.Primary.Sound			= Sound( "weapons/necropolis/spas12/m3-1.wav" );

SWEP.PrintName 				= "SPAS-12";
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
SWEP.Primary.Delay 			= 0.733;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.SpreadCone 	= Vector( 0.08, 0.08, 0.08 );
SWEP.ShotgunReload 			= true;

SWEP.Primary.IronSightPos = Vector( 1.21, 1.64, -0.22 );
SWEP.Primary.IronSightAng = Angle( 0.94, -3.43, -0 );

SWEP.Primary.HolsteredPos 	= Vector( -0.8, -1.0, -10.0 );
SWEP.Primary.HolsteredAng 	= Angle( 0.0, -50.0, 0.0 );

SWEP.ItemWidth 		= 4;
SWEP.ItemHeight 	= 2;

SWEP.MuzzleDepth 			= 30;

SWEP.BreaksDoors = true;

SWEP.IconCamPos 	= Vector( 0, -200, 0 )
SWEP.IconLookAt 	= Vector( 15, 0, 2 ) 
SWEP.IconFOV		= 8
SWEP.HUDWidth 		= 200;
SWEP.HUDHeight 		= 100;
SWEP.NicePhrase 	= "a SPAS-12";
SWEP.HeavyWeight 	= true;

function SWEP:OnPrimarySound( seq )
	
	if( seq == self:LookupSequence( "shoot1" ) ) then
		
		timer.Simple( 0.566, function()
			self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pump.wav" ) );
		end );
		
	else
		
		timer.Simple( 0.3, function()
			self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pumpback.wav" ) );
		end );
		timer.Simple( 0.533, function()
			self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pumpforward.wav" ) );
		end );
		
	end
	
end

function SWEP:OnReloadEndSound()
	
	timer.Simple( 0.433, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pump.wav" ) );
	end );
	
end

function SWEP:OnReloadSound()
	
	timer.Simple( 0.166, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_insertshell.wav" ) );
	end );
	
end

function SWEP:OnDrawSound()
	
	timer.Simple( 9/30, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pumpback.wav" ) );
	end );
	timer.Simple( 17/30, function()
		self.Owner:EmitSound( Sound( "weapons/necropolis/spas12/m3_pumpforward.wav" ) );
	end );
	
end