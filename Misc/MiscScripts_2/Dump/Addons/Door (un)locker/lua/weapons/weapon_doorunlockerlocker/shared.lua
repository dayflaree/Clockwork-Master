if(SERVER) then

	AddCSLuaFile( "shared.lua" );

end

if(CLIENT) then

	SWEP.PrintName = "Door Unlocker/Locker"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

end

SWEP.Author			= "Sotos (Modified by _Undefined)"
SWEP.Instructions	= "Left click to lock/unlock doors. Right click to knock on a door. Reload to own an unowned door."
SWEP.Contact		= ""
SWEP.Purpose		= "Weapon for door owning and locking."

SWEP.ViewModelFlip	= false
SWEP.ViewModel = Model("models/weapons/v_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/W_pistol.mdl")

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Sound = Sound("doors/door_latch3.wav")
SWEP.Sound2 = Sound("npc/zombie/zombie_pound_door.wav")

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.NextReload = 0

function SWEP:Initialize()
	if(SERVER) then
		self:SetWeaponHoldType("pistol")
	end
end

function SWEP:PrimaryAttack()
	if( CLIENT ) then return end
	local trace = self.Owner:GetEyeTrace()	
	Dist = self.Owner:GetPos():Distance(trace.Entity:GetPos())
	if Dist > 100 then return end
	
	if trace.Entity:GetNWString("Owner") == self.Owner:Nick() then
		if trace.Entity:GetNWInt("Locked") == 1 then
			trace.Entity:Fire( "unlock", "", 0 )
			self.Owner:ChatPrint("Door Unlocked!")
			trace.Entity:SetNWInt("Locked", 0)
		else
			trace.Entity:Fire("lock", "", 0)
			self.Owner:ChatPrint("Door Locked!")
			trace.Entity:SetNWInt("Locked", 1)
		end
		self.Owner:EmitSound(self.Sound)
		self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
	end
end

function SWEP:SecondaryAttack()
	local trace = self.Owner:GetEyeTrace()
	Dist = self.Owner:GetPos():Distance(trace.Entity:GetPos())
	if Dist < 100 then
		trace.Entity:EmitSound(self.Sound2)
	end
end
  
function SWEP:Reload()
	if (CLIENT) then return end
	if CurTime() < self.NextReload then return end
	local trace = self.Owner:GetEyeTrace()
	Dist = self.Owner:GetPos():Distance(trace.Entity:GetPos())
	if Dist > 100 then return end

	if not trace.Entity:IsValid() or not trace.Entity:GetClass() == "prop_door_rotating" then return end
	
 	if(trace.Entity:GetNWString("Owner") == "World" || trace.Entity:GetNWString("Owner") == "") then
		trace.Entity:SetNWString("Owner", self.Owner:Nick())
		self.Owner:ChatPrint("Door now owned by you!")
	else
		self.Owner:ChatPrint("Door already owned!")
	end
	self.NextReload = CurTime() + 1.0
end
