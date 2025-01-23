include( "shared.lua" )

function ENT:Initialize()
	self:SetRenderBoundsWS( Vector( -10000, -10000, -10000 ), Vector( 10000, 10000, 10000 ) )
end

function ENT:Think()
	if ( self:GetOwner() == LocalPlayer() ) then
		if ( GetViewEntity() != LocalPlayer() ) then
			self:SetColor( 255, 255, 255, 255 )
		else
			self:SetColor( 255, 255, 255, 0 )
		end
	end
	
	self:SetNoDraw( self:GetOwner():GetNWInt( "STORE_HAT", 0 ) == 0 )
end

function ENT:Draw()
	local hat = store.hats[ self:GetOwner():GetNWInt( "STORE_HAT" ) ]
	local index = self:GetOwner():LookupBone( "ValveBiped.Bip01_Head1" )
	local pos, ang = self:GetOwner():GetBonePosition( index )
	
	local ang2 = Angle( ang.p, ang.y, ang.r )
	ang2:RotateAroundAxis( ang:Right(), hat.angle.p )
	ang2:RotateAroundAxis( ang:Up(), hat.angle.y )
	ang2:RotateAroundAxis( ang:Forward(), hat.angle.r )
	self:SetAngles( ang2 )
	
	self:SetPos( pos + ang:Up() * hat.position.x + ang:Right() * hat.position.y + ang:Forward() * hat.position.z )
	
	self:SetModelScale( hat.scale )
	
	self:DrawModel()
end