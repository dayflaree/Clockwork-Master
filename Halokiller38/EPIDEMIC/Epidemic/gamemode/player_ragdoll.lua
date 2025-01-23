
local meta = FindMetaTable( "Player" );

function meta:Passout()

	if( self:GetPlayerRagdolled() ) then return; end
	if( not self:Alive() ) then return; end

	self:GetTable().RagdollHealth = self:Health();

	self:RagdollPlayer();

	for k, v in pairs( self:GetTable().AttachedProps ) do
	
		if( v.Entity:IsValid() ) then
		
			v.Entity:SetNoDraw( true );
		
		end
	
	end

end

function meta:Getup()

	if( not self:GetPlayerRagdolled() ) then return; end
	if( not self:Alive() ) then return; end
	
	self:GetTable().Unragdolling = true;

	self:UnragdollPlayer();
	
	self:GetTable().Unragdolling = false;

	for k, v in pairs( self:GetTable().AttachedProps ) do
	
		if( v.Entity:IsValid() ) then
		
			v.Entity:SetNoDraw( false );
		
		end
	
	end


end


