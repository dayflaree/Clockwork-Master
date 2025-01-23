--[[
function CreateTS2NPC( ply, class )

	local ent = ents.Create( class );
	ent:SetPos( ply:GetEyeTrace().HitPos );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	ent.Owner = ply;
	ent:Spawn();

	return ent;

end
--]]

--Commands
function ccEnemyNPC( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	HandleNPCEnemy( ply, ply:GetEyeTrace() );

end
concommand.Add( "rpa_setenemynpc", ccEnemyNPC )

function ccHealthNPC( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not tonumber( arg[1] ) ) then
		Console( ply, "rpa_sethealthnpc <Number> - Sets the NPC's health" );
		return;
	end
	
	HandleNPCHealth( ply, ply:GetEyeTrace(), arg[1] );

end
concommand.Add( "rpa_sethealthnpc", ccHealthNPC )

function ccMoveNPC( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	HandleNPCMove( ply, ply:GetEyeTrace() );

end
concommand.Add( "rpa_movenpc", ccMoveNPC )

function ccSelectNPC( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	HandleNPCSelect( ply, ply:GetEyeTrace() );

end
concommand.Add( "rpa_selectnpc", ccSelectNPC )

--Main coding
function HandleNPCEnemy( ply, tr )

	if( not tr.Entity or
		not tr.Entity:IsValid() or
		not tr.Entity:IsPlayer() ) then
		
		ply:PrintMessage( 3, "Must select enemy as a player!" );
		return;
		
	end
	
	for k, v in pairs( ply.SelectedNPCS ) do
	
		local npc = ents.GetByIndex( k );
	
		if( npc and npc:IsValid() ) then
		
			npc:AddEntityRelationship( tr.Entity, D_HT, 99 );
			npc:SetEnemy( tr.Entity );
			
		end
	
	end

	ply:PrintMessage( 3, "Set NPC(s) enemy!" );

end
concommand.Add( "rpa_setenemynpc", ccHandleNPCEnemy )

function HandleNPCHealth( ply, tr, health )

	if not tr.Entity or
		not tr.Entity:IsValid() or
		not tr.Entity:IsNPC() then
		
		ply:PrintMessage( 3, "Must select NPC!" );
		return;
		
	end
	
	tr.Entity:SetHealth( tonumber( health ) );

	ply:PrintMessage( 3, "Set NPC health to: " .. health );
	
end

function HandleNPCSelect( ply, tr )

	if( not tr.Entity or
		not tr.Entity:IsValid() or
		not tr.Entity:IsNPC() ) then
		
		ply:PrintMessage( 3, "Must select NPC!" );
		return;
		
	end
	
	if( not ply.SelectedNPCS ) then
	
		ply.SelectedNPCS = { }
		
	end
	
	if( ply.SelectedNPCS[tr.Entity:EntIndex()] ) then
	
		ply.SelectedNPCS[tr.Entity:EntIndex()] = nil;
		ply:PrintMessage( 3, "Unselected NPC" );
		return;
	
	end

	ply.SelectedNPCS[tr.Entity:EntIndex()] = { }
	ply:PrintMessage( 3, "Selected NPC" );
	
end

function HandleNPCMove( ply, tr )

	for k, v in pairs( ply.SelectedNPCS ) do
	
		local npc = ents.GetByIndex( k );
	
		if( npc and npc:IsValid() ) then
		
			npc:SetLastPosition( tr.HitPos );
			npc:SetSchedule( SCHED_FORCED_GO );
		
		end
	
	end

	ply:PrintMessage( 3, "NPC(s) moved" );

end