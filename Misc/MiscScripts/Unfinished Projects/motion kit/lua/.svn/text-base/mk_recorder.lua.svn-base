/*-------------------------------------------------------------------------------------------------------------------------
	This file manages EVERYTHING that has to do with recording movement
-------------------------------------------------------------------------------------------------------------------------*/

recorder.Recording = { }
recorder.RecordingStart = os.clock( )
recorder.IsRecording = false

/*-------------------------------------------------------------------------------------------------------------------------
	Record a frame for the specified entity
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:CaptureFrame( ent )
	local TempData = { }
		TempData.Position = ent:GetPos( )
		TempData.Angles = ent:GetAngles( )
		TempData.Velocity = ent:GetPhysicsObject( ):GetVelocity( )
		TempData.AngleVelocity = ent:GetPhysicsObject( ):GetAngleVelocity( )
		TempData.Mdl = ent:GetModel( )
		TempData.Mat = ent:GetMaterial( )
		TempData.EntID = ent:EntIndex( )
	return TempData
end

/*-------------------------------------------------------------------------------------------------------------------------
	Get the recording entity candidates
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:GetRecordedEntities( )
	local recents = { }
	
	for _, ent in pairs( ents.FindByClass( "prop_physics" ) ) do
		if ( ent:GetNWBool( "MK_Tracked", false ) ) then
				table.insert( recents, ent )
		end
	end
	
	return recents
end

/*-------------------------------------------------------------------------------------------------------------------------
	Record a frame
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:RecordFrame( )
	self.Recording.Frames[ #self.Recording.Frames + 1 ] = { }
	local curframe = self.Recording.Frames[ #self.Recording.Frames ]
	curframe.entities = { }
	
	for _, ent in pairs( self:GetRecordedEntities( ) ) do
		table.insert( curframe.entities, self:CaptureFrame( ent ) )
	end
	
	curframe.time = self:GetTime( )
	self.Recording.Frames[ #self.Recording.Frames ] = curframe
end

/*-------------------------------------------------------------------------------------------------------------------------
	Clear buffered recording
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:ClearRecording( )
	self.Recording = { }
	self.Recording.Frames = { }
end

/*-------------------------------------------------------------------------------------------------------------------------
	Get the recording time
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:GetTime( )
	return os.clock( ) - self.RecordingStart
end

/*-------------------------------------------------------------------------------------------------------------------------
	Start recording
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:Start( ply )
	if ( self.IsRecording or #self:GetRecordedEntities( ) == 0 ) then return false end
	
	self:ClearRecording( )
	self.RecordingStart = os.clock( )
	self.IsRecording = true
	umsg.Start( "MK_changeRecordingState" ) umsg.Bool( true ) umsg.String( ply:Nick( ) ) umsg.End( )
	
	hook.Add( "Think", "RecordHook", function( ) recorder:RecordFrame( ) end )
	
	Msg( "Started recording... (" .. ply:Nick( ) .. ")\n" )
end

/*-------------------------------------------------------------------------------------------------------------------------
	End recording
-------------------------------------------------------------------------------------------------------------------------*/

function recorder:End( )
	if ( !self.IsRecording ) then return false end
	
	hook.Remove( "Think", "RecordHook" )
	self.IsRecording = false
	umsg.Start( "MK_changeRecordingState" ) umsg.Bool( false ) umsg.String( "" ) umsg.End( )
	
	Msg( "Recorded " .. #self.Recording.Frames .. " total frames over " .. math.Round( self:GetTime( ) * 100 ) / 100 .. " seconds with " .. table.Count( self.Recording.Frames[ 1 ].entities ) .. " entities!\n" )
end