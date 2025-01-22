if (SERVER) then

	AddCSLuaFile( "shared.lua" )
resource.AddFile("models/glowstick/v_glowstick_wht.mdl")
resource.AddFile("models/glowstick/stick_wht.mdl")
resource.AddFile("materials/models/glowstick/glow_wht.vtf")
resource.AddFile("materials/models/glowstick/01.vtf")

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	
end

if ( CLIENT ) then

  language.Add ("ent_glowstick_fly", "Glow Stick White")
  	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 56
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.HoldType			= "slam"	
	SWEP.PrintName			= "Glow Stick"
	SWEP.Author				= "Patrick Hunt"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 5
	
end

SWEP.Author			= "Patrick Hunt"
SWEP.Contact		= "Patrick06Hunt@gmail.com"
SWEP.Purpose		= ""
SWEP.Instructions		= "LMB - Drop lighitng glow stick."
SWEP.HoldType			= "slam"
SWEP.Category			= "Glow Sticks"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/glowstick/v_glowstick_wht.mdl"
SWEP.WorldModel			= "models/glowstick/stick_wht.mdl"

SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "bugbait"
SWEP.Primary.Delay		= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 2

function SWEP:Think()
end

function SWEP:Initialize()
    //util.PrecacheSound(self.Primary.Sound);
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
   self.Weapon:SetNextPrimaryFire(CurTime() + 1.75)
   return true
end

function SWEP:Reload()
	return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self:TakePrimaryAmmo(1)
		
		timer.Simple(0.5, function()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
				if SERVER then
					local ent = ents.Create("ent_glowstick_wht_fly")
				
				ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
				ent:SetAngles(self.Owner:EyeAngles())
				ent:Spawn()
				ent:Activate()
								
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 125)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
			end
		end)
			timer.Simple(1, function()
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			end)
end

function SWEP:SecondaryAttack()
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
	self:TakePrimaryAmmo(1)
	
		timer.Simple(0.5, function()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
				if SERVER then
					local ent = ents.Create("ent_glowstick_wht_fly")
				
				ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
				ent:SetAngles(self.Owner:EyeAngles())
				ent:Spawn()
				ent:Activate()
								
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 500)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
			end
		end)
			timer.Simple(1, function()
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			end)
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end