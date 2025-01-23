if SERVER then --the init.lua stuff goes in here
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end
 
if CLIENT then --the cl_init.lua stuff goes in here
	SWEP.PrintName = "Dildo Launcher"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	language.Add ("Undone_Dildooo", "Stashed Dildo")
end
 
 
SWEP.Author = "_Undefined"
SWEP.Contact = ""
SWEP.Purpose = "DILDO THAT SON O' BITCH"
SWEP.Instructions = "Left click to throw a dildo, right click to get horny."
SWEP.Category = "Prop Launchers"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/v_RPG.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
 
local ShootSound = Sound("weapons/crossbow/fire1.wav")

function SWEP:Reload()
	if not last then last = CurTime() end
	if CurTime() < last + 1 then return end
	
	self:DefaultReload(ACT_VM_RELOAD)
	
	for i = 1, 10 do
		self:FireProp("models/dildo2.mdl")
	end
	
	last = CurTime()
end
 
function SWEP:Think()
end

function SWEP:FireProp(model)
	local tr = self.Owner:GetEyeTrace()
	
	self.Weapon:EmitSound(ShootSound)
	self.BaseClass.ShootEffects(self)
 
	if not SERVER then return end
 
	local ent = ents.Create("prop_physics")
	ent:SetModel(model)
 
	ent:SetPos(self.Owner:EyePos())
	ent:SetOwner(self.Owner)
	local ang = self.Owner:EyeAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ent:SetAngles(ang)
	ent:Spawn()
	
	ent:SetColor(math.Rand(0, 1) * 255, math.Rand(0, 1) * 255, math.Rand(0, 1) * 255, 255)
 
	local phys = ent:GetPhysicsObject()
	
	phys:SetMass(500)
	phys:SetMaterial("gmod_bouncy")
 
	local shot_length = tr.HitPos:Length()
	phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  math.pow(shot_length, 3))
 
	cleanup.Add(self.Owner, "props", ent)
 
	undo.Create("Dildooo")
	undo.AddEntity(ent)
	undo.SetPlayer(self.Owner)
	undo.Finish()
end

function SWEP:PrimaryAttack()
	self:FireProp("models/dildo2.mdl")
end
 
function SWEP:SecondaryAttack()
	self:FireProp("models/dildo.mdl")
end