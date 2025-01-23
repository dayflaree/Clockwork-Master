
local PLUGIN = {}

PLUGIN.Name = "Blacklist ( Admin )"
PLUGIN.Author = "Jake_1305"
PLUGIN.Date = "20th July 2010"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2
PLUGIN.Gamemodes = { "Orange Cosmos RP" }

local BLTypes = {
	{ T = "Police", ID = CLASS_POLICE },
	{ T = "Paramedic", ID = CLASS_MEDIC },
	{ T = "Mayor", ID = CLASS_Mayor },
	{ T = "Fireman", ID = CLASS_FIREMAN },
}

if (SERVER) then

	ASS_NewLogLevel("ASS_OCRP_BLACKLIST")

	function PLUGIN.SpectatePLAYERBL(PLAYER, CMD, ARGS)

		if (PLAYER:HasLevel(3)) then

				print(tostring(ARGS[1]))

				local tospec = ASS_FindPlayer(ARGS[1])

				if (!tospec) then
					ASS_MessagePlayer(PLAYER, "Player not found!\n")
					return

				end
				
				PLAYER:Blacklist(tospec, ARGS[2])

				SendLog(PLAYER:Nick(), "OCRP_BLACKLIST", tospec:Nick(), ARGS[2])



		else
		
			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end
	end
	concommand.Add("OCRP_BLACKLIST_NOW", PLUGIN.SpectatePLAYERBL)
	
end

if (CLIENT) then


	function PLUGIN.BL(PLAYER,name)
		print("printl2".. tostring(PLAYER))
		RunConsoleCommand( "OCRP_BLACKLIST_NOW", PLAYER:UniqueID(), name )
	end

	
	function PLUGIN.BLB(MENU, PLAYER)
		for k,v in pairs(BLTypes) do
			MENU:AddOption( v.T, function() return PLUGIN.BL(PLAYER, v.ID) end )
		end
	end

	function PLUGIN.AddGamemodeMenu(DMENU)			

		DMENU:AddSubMenu( "Blacklist ( Admin )", nil, 
			function(NEWMENU)
				ASS_PlayerMenu(NEWMENU, {"HasSubMenu"}, PLUGIN.BLB)
			end )

	end
	
end


ASS_RegisterPlugin(PLUGIN)

