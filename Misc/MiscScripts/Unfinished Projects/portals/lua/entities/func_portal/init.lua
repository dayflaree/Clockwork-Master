// Basic entity info
ENT.Type = "brush"

// Helper functions
local function calculateNewVelocity( portal, vel )
	if ( math.abs( portal.direction.y ) > 0 ) then
		vel.x = 0.11 * -vel.x
		vel.y = -vel.y
	end
	
	return vel
end

local function calculateNewOffset( portal, offset )
	if ( math.abs( portal.direction.y ) > 0 ) then
		offset.x = -offset.x
		offset.y = -offset.y
	end
	
	return offset
end

local function calculateNewAngles( portal, exit, angles )
	if ( ( portal.direction - exit.direction ):Length() < 1 ) then
		angles:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end
	
	return angles
end

// Movement handling
function ENT:StartTouch( ply )
	if ( ply:GetVelocity():Dot( self.direction ) > 0 ) then return end
	
	local vel = ply:GetVelocity()
	vel = calculateNewVelocity( self, vel )
	ply:SetLocalVelocity( vel )
	
	local angles = ply:EyeAngles()
	angles = calculateNewAngles( self, self.exit, angles )
	ply:SetEyeAngles( angles )
	
	local offset = ply:GetPos() - self:OBBCenter()
	offset = calculateNewOffset( self, offset )
	local pos = self.exit:OBBCenter() + offset
	ply:SetPos( pos + vel / 7.4 )
end

// Find paired entity
function ENT:Think()
	// Determine exit portal
	if ( !self.exit ) then
		for _, ent in ipairs( ents.FindByClass( "func_portal" ) ) do
			if ( ent != self and ent.pair == self.pair ) then
				self.exit = ent
				return
			end
		end
	end
end

// Collect properties
function ENT:KeyValue( key, value )
	if ( key == "pair" ) then
		self.pair = tonumber( value )
	elseif ( key == "direction" ) then
		self.direction = Vector( unpack( value:Split( " " ) ) )
	end
end