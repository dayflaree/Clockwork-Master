
if( not CommonNPCs ) then
	CommonNPCs = { };
end

NPCHordes = { }

HordePause = false;

function CreateHordeSpot( pos, limit, delay )

	table.insert( NPCHordes, {
	
		NextSpawnTime = CurTime(),
		Pos = pos,
		DelayTime = delay,
		Limit = limit,
		Ent = { },
	
	} );

end

function HandleHorde( horde )

	if( CurTime() > horde.NextSpawnTime ) then
	
		horde.NextSpawnTime = CurTime() + horde.DelayTime;

		local count = 0;
		
		for k, v in pairs( horde.Ent ) do
		
			if( v:IsValid() ) then
			
				count = count + 1;
			
			else
			
				horde.Ent[k] = nil;
			
			end
		
		end

		if( count < horde.Limit ) then
		
			local ent = CreateCommonAt( horde.Pos );
			table.insert( horde.Ent, ent );
			
		end
	
	end

end

function CreateCommonAt( pos, owner )

	local ent = ents.Create( "ep_commonzombie" );

	ent:SetPos( pos );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	
	if( owner ) then
	
		ent:GetTable().Owner = owner;
	
	end
	
	ent:Spawn();
	
	undo.Create( "Common Infected" );
		undo.AddEntity( ent );
		undo.SetPlayer( owner );
	undo.Finish();
	
	table.insert( CommonNPCs, ent );
	
	return ent;

end

function MoveAllCommonToShootPos( ply )

	for k, v in pairs( CommonNPCs ) do
	
		if( v:IsValid() ) then
	
			local pos = ply:GetEyeTrace().HitPos;
			
			v:RunToPoint( pos, true );
			
		end
		
	end	

end

function CreateCommonInfrontPlayer( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 400;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );

	return CreateCommonAt( tr.HitPos, ply );


end

function ClearOwnerCommons( ply )

	for k, v in pairs( CommonNPCs ) do
	
		if( v:IsValid() and v:GetTable().Owner == ply ) then
	
			v:Remove();
			CommonNPCs[k] = nil;
		
		end
		
	end

end

function ClearAllCommons()

	for k, v in pairs( CommonNPCs ) do
	
		if( v:IsValid() ) then
	
			v:Remove();
		
		end
		
	end
	
	CommonNPCs = { };

end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo ) -- nope
end