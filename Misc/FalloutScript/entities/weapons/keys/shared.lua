if (SERVER) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 0
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then
	SWEP.PrintName      = "Keys"
	SWEP.Author    = ""
	SWEP.Instructions = "Left click to lock doors. Right click to unlock. Keeps you in a neutral pose."
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.Contact    = ""
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
end
 
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
 
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.Primary.ClipSize      =-1
SWEP.Primary.DefaultClip    =-1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic    = false

SWEP.Secondary.ClipSize      =-1
SWEP.Secondary.DefaultClip    =-1
SWEP.Secondary.Ammo = "none"

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	local trace = self.Owner:GetEyeTrace( entity )
	local target = trace.Entity
	
	if( not target:IsValid() or not LEMON.IsDoor or self.Owner:EyePos():Distance( target:GetPos() ) > 90 ) then
	return; end
	
	RunConsoleCommand("rp_lockdoor", target:EntIndex())
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.0 )

end

function SWEP:SecondaryAttack()

	if CLIENT then return end
	local trace = self.Owner:GetEyeTrace( entity )
	local target = trace.Entity
	
	if( not target:IsValid() or not LEMON.IsDoor or self.Owner:EyePos():Distance( target:GetPos() ) > 90 ) then
	return; end
	
	RunConsoleCommand("rp_unlockdoor", target:EntIndex())
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 )

end

function SWEP:Think()
end

function SWEP:Initialize()
	if (CLIENT) then return end
	self:SetWeaponHoldType("normal")
end 