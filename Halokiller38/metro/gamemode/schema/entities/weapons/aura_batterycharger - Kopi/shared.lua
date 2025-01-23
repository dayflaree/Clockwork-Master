
AddCSLuaFile( "shared.lua" )

SWEP.Author			= "LauScript"
SWEP.Contact		= ""
SWEP.Purpose		= "Charge a battery."
SWEP.Instructions	= "Click continuously to charge."

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_c4.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.chargeSounds = {
	"avoxgaming/charger/charger_pump1.wav",
	"avoxgaming/charger/charger_pump2.wav",
	"avoxgaming/charger/charger_pump3.wav"
};

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()
end;


/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
function SWEP:Reload()
end;


/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()	
end;


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if ( not self.Owner.lastCharge or self.Owner.lastCharge < CurTime() ) then
		self.Owner.lastCharge = CurTime() + 1;
		
		local battery = self.Owner:GetCharacterData("battery");
		
		if ( battery <= 80 ) then
			self.Owner:SetCharacterData("battery", battery + 20 );
			self.Owner:EmitSound( table.Random( self.chargeSounds), 50, 100 );
		end;
	end;
end;

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end;
