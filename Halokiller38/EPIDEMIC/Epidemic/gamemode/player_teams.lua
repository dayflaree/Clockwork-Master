
local meta = FindMetaTable( "Player" );

function meta:GiveTeamLoadout()

	if( self:GetPlayerIsInfected() ) then
	
		self:Give( "ep_zhands" );
	
	else

		self:Give( "ep_hands" );
		
	end

end

function meta:SetTeamModel()
	
	local modeltab = string.Explode( "#", self:GetPlayerOriginalModel() );
	local model	= modeltab[1];
	local skin	= modeltab[2] or 0;
	
	self:SetModel( model );
	self:SetSkin( skin );

end

function meta:DoModelSpecificSounds()
	
	if( self.ObserveMode ) then return end
	
	local mdl = string.lower( self:GetModel() );
	
	if( CurTime() < self:GetTable().NextModelSpecificSound ) then
	
		return;
	
	end
	
	if( not self:GetPlayerIsInfected() ) then

		if( string.find( mdl, "fsurvivor" ) or string.find( mdl, "female" ) ) then
			
			
			
		else
			
			
			
		end
		
		self:GetTable().NextModelSpecificSound = CurTime() + math.random( 45, 360 );
		
	end

end

function meta:DoModelSpecificFootsteps( pos )
	
	local mdl = string.lower( self:GetModel() );
	
	if( self:GetPlayerIsInfected() ) then
		
		if( string.find( mdl, "cyclops.mdl" ) ) then
			
			if( not self.NumFootsteps ) then self.NumFootsteps = 0 end
			
			if( self.NumFootsteps == 3 ) then
				
				self.NumFootsteps = 0;
				util.ScreenShake( pos, 200, 200, 0.8, 600 );
				
			end
			
			self.NumFootsteps = self.NumFootsteps + 1;
			
		end
		
	end
	
end

function meta:DoModelSpecificData()

	for k, v in pairs( PlayerModels ) do
	
		if( table.HasValue( v.Models, string.lower( self:GetModel() ) ) ) then
		
			if( v.Armor ) then
			
				self:SetPlayerArmor( v.Armor );
			
			end
			
			if( v.Health ) then
			
				self:SetHealth( v.Health );
			
			end
			
			return;
		
		end
	
	end

end