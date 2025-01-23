
event = { }
fade = { }
msgs = { }

--include( "BananaVGUI/panel.lua" );
--include( "BananaVGUI/scrolling.lua" );

include( "shared.lua" );
include( "cl_chat.lua" );
include( "cl_hooks.lua" );
include( "cl_hud.lua" );
include( "cl_event.lua" );
include( "cl_msg.lua" );
include( "cl_dev.lua" );
include( "cl_adminmenu.lua" );
include( "cl_util.lua" );

function PostClientsideLoad()

	CreateClientMessages();
	CreateClientEvents();

end


local function ccGetCamPos( ply )
	
	Msg( ply:EyePos() );
	Msg( "\n" );
	Msg( ply:EyeAngles() );

end
concommand.Add( "getcampos", ccGetCamPos );

local function ccWhatModelIsThis( ply, cmd, arg )

	local ent = ply:GetEyeTrace().Entity;
	
	if( ent:IsValid() ) then
	
		Msg( ent:GetModel() .. "\n" );

	end

end
concommand.Add( "whatmodelisthis", ccWhatModelIsThis );






