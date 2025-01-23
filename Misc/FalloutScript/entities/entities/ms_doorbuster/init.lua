AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
		
function ENT:SpawnFunction( userid, tr )
	local trace = util.GetPlayerTrace( userid, userid:GetCursorAimVector() )
	local tr = util.TraceLine( trace )
	local thisent = ents.Create( "ms_doorbuster" )
		thisent:SetPos( tr.HitPos + tr.HitNormal * 32 )
		thisent:SetAngles( tr.HitNormal:Angle() )
		thisent:Spawn()
	thisent:Activate()
end

function ENT:Initialize()
self.Entity:SetModel("models/weapons/w_c4.mdl")
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Timer=0
self.Active=false
self.Lastbeep=CurTime()
self.Numbeeps=1
util.PrecacheSound("hl1/fvox/beep.wav")
end

function ENT:PhysicsCollide(data, physobj)
	if string.find(data.HitEntity:GetClass(),"door") then
	constraint.Weld(self.Entity,data.HitEntity,0,0,0)
	end
end

function ENT:Use( activator, caller )
	if self.Active==false then
	self.Active=true
	self.Timer=CurTime()
	self.Entity:EmitSound("hl1/fvox/beep.wav",75, 200)
	self.Lastbeep=CurTime()
	end
end

function door_reset(doorent,pos)
doorent:SetPos(pos)
end

function ENT:StartTouch()
end

function ENT:EndTouch()
end

function ENT:AcceptInput(name,activator,caller)
	if name=="explode" then
		self.Entity:Use(activator,caller)
	end
end

local function explodeshit(xent)
	local doors = ents.FindInSphere(xent:GetPos(),25)
		for i=1,table.getn(doors) do
			if (doors[i]:GetClass()=="prop_door_rotating") then
			
				doors[i]:Fire("unlock","",0)
				doors[i]:Fire("open","",0)
				
				timer.Simple(60,door_reset,doors[i],doors[i]:GetPos())
				
						local ent = ents.Create( "prop_physics" )
						ent:SetPos(doors[i]:GetPos())
						ent:SetAngles(doors[i]:GetAngles())
						ent:SetKeyValue( "model", doors[i]:GetModel( ) ) 
						ent:Spawn()
						ent:Activate()
						ent:SetSkin(doors[i]:GetSkin())
						doors[i]:SetPos(Vector(-10000,-10000,-10000))
						ent:Fire("enablemotion","",0)
						local physobj=ent:GetPhysicsObject()
						if physobj:IsValid() then
							physobj:SetVelocity( (ent:GetPos()-xent:GetPos()):Normalize()*500 )
						end
			else
			doors[i]:Fire("unlock","",0)
			doors[i]:Fire("open","",0)
			end
		end
		

	local ent = ents.Create( "env_explosion" )
	ent:SetPos(xent:GetPos())
	ent:SetKeyValue( "iMagnitude", "50" ) 
	ent:Spawn()
	ent:Activate()
	ent:Fire("Explode","",0)
	ent:Fire("Kill","",0.1)
	local effect = EffectData()
		effect:SetOrigin(xent:GetPos())
		effect:SetScale(600)
	util.Effect("super_explosion2", effect)
 	local effectdata = EffectData() 
 		effectdata:SetOrigin( xent:GetPos() ) 
 		effectdata:SetNormal( Vector(0,0,0) ) 
 		effectdata:SetMagnitude( 10 ) 
 		effectdata:SetScale( 1 ) 
 		effectdata:SetRadius( 18 ) 
 	util.Effect( "Sparks", effectdata, true, true ) 

end

function ENT:Think()
	if self.Active==true and self.Lastbeep+1/self.Numbeeps<CurTime() then
	self.Entity:EmitSound("hl1/fvox/beep.wav", 75, 200)
	self.Lastbeep=CurTime()
	self.Numbeeps=self.Numbeeps+1
	end

	if self.Active==true and self.Timer+5<CurTime() then
	explodeshit(self.Entity)
	self.Entity:Remove()
	end
end
