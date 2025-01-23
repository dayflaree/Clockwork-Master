/*-------------------------------------------------------------------------------------------------------------------------
	Create global tables holding all the functions and variables
-------------------------------------------------------------------------------------------------------------------------*/

recorder = { }
replayer = { }

/*-------------------------------------------------------------------------------------------------------------------------
	Distribute and include files
-------------------------------------------------------------------------------------------------------------------------*/

if SERVER then
	AddCSLuaFile( "autorun/mk_autorun.lua" )
	AddCSLuaFile( "weapons/gmod_tool/stools/mk_scene.lua" )
	
	resource.AddFile( "materials/gui/motionkit/camera_icon.vtf" )
	resource.AddFile( "materials/gui/motionkit/camera_icon.vmt" )
	
	include( "mk_recorder.lua" )
	include( "mk_replay.lua" )
else
	local function MK_changeRecordingState( um )
		recorder.IsRecording = um:ReadBool( )
		recorder.RecordingUser = um:ReadString( )
	end
	usermessage.Hook( "MK_changeRecordingState", MK_changeRecordingState )
end