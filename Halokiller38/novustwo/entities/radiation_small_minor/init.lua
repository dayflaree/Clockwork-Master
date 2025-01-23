AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.Entity:DrawShadow( false )
	
	self.Active = true
	self.Radius = 250
	self.Pos = self.Entity:GetPos()
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( self.ClassName )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:KeyValue( key, value )

	if key == "radius" then
	
		self.Radius = math.Clamp( tonumber( value ), 100, 5000 )
	
	elseif key == "randomradius" then
	
		self.Radius = math.random( 100, math.Clamp( tonumber( value ), 500, 5000 ) )
	
	end

end

function ENT:GetRadiationRadius()

	return self.Radius

end

function ENT:Think()
	
	if not self.Active then return end
	
	for k,v in pairs( player.GetAll() ) do
	if (NEXUS.player.IsNoClipping(v)) then return end
	
		local dist = v:GetPos():Distance( self.Pos )
	
		if dist < self.Radius then
			
			if ( v.RadAddTime or 0 ) < CurTime() then
		
				v.RadAddTime = CurTime() + 6
				v:SetCharacterData( "radiation", math.Clamp(v:GetCharacterData("radiation") + 1, 0, 1000) );
				
			end
			
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( dist / self.Radius, 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + scale * 1.5
				
				if (v:GetCharacterData("radiation") < 10) then
				
					v:EmitSound( "Geiger.BeepLow", 40, math.random( 90, 110 ) )
				
				else
				
					v:EmitSound( "Geiger.BeepHigh", 40, math.random( 90, 110 ) )
				
				end
			
			end
		
		end
	
	end
	
end

