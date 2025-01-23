
local function ooc( ply, cmd, arg )

	if( !ply:HasAnyAdminFlags() and CurTime() < ply:GetPlayerLastOOC() + OOCDELAY ) then
	
		return "";
	
	end

	ply:SetPlayerLastOOC( CurTime() );

	return arg;
	
end
ChatCommand( "//", ooc );
ChatCommand( "/a", ooc );
ChatCommand( "/ooc", ooc );
ChatCommand( "[ooc]", ooc );

local function looc( ply, cmd, arg )

	ply:SayLocalChat( "[L-OOC] " .. arg, 240, "looc", true );
	
end
ChatCommand( "[[", looc );
ChatCommand( ".//", looc );

local function whisper( ply, cmd, arg )

	ply:SayLocalChat( arg, 80, "wicc" );
	PlaySentence( ply, string.len( arg ) );
	
end
ChatCommand( "/w", whisper );
ChatCommand( "/whisper", whisper );

local function yell( ply, cmd, arg )

	ply:GetTable().LastYelledIC = CurTime();

	ply:SayLocalChat( arg, 550, "yicc" );
	PlaySentence( ply, string.len( arg ) );
	
end
ChatCommand( "/y", yell );
ChatCommand( "/yell", yell );

local function me( ply, cmd, arg )

	ply:SayLocalChat( arg, 240, "ica", nil, true );
	
end
ChatCommand( "/me", me );

local function yme( ply, cmd, arg )

	ply:SayLocalChat( arg, 550, "yica", nil, true );
	
end
ChatCommand( "/lme", yme );

local function it( ply, cmd, arg )

	ply:NarrateChatAction( arg, false );
	
end
ChatCommand( "/it", it );

local function lyme( ply, cmd, arg )

	ply:NarrateChatAction( arg, true );
	
end
ChatCommand( "/lit", lyme );

local function r( ply, cmd, arg )

	if( ply:HasItem( "radio" ) ) then

		if( tonumber( ply.CurRadioFreq ) < 0 ) then
		
			ply:NoticePlainWhite( "Choose a radio frequency from your RADIO chat-tab." );
			return;
		
		end

		ply:SayLocalChat( string.sub( arg, 2 ), 240, "ic", nil, false, true );
	
	else
	
		ply:NoticePlainWhite( "You don't have a radio." );
	
	end
	
end
ChatCommand( "/r", r );

local function bc( ply, cmd, arg )

	if( ply:HasItem( "broadcastradio" ) ) then
		
		ply:SayLocalChat( string.sub( arg, 2 ), 240, "ic", nil, false, false, true );
	
	else
	
		ply:NoticePlainWhite( "You don't have a broadcast radio." );
	
	end
	
end
ChatCommand( "/bc", bc );

local function passout( ply, cmd, arg )

	ply:ConCommand( "rp_passout\n" );
	
end
ChatCommand( "/passout", passout );

local function getup( ply, cmd, arg )

	ply:ConCommand( "rp_getup\n" );
	
end
ChatCommand( "/getup", getup );


local function pm( ply, cmd, arg )

	arg = string.sub( arg, 2 );
	
	local firstspace = string.find( arg, " " );
	
	if( firstspace ) then
		
		local name = string.sub( arg, 1, firstspace - 1 );
		local msg = string.sub( arg, firstspace + 1 );
		
		ply:SendPM( name, msg );
		
	end
	
end
ChatCommand( "/pm", pm );

local function reply( ply, cmd, arg )
	
	if( ply.LastPMTarget and ply.LastPMTarget:IsValid() ) then
		
		ply:SendPM( ply.LastPMTarget:RPNick(), arg );
		
	else
		
		ply.LastPMTarget = nil;
		ply:PrintBlueMessage( "You have nobody to reply to" );
		
	end
	
end
ChatCommand( "/re", reply );

local function a( ply, cmd, arg )
	
	ply:ChatToAdmins( arg );
	
end
ChatCommand( "!a", a );
