
local PLUGIN = {}

PLUGIN.Name = "Demote ( Admin )"
PLUGIN.Author = "Jake_1305"
PLUGIN.Date = "20th July 2010"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = { "Orange Cosmos RP" }

if (SERVER) then

	ASS_NewLogLevel("ASS_OCRP_DEMOTE")

	function PLUGIN.DemotePLAYER(PLAYER, CMD, ARGS)

		if (PLAYER:HasLevel(3)) then

				print(tostring(ARGS[1]))

				local tospec = ASS_FindPlayer(ARGS[1])

				if (!tospec) then
					ASS_MessagePlayer(PLAYER, "Player not found!\n")
					return

				end
				
				OCRP_DEMOTE( PLAYER, tospec )



		else
		
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end
	end
	concommand.Add("OCRP_DEMOTE_NOW", PLUGIN.DemotePLAYER)
	
end

if (CLIENT) then


	function PLUGIN.Demote(PLAYER)
		print("printl2".. tostring(PLAYER))
		RunConsoleCommand( "OCRP_DEMOTE_NOW", PLAYER )
	end


	function PLUGIN.AddGamemodeMenu(DMENU)			

		DMENU:AddSubMenu( "Demote ( Admin )", nil, 
			function(NEWMENU)
				ASS_PlayerMenu(NEWMENU, {"HasSubMenu","IncludeLocalPlayer"}, PLUGIN.Demote)
			end )

	end
	
end


ASS_RegisterPlugin(PLUGIN)

