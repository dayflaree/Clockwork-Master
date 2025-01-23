if ( SERVER ) then 
   
 	AddCSLuaFile( "shared.lua" ) 

end 
 
  	SWEP.HoldType = "pistol";
	
if( CLIENT ) then
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "ts2_base";
   
SWEP.Spawnable			= false 
SWEP.AdminSpawnable		= true 

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"; --model
SWEP.WorldModel = "models/weapons/w_crowbar.mdl";

SWEP.Price = 250;

SWEP.PrintName = "Crowbar";
SWEP.TS2Desc = "A slightly rusted metal crowbar";

SWEP.Primary.Delay = .09;
SWEP.IsMelee = true;
 
SWEP.TS2HoldType = "PISTOL";

SWEP.Primary.HolsteredPos = Vector( 2.8, -2.0, -2.0 );
SWEP.Primary.HolsteredAng = Vector( -15.0, 15.0, 0.0 );
   
SWEP.ItemWidth = 3;
SWEP.ItemHeight = 1;

SWEP.IconCamPos = Vector( 6, -46, 7 )  
SWEP.IconLookAt = Vector( 0, 8, 0 )
SWEP.IconFOV = 19

SWEP.SwipeSounds =
{

	"npc/vort/claw_swing1.wav",
	"npc/vort/claw_swing2.wav",

}
