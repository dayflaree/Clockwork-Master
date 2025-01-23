
local meta = FindMetaTable( "Player" );

function meta:TransferToNewCharacter( name, classid, age, desc, model )
	
	self:SetPlayerDidInitialCC( true );
	
	self:ApplyMovementSpeeds();
	self:MakeInvisible( false );
	
	local modeltab = string.Explode( "#", model );
	local mdl	= modeltab[1];
	local skin	= modeltab[2] or 0;
	
	self:SetModel( mdl );
	self:SetSkin( tonumber( skin ) );
	
	self:CharacterInitialize();

	self:SetNWString( "RPName", name );
	self:SetPlayerClass( classid );
	self:SetPlayerAge( age );
	self:SetPlayerPhysDesc( desc );
	self:SetPlayerOriginalModel( model );
	
	self.CurRadioFreq = 0;
	self:CallEvent( "RRM" );
	
	self:ApplyMovementSpeeds();

	self:GetTable().Recognized = { }
	self:GetTable().SendPlayerNames = { }

	umsg.Start( "RPR" );
		umsg.Short( self:EntIndex() );
	umsg.End();

	umsg.Start( "RRL", self );
	umsg.End();

	if( self:sqlCharacterExists() ) then
	
		timer.Simple( .5, self.DoRecognitionList, self );
	
	else

		-- INITIAL CHARACTER SAVING
		self:sqlCreateCharacterSave();
	
	end
	
	self:SetPlayerMySQLCharID( self:sqlGetCharacterID() );
	
	self:Freeze( false );
	
	self:KillSilent();
	self:Spawn();

end

function meta:DoRecognitionList()
	
	local delay = 0;
	
	local tbl = self:sqlGetRecognizedPlayers();
	
	for k, v in pairs( player.GetAll() ) do
	
		if( ( v:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] and
			self:GetTable().Recognized[v:SteamID() .. "+" .. v:GetPlayerMySQLCharID()] ) or
			table.HasValue( tbl, v ) ) then
			
			timer.Simple( delay, self.CreateRecognitionWith, self, v );
			
			delay = delay + .3;
			
		end
	
	end

end

function meta:CreateRecognitionWith( ply )

	umsg.Start( "RPHI", self );
		umsg.Short( ply:EntIndex() );
		umsg.String( ply:RPNick() .. "\n" .. ply:GetPlayerPhysDesc() );
	umsg.End();
	
	umsg.Start( "RPHI", ply );
		umsg.Short( self:EntIndex() );
		umsg.String( self:RPNick() .. "\n" .. self:GetPlayerPhysDesc()  );
	umsg.End();

			
	ply:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()]  = { }		
	self:GetTable().Recognized[ply:SteamID() .. "+" .. ply:GetPlayerMySQLCharID()] = { }
	
	
end

function meta:Recognize( ply )

	if( ply:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) then
			
		umsg.Start( "RPHI", self );
			umsg.Short( ply:EntIndex() );
			umsg.String( ply:RPNick() .. "\n" .. ply:GetPlayerPhysDesc() );
		umsg.End();
		
		umsg.Start( "RPHI", ply );
			umsg.Short( self:EntIndex() );
			umsg.String( self:RPNick() .. "\n" .. self:GetPlayerPhysDesc()  );
		umsg.End();
			
	end
			
	self:GetTable().Recognized[ply:SteamID() .. "+" .. ply:GetPlayerMySQLCharID()] = { }
		

end

function meta:GetRPName()

	return self:GetNWString( "RPName" );

end

function meta:RPNick()

	return self:GetNWString( "RPName" );

end

function meta:GiveHealth( amt )

	self:SetHealth( math.Clamp( self:Health() + amt, 0, self:GetTable().MaxHealth ) );

end

function meta:UpdateAdminFlags()

	self:GetTable().AdminFlags = GAMEMODE.ServerAdmins[self:SteamID()] or "";

	if( self:IsSuperAdmin() ) then
	
		self:GetTable().AdminFlags = "+";
	
	end

end

function meta:HolsterWeaponIfPossible()

	local weap = self:GetActiveWeapon();
	
	if( weap and weap:IsValid() ) then

		if( weap:GetTable() and weap:GetTable().Primary ) then
			
			self:SetNWBool( "Holstered", weap:GetTable().Primary.HolsteredAtStart or false );
			umsg.Start( "HackUpdatePlayerHolster", self );
				umsg.Bool( weap:GetTable().Primary.HolsteredAtStart or false );
			umsg.End();

		end
	
	end

end

function meta:TakeHealth( amt )
	
	if( !self:Alive() ) then return end
	
	if( amt >= self:Health() ) then
		
		self:Kill();
		return;
	
	end

	self:SetHealth( self:Health() - amt );

end

function meta:MakeInvisible( b )
	
	if( !self or !self:IsValid() ) then return end
	
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

	for k, v in pairs( self:GetTable().AttachedProps ) do
	
		if( v.Entity:IsValid() ) then
		
			v.Entity:SetNoDraw( bool );
		
		end
	
	end

end

function meta:MakeNotInvisible()

	self:MakeInvisible( false );
	
	self:GetTable().Invisible = false;

end


function meta:Observe( bool )

	self:GetTable().ObserveMode = bool;
	self:SetNoDraw( bool );

	for k, v in pairs( self:GetTable().AttachedProps ) do
	
		if( v.Entity:IsValid() ) then
		
			v.Entity:SetNoDraw( bool );
		
		end
	
	end

	if( self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() ) then
		self:GetActiveWeapon():SetNoDraw( bool );
	end
		
	self:SetNotSolid( bool );
	
	if( bool ) then
		self:SetMoveType( 8 );
		self:GodEnable();
	else
		self:SetMoveType( 2 );
		self:GodDisable();
		self:GetTable().NullifyNextFallDmg = true;
	end
	
end


--[[
--======================================--
-- HANDLE JUMP FALL                     --
--======================================--

This function is called everytime the player falls from a distance.

190 is the minimum distance for the player's movement to be stopped momentarily after a fall.

]]--

function meta:HandleJumpFall( dist )

	if( dist > 280 ) then
		
		self:TakeHealth(( dist - 280 ) * .5 );
		
	end

end

--[[
function meta:HandleJumpFall( dist )

	if( dist >= 190 ) then
	
		--Imitate the effect of falling and stopping.
	
		self:ConCommand( "+duck" );
		self:StopMovement();	
		
		self:ViewPunch( Angle( 1, 1, 0 ) * 15 );
		
		timer.Simple( .4, function()
		
			self:ConCommand( "-duck" );
			self:ApplyMovementSpeeds();
		
		end );
	 -- removed due to unpredicted
		if( dist > 280 ) then
			
			local dmg = ( dist - 280 ) * 1.3;
		
			local rmul = math.Rand( .5, 1.3 );
			local lmul = math.Rand( .5, 1.3 );
			
			self:SetPlayerLLegHP( math.Clamp( self:GetPlayerLLegHP() - dmg * lmul, 0, 100 ) );
			self:SetPlayerRLegHP( math.Clamp( self:GetPlayerRLegHP() - dmg * rmul, 0, 100 ) );
			
			self:TakeHealth(( dist - 280 ) * .5 );
				
		end
	
	else
	
		--self:ViewPunch( Angle( 4, 0, 0 ) );
	
	end

end
--]]
