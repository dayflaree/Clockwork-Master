
function GM:PlayerSpawn( ply )
	
	umsg.PoolString( ply:SteamID() );
	
	if( ply:GetTable().ObserveMode ) then
	
		ply:Observe( false );
	
	end
	
	ply:CrosshairDisable();
	
	if( ply:HasItem( "binoculars" ) ) then
		
		ply:SetCanZoom( true );
		
	else
		
		ply:SetCanZoom( false );
		
	end
	
	ply.zVel = 0;
	
	ply:DetatchGlasses();
	
	if( ply:GetPlayerRagdolled() ) then
		
		ply:MakeNotInvisible();
		ply:Freeze( false );
		
		ply:SetPlayerRagdolled( false );

		ply:RemoveRagdoll();
		
		ply:SetHealth( ply:GetTable().RagdollHealth );
	
	end
	
	umsg.Start( "SetOOCDelay", ply );
		umsg.Short( OOCDELAY );
	umsg.End();
	
	ply:Give( "gmod_tool" );	
	ply:Give( "weapon_physgun" );
	
	ply:SetPlayerLastHeldWeapon( "" );

	if( not ply:GetTable().Unragdolling ) then

		ply:SetPlayerRArmHP( 100 );
		ply:SetPlayerLArmHP( 100 );
		ply:SetPlayerRLegHP( 100 );
		ply:SetPlayerLLegHP( 100 );
		ply:SetPlayerSprint( 100 );
		ply:SetPlayerConscious( 100 );
		ply:SetPlayerBlood( 100 );
		ply:SetPlayerBleedingAmount( 0 );
	
	else
	
		ply:GetTable().Unragdolling = false;
	
	end
	
	if( ply:GetPlayerClass() == "Infected" ) then
	
		ply:SetPlayerIsInfected( true );
		
		for _, v in pairs( player.GetAll() ) do
			
			if( !ply:GetTable().Recognized[v:SteamID() .. "+" .. v:GetPlayerMySQLCharID()] ) then 
				
				ply:Recognize( v );
				ply:sqlSaveRecognition( v );
				
			end
			
			if( !v:GetTable().Recognized[ply:SteamID() .. "+" .. ply:GetPlayerMySQLCharID()] ) then 
				
				v:Recognize( ply );
				v:sqlSaveRecognition( ply );
				
			end
			
		end
	
	else
	
		ply:SetPlayerIsInfected( false );
	
	end
		
	ply:SetTeamModel();
	ply:GiveTeamLoadout();
	
	ply:ApplyMovementSpeeds();
	
	ply:DoModelSpecificData();
	
	if( ply.BoomerLegs ) then
		
		ply.BoomerLegs:Remove();
		ply.BoomerLegs = nil;
		
	end
	
	if( ply:GetTable().HeavyWeapon ) then
		ply:Give( ply:GetTable().HeavyWeapon.Data.ID );
		timer.Simple( .3, ply.SetHeavyWeaponHealthAmt, ply, ply:GetTable().HeavyWeapon.Data.HealthAmt );
	end

	if( ply:GetTable().LightWeapon ) then
		ply:Give( ply:GetTable().LightWeapon.Data.ID );
		timer.Simple( .3, ply.SetLightWeaponHealthAmt, ply, ply:GetTable().LightWeapon.Data.HealthAmt );
	end	
	
	if( ply:HasWeapon( "ep_hands" ) ) then
	
		ply:SelectWeapon( "ep_hands" );
	
	elseif( ply:HasWeapon( "ep_zhands" ) ) then
	
		ply:SelectWeapon( "ep_zhands" );
	
	end

end

function GM:PlayerConnect( name, address )

	umsg.Start( "PlyCon" );
		umsg.String( name );
	umsg.End();
	
end

function GM:PlayerDisconnected( ply )

	Players:PrintMessage( 2, ply:Nick() .. "(" .. ply:SteamID() .. ") has disconnected." );
	
	ply:sqlAttemptToSaveAmmo();
	-- bugged?
	
	if( ply.BoomerLegs ) then
		
		ply.BoomerLegs:Remove();
		
	end

--[[
	ply:sqlSaveInventory();
	
	umsg.Start( "PDSC" );
		umsg.String( ply:Nick() );
		umsg.String( ply:SteamID() );
	umsg.End();
	]]--
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if( not ply:GetTable().IsRagdolled ) then
		
		ply:CreateRagdoll();
	
	end

end

function GM:CanPlayerSuicide( ply )

	if( ply:GetTable().IsRagdolled ) then
	
		return false;
	
	end
	
	if( not ply:GetTable().CanSeePlayerMenu ) then
	
		return false;
	
	end
	
	if( ply:GetTable().Invisible ) then
	
		return false;
	
	end
	
	return true;

end

function GM:PlayerDeath( ply, inflictor, killer )

	for k, v in pairs( ply:GetTable().ProgressBars ) do
	
		ply:RemoveProgressBar( k );
	
	end

	if( ply:GetPlayerRagdolled() ) then
	
		ply:Freeze( false );
	
	end
	
	if( ply:GetTable().BledToDeath ) then
	
		umsg.Start( "D", ply );
			umsg.Short( 4 );
		umsg.End();
			
	else

		if( ply == killer ) then
			
			if( ply:GetTable().HitByMelee ) then
					
				umsg.Start( "D", ply );
					umsg.Short( 6 );
				umsg.End();	
				
				ply:GetTable().HitByMelee = false;
			
			elseif( ply:GetTable().HitByChainsaw ) then
			
				umsg.Start( "D", ply );
					umsg.Short( 7 );
				umsg.End();			
				
				ply:GetTable().HitByChainsaw = false;

			elseif( ply:GetTable().HelicopterCrash ) then
				
				umsg.Start( "D", ply );
					umsg.Short( 8 );
				umsg.End();			
				
				ply:GetTable().HelicopterCrash = false;
				
			else
				
				umsg.Start( "D", ply );
					umsg.Short( 1 );
				umsg.End();
				
			end
		
		end
		
		if( ply ~= killer ) then
			
			if( killer:GetClass() == "ep_commonzombie" ) then
			
				umsg.Start( "D", ply );
					umsg.Short( 5 );
				umsg.End();		
				
			elseif( ply:GetTable().HeadShot ) then
		
				umsg.Start( "D", ply );
					umsg.Short( 3 );
				umsg.End();		
				
				ply:GetTable().HeadShot = false;
	
			else
	
				umsg.Start( "D", ply );
					umsg.Short( 2 );
				umsg.End();
			
			end
		
		end

	end

end

function GM:KeyPress( ply, key )

	if( CurTime() < ply:GetTable().NextKeyPressDetect ) then
	
		return;
	
	end

	if( key == IN_JUMP ) then

		if( ply:GetPlayerIsInfected() and ( string.find( string.lower( ply:GetModel() ), "hunter.mdl" ) or
			string.find( string.lower( ply:GetModel() ), "femhunter" ) or
			string.find( string.lower( ply:GetModel() ), "hunter2.mdl" ) ) and ply:OnGround() and !ply:KeyDown( IN_ATTACK2 ) ) then
		
			ply:SetVelocity( ply:GetAimVector() * 800 );
		
		end

		ply:GetTable().NextKeyPressDetect = CurTime() + 1;
	
	end

end

function GM:GetFallDamage( ply, speed )
	
	if( ply:GetPlayerIsInfected() ) then return 0 end
	return self.BaseClass:GetFallDamage( ply, speed );
	
end

function GM:PlayerDeathSound()

	return true;

end
