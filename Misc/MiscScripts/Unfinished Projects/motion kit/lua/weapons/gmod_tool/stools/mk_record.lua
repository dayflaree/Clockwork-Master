/*-------------------------------------------------------------------------------------------------------------------------
	The STOOL for recording and replaying
-------------------------------------------------------------------------------------------------------------------------*/

TOOL.Category = "Motion Kit"
TOOL.Name = "Animating"
TOOL.Command = nil
TOOL.ConfigName = ""
if CLIENT then
	recordingStart = 0
end

if CLIENT then
	language.Add( "Tool_mk_record_name", "Animating" )
	language.Add( "Tool_mk_record_desc", "Record props for your scene" )
	language.Add( "Tool_mk_record_0", "Left Click to start recording a new scene. Right click to stop recording. Reload to replay." )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Start recording
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:LeftClick( tr )
	if recorder.IsRecording then return false end
	
	if SERVER then
		recorder:Start( self:GetOwner( ) )
	else
		recordingStart = os.time( )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Stop recording
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:RightClick( tr )
	//if !recorder.IsRecording then return false end
	
	if SERVER then
		if recorder.IsRecording then
			recorder:End( )
		else
			replayer:startReplay( )
		end
	else
		recordingStart = 0
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Replay recording
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:Reload( tr )
	if SERVER and recorder.Recording.Frames then replayer:startReplay( ) end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Check whether the recording HUD should still be visible
-------------------------------------------------------------------------------------------------------------------------*/

MK_hudTimeOut2 = os.clock( ) - 0.1
function TOOL:Think( )
	if CLIENT then MK_hudTimeOut2 = os.clock( ) + 0.1 end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Recording HUD
-------------------------------------------------------------------------------------------------------------------------*/

local function formatTime( secs )
	if secs == os.time( ) then return "0.00" end
	
	local mins = 0
	local secs = secs
	
	while secs >= 60 do
		mins = mins + 1
		secs = secs - 60
	end
	
	if secs < 10 then secs = "0" .. secs end
	return mins .. "." .. secs
end

if CLIENT then surface.CreateFont( "HalfLife2", 46, 400, true, false, "timeFont" ) end
function MK_RecordingHUD( )
	if MK_hudTimeOut2 > os.clock( ) then		
		surface.SetFont( "timeFont" )
		local timeText = formatTime( os.time( ) - recordingStart )
		local _, h = surface.GetTextSize( timeText )
		h = h + 6
		local w = 600
		local x = ScrW( ) / 2 - w / 2 + 6
		local y = ScrH( ) - h - 36
		
		draw.RoundedBox( 6, ScrW( ) / 2 - w / 2, ScrH( ) - h - 40, w, h + 6, Color( 0, 0, 0, 128 ) )
		
		draw.SimpleText( "TIME", "DefaultSmall", x, y, Color( 255, 255, 100, 255 ), 0, 0 )
		draw.SimpleText( timeText, "timeFont", x, y + 6, Color( 255, 255, 100, 255 ), 0, 0 )
		
		local entCount = 0
		for _, v in pairs( ents.FindByClass( "prop_physics" ) ) do if v:GetNWBool( "MK_Tracked", false ) then entCount = entCount + 1 end end
		draw.SimpleText( "ENTITIES", "DefaultSmall", x + 90, y, Color( 255, 255, 100, 255 ), 0, 0 )
		draw.SimpleText( entCount, "timeFont", x + 90, y + 6, Color( 255, 255, 100, 255 ), 0, 0 )
		
		if recorder.IsRecording and recorder.RecordingUser != LocalPlayer( ):Nick( ) then
			draw.SimpleText( "RECORDING STATE", "DefaultSmall", x + 180, y, Color( 255, 255, 100, 255 ), 0, 0 )
			draw.SimpleText( recorder.RecordingUser .. " is now recording, you will have to wait.", "DefaultSmall", x + 190, y + 14, Color( 255, 255, 100, 255 ), 0, 0 )
		end
	end
end
hook.Add( "HUDPaint", "MK_RecordingHUD", MK_RecordingHUD )