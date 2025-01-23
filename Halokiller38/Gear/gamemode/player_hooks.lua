
function PlayerInitialSpawn( ply )
	
	ply:BaseInitialize();
	
	ply:Initialize();
	
	
	
end
hook.Add( "PlayerInitialSpawn", "GearPlayerInitialSpawn", PlayerInitialSpawn );

function PlayerSpawn( ply )

	ply:CrosshairDisable();

end
hook.Add( "PlayerSpawn", "GearPlayerSpawn", PlayerSpawn );


function PlayerDisconnected( ply )

	if( ply:GetTable().RagdollEntity and ply:GetTable().RagdollEntity:IsValid() ) then
		ply:GetTable().RagdollEntity:Remove();
	end
	
end
hook.Add( "PlayerDisconnected", "GearPlayerDisconnected", PlayerDisconnected );