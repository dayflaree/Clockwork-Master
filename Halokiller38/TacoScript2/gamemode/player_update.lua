local meta = FindMetaTable( "Player" );

function meta:OnUpdatePlayerSpeed()

	self:ComputePlayerSpeeds();
	
	return true;

end

function meta:OnUpdatePlayerBleeding( oldval, val )

	if( val == true and ( self:IsCP() ) ) then
		return false;
	end

	return true;

end

function meta:OnUpdatePlayerFreezeHead( oldval, val )

	if( val ) then
	
		self:DrawViewModel( false );
	
	else
	
		self:DrawViewModel( true );
	
	end

	return true;

end