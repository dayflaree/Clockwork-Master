-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- client_resources.lua
-- This will tell the server what needs to be downloaded to the client and log it.
-- This will NOT tell the client what needs to be included, though.
-------------------------------

function AddResource( res_type, path )

	if( string.lower( res_type ) == "lua" ) then
	
		AddCSLuaFile( path );
		--LEMON.DayLog( "script.txt", "Added clientside lua file '" .. path .. "'" )
		
	end
	
end

-- LUA Files
AddResource( "lua", "cl_skin.lua" ); -- Shared Functions
AddResource( "lua", "vgui_blackscene.lua" ); -- Shared Functions
AddResource( "lua", "shared.lua" ); -- Shared Functions
AddResource( "lua", "cl_binds.lua" ); -- Binds
AddResource( "lua", "cl_charactercreate.lua" ); -- Character Creation functions
AddResource( "lua", "cl_hud.lua"); -- The HUD
AddResource( "lua", "cl_init.lua"); -- The initialization of clientside gamemode
AddResource( "lua", "cl_search.lua"); -- The initialization of clientside gamemode
AddResource( "lua", "cl_playermenu.lua"); -- The F1 playermenu
AddResource( "lua", "player_shared.lua"); -- Shared player functions
AddResource( "lua", "cl_admin.lua" )
AddResource( "lua", "VGUI/hpanel.lua" )
AddResource( "lua", "VGUI/apanel.lua" )
AddResource( "lua", "VGUI/ipanel.lua" )
AddResource( "lua", "VGUI/wpanel.lua" )
AddResource( "lua", "VGUI/motd.lua" )
AddResource( "lua", "cl_quiz.lua" )