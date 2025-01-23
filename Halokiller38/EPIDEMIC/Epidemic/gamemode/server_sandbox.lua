
GM.ToolLogs = { };
GM.PropLogs = { };

function GM:PhysgunPickup( ply, ent )
	
	if( ent.NoPhys ) then return false end
	
	if( ply:HasAdminFlags( "p" ) ) then 
	
		if( ent:IsPlayer() ) then
			
			ent:SetGravity( 0.001 );
			
		end
		
		return true; 
		
	end
	
	if( not ply:HasPlayerFlags( "t" ) ) then
	
		if( ent:GetTable().SpawnedBy == ply ) then
		
			return true;
			
		else
		
			return false;
		
		end
	
	end


	if( ent:IsPlayer() ) then
	
		return false;
	
	end
	
	
	if( ent:IsDoor() ) then
	
		return false;
	
	end
	
	if( string.find( ent:GetClass(), "func_" ) ) then
	
		return false;
	
	end

	if( ent:GetClass() == "ep_commonzombie" ) then
	
		return false;
	
	end
	
	return true;

end

function GM:PhysgunDrop( ply, ent )
	
	if( ent:IsPlayer() ) then
		
		ent:SetGravity( 1 );
		
	end
	
end

function GM:CanTool( ply, tr, tool )

	if( CurTime() < ply:GetTable().NextToolUsage ) then
	
		return false;
	
	end
	
	if( not ply:GetPlayerDidInitialCC() ) then
	
		return false;
	
	end

	if( ply:HasAdminFlags( "p" ) ) then 
		
		if( tool != "paint" ) then
			
			table.insert( GAMEMODE.ToolLogs, ply:Nick() .. " (" .. ply:SteamID() .. ") used tool " .. tool .. " on: " .. tr.Entity:GetModel() );
			
		end
		
		return true; 
		
	end
	
	if( tr.Entity and tr.Entity:IsValid() ) then
		
		if( tool == "duplicator" and tr.Entity:GetClass() != "prop_physics" ) then
			
			return false;
			
		end
		
		if( string.find( tr.Entity:GetModel(), "models/infected/necropolis/common/" ) ) then
			
			return false;
			
		end
		
	end
	
	if( ToggledTools[tool] and ToggledTools[tool] == 0 ) then
	
		ply:PrintBlueMessage( "Disallowed tool!" );
		ply:GetTable().NextToolUsage = CurTime() + .3;
		return false;
	
	end
	
	if( not ply:HasPlayerFlags( "t" ) ) then
	
		if( tr.Entity:GetTable().SpawnedBy == ply ) then
		
			if( tool == "remover" ) then
				
				table.insert( GAMEMODE.ToolLogs, ply:Nick() .. " (" .. ply:SteamID() .. ") used tool " .. tool .. " on: " .. tr.Entity:GetModel() );
				return true;
			
			else
			
				return false;
			
			end
		
		else
		
			return false;
		
		end
	
	end
	
	if( tool == "rtcamera" ) then
		
		return false;
		
	end
	
	if( tr.Entity:IsPlayer() ) then
	
		return false;
	
	end
	
	if( tr.Entity:IsDoor() ) then
	
		return false;
	
	end
	
	if( tool == "turret" ) then
	
		return false;
	
	end
	
	if( tool == "emitter" ) then
		
		return false;
		
	end
	
	if( tool == "lamp" ) then
		
		return false;
		
	end
	
	if( tool == "light" ) then
		
		return false;
		
	end

	if( tr.Entity:GetClass() == "ep_commonzombie" ) then
	
		return false;
	
	end
	
	if( tool != "paint" ) then
		
		table.insert( GAMEMODE.ToolLogs, ply:Nick() .. " (" .. ply:SteamID() .. ") used tool " .. tool .. " on: " .. tr.Entity:GetModel() );
		
	end
	
	return true;

end

function GM:PlayerSpawnSENT( ply, classname )

	if( ply:HasAdminFlags( "p" ) ) then 
	
		return true; 
		
	end
	
	return false;

end


function GM:PlayerSpawnSWEP()

	return false;

end

function GM:PlayerSpawnVehicle( ply, propid )
	
	if( ply:HasAdminFlags( "p" ) ) then 
	
		return true; 
		
	end
	
	return false;
	
end

local function LimitReachedProcess( ply, str )
 
        // Always allow in single player
        if (SinglePlayer()) then return true end
 
        local c = server_settings.Int( "sbox_max"..str, 0 )
        
        if( str == "props" ) then
        
        	if( GAMEMODE.PlayerSpawnLimits[ply:SteamID()] and 
        		GAMEMODE.PlayerSpawnLimits[ply:SteamID()].PropLimit > -1 ) then
        	
        		c = GAMEMODE.PlayerSpawnLimits[ply:SteamID()].PropLimit;
        	
        	end 
        
        end
        
        if( str == "ragdolls" ) then
        
        	if( GAMEMODE.PlayerSpawnLimits[ply:SteamID()] and 
        		GAMEMODE.PlayerSpawnLimits[ply:SteamID()].RagdollLimit > -1 ) then
        	
        		c = GAMEMODE.PlayerSpawnLimits[ply:SteamID()].RagdollLimit;
        	
        	end 
        
        end
       
        if ( ply:GetCount( str ) < c || c < 0 ) then return true end
       
        ply:LimitHit( str )
        return false
 
end

function GM:PlayerSpawnProp( ply, mdl )
	
	mdl = string.lower( mdl );
	
	if( ply:HasAdminFlags( "p" ) ) then 
	
		return true; 
		
	end
	
	if( string.find( mdl, "props_combine" ) ) then 
	
		return false; 
		
	end
	
	if( string.find( mdl, "/props_phx/" ) or string.find( mdl, "/hunter/" ) or string.find( mdl, "/noesis/" ) or string.find( mdl, "/xeon133/" ) or string.find( mdl, "/xqm/" ) or string.find( mdl, "/squad/" ) or string.find( mdl, "/mechanics/" ) or string.find( mdl, "/phxtended/" ) ) then 
		
		return false; 
		
	end

	return LimitReachedProcess( ply, "props" );

end

function GM:PlayerSpawnRagdoll( ply, model )
	
	if( ply:HasAdminFlags( "p" ) ) then 
	
		return true; 
		
	end
	
    return false;
    
end

function GM:PlayerSpawnedProp( ply, model, ent )
	
	table.insert( GAMEMODE.PropLogs, ply:Nick() .. " (" .. ply:SteamID() .. ") spawned prop: " .. model );
 	
 	ent:GetTable().SpawnedBy = ply;
 	ent:GetTable().Owners = { };
	
	ply:AddCount( "props", ent );
    
end


