--[[
	lauscript stuff
--]]

if (SERVER) then
	AddCSLuaFile("sh_auto.lua");
end

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Battery Charger";
end

SWEP.Instructions = "Primary Fire: Charge";
SWEP.Purpose = "Charging batteries manually.";
SWEP.Contact = "";
SWEP.Author	= "LauScript";

SWEP.HoldType = "fist"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 8;
SWEP.Primary.Delay = 2;
SWEP.Primary.Ammo = "";

SWEP.Secondary.NeverRaised = true;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

SWEP.chargeSounds = {
	"avoxgaming/charger/charger_pump_1.wav",
	"avoxgaming/charger/charger_pump_2.wav",
	"avoxgaming/charger/charger_pump_3.wav"
};

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	return true;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType);

end

-- A function to do the SWEP's animations.
function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

function SWEP:PrimaryAttack()
	if ( not self.Owner.lastCharge or self.Owner.lastCharge < CurTime() ) then
		self.Owner.lastCharge = CurTime() + 1;
		
		local battery = self.Owner:GetCharacterData("battery");
		
		if ( battery <= 100 ) then
			self.Owner:SetCharacterData("battery", battery + 20 );
			self.Owner:EmitSound( table.Random( self.chargeSounds), 50, 100 );
		end;
	end;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()

end;