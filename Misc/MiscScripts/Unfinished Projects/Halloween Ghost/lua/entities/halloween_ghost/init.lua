AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

resource.AddFile( "models/props_halloween/ghost.mdl" )
resource.AddFile( "models/props_halloween/ghost.sw.vtx" )
resource.AddFile( "models/props_halloween/ghost.vvd" )
resource.AddFile( "models/props_halloween/ghost.dx80.vtx" )
resource.AddFile( "models/props_halloween/ghost.dx90.vtx" )
resource.AddFile( "materials/models/props_halloween/scary_ghost.vmt" )
resource.AddFile( "materials/models/props_halloween/scary_ghost.vtf" )
resource.AddFile( "particles/scary_ghost.pcf" )
resource.AddFile( "sound/vo/halloween_moan1.wav" )
resource.AddFile( "sound/vo/halloween_moan2.wav" )
resource.AddFile( "sound/vo/halloween_moan3.wav" )
resource.AddFile( "sound/vo/halloween_moan4.wav" )
resource.AddFile( "sound/vo/halloween_boo1.wav" )
resource.AddFile( "sound/vo/halloween_boo2.wav" )
resource.AddFile( "sound/vo/halloween_boo3.wav" )
resource.AddFile( "sound/vo/halloween_boo4.wav" )
resource.AddFile( "sound/vo/halloween_boo5.wav" )
resource.AddFile( "sound/vo/halloween_boo6.wav" )
resource.AddFile( "sound/vo/halloween_boo7.wav" )

include( "shared.lua" )

function ENT:DebugMessage( msg )
	for _, pl in pairs( player.GetAll() ) do
		pl:ChatPrint( "Ghost #" .. self.Entity:EntIndex() .. " -> " .. msg )
	end
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.HitWorld ) then return end
 
	local ent = ents.Create( "halloween_ghost" )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 32 ) )
	ent:Spawn()
 
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel( "models/props_halloween/ghost.mdl" )
	
	self.Entity:PhysicsInitBox( Vector() * -8, Vector() * 8 )
	self.Entity:SetCollisionBounds( Vector() * -8, Vector() * 8 )
	self.Entity:SetSolid( SOLID_NONE )
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
	end
	
	self.Entity:StartMotionController()
	
	self.ShadowParams = {}
	self.NextMoan = CurTime() + math.random( 1, 3 )
	self.NextBoo = 0
	self.HauntedPlayer = table.Random( player.GetAll() )
	self.Ang = 0
end

function ENT:Think()
    if ( CurTime() > self.NextMoan ) then
		self.Entity:EmitSound( "vo/halloween_moan" .. math.random( 1, 4 ) .. ".wav" )
		self.NextMoan = CurTime() + math.random( 5, 8 )
	elseif ( CurTime() > self.NextBoo and self.Entity:GetPos():Distance( self.HauntedPlayer:GetPos() ) ) then
		local yaw = ( self.Entity:GetPos() - self.HauntedPlayer:GetPos() ):Angle().y - self.HauntedPlayer:EyeAngles().y
		
		if ( yaw > 160 and yaw < 200 ) then
			self.Entity:EmitSound( "vo/halloween_boo" .. math.random( 1, 7 ) .. ".wav" )
			self.NextBoo = CurTime() + math.random( 3, 5 )
			
			self.HauntedPlayer:ViewPunch( Angle( -30, 0, 0 ) )
			self.HauntedPlayer:SetHealth( self.HauntedPlayer:Health() - 10 )
			if ( self.HauntedPlayer:Health() < 1 ) then
				self.HauntedPlayer:Kill()
				
				ParticleEffect( "ExplosionCore_sapperdestroyed", self.Entity:GetPos(), Angle( 0, 0, 0 ) )
				self.Entity:Remove()
			end
		end		
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	phys:Wake()
	
	local target = self.HauntedPlayer:GetPos() + Vector( 0, 0, 32 )
	if ( target:Distance( self.Entity:GetPos() ) > 266 ) then
		self.ShadowParams.pos = Lerp( 1 - 256 / target:Distance( self.Entity:GetPos() ), self.Entity:GetPos(), target )
		self.ShadowParams.angle = ( self.HauntedPlayer:GetPos() - self.Entity:GetPos() ):Angle()
		
		local offsetPos = self.Entity:GetPos() - target
		self.Ang = math.deg( math.acos( offsetPos.x / self.Entity:GetPos():Distance( target ) ) )
	else
		self.Ang = ( self.Ang + 1 ) % 360
		self.ShadowParams.pos = self.HauntedPlayer:GetPos() + Vector( math.cos( math.rad( self.Ang ) ) * 256, math.sin( math.rad( self.Ang ) ) * 256, 0 )
		self.ShadowParams.angle = ( self.HauntedPlayer:GetPos() - self.Entity:GetPos() ):Angle()
	end
	
	self.ShadowParams.secondstoarrive = 1
	self.ShadowParams.maxangular = 5000
	self.ShadowParams.maxangulardamp = 10000
	self.ShadowParams.maxspeed = 1000000
	self.ShadowParams.maxspeeddamp = 10000
	self.ShadowParams.dampfactor = 0.8
	self.ShadowParams.teleportdistance = 5012
	self.ShadowParams.deltatime = deltatime
 
	phys:ComputeShadowControl( self.ShadowParams )
end