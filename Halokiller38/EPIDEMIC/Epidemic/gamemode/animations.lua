NewConCommand( "rp_setidleanim1", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedIdleAnim", 1 );
end );

NewConCommand( "rp_setidleanim2", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedIdleAnim", 2 );
end );

NewConCommand( "rp_setidleanim3", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedIdleAnim", 3 );
end );

NewConCommand( "rp_setidleanim4", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedIdleAnim", 4 );
end );

NewConCommand( "rp_setwalkanim1", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedWalkAnim", 1 );
end );

NewConCommand( "rp_setwalkanim2", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedWalkAnim", 2 );
end );

NewConCommand( "rp_setcrouchanim1", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedCrouchAnim", 1 );
end );

NewConCommand( "rp_setcrouchanim2", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedCrouchAnim", 2 );
end );

NewConCommand( "rp_setcrouchanim3", 1, function( ply, cmd, arg )
	ply:SetNWInt( "SelectedCrouchAnim", 3 );
end );

NewConCommand( "rp_lean", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 or ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "plazaidle" .. math.random( 1, 2 ) );
		
	end
	
end );

NewConCommand( "rp_sit", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 or ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "Sit_Ground" );
		
	end
	
end );

NewConCommand( "rp_sitchair", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		local n = math.random( 1, 5 );
		if( n == 1 ) then
			
			ForceSequence( ply, "Sit_Chair" );
			
		elseif( n == 2 ) then
			
			ForceSequence( ply, "sitccouchtv1" );
			
		elseif( n == 3 ) then
			
			ForceSequence( ply, "sitchair1" );
			
		elseif( n == 4 ) then
			
			ForceSequence( ply, "sitcouch1" );
			
		elseif( n == 5 ) then
			
			ForceSequence( ply, "sitcouchknees1" );
			
		end
		
	elseif( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		local n = math.random( 1, 6 );
		if( n == 1 ) then
			
			ForceSequence( ply, "Sit_Chair" );
			
		elseif( n == 2 ) then
			
			ForceSequence( ply, "Silo_Sit" );
			
		elseif( n == 3 ) then
			
			ForceSequence( ply, "sitccouchtv1" );
			
		elseif( n == 4 ) then
			
			ForceSequence( ply, "sitchair1" );
			
		elseif( n == 5 ) then
			
			ForceSequence( ply, "sitcouch1" );
			
		elseif( n == 6 ) then
			
			ForceSequence( ply, "sitcouchknees1" );
			
		end
		
	end
	
end );

NewConCommand( "rp_wave", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		ForceSequence( ply, "Wave", 4 );
		
	elseif( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "Wave", 3.33 );
		
	end
	
end );

NewConCommand( "rp_tinker", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "canals_arlene_tinker" );
		
	end
	
end );

NewConCommand( "rp_kneeltinker", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "d1_town05_jacobs_heal" );
		
	elseif( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		ForceSequence( ply, "roofidle1" );
		
	end
	
end );

NewConCommand( "rp_kneel", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "canals_mary_postidle" );
		
	end
	
end );

NewConCommand( "rp_examineanim", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		ForceSequence( ply, "d1_town05_Daniels_Kneel_Idle" );
		
	elseif( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "checkmalepost" );
		
	end
	
end );

NewConCommand( "rp_calmdown", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "stopwomanpre" );
		
	end
	
end );

NewConCommand( "rp_handsknees", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 or ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "d2_coast03_postbattle_idle02" );
		
	end
	
end );

NewConCommand( "rp_lieonback", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		ForceSequence( ply, "lying_down" );
		
	end
	
end );

NewConCommand( "rp_cheer", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 1 ) then
		
		if( math.random( 1, 2 ) == 1 ) then
			
			ForceSequence( ply, "cheer1", 1.86 );
			
		else
			
			ForceSequence( ply, "cheer2", 3 );
			
		end
		
	elseif( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 3 ) then
		
		ForceSequence( ply, "cheer1", 1.53 );
		
	end
	
end );

NewConCommand( "rp_entercode", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "console_type", 3.33 );
		
	end
	
end );

NewConCommand( "rp_entercodeloop", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "console_type_loop" );
		
	end
	
end );

NewConCommand( "rp_signaladvance", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_advance", 1.26 );
		
	end
	
end );

NewConCommand( "rp_signalforward", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_forward", 1.26 );
		
	end
	
end );

NewConCommand( "rp_signalgroup", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_group", 0.94 );
		
	end
	
end );

NewConCommand( "rp_signalhalt", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_halt", 1 );
		
	end
	
end );

NewConCommand( "rp_signalleft", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_left", 0.81 );
		
	end
	
end );

NewConCommand( "rp_signalright", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_right", 0.83 );
		
	end
	
end );

NewConCommand( "rp_signaltakecover", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 2 ) then
		
		ForceSequence( ply, "signal_takecover", 0.85 );
		
	end
	
end );

NewConCommand( "rp_shove", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 19 ) then
		
		ForceSequence( ply, "barrelpush", 1 );
		
	end
	
end );

NewConCommand( "rp_pushbutton", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 19 ) then
		
		ForceSequence( ply, "buttonfront", 2.166 );
		
	end
	
end );

NewConCommand( "rp_stop", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 19 ) then
		
		ForceSequence( ply, "harassfront2", 1.6333 );
		
	end
	
end );

NewConCommand( "rp_point", 1, function( ply, cmd, arg )
	
	if( ply:GetTable().AnimTable and ply:GetTable().AnimTable == 19 ) then
		
		ForceSequence( ply, "point", 0.933 );
		
	end
	
end );

function CCToggleHolster( ply, cmd, arg )

	local weap = ply:GetActiveWeapon();
	
	if( weap and weap:IsValid() and weap:GetTable().Primary and not weap:GetTable().Primary.CanToggleHolster ) then
		return;
	end
	
	if( weap and weap:IsValid() ) then
	
		local class = weap:GetClass();

		if( class == "weapon_physcannon" or
			class == "weapon_physgun" or
			class == "gmod_tool" ) then return; end
		
		if( weap:GetTable().HolsterToggle ) then
			weap:GetTable().HolsterToggle( weap );
		end
		
	
	end
	
	local val = !ply:GetNWBool( "Holstered", true );
	
	if( !val and weap:GetTable().PlayDrawHolsterAnim ) then
		
		weap:Deploy( true );
		
	end
	
	--ply:SetPlayerHolstered( !ply:GetPlayerHolstered() );
	ply:SetNWBool( "Holstered", val );
	umsg.Start( "HackUpdatePlayerHolster", ply );
		umsg.Bool( val );
	umsg.End();
	
	--ply:DrawViewModel( true );

end
concommand.Add( "rp_toggleholster", CCToggleHolster );