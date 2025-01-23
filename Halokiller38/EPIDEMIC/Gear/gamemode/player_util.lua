
local meta = FindMetaTable( "Player" );

PlayerRagdolls = { }

function meta:CallEvent( name )
	
	if( !self or !self:IsValid() ) then return end
	umsg.Start( "_" .. name, self ); umsg.End();

end

function meta:BaseInitialize()

	self:GetTable().Vars = { }

	for k, v in pairs( PlayerVars ) do
	
		self:GetTable().Vars[k] = v.default;
	
	end

end

function meta:CreateServerSideVariables()

	for k, v in pairs( SSPlayerVars ) do
	
		self:GetTable()[k] = v.value;
	
	end

end

function meta:ResetVariables()

	if( self:GetTable().Vars ) then

		for k, v in pairs( PlayerVars ) do
		
			if( v.canreset ) then
		
				self:GetTable().Vars[k] = v.default;
			
			end
			
		end
		
		self:CallEvent( "ResetVariables" );

	end

end

function meta:Initialize()

	

end

function meta:MakeInvisible( b )

	if( b == nil ) then
		b = true;
	end

	self:SetNotSolid( b );
	self:SetNoDraw( b );
	self:DrawViewModel( !b );
	
	if( self:GetActiveWeapon():IsValid() ) then
		self:GetActiveWeapon():SetNoDraw( b );
	end
	
	self:GetTable().Invisible = b;

end

function meta:MakeNotInvisible()

	self:MakeInvisible( false );
	
	self:GetTable().Invisible = false;

end

function meta:BleedOutADecal()

	local trace = { }
	trace.start = self:EyePos();
	trace.endpos = trace.start - Vector( 0, 0, 80 );
	
	local front = false;
	local back = false;
	local mid = false;
	
	if( math.random( 1, 3 ) == 2 ) then
		back = true;
	elseif( math.random( 3, 6 ) == 4 ) then
		mid = true;
	else
		front = true;
	end
	
	if( front ) then
		trace.endpos = trace.endpos + self:GetForward() * 30;
	elseif( back ) then
		trace.endpos = trace.endpos + self:GetForward() * -30;
	end
	
	local left = false;
	local right = false;
	local center = false;
	
	if( mid ) then
		if( math.random( 1, 3 ) == 2 ) then
			left = true;
		else
			right = true;
		end
	else
		if( math.random( 1, 3 ) == 2 ) then
			left = true;
		elseif( math.random( 4, 7 ) == 5 ) then
			right = true;
		else
			center = true;
		end
	end
	
	if( left ) then
		trace.endpos = trace.endpos + self:GetRight() * -30;
	elseif( right ) then
		trace.endpos = trace.endpos + self:GetRight() * 30;
	end

	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	local pos = tr.HitPos;
	local norm = tr.HitNormal;

	util.Decal( "Blood", pos + norm, pos - norm );

end

function meta:RagdollPlayer()

	if( self:GetTable().IsRagdolled ) then
		return;
	end

	local ragdoll = ents.Create( "prop_ragdoll" );
	
	ragdoll:SetPos( self:GetPos() );
	ragdoll:SetAngles( self:GetAngles() );
	ragdoll:SetModel( self:GetModel() );
	ragdoll:SetOwner( self );
	
	ragdoll:Spawn();
	
	local c = ragdoll:GetPhysicsObjectCount();
	
	local vel = self:GetVelocity();
	
	for n = 1, c do
		
		local bone = ragdoll:GetPhysicsObjectNum( n );
		
		if( bone and bone:IsValid() ) then
		
			local bonepos, boneang = self:GetBonePosition( ragdoll:TranslatePhysBoneToBone(n) );
			
			bone:SetPos( bonepos );
			bone:SetAngle( boneang );
			bone:AddVelocity( vel );
			
		end
		
	end

	self:MakeInvisible();
	
	self:Freeze( true );
	
	self:GetTable().IsRagdolled = true;
	self:GetTable().RagdollEntity = ragdoll;
	ragdoll:GetTable().IsPlayerRagdoll = true;
	ragdoll:GetTable().Player = self;
	
	self:SetPlayerRagdolled( true );
	
	table.insert( PlayerRagdolls, ragdoll );
	
	return ragdoll;
	
end

function meta:UnragdollPlayer()

	self:GetTable().IsRagdolled = false;

	self:MakeNotInvisible();
	self:Freeze( false );
	self:CrosshairDisable();
	
	self:SetPlayerRagdolled( false );

	local spawnpos;

	if( self:GetTable().RagdollEntity and self:GetTable().RagdollEntity:IsValid() ) then
	
		if( self:Health() > 0 ) then
			spawnpos = self:GetTable().RagdollEntity:GetPos();
			self:RemoveRagdoll();
		end
		
	end
	
	if( self:Health() > 0 ) then
	
		self:Spawn();

		if( spawnpos ) then
		
			self:SetPos( spawnpos );
		
		end

	end

end

function meta:RemoveRagdoll()

	if( self:GetTable().RagdollEntity and self:GetTable().RagdollEntity:IsValid() ) then
		
		self:GetTable().RagdollEntity:Remove();
		self:GetTable().RagdollEntity = nil;

	end

end
