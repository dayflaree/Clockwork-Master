if SERVER then
	AddCSLuaFile("shared.lua")
end
  
if CLIENT then
    SWEP.PrintName = "Use Gun"
    SWEP.Slot = 0
    SWEP.SlotPos = 0
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
end
  
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
  
SWEP.Author = "_Undefined"
SWEP.Contact = ""
SWEP.Purpose = "Use things from far away."
SWEP.Instructions = "Aim on anything usable and click to use."
  
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
  
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
  
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
  
function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	local tr = self:GetOwner():GetEyeTrace()
	if tr.Entity and tr.Entity.Use then
		tr.Entity:Use(self:GetOwner())
	else
		tr.Entity:Fire("use", "1", 0)
	end
end
  
function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end