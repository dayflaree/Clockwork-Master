

function GM:ShowHelp( ply )

	if( CurTime() < ply:GetTable().NextHelp ) then return; end
	if( not ply:GetTable().CanSeePlayerMenu ) then return; end	

	ply:CallEvent( "ToggleHelpMenu" );

	ply:GetTable().NextHelp = CurTime() + .3;

end

function GM:ShowSpare1( ply )

	if( CurTime() < ply:GetTable().NextShowSpare ) then return; end
	if( not ply:GetTable().CanSeePlayerMenu ) then return; end

	--Toggle the player menu
	ply:CallEvent( "TogglePM" );
	
	ply:GetTable().NextShowSpare = CurTime() + .3;

end

function GM:ShowSpare2( ply )

	if( CurTime() < ply:GetTable().NextShowSpare ) then return; end

	ply:GetTable().NextShowSpare = CurTime() + .3;

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 90;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsPlayer() ) then
		
			if( ply:GetTable().Recognized[tr.Entity:SteamID() .. "+" .. tr.Entity:GetPlayerMySQLCharID()] ) then 
			
				ply:NoticePlainWhite( "Already recognized player" );
				return; 
				
			end
			
			ply:NoticePlainWhite( "Recognized player" );
			
			ply:Recognize( tr.Entity );
			
			ply:sqlSaveRecognition( tr.Entity );
			
		end
		
		if( tr.Entity:GetTable().SpawnedBy ) then
		
			ply:HandlePropInteraction( tr.Entity );
			ply:GetTable().PAEntity = tr.Entity;
		
		end

		if( tr.Entity:GetTable().ItemData ) then
		
			if( ply:GetPlayerIsInfected() ) then return; end
		
			local itemdata = tr.Entity:GetTable().ItemData;
			
			if( string.find( itemdata.Flags, "w" ) or string.find( itemdata.Flags, "v" ) ) then
			
				ply:CarryWeapon( tr.Entity );
			
			elseif( string.find( itemdata.Flags, "i" ) ) then
			
				if( not ply:HasItemInventory( itemdata.ID ) ) then
			
					ply:UseItemEntity( tr.Entity );
			
				else
				
					ply:NoticePlainWhite( "Already have this." );
				
				end
			
			else
			
				local invs = ply:GetAvailableInventories();
				
				if( #invs == 0 ) then
				
					ply:NoticePlainWhite( "You do not have enough inventory space." );
					return;
				
				end
				
				local availinv = { }
			
				for k, v in pairs( invs ) do
				
					if( ply:HasInventorySpace( v, itemdata.Width, itemdata.Height ) ) then
					
						table.insert( availinv, v );
					
					end
					
				end
				
				if( #availinv == 0 ) then
				
					ply:NoticePlainWhite( "You do not have enough inventory space." );
					return;
				
				else
			
					ply:HandlePickingUpEntity( availinv[1], tr.Entity );
	
				end
				
			end
		
		end
		
	end
	
	
end

function GM:PlayerSwitchFlashlight( ply )

	if( CurTime() < ply:GetTable().NextFlashLight ) then
		return false;
	end

	ply:GetTable().NextFlashLight = CurTime() + 1;

	return ply:HasItem( "flashlight" );

end

NextSpawnIntervalCheck = 0;

NextServerThink = CurTime();

function GM:Think()

	if( NextServerThink > CurTime() ) then return; end

	NextServerThink = CurTime() + .3;

	Players:Think();
	
	if( not HordePause ) then
	
		for k, v in pairs( NPCHordes ) do
		
			HandleHorde( v );
		
		end
		
	end
	
	if( ITEMSPAWN_ENABLED ) then
		
		if( CurTime() > NextSpawnIntervalCheck ) then
		
			NextSpawnIntervalCheck = CurTime() + .3;
		
			for k, v in pairs( ItemSpawnPoints ) do
			
				if( CurTime() > v.nextinterval ) then
				
					HandleItemSpawning( k );
				
				end
			
			end
			
		end
		
	end

end

function GM:InitPostEntity()

	LoadWeaponsToItems();
	LoadItemSpawnerMap();
	LoadItemSpawnerState();

end

function GM:PlayerCanHearPlayersVoice( ply, ply2 )
	
	return false;

end