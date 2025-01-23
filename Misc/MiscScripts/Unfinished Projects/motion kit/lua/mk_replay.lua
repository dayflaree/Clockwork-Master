/*-------------------------------------------------------------------------------------------------------------------------
	This file manages EVERYTHING that has to do with replicating recorded movement
-------------------------------------------------------------------------------------------------------------------------*/

local ents = ents
replayer.Recording = nil

/*-------------------------------------------------------------------------------------------------------------------------
	Function to restore situation at the given frame in the current animation
-------------------------------------------------------------------------------------------------------------------------*/

function replayer:restoreFrame( frame )
	for _, data in pairs( recorder.Recording.Frames[ frame ].entities ) do
		self:restoreEntity( data )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Function to restore entity to the given frame in the current animation
-------------------------------------------------------------------------------------------------------------------------*/

function replayer:angleLength( angle )
	return Vector( angle.p, angle.y, angle.r ):Length( )
end

function replayer:restoreEntity( data )
	local ent = ents.GetByIndex( data.EntID )
	
	// Checked: ( ent:GetPos( ):Distance( data.Position ) > ent:GetVelocity( ):Length( ) or self:angleLength( ent:GetAngles( ) - data.Angles ) > ent:GetPhysicsObject( ):GetAngleVelocity( ):Length( ) or true )
	ent:SetPos( data.Position )
	ent:SetAngles( data.Angles )
	ent:GetPhysicsObject( ):Wake( )
	
	ent:GetPhysicsObject( ):SetVelocity( data.Velocity )
	ent:GetPhysicsObject( ):AddAngleVelocity( ent:GetPhysicsObject( ):GetAngleVelocity( ) * -1 + data.AngleVelocity )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Automates the playing back
-------------------------------------------------------------------------------------------------------------------------*/

function replayer:startReplay( )
	self.replayStart = os.clock( )
	self.curFrame = 1
	
	hook.Add( "Think", "MK_Replay", function( )
		if ( os.clock( ) - replayer.replayStart > recorder.Recording.Frames[replayer.curFrame].time ) then
			replayer:restoreFrame( replayer.curFrame )
			self.curFrame = self.curFrame + 1
			
			if ( self.curFrame > #recorder.Recording.Frames ) then hook.Remove( "Think", "MK_Replay" ) end
		end
	end )
end