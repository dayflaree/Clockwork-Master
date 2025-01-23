--This handles the volume, sound and speed of the heartbeat that you hear.
--It's based off sprint and possibly other factors.
HeartBeat = {

	AudiblePerc = 0,
	RateMul = 0,
	PitchPerc = 100,
	NextHeartBeat = CurTime(),
	SimulatedCalmness = 100,
	NextCalmnessHeal = 0,
	InfectedHeartBeat = false,

}
function HandleHeartBeatRate()

	if( HeartBeat.NextHeartBeat < CurTime() ) then

		if( HeartBeat.AudiblePerc > 0 and ClientVars["Class"] ~= "Infected" ) then

			LocalPlayer():EmitSound( "heartbeat.wav", HeartBeat.AudiblePerc, HeartBeat.PitchPerc );

		end

	end
	
	if( HeartBeat.SimulatedCalmness < 100 and
		CurTime() > HeartBeat.NextCalmnessHeal ) then
	
		HeartBeat.SimulatedCalmness = math.Clamp( HeartBeat.SimulatedCalmness + 2, 0, 100 );
		HeartBeat.NextCalmnessHeal = CurTime() + 2;
		
	end
	
	local diff;
	local sub = 0;
	
	if( ClientVars["Class"] == "Infected" ) then 
	
		HeartBeat.SimulatedCalmness = 0;
		HeartBeat.InfectedHeartBeat = true;
	
	elseif( HeartBeat.InfectedHeartBeat ) then
	
		HeartBeat.InfectedHeartBeat = false;
		HeartBeat.SimulatedCalmness = 100;
	
	end
	
	if( ClientVars["Sprint"] < HeartBeat.SimulatedCalmness ) then
		sub = ClientVars["Sprint"];
	else
		sub = HeartBeat.SimulatedCalmness;
	end
	
	diff = 100 - sub;
	
	--Sprint based
	HeartBeat.RateMul = diff / 10;
	HeartBeat.PitchPerc = 100 + ( 5 * HeartBeat.RateMul );
	HeartBeat.AudiblePerc = math.Clamp( 10 * HeartBeat.RateMul, 0, 150 );

	if( HeartBeat.NextHeartBeat < CurTime() ) then
		
		HeartBeat.NextHeartBeat = CurTime() + math.Clamp( 2 * sub / 100, .5, 1.5 );
			
	end
	
	--Conscious based
	local conscious = ClientVars["Conscious"];

	if( conscious < 50 ) then

		HeartBeat.AudiblePerc = math.Clamp( 10 * ( 100 - conscious ) * .5, 0, 150 );
		
	end
	

end


ConsciousBlur = 
{

	HeadBob = 0,
	HeadBobRoll = 0,
	HeadBobDir = 1,
	HeadBobRollDesp = 0,
	HeadBobNewRoll = true,
	HeadBobRollToOrigin = false,
	Levels = { },

}
function CreateConsciousBlurEffects()

	for n = 1, 100 do
	
		if( n < 65 ) then
	
			ConsciousBlur.Levels[n] =
			{
			
				AddTransp = math.Clamp( .8 - ( 2 * ( ( 60 - n ) * .01 ) ), .1, 1 ),
				DrawTransp = .99,
				FrameDelay = .02 + ( ( 40 - n ) * .001 ),
				HeadBobMin = -4 * ( ( 100 - n ) * .01 ),
				HeadBobMax = 4 * ( ( 100 - n ) * .01 ),
				HeadBobAmount = ( 60 - n ) * .01;
			
			}
			
		else

			ConsciousBlur.Levels[n] =
			{
			
				AddTransp = 1,
				DrawTransp = 1,
				FrameDelay = 0,
				HeadBobAmount = 0,
				HeadBobMin = 0,
				HeadBobMax = 0,
			
			}
		
		end
		
	end

end

CreateConsciousBlurEffects();

function event.HH()

	DoMotionBlurHit = true;
	MotionBlurHitEnd = CurTime() + .3;

	HeartBeat.SimulatedCalmness = 20;
	HeartBeat.NextCalmnessHeal = CurTime() + 2;

end

function event.HMH()

	DoMotionBlurHit = true;
	MotionBlurHitEnd = CurTime() + 1;

	HeartBeat.SimulatedCalmness = 20;
	HeartBeat.NextCalmnessHeal = CurTime() + 2;

end

DoMotionBlurHit = false;
MotionBlurHitEnd = 0;

function SetFog( um )
	
	local startfog = um:ReadShort();
	local endfog = um:ReadShort();
	local color = um:ReadVector();
	
	RunConsoleCommand( "fog_override", "1" );
	RunConsoleCommand( "fog_start", tostring( startfog ) );
	RunConsoleCommand( "fog_startskybox", tostring( startfog ) );
	RunConsoleCommand( "fog_end", tostring( endfog ) );
	RunConsoleCommand( "fog_endskybox", tostring( endfog ) );
	RunConsoleCommand( "fog_color", tostring( color.x ) .. " " .. tostring( color.y ) .. " " .. tostring( color.z ) );
	RunConsoleCommand( "fog_colorskybox", tostring( color.x ) .. " " .. tostring( color.y ) .. " " .. tostring( color.z ) );
	
end
usermessage.Hook( "SetFog", SetFog );

function StopFog( um )
	
	RunConsoleCommand( "fog_override", "0" );
	
end
usermessage.Hook( "StopFog", StopFog );

HTM = nil;

function OpenDisseStream( ply, cmd, args )
	
	if( args[1] != "1" ) then
		
		if( HTM ) then
			
			HTM:SetHTML( "" );
			
		end
		return;
		
	end
	
	HTM = vgui.Create( "HTML" );
	HTM:SetPos( 0, 0 );
	HTM:SetSize( 0, 0 );
	HTM:SetHTML( [[<iframe width="100%" height="166" scrolling="no" frameborder="no" src="http://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F34200003&amp;auto_play=true&amp;show_artwork=false&amp;color=ff7700"></iframe>]] );
	
end
concommand.Add( "ep_dissestream", OpenDisseStream );

function OpenYoutube( um )
	
	if( HTM and HTM:IsValid() ) then
		
		HTM:Remove();
		
	end
	
	local link = um:ReadString();
	
	HTM = vgui.Create( "HTML" );
	HTM:SetPos( 0, 0 );
	HTM:SetSize( 0, 0 );
	HTM:SetHTML( [[<object width="560" height="315"><param name="movie" value="http://www.youtube.com/v/]] .. link .. [[?version=3&amp;hl=en_GB&autoplay=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/]] .. link .. [[?version=3&amp;hl=en_GB&autoplay=1" type="application/x-shockwave-flash" width="560" height="315" allowscriptaccess="always" allowfullscreen="true"></embed></object>]] );
	
end
usermessage.Hook( "YouTube", OpenYoutube );

function StopSounds( ply, cmd, args )
	
	if( HTM and HTM:IsValid() ) then
		
		HTM:Remove();
		
	end
	
	HTM = nil;
	
end
concommand.Add( "ep_stopsounds", StopSounds );