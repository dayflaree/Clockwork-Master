// Send portal render code
AddCSLuaFile( "autorun/client/init.lua" )

// Send info about portals to clients
hook.Add( "PlayerInitialSpawn", "BrushPortalInfoTransmission", function( ply )
	local portals = ents.FindByClass( "func_portal" )
	
	umsg.Start( "BrushPortalInfo", ply )
		umsg.Char( #portals )
		
		for _, portal in ipairs( portals ) do			
			umsg.Vector( portal:OBBCenter() + portal.direction * 16 )
			umsg.Vector( portal:OBBMins() )
			umsg.Vector( portal:OBBMaxs() )
			umsg.Vector( portal.direction )
			umsg.Char( table.KeyFromValue( portals, portal.exit ) )
		end
	umsg.End()
end )

// Set up visibility through portals
hook.Add( "SetupPlayerVisiblity", "BrushPortalVisibility", function( ply, ent )
	for _, portal in ipairs( ents.FindByClass( "func_portal" ) ) do
		AddOriginToPVS( portal:OBBCenter() )
	end
	print( "Added PVS!" )
end )