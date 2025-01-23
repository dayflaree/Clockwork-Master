
local PLUGIN = {}

PLUGIN.Name = "lulz"
PLUGIN.Author = "DarthKikBut"
PLUGIN.Date = "20th July 2010"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = { "Orange Cosmos RP" }

if (CLIENT) then

	local function PerformBlacklist ( TEAM, PLAYER )
		if !PLAYER or !PLAYER:IsValid() or !PLAYER:IsPlayer() then return false; end
		
		local function SendInfo ( Info ) 
			if PLAYER and PLAYER:IsValid() and PLAYER:IsPlayer() then
				RunConsoleCommand('ocrp_bl_srs', TEAM, PLAYER:UniqueID(), Info);
			end
		end
		
		Derma_StringRequest('Blacklist Reason', 'Why are you blacklisting this person?', '', SendInfo);
	end

	function PLUGIN.DoBlacklist(MENU, PLAYER)
		
		MENU:AddOption( 'Serious RP',	function() PerformBlacklist(999, PLAYER) end )

	end
	
	function PLUGIN.UndoBlacklist(MENU, PLAYER)
		
		MENU:AddOption( 'Serious RP',	function() return RunConsoleCommand('ocrp_ubl_srs', 999, PLAYER:UniqueID()) end )

	end
	
	
	function PLUGIN.AddGamemodeMenu(DMENU)			
	
		DMENU:AddSubMenu( "SRS Blacklist",   nil, function(NEWMENU) ASS_PlayerMenu( NEWMENU, {"IncludeAll", "IncludeLocalPlayer", "HasSubMenu"}, PLUGIN.DoBlacklist ) end ):SetImage( "gui/silkicons/status_offline" )
		DMENU:AddSubMenu( "SRS Un-Blacklist",   nil, function(NEWMENU) ASS_PlayerMenu( NEWMENU, {"IncludeAll", "IncludeLocalPlayer", "HasSubMenu"}, PLUGIN.UndoBlacklist ) end ):SetImage( "gui/silkicons/status_offline" )

	end

end

ASS_RegisterPlugin(PLUGIN)

