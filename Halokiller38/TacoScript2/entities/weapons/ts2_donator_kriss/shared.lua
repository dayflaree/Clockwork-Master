
if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" ) 
 
 end 
 
  	SWEP.HoldType = "smg";

if( CLIENT ) then

	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFlip	= true;
	SWEP.DrawCrosshair = false;

end
 
 SWEP.Base = "ts2_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= true 
   
SWEP.Primary.Sound = Sound( "weapons/kriss.wav" );

SWEP.WorldModel = "models/weapons/w_smg_kis.mdl";
SWEP.ViewModel = "models/weapons/v_smg_kis.mdl";

SWEP.PrintName = "Kriss RIS PDW";
SWEP.TS2Desc = "Donator weapon";

SWEP.Price = 3500;

 SWEP.Primary.Recoil			= .2 
 SWEP.Primary.RecoilAdd			= .3
 SWEP.Primary.RecoilMin = .3
 SWEP.Primary.RecoilMax = .4
 
 SWEP.Primary.ViewPunchMul = 2;
 SWEP.Primary.Damage			= 9
 SWEP.Primary.NumShots		= 1 
 
 SWEP.TS2HoldType = "SMG";

SWEP.Primary.DoorBreach = false;
SWEP.Primary.HighPowered = false;
SWEP.Primary.ClipSize = 40;
SWEP.Primary.DefaultClip = 200;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .1;
SWEP.Primary.Automatic = true;
SWEP.Primary.SpreadCone = Vector( .02, .02, .02 );
SWEP.Primary.ReloadDelay = 2.3;
 
SWEP.Primary.HolsteredPos = Vector( 10.8, -5.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -5.0, 50.0, 0.0 );

SWEP.Primary.IronSightPos = Vector( 3.86, 1.376, -3.9612  );
SWEP.Primary.IronSightAng = Vector( -0.2593, 0.045, 0.8877 );

 SWEP.ItemWidth = 2;
 SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 3, -45, -10 ) 
SWEP.IconLookAt = Vector( 1, -7, -2 )
SWEP.IconFOV = 20;

 --function SWEP:Equip( Owner )

--	if( Owner:IsValid() ) then
	
--		if( Owner:SteamID() ~= "STEAM_0:1:18717157"  ) then
	
--			Owner:PrintMessage( 3, "You can't have this!" );
--			Owner:StripWeapon( "ts2_donator_kriss" );
--		end
--	end
--end



