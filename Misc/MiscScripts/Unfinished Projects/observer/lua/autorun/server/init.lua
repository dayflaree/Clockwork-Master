// Send client files
AddCSLuaFile( "autorun/client/init.lua" )
AddCSLuaFile( "vgui/playerentry.lua" )

// TODO: Timeout system to prevent captured clients from stopping the data from being sent and thus blocking admins from capturing any other players completely!!!

// Start new capture
concommand.Add( "observer_capture", function( ply, _, args )
	if ( ply.OB_Receiving ) then return false end
	
	local ent, density = Entity( args[1] ), tonumber( args[2] )
	if ( ply:IsAdmin() and IsValid( ent ) and ent:IsPlayer() and density and density >= 3 and density <= 100 ) then
		if ( ent.OB_Receiver ) then
			umsg.Start( "OB_Error", ply )
				umsg.String( "This player is already being captured by " .. ent.OB_Receiver:Nick() .. ". Wait your turn." )
			umsg.End()
			
			return false
		end 
		
		umsg.Start( "OB_Capture", ent )
			umsg.Short( density )
			umsg.Entity( ply )
		umsg.End()
		
		ply.OB_Receiving = true
		ply.OB_Sender = ent
		ent.OB_Receiver = ply
		ent.OB_Density = density
		ent.OB_Info = nil
	end
end )

// Receive capture info
concommand.Add( "observer_captureinfo", function( ply, _, args )
	if ( !ply.OB_Receiver ) then return false end // Do not allow sending if it hasn't been requested
	local w, h = tonumber( args[1] ), tonumber( args[2] )
	if ( !w or !h ) then return false end
	
	ply.OB_Info = { w = w, h = h, expectedData = math.ceil( w / ply.OB_Density ) * math.ceil( h / ply.OB_Density ) * 3 }
	
	umsg.Start( "OB_Info", ply.OB_Receiver )
		umsg.Entity( ply )
		umsg.Short( math.ceil( ply.OB_Info.w / ply.OB_Density ) )
		umsg.Short( math.ceil( ply.OB_Info.h / ply.OB_Density ) )
		umsg.Long( ply.OB_Info.expectedData )
		umsg.Short( ply.OB_Density )
	umsg.End()
end )

// Receive capture data
concommand.Add( "observer_capturedata", function( ply, _, args )
	if ( !ply.OB_Info ) then return false end // Do not allow sending if it hasn't been authorised
	
	umsg.Start( "OB_Data", ply.OB_Receiver )
		umsg.String( args[1] )
	umsg.End()
	
	ply.OB_Info.expectedData = ply.OB_Info.expectedData - 200
	if ( ply.OB_Info.expectedData <= 0 ) then
		
		ply.OB_Info = nil
		ply.OB_Receiver.OB_Receiving = false
		ply.OB_Receiver = nil
	end
end )

// Detect disconnected receivers/senders
timer.Create( "observer_detectdisconnected", 1, 0, function()
	for _, ply in ipairs( player.GetAll() ) do
		if ( ply.OB_Receiver and !IsValid( ply.OB_Receiver ) ) then
			print( "Player receiving from " .. ply:Nick() .. " left, stopping transmission!" )
			ply.OB_Receiver = nil
			ply.OB_Info = nil
		elseif ( ply.OB_Receiving and !IsValid( ply.OB_Sender ) ) then
			print( "Player sending a capture to " .. ply:Nick() .. " left, stopping transmission!" )
			ply.OB_Receiving = false
			
			umsg.Start( ply, "OB_CaptureCancelled" )
			umsg.End()
		end
	end
end )