
local meta = FindMetaTable( "Player" );

function meta:ReturnControls()

	self:UnSpectate();
	
	if( self:GetTable().FakeSpectate ) then
	
		self:Freeze( false );
		self:DrawViewModel( true );
		self:SetNoDraw( false );
		self:GetTable().FakeSpectate = false;

	end

end

function meta:FakeSpectate()

	self:Freeze( true );
	self:DrawViewModel( false );
	self:SetNoDraw( true );
	self:GetTable().FakeSpectate = true;

end


function meta:SpectateNewPlayerOrFreeze()

	if( not self:SpectateRandomPlayer() ) then
	
		self:FakeSpectate();
	
	end

end


function meta:SpectatePlayer( ent )

	self:Spectate( 5 );
	self:SpectateEntity( ent );
	self:Freeze( false );
	
	self:GetTable().SpectatingEntity = ent;
	self:GetTable().SpectatingIndex = ent:EntIndex();

end

function meta:CanSpectate( ent )

	return true;

end

function meta:SpectateRandomPlayer()

	for k, v in pairs( player.GetAll() ) do
	
		if( self:CanSpectate( v ) ) then
		
			self:SpectatePlayer( v );
			return true;
		
		end
	
	end

	return false;

end

function meta:SpectateNextPlayer()

	if( not self:GetTable().SpectatingIndex ) then
		return self:SpectateRandomPlayer();
	end
	
	local plys = { }
	local start = 0;
	
	for k, v in pairs( player.GetAll() ) do
	
		if( self:CanSpectate( v ) ) then
		
			table.insert( plys, v );
			
			if( v == self:GetTable().SpectatingEntity ) then
			
				start = #plys;
			
			end
		
		end
	
	end
	
	local searching = true;
	local orig = start;
	
	while( searching ) do
	
		start = start + 1;
		
		if( start > #plys ) then
		
			start = 1;
		
		end
		
		if( orig == start ) then
		
			searching = false;
		
		end
		
		if( plys[start] ) then
		
			searching = false;
		
		end
		
	end
	
	local newply = plys[start];
	
	if( newply ) then
	
		self:SpectatePlayer( newply );
		return true;
	
	end
	
	return false;

end

function meta:SpectatePreviousPlayer()

	if( not self:GetTable().SpectatingIndex ) then
		return self:SpectateRandomPlayer();
	end
	
	local plys = { }
	local start = 0;
	
	for k, v in pairs( player.GetAll() ) do
	
		if( self:CanSpectate( v ) ) then
		
			table.insert( plys, v );
			
			if( v == self:GetTable().SpectatingEntity ) then
			
				start = #plys;
			
			end
		
		end
	
	end
	
	local searching = true;
	local orig = start;
	
	while( searching ) do
	
		start = start - 1;
		
		if( start < 1 ) then
		
			start = #plys;
		
		end
		
		if( orig == start ) then
		
			searching = false;
		
		end
		
		if( plys[start] ) then
		
			searching = false;
		
		end
		
	end
	
	local newply = plys[start];
	
	if( newply ) then
	
		self:SpectatePlayer( newply );
		return true;
	
	end
	
	return false;

end