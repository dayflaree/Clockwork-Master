if( SERVER ) then
   
 	AddCSLuaFile( "shared.lua" )
 
 end 

 
 SWEP.Base = "ep_base";
   
 SWEP.Spawnable			= false 
 SWEP.AdminSpawnable		= false 
   
if( CLIENT ) then

	SWEP.DrawCrosshair = false;

end

SWEP.HoldType = "pistol";


SWEP.ViewModel      = ""
SWEP.WorldModel   = "models/lostcoast/fisherman/harpoon.mdl"

SWEP.PrintName = "Harpoon";
SWEP.EpiDesc = "???";

SWEP.EpiHoldType = "RIFLE";

SWEP.Degrades = false;

SWEP.Primary.AmmoType = -1;

SWEP.Primary.HolsteredPos = Vector( 0, 0, 0 );
SWEP.Primary.HolsteredAng = Angle( 0, 0, 0 );
SWEP.Primary.Delay = 9999;
SWEP.Primary.Automatic = false;

SWEP.ItemWidth = 4;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 0, 200, 0 ) 
SWEP.IconLookAt = Vector( 0, 0, 0 ) 
SWEP.IconFOV = 24
SWEP.HUDWidth = 200;
SWEP.HUDHeight = 200;
SWEP.NicePhrase = "a harpoon";
SWEP.HeavyWeight = true;

SWEP.NoHolster = true;

SWEP.OverridePrimary = true;

function SWEP:Holster()
	
	return true;
	
end

function SWEP:Deploy()
	
	return true;
	
end

function SWEP:Think()
	
end