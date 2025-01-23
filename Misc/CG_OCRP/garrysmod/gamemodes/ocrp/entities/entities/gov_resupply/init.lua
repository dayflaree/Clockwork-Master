AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	local angles = self:GetAngles()
	local newangles = angles
	self:SetAngles(Angle(0,0,0))
	self:SetModel("models/props_lab/lockers.mdl")
	self:PhysicsInit(0)
	self:SetMoveType(0)
	self:SetSolid(SOLID_VPHYSICS)
	self.LockerDoor1 = ents.Create("prop_physics")
	self.LockerDoor1:SetParent(self)
	self.LockerDoor1:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor1:SetPos(self:GetPos() + Vector(10,0,38))
	self.LockerDoor1:SetKeyValue( "spawnflags", 8)
	self.LockerDoor1:Spawn()
	self.LockerDoor1:SetMoveType(0)
	self.LockerDoor1:SetSolid(0)
	self.LockerDoor1:SetCollisionGroup(0)
	self.LockerDoor2 = ents.Create("prop_physics")
	self.LockerDoor2:SetParent(self)
	self.LockerDoor2:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor2:SetPos(self:GetPos() + Vector(10,-15,38))
	self.LockerDoor2:SetKeyValue( "spawnflags", 8)
	self.LockerDoor2:Spawn()
	self.LockerDoor2:SetCollisionGroup(0)
	self.LockerDoor2:SetMoveType(0)
	self.LockerDoor2:SetSolid(0)
	self.LockerDoor3 = ents.Create("prop_physics")
	self.LockerDoor3:SetParent(self)
	self.LockerDoor3:SetKeyValue( "spawnflags", 8)
	self.LockerDoor3:SetModel("models/props_lab/lockerdoorsingle.mdl")
	self.LockerDoor3:SetPos(self:GetPos() + Vector(10,16,38))
	self.LockerDoor3:Spawn()
	self.LockerDoor3:SetMoveType(0)
	self.LockerDoor3:SetCollisionGroup(0)
	self.LockerDoor3:SetSolid(0)
	self:SetAngles(newangles)
	self.OCRPData = {}
	self.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 6000}}
	self.OCRPData["Inventory"]["item_ammo_cop"] = 32
	self.OCRPData["Inventory"]["item_ammo_riot"] = 8
	self.OCRPData["Inventory"]["item_ammo_ump"] = 25
	self.OCRPData["Inventory"]["item_shotgun_cop"] = 1
	self.OCRPData["Inventory"]["item_taser_cop"] = 2
	self.OCRPData["Inventory"]["item_ammo_taser"] = 20
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:SetAmount(varAmount)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() && !activator.CantUse then
		activator:Resupply()
		activator.CantUse = true
		timer.Simple(0.3, function() activator.CantUse = false end)
		if activator:Team() == CLASS_POLICE || activator:Team() == CLASS_CHIEF || activator:Team() == CLASS_SWAT  then
			activator:Inv_View(self)
		end
	end
end
