if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.Slot = 1;
	SWEP.SlotPos = 5;
	SWEP.PrintName = "Hands";
end
SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.ViewModel = "models/weapons/v_pistol.mdl";
SWEP.ViewModelFOV = 64;
SWEP.HoldType = "normal";

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 0;
SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;

function SWEP:PrimaryAttack()
	return false;
end;

function SWEP:SecondaryAttack()
	return false;
end;