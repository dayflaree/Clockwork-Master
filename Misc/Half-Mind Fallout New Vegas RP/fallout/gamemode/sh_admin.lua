function concommand.AddAdmin( cmd, cb, sa )
	
	local function f( ply, cmd, args )
		
		if( sa ) then
			
			if( ply:IsSuperAdmin() ) then
				
				cb( ply, cmd, args );
				
			end
			
			return;
			
		end
		
		if( ply:IsAdmin() ) then
			
			cb( ply, cmd, args );
			
		end
		
	end
	concommand.Add( cmd, f );
	
end

function GM:PlayerNoClip( ply )
	
	if( !ply:IsAdmin() ) then
		
		return false;
		
	end
	
	if( SERVER ) then
		
		if( ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
			
			ply:GodDisable();
			ply:SetNoTarget( false );
			ply:SetNoDraw( false );
			ply:SetNotSolid( false );
			
			net.Start( "nCharacterHideMdls" );
				net.WriteEntity( ply );
				net.WriteBool( false );
			net.Broadcast();
			
			local equipped = {};
			
			for k,v in pairs( ply.Inventory ) do
			
				if( v.Equipped and v.Headgear ) then
				
					equipped[#equipped + 1] = v.Class;
					
				end
				
			end
			
			net.Start( "nCharacterUpdateModel" )
				net.WriteEntity( ply );
				net.WriteString( ply:GetModel() );
				net.WriteTable( equipped );
			net.SendPVS( ply:GetPos() );
			
			if( ply:GetActiveWeapon() != NULL ) then
				
				ply:GetActiveWeapon():SetNoDraw( false );
				ply:GetActiveWeapon():SetColor( Color( 255, 255, 255, 255 ) );
				
			end
			
		else
			
			ply:GodEnable();
			ply:SetNoTarget( true );
			ply:SetNoDraw( true );
			ply:SetNotSolid( true );

			net.Start( "nCharacterHideMdls" );
				net.WriteEntity( ply );
				net.WriteBool( true );
			net.Broadcast();
			
			if( ply:GetActiveWeapon() != NULL ) then
				
				ply:GetActiveWeapon():SetNoDraw( true );
				ply:GetActiveWeapon():SetColor( Color( 255, 255, 255, 0 ) );
				
			end
			
		end
		
	end
	
	return true;
	
end