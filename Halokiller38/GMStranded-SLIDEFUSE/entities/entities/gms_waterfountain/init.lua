AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

--Called when an entity is no longer touching this SENT.
--Return: Nothing
function ENT:EndTouch(entEntity)
end

--Called when the SENT is spawned
--Return: Nothing

function ENT:Initialize()
	self.Entity:SetModel("models/props/de_inferno/fountain.mdl")
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetColor(255,255,255,255)
end

function ENT:Use(ply)
if !(SPropProtection.PlayerIsPropOwner(ply, self.Entity) or SPropProtection.IsBuddy(ply, self.Entity)) then return end
	if ply.Thirst < 1000 and ply.Thirst > 950 then
		ply.Thirst = 1000
		ply:UpdateNeeds()
		if ply.Hasdrunk == false or ply.Hasdrunk == nil then
			ply:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1,2)..".wav"))
			ply.Hasdrunk = true
			timer.Simple(0.9, function()	ply.Hasdrunk = false end, ply)
		end				
		elseif ply.Thirst < 950 then
		ply.Thirst = ply.Thirst + 50
		if ply.Hasdrunk == false or ply.Hasdrunk == nil then
			ply:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1,2)..".wav"))
			ply.Hasdrunk = true
			timer.Simple(0.9, function()	ply.Hasdrunk = false end, ply)
		end				
		ply:UpdateNeeds()
	end
end

function ENT:AcceptInput(input, ply)
end

--Called when the entity key values are setup (either through calls to ent:SetKeyValue, or when the map is loaded).
--Return: Nothing
function ENT:KeyValue(k,v)
end

--Called when a save-game is loaded.
--Return: Nothing
function ENT:OnRestore()
end

--Called when something hurts the entity.
--Return: Nothing
function ENT:OnTakeDamage(dmiDamage)
end

--Controls/simulates the physics on the entity.
--Return: (SimulateConst) sim, (Vector) linear_force and (Vector) angular_force
function ENT:PhysicsSimulate(pobPhysics,numDeltaTime)
end

--Called when an entity starts touching this SENT.
--Return: Nothing
function ENT:StartTouch(entEntity)
end

--Called when the SENT thinks.
--Return: Nothing
function ENT:Think()
end

--Called when an entity touches this SENT.
--Return: Nothing
function ENT:Touch(entEntity)
end

--Called when: ?
--Return: TRANSMIT_ALWAYS, TRANSMIT_NEVER or TRANSMIT_PVS
function ENT:UpdateTransmitState(entEntity)
end