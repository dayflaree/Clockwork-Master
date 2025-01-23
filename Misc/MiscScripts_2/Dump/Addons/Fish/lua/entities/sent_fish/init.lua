// Send files to client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

// Include shared file
include("shared.lua")

ENT.LifeTimeOutOfWater	= 5 // The amount of time a fish can last without water (in seconds)
ENT.Depth				= 20 // How deep a fish is swimming (source units?)
ENT.SwimSpeed			= 3 // Self explanatory
ENT.Models				= {
"models/props/cs_militia/fishriver01.mdl",
"models/props/de_inferno/GoldFish.mdl",
"models/props/prop_clownfish.mdl",
"models/props/prop_damselfish.mdl",
"models/props/prop_grammabasslet.mdl",
"models/props/prop_moorishidol.mdl"
}

ENT.OutOfWater			= nil
ENT.OutOfWaterTimer		= nil
ENT.IsAlive				= nil
ENT.DeadTime			= nil

function ENT:SpawnFunction(player,trace)
	if trace.Hit then
		local ent = ents.Create("sent_fish")
		// set the spawn pos
		ent:SetPos(trace.HitPos + trace.HitNormal * 16)
		// choose a random model
		local random = math.random(1,#self.Models)
		ent:SetModel(self.Models[random])
		ent:Spawn()
		ent:Activate()
		return ent
	end
end

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.IsAlive = true
	self.OutOfWater = false
end

function ENT:OnTakeDamage(dmginfo)
	// react to the damage
	self.Entity:TakePhysicsDamage(dmginfo)
	self:Kill()
end

function ENT:Kill()
	self.IsAlive = false
	self.DeadTime = CurTime()
	hook.Add("Think",self.Entity:EntIndex().."fishfadeout",
	function()
		// Five second delay before fading out (and eventually removed)
		if self.DeadTime < (CurTime() - 5) then
			local r,g,b,a = self.Entity:GetColor()
			if a > 0 then
				// Fadout like dead npcs do
				self.Entity:SetColor(r,g,b,a - 1)
			else
				// Remove the hook and the entity
				self.Entity:Remove()
				hook.Remove("Think",self.Entity:EntIndex().."fishfadeout")
			end
		end
	end)
end

function ENT:Think()
	if self.IsAlive then
		// check if the fish is underwater
		if self.Entity:WaterLevel() > 0 then
			self.OutOfWater = false
			local pos = self.Entity:GetPos()
			// Make the fish swim at a certain depth
			local tr = {}
			tr.start = pos + Vector(0,0,self.Depth)
			tr.endpos = pos + Vector(0,0,self.Depth + 25)
			tr.mask = MASK_WATER
			
			local phys = self.Entity:GetPhysicsObject()
			if not phys or not phys:IsValid() then return end
			
			local traceline = util.TraceLine(tr)
			if !traceline.Hit then
				// Keep it from floating up
				phys:ApplyForceCenter(Vector(0,0,-90) * 2)
			end
			local ang = math.abs(math.Round(self.Entity:GetAngles().y))
			local ang2 = math.Round(self.Entity:GetAngles().y)
			// Make the fish "swim" in the direction it's facing
			if ((ang <= 360) && (ang >= 315)) || ((ang <= 45) && (ang >= 0)) then
				phys:ApplyForceCenter(Vector(90,0,0) * (self.SwimSpeed + math.Rand(-0.5,0.5)))
			elseif ((ang >= 135) && (ang <= 225)) then
				phys:ApplyForceCenter(Vector(-90,0,0) * (self.SwimSpeed + math.Rand(-0.5,0.5)))
			elseif ((ang2 > 45) && (ang2 < 135)) || ((ang2 < -225) && (ang2 > -315)) then
				phys:ApplyForceCenter(Vector(0,90,0) * (self.SwimSpeed + math.Rand(-0.5,0.5)))
			elseif ((ang2 > 225) && (ang2 < 315)) || ((ang2 < -45) && (ang2 > -135)) then
				phys:ApplyForceCenter(Vector(0,-90,0) * (self.SwimSpeed + math.Rand(-0.5,0.5)))
			end
			// Keep the fish from rolling right/left or looking up/down
			self.Entity:SetAngles(Angle(0,self.Entity:GetAngles().y,0))
		else
			if !self.OutOfWater then
				self.OutOfWaterTimer = CurTime()
				self.OutOfWater = true
			else
				if CurTime() >= (self.OutOfWaterTimer + self.LifeTimeOutOfWater) then
					// If the entity is out of the water for too long...
					self:Kill()
				end
			end
			// Make the fish jump if it is out of water.
			local trace = util.QuickTrace(self.Entity:GetPos(),Vector(0,0,-90),{self.Entity})
			if trace.HitWorld then
				// Check if the entity is on the ground
				if (self.Entity:GetPos() - trace.HitPos):Length() <= 5 then
					// Height of the jump depends on how long it's already been out of water.
					phys:ApplyForceCenter(Vector(0,0,90) * (75 * (1 / ((CurTime() + self.LifeTimeOutOfWater) - self.OutOfWaterTimer))))
				end
			end
		end
		if self.Entity:IsOnFire() then
			self.Entity:SetColor(0,0,0,255)
			self:Kill()
		end
	end
end

function ENT:Use(activator,caller,type,value)
	if activator:IsPlayer() then
		// feed the player, increase their health
		activator:SetHealth(activator:Health() + 5)
	end
	self.Entity:Remove()
end
