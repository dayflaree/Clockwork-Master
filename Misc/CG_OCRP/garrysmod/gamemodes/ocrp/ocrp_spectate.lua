
local PLUGIN = {}

PLUGIN.Name = "Spectate ( Admin )"
PLUGIN.Author = "Jake_1305"
PLUGIN.Date = "20th July 2010"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = { "Orange Cosmos RP" }

local SpecTypes = {
	{ Name = "First" },
	{ Name = "Third" },
}

if (SERVER) then

	ASS_NewLogLevel("ASS_OCRP_SPEC")

	function PLUGIN.SpectatePLAYER(PLAYER, CMD, ARGS)

		if (PLAYER:HasLevel(3)) then

				print(tostring(ARGS[1]))

				local tospec = ASS_FindPlayer(ARGS[1])

				if (!tospec) then
					ASS_MessagePlayer(PLAYER, "Player not found!\n")
					return

				end
				
				OCRP_SPECTATEGM( PLAYER, tospec, ARGS[2] )

				SendLog(PLAYER:Nick(), "OCRP_SPECTATE", tospec:Nick(), ARGS[2])



		else
		
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end
	end
	concommand.Add("OCRP_SPECTATE_NOW", PLUGIN.SpectatePLAYER)
	
end

if (CLIENT) then


	function PLUGIN.Spec(PLAYER,name)
		print("printl2".. tostring(PLAYER))
		RunConsoleCommand( "OCRP_SPECTATE_NOW", PLAYER:UniqueID(), name )
	end

	
	function PLUGIN.SpecB(MENU, PLAYER)
		for k,v in pairs(SpecTypes) do
			MENU:AddOption( v.Name,	function() return PLUGIN.Spec(PLAYER, v.Name) end )
		end
	end

	function PLUGIN.AddGamemodeMenu(DMENU)			

		DMENU:AddSubMenu( "Spectate ( Admin )", nil, 
			function(NEWMENU)
				ASS_PlayerMenu(NEWMENU, {"HasSubMenu"}, PLUGIN.SpecB)
			end )

	end
	
end


ASS_RegisterPlugin(PLUGIN)

