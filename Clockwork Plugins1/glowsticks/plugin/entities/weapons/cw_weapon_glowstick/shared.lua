if (SERVER) then

	AddCSLuaFile( "shared.lua" )

	resource.AddFile("glowstick/glowstick_shake.wav")
	resource.AddFile("glowstick/glowstick_snap.wav")

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	language.Add ("cw_glowstick_fly", "Glow Stick")

  	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 90
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.HoldType			= "camera"
	SWEP.PrintName			= "Glow Stick"
	SWEP.Author				= "Zak"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 5	
end

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions		= "Mouse1 to drop.\nMouse2 to throw."
SWEP.HoldType			= "slam"
SWEP.Category			= "Glow Sticks"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/glowstick/v_glowstick.mdl"
SWEP.WorldModel			= "models/glowstick/stick.mdl"
SWEP.ShowWorldModel		= false

SWEP.ViewModelBoneMods = {
	["smdimport"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["glowstick"] = { type = "Model", model = "models/pg_props/pg_obj/pg_glow_stick.mdl", bone = "smdimport", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}
SWEP.WElements = {
	["glowstick"] = { type = "Model", model = "models/pg_props/pg_obj/pg_glow_stick.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.427, -0.636, 0.241), angle = Angle(0, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}

SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "grenade"
SWEP.Primary.Delay			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 2

function SWEP:Think()
end

function SWEP:Initialize()
    util.PrecacheSound("glowstick/glowstick_snap.wav");
	util.PrecacheSound("glowstick/glowstick_shake.wav");
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
					local ent = ents.Create("cw_glowstick_fly")
				
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
					local ent = ents.Create("cw_glowstick_fly")
				
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