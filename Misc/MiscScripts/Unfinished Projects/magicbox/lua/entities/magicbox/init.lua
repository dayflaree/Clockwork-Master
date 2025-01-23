/*-------------------------------------------------------------------------------------------------------------------------
	Serverside magic box code
-------------------------------------------------------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

/*-------------------------------------------------------------------------------------------------------------------------
	Spawn function
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:SpawnFunction( ply, tr )
	if ( !tr.HitWorld ) then return false end
	
	local ent = ents.Create( "magicbox" )
	ent:SetPos( tr.HitPos + Vector( 0, 0, 41 ) )
	ent:Spawn()
	ent:SetAngles( Angle( 0, 180, -90 ) )
	
	return ent
end

/*-------------------------------------------------------------------------------------------------------------------------
	Initialization
-------------------------------------------------------------------------------------------------------------------------*/

local function createBox( pos, owner )
	local ent = ents.Create( "prop_physics" )
	
	ent:SetModel( "models/props_junk/wood_crate002a.mdl" )
	ent:SetOwner( owner )
	ent:SetPos( pos )
	ent:Spawn()
	timer.Simple( 0, function() ent:SetHealth( 10000 ) end )
	ent:GetPhysicsObject():EnableMotion( false )
	
	return ent
end

function ENT:Initialize()
	self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	
	self:PhysicsInitBox( Vector( -20.3231, -34.4971, -20.2868 ) * 1.2, Vector( 20.3128, 34.2730, 20.1908 ) * 1.2 )
	self:SetCollisionBounds( Vector( -20.3231, -20.2868, -34.4971 ) * 1.2, Vector( 20.3128, 20.1908, 34.2730 ) * 1.2 )
	
	self:GetPhysicsObject():EnableMotion( false )
	
	//
	//	Create box world
	//
	
	local tr = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Vector( 5000, 0, 10000 ), filter = self } )
	local pos = tr.HitPos - Vector( 0, 0, 512 )
	self:SetNWVector( "WorldPos", pos )
	self.WorldEnts = {}
	
	// Floor and ceiling
	for x = 0, 5 do
		for y = 0, 2 do
			table.insert( self.WorldEnts, createBox( pos + Vector( x * 40, y * 67, 0 ), self ) )
			table.insert( self.WorldEnts, createBox( pos + Vector( x * 40, y * 67, 151 ), self ) )
		end
	end
	
	// Sides
	for z = 0, 2 do
		for y = 0, 2 do
			table.insert( self.WorldEnts, createBox( pos + Vector( -40, y * 67, z * 38 + 38 ), self ) )
			table.insert( self.WorldEnts, createBox( pos + Vector( 6*40, y * 67, z * 38 + 38 ), self ) )
		end
	end
	
	// Front/rear
	for z = 0, 2 do
		for x = 0, 5 do
			if ( !( x == 4 and z < 2 ) ) then
				table.insert( self.WorldEnts, createBox( pos + Vector( x * 40, -66, z * 38 + 38 ), self ) )
			end
			table.insert( self.WorldEnts, createBox( pos + Vector( x * 40, 3*67-1, z * 38 + 38 ), self ) )
		end
	end
	
	//
	//	Create exit teleport
	//
	
	local tp = ents.Create( "magicbox_exit" )
	tp:SetPos( pos + Vector( 4*40, -56, 56 ) )
	tp:SetOwner( self )
	tp:Spawn()
	tp:SetAngles( Angle( 0, 0, -90 ) )
	self.Exit = tp
end

/*-------------------------------------------------------------------------------------------------------------------------
	Teleporting
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:Touch( ent )
	local off = ( ent:GetPos() - self:GetPos() )
	local y = off:Angle().y
	
	if ( ent:IsPlayer() and y >= 265 and y <= 275 ) then
		ent:SetPos( self:GetNWVector( "WorldPos" ) + Vector( 160 + off.x, -38, 20 )  )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Clean up
-------------------------------------------------------------------------------------------------------------------------*/

function ENT:OnRemove()
	for _, ent in pairs( self.WorldEnts ) do
		if ( ent:IsValid() ) then ent:Remove() end
	end
	self.Exit:Remove()
end