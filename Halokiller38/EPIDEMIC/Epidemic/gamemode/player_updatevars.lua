
local meta = FindMetaTable( "Player" );

function meta:OnUpdatedPlayerConscious( val, newval )

	if( ( val >= 50 and newval < 50 ) or ( newval >= 50 and val < 50 ) or
		CurTime() > self:GetTable().CanUpdateConsciousBasedSpeed ) then
	
		self:ApplyConsciousBasedSpeed( newval );
	
		self:GetTable().CanUpdateConsciousBasedSpeed = CurTime() + 1;
	
	end

end

function meta:OnUpdatedPlayerLLegHP( val, newval )

	self:OnUpdateLegHealth( newval );

end

function meta:OnUpdatedPlayerRLegHP( val, newval )

	self:OnUpdateLegHealth( newval );

end

