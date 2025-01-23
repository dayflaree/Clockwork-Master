
local PLUGIN = {}

PLUGIN.Name = "Unspectate ( Admin )"
PLUGIN.Author = "Jake_1305"
PLUGIN.Date = "20th July 2010"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = { "Orange Cosmos RP" }

if (SERVER) then

	ASS_NewLogLevel("ASS_OCRP_SPEC")

	function PLUGIN.SpectatePLAYERUN(PLAYER, CMD, ARGS)

		if (PLAYER:HasLevel(3)) then
				
				OCRP_SPECTATEGM( PLAYER, nil, nil, true )

		else
		
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end
	end
	concommand.Add("OCRP_SPECTATE_NOW_UN", PLUGIN.SpectatePLAYERUN)
	
end

if (CLIENT) then

	function PLUGIN.AddGamemodeMenu(DMENU)			

		DMENU:AddOption( "Unspectate ( Admin )",
			function()
				RunConsoleCommand("OCRP_SPECTATE_NOW_UN")
			end )

	end
	
end


ASS_RegisterPlugin(PLUGIN)

