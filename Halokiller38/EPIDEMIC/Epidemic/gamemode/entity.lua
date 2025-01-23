local meta = FindMetaTable( "Entity" );

function meta:IsOwnedBy( ply )

	if( self:GetTable().SpawnedBy == ply ) then
	
		return true;
	
	end
	
	if( self:GetTable().Owners and table.HasValue( self:GetTable().Owners, ply ) ) then
	
		return true;
	
	end
	
	return false;

end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
	if( ent:GetClass() == "prop_door_rotating" ) then
		
		if( dmginfo:IsBulletDamage() ) then
			
			if( !ent.DoorHealth or ( ent.DoorHealth and ent.DoorHealth <= 13 ) ) then
				
				HandleDoorDamage( ent, attacker );
				
			end
			
		end
		
	end
	
end