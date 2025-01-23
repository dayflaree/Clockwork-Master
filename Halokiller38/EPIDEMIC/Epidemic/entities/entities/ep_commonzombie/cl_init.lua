
include( "shared.lua" );

function ENT:Draw()
	
	--self:SetRenderAngles( Angle( 0, self:GetNWInt( "OverrideY" ), 0 ) );
	self:DrawModel();
	
end
