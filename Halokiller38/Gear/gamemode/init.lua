----------------------------
-- Gear
-- by Rick Dark
-- March 8, 08
----------------------------

GM.Name = "Gear";

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_chat.lua" );
AddCSLuaFile( "cl_hooks.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_event.lua" );
AddCSLuaFile( "cl_msg.lua" );
AddCSLuaFile( "cl_adminmenu.lua" );
AddCSLuaFile( "cl_dev.lua" );
AddCSLuaFile( "cl_util.lua" );

--AddCSLuaFile( "BananaVGUI/panel.lua" );
--AddCSLuaFile( "BananaVGUI/scrolling.lua" );

include( "shared.lua" );
include( "players.lua" );
include( "player_spectate.lua" );
include( "server_util.lua" );
include( "player_chat.lua" );
include( "console_commands.lua" );
include( "engconsole_commands.lua" );
include( "player_util.lua" );
include( "player_hooks.lua" );
include( "player_connect.lua" );
include( "animation_tables.lua" );
include( "animations.lua" );
include( "sql.lua" );

if( InitializedOnce == nil ) then
	InitializedOnce = false;
end

function Initialize()

	InitializedOnce = true;

end
hook.Add( "Initialize", "GearInitialize", Initialize );
