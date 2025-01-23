
local meta = FindMetaTable( "Player" );

--Set sprint speed (not jogging speed)
function meta:SetSprintSpeed( spd )

	self:GetTable().SprintSpeed = spd;

end

ModelCrouchWalkSpeeds = { };
ModelWalkSpeeds = { };
ModelRunSpeeds = { };
ModelSprintSpeeds = { };

ModelCrouchWalkSpeeds["failure.mdl"] = 150;
ModelCrouchWalkSpeeds["boomer.mdl"] = 60;
ModelCrouchWalkSpeeds["hunter"] = 75;
ModelCrouchWalkSpeeds["ghoul.mdl"] = 60;
ModelCrouchWalkSpeeds["classic_torso.mdl"] = 45;
ModelCrouchWalkSpeeds["fast_torso.mdl"] = 155;
ModelCrouchWalkSpeeds["/chell.mdl"] = 66;
ModelCrouchWalkSpeeds["fisherman.mdl"] = 50;

ModelWalkSpeeds["failure.mdl"] = 50;
ModelWalkSpeeds["boomer.mdl"] = 85;
ModelWalkSpeeds["hunter"] = 85;
ModelWalkSpeeds["fat.mdl"] = 45;
ModelWalkSpeeds["/chell.mdl"] = 190;
ModelWalkSpeeds["ghoul.mdl"] = 60;
ModelWalkSpeeds["classic_torso.mdl"] = 45;
ModelWalkSpeeds["fast_torso.mdl"] = 155;
ModelWalkSpeeds["fisherman.mdl"] = 50;

ModelRunSpeeds["failure.mdl"] = 50;
ModelRunSpeeds["bloodsucker"] = 310;
ModelRunSpeeds["boomer.mdl"] = 175;
ModelRunSpeeds["hunter"] = 225;
ModelRunSpeeds["ghoul"] = 255;
ModelRunSpeeds["fat.mdl"] = 190;
ModelRunSpeeds["classic_torso.mdl"] = 45;
ModelRunSpeeds["fast_torso.mdl"] = 155;
ModelRunSpeeds["/chell.mdl"] = 190;
ModelRunSpeeds["fisherman.mdl"] = 108;

ModelSprintSpeeds["failure.mdl"] = 50;
ModelSprintSpeeds["bloodsucker"] = 400;
ModelSprintSpeeds["boomer.mdl"] = 175;
ModelSprintSpeeds["hunter"] = 225;
ModelSprintSpeeds["fat.mdl"] = 190;
ModelSprintSpeeds["ghoul"] = 255;
ModelSprintSpeeds["classic_torso.mdl"] = 45;
ModelSprintSpeeds["fast_torso.mdl"] = 155;
ModelSprintSpeeds["/chell.mdl"] = 190;
ModelSprintSpeeds["fisherman.mdl"] = 108;

--Apply the default movement speeds to a player. 
function meta:ApplyMovementSpeeds()

	--SetRunSpeed is to set JOGGING speed.
	if( self:GetPlayerConscious() < 50 ) then
	
		self:ApplyConsciousBasedSpeed();
		return;
	
	end
	
	if( self:GetPlayerLLegHP() < 60 or 
		self:GetPlayerRLegHP() < 60 ) then
	
		self:ApplyLegHealthBasedSpeed();
		return;
	
	end
	
	local cw = true;
	for k, v in pairs( ModelCrouchWalkSpeeds ) do
		
		if( string.find( string.lower( self:GetModel() ), k ) ) then
			
			self:SetCrouchedWalkSpeed( v );
			cw = false;
			
		end
		
	end
	
	if( cw ) then
		
		self:SetCrouchedWalkSpeed( 250 );
		
	end
	
	local w = true;
	for k, v in pairs( ModelWalkSpeeds ) do
		
		if( string.find( string.lower( self:GetModel() ), k ) ) then
			
			self:SetWalkSpeed( v );
			w = false;
			
		end
		
	end
	
	if( w ) then
		
		self:SetWalkSpeed( 90 );
		
	end
	
	local r = true;
	for k, v in pairs( ModelRunSpeeds ) do
		
		if( string.find( string.lower( self:GetModel() ), k ) ) then
			
			self:SetRunSpeed( v );
			r = false;
			
		end
		
	end
	
	if( r ) then
		
		self:SetRunSpeed( 250 );
		
	end
	
	local s = true;
	for k, v in pairs( ModelSprintSpeeds ) do
		
		if( string.find( string.lower( self:GetModel() ), k ) ) then
			
			self:SetCrouchedWalkSpeed( v );
			s = false;
			
		end
		
	end
	
	if( s ) then
		
		self:SetSprintSpeed( 310 );
		
	end

end

--Cease the player from moving.
function meta:StopMovement()
	
	if( self and self:IsValid() ) then
		
		self:SetWalkSpeed( 0 );
		self:SetCrouchedWalkSpeed( 0 );
		self:SetRunSpeed( 0 );
		self:SetSprintSpeed( 0 );
		
	end
	
end

--Happens when player runs out of sprint
function meta:NoSprintMovement()

	if( self:GetPlayerConscious() < 50 ) then
	
		self:ApplyConsciousBasedSpeed();
		return;
	
	end

	self:SetWalkSpeed( 80 );
	self:SetCrouchedWalkSpeed( 180 );
	self:SetRunSpeed( 150 );
	self:SetSprintSpeed( 150 );	

end

--Conscious based speeds
function meta:ApplyConsciousBasedSpeed()

	if( self:GetTable().NoSprintMode ) then
	
		if( self:GetPlayerConscious() < 50 ) then
		
			local change = 50 - self:GetPlayerConscious();

			self:SetWalkSpeed( 75 - change * .45 );
			self:SetCrouchedWalkSpeed( 180 - change * .5 );
			self:SetRunSpeed( 150 - change * 1.1 );
			self:SetSprintSpeed( 150 - change * 1.1 );	
				
		else
		
			self:NoSprintMovement();
		
		end

	else
	
		if( self:GetPlayerConscious() < 50 ) then
		
			local change = 50 - self:GetPlayerConscious();
				
			self:SetWalkSpeed( 90 - change * .45 );
			self:SetCrouchedWalkSpeed( 250 - change * .5 );
			self:SetRunSpeed( 230 - change * 1.1 );
			self:SetSprintSpeed( 260 - change * 1.1 );	
	
		else
		
			self:ApplyMovementSpeeds();
		
		end
	
	end

end

function meta:ApplyLegHealthBasedSpeed()

	if( self:GetPlayerRLegHP() > 60 and
		self:GetPlayerLLegHP() > 60 ) then self:ApplyMovementSpeeds(); return; end

	local rdmgdone = math.Clamp( 60 - self:GetPlayerRLegHP(), 0, 100 );
	local ldmgdone = math.Clamp( 60 - self:GetPlayerLLegHP(), 0, 100 );
	
	local dmgdone = rdmgdone + ldmgdone;
	
	local slowdownperc = dmgdone / 60;
	
	if( dmgdone < 100 ) then
	
		if( self:GetTable().NoSprintMode ) then
		
			self:SetWalkSpeed( 75 - 20 * slowdownperc );
			self:SetCrouchedWalkSpeed( 180 - 20 * slowdownperc );
			self:SetRunSpeed( 150 - 30 * slowdownperc );
			self:SetSprintSpeed( 150 - 30 * slowdownperc );	
	
		else
	
			self:SetWalkSpeed( 90 - 30 * slowdownperc );
			self:SetCrouchedWalkSpeed( 250 - 25 * slowdownperc );
			self:SetRunSpeed( 230 - 90 * slowdownperc );
			self:SetSprintSpeed( 260 - 100 * slowdownperc );	
	
		
		end
		
	else
	
		self:SetWalkSpeed( 90 - 30 * slowdownperc );
		self:SetCrouchedWalkSpeed( 250 - 25 * slowdownperc );
		self:SetRunSpeed( 20 );
		self:SetSprintSpeed( 20 );	
	
	end
	
end


