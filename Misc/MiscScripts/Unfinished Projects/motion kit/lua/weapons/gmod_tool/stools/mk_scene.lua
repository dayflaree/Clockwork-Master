/*-------------------------------------------------------------------------------------------------------------------------
	The STOOL for selecting the entities to record
-------------------------------------------------------------------------------------------------------------------------*/

TOOL.Category = "Motion Kit"
TOOL.Name = "Scene Management"
TOOL.Command = nil
TOOL.ConfigName = ""

if CLIENT then
	language.Add( "Tool_mk_scene_name", "Scene Management" )
	language.Add( "Tool_mk_scene_desc", "Manage the entities you want to record" )
	language.Add( "Tool_mk_scene_0", "Left Click to enable animation for entity. Right Click to disable animation for entity." )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Enable recording for the selected entity
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:LeftClick( tr )
	local ent = tr.Entity
	return self:EntitySetRecorded( ent, true )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Disable recording for the selected entity
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:RightClick( tr )
	local ent = tr.Entity
	return self:EntitySetRecorded( ent, false )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Function that actually sets it to recorded or not recorded
-------------------------------------------------------------------------------------------------------------------------*/

function TOOL:EntitySetRecorded( ent, IsRecorded )
	if ValidEntity( ent ) and ent:GetClass( ) == "prop_physics" and ent:GetNWBool( "MK_Tracked", false ) != IsRecorded and !recorder.IsRecording then
		if CLIENT then
			return true
		else
			ent:SetNWBool( "MK_Tracked", IsRecorded )
		end
	else
		return false
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Check to see if the camera icon HUD should still be drawn
-------------------------------------------------------------------------------------------------------------------------*/

MK_hudTimeOut = os.clock( ) - 0.1
function TOOL:Think( )
	if CLIENT then MK_hudTimeOut = os.clock( ) + 0.1 end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Draw the camera icons over the entities that have recording enabled
-------------------------------------------------------------------------------------------------------------------------*/

if CLIENT then
	local camIcon = surface.GetTextureID( "gui/motionkit/camera_icon" )
	local MK_CamSize = 32
	local MK_AnimDir = 0.25
	local maxVisibleDist = 1024
	local maxFullVisibleDist = 256
	
	function MK_DrawCameras( )
		if os.clock( ) < MK_hudTimeOut then
			local recEnts = 0
			local iconSize = 32 + math.sin( CurTime( ) * 8 ) * 8
			surface.SetTexture( camIcon )
			
			for _, v in pairs( ents.FindByClass( "prop_physics" ) ) do
				if v:GetNWBool( "MK_Tracked", false ) then
					local scrpos = v:LocalToWorld( v:OBBCenter( ) ):ToScreen( )
					surface.SetDrawColor( 255, 255, 255, math.Clamp( 128 - ( LocalPlayer( ):GetPos( ):Distance( v:GetPos( ) ) - maxFullVisibleDist ) / ( maxVisibleDist - maxFullVisibleDist ) * 128, 0, 255 ) )
					surface.DrawTexturedRect( scrpos.x - ( iconSize / 2 ), scrpos.y - ( iconSize / 2 ), iconSize, iconSize )
					recEnts = recEnts + 1
				end
			end
			
			local trackText = ""
			if !recorder.IsRecording then
				if recEnts == 1 then
					trackText = "1 entity selected for recording"
				else
					trackText = recEnts .. " entities selected for recording"
				end
			else
				trackText = "You can't change the recording state while " .. recorder.RecordingUser .. " is recording!"
			end
			
			surface.SetFont( "ScoreboardText" )
			draw.WordBox( 8, ScrW( ) / 2 - surface.GetTextSize( trackText ) / 2 - 4, ScrH( ) - 50, trackText, "ScoreboardText", Color( 0, 0, 0, 128 ), Color( 255, 255, 100 ) )
		end
	end
	hook.Add( "HUDPaint", "MK_DrawCameras", MK_DrawCameras )
end