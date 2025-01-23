if (CLIENT) then
	SWEP.PrintName			= "Pump Shotgun"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "k"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_shotgun_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"

SWEP.HoldType = "shotgun"

SWEP.Peircing = 5

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 6
SWEP.Primary.Cone			= 0.12
SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Assualt = true

SWEP.SightsPos = Vector (3.0141, 0, 0.1483)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (5.7593, -3.7178, 3.4112)
SWEP.IronSightsAng = Vector (0, 0, 0)


function SWEP:Reload() 
	if self.Weapon:GetNetworkedBool("reloading",false) then return end 
	if self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then 
		self.Weapon:SetNetworkedBool("reloading",true) 
		self.Weapon:SetVar("reloadtimer",CurTime() + 0.3) 
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD) 
	end 
end 

function SWEP:CanPrimaryAttack()
	if self:GetNWBool("reloading") then return false end
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end

function SWEP:Think() 
	if self.Weapon:GetNetworkedBool("reloading",false) then 
		if self.Weapon:GetVar("reloadtimer",0) < CurTime() then 
			if self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then 
				self.Weapon:SetNetworkedBool("reloading",false) 
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) 
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
				if SERVER then
					self.Owner:Inv_GiveItem(self.Primary.AmmoItem,1)
					self.Owner:RemoveItem(self.Primary.AmmoItem,1)
				end
				return 
			end 
			self.Weapon:SetVar("reloadtimer",CurTime() + 0.3) 
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)			
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)	
			if SERVER then
				if self.Owner:HasItem(self.Primary.AmmoItem,1) then
					self.Owner:Inv_RemoveItem(self.Primary.AmmoItem,1)
					self.Owner:UpdateAmmoCount()
				end
			end	
		end
	end
end

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 1       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.5 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Callback 	= HitImpact
-- 	bullet.Callback	= function ( a, b, c ) BulletPenetration( 0, a, b, c ) end 	-- CALL THE FUNCTION BULLETPENETRATION

	self.Owner:FireBullets(bullet)					-- Fire the bullets
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)      	-- View model animation
	self.Owner:MuzzleFlash()        					-- Crappy muzzle light
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation


	if ((SinglePlayer() and SERVER) or (not SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end


	local trace = self.Owner:GetEyeTrace();

	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 250 then return end

	if trace.Entity:GetClass() == "prop_door_rotating"  and (SERVER) then	
		if !self.Owner:HasSkill("skill_picking",7) and !self.Owner:HasSkill("skill_rob",6) then return
		end

		trace.Entity:Fire("open", "", 0.001)
		trace.Entity:Fire("unlock", "", 0.001)

		local pos = trace.Entity:GetPos()
		local ang = trace.Entity:GetAngles()
		local model = trace.Entity:GetModel()
		local skin = trace.Entity:GetSkin()

		trace.Entity:SetNotSolid(true)
		trace.Entity:SetNoDraw(true)

		local function ResetDoor(door, fakedoor)
			door:SetNotSolid(false)
			door:SetNoDraw(false)
			fakedoor:Remove()
		end

		local norm = (pos - self.Owner:GetPos()):Normalize()
		local push = 55000 * norm
		local ent = ents.Create("prop_physics")

		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetModel(model)

		if(skin) then
			ent:SetSkin(skin)
		end

		ent:Spawn()

		timer.Simple(0.01, ent.SetVelocity, ent, push)               
		timer.Simple(0.01, ent:GetPhysicsObject().ApplyForceCenter, ent:GetPhysicsObject(), push)
		timer.Simple(25, ResetDoor, trace.Entity, ent)
	end
end




