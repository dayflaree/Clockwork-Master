

DeriveGamemode( "sandbox" );

AddCSLuaFile( "cl_deaths.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_msg.lua" )
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_vgui.lua" );
AddCSLuaFile( "entity.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "scoreboard/admin_buttons.lua" );
AddCSLuaFile( "scoreboard/player_frame.lua" );
AddCSLuaFile( "scoreboard/player_infocard.lua" );
AddCSLuaFile( "scoreboard/player_row.lua" );
AddCSLuaFile( "scoreboard/scoreboard.lua" );
AddCSLuaFile( "scoreboard/vote_button.lua" );
AddCSLuaFile( "cl_helpvgui.lua" );
AddCSLuaFile( "cl_menu.lua" );
AddCSLuaFile( "copypasta.lua" );
AddCSLuaFile( "buymenu_shipments.lua" );
AddCSLuaFile( "LmaoLlama/simpleHud.lua" );
AddCSLuaFile( "LmaoLlama/damagenumbers.lua" );
AddCSLuaFile("sh_teammenu.lua");
AddCSLuaFile("cl_physables.lua");
AddCSLuaFile("language_sh.lua")
//AddCSLuaFile( "protectexploits.lua" )
AddCSLuaFile("cl_chatbox.lua");
AddCSLuaFile("cl_hud.lua");

--Falco's prop protection
local BlockedModelsExist = sql.QueryValue("SELECT COUNT(*) FROM FPP_BLOCKEDMODELS;") ~= false
if not BlockedModelsExist then
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKEDMODELS('model' TEXT NOT NULL PRIMARY KEY);")
	include("FPP/FPP_DefaultBlockedModels.lua") -- Load the default blocked models
end
AddCSLuaFile("FPP/sh_CPPI.lua")
AddCSLuaFile("FPP/sh_settings.lua")
AddCSLuaFile("FPP/client/FPP_Menu.lua")
AddCSLuaFile("FPP/client/FPP_HUD.lua")
AddCSLuaFile("FPP/client/FPP_Buddies.lua")

include("FPP/sh_settings.lua")
include("FPP/sh_CPPI.lua")
include("FPP/server/FPP_Settings.lua")
include("FPP/server/FPP_Core.lua")
include("FPP/server/FPP_Antispam.lua")
include("cl_physables.lua")
include("language_sh.lua")


//include( "help.lua" );

GM.Tribes = {}
GM.NumTribes = 1

include("decay.lua")
include( "protectexploits.lua" )
include( "player.lua" );
include( "money.lua" );
include( "shared.lua" );
include( "chat.lua" );
include( "rplol.lua" );
include( "util.lua" );
include( "drugs.lua" );
include( "admins.lua" );
include( "admincc.lua" );
include( "entity.lua" );
include( "bannedprops.lua" );
include( "commands.lua" );
include( "hints.lua" );
include( "vars.lua" );
include( "rating.lua" );
include("swep_fix.lua");
include( "Extracrap.lua" );
include( "propprotect/cl_init.lua" );
CSFiles = { }

LRP = { }


function includeCS( dir )

	AddCSLuaFile( dir );
	table.insert( CSFiles, dir );

end




// all of these are obsol33t. well, except for cmdprefix.
SetGlobalInt( "nametag", 0 ); --Should names show?
SetGlobalInt( "jobtag", 1 ); --Should jobs show?
SetGlobalInt("globalshow", 0) ; --Should we see player info from across the map?
SetGlobalString( "cmdprefix", "/" ); --Prefix before any chat commands

----------------------------------------
----------------------------------------

//GenerateChatCommandHelp();

function GM:Initialize()
	self.BaseClass:Initialize();
	//getJackpot()
end

for k, v in pairs( player.GetAll() ) do

	v:NewData();
	v:SetNetworkedBool("helpMenu",false)
	getMoney(ply);
end

function ShowSpare1( ply )

	ply:ConCommand( "gm_showspare1\n" );

end
concommand.Add( "gm_spare1", ShowSpare1 );
 
 function serverHelp( player ) 
 
	if(player:GetNetworkedBool("helpMenu") == false) then
	player:SetNetworkedBool("helpMenu",true)
else
	player:SetNetworkedBool("helpMenu",false)
end
 
 end    
 concommand.Add( "serverHelp", serverHelp ) 


 function GM:ShowTeam( ply )
  ply:ConCommand( "bw_factionmenu" )
 end

function ShowSpare2( ply )
	ply:ConCommand( "gm_showspare2\n" );
end
concommand.Add( "gm_spare2", ShowSpare2 );

function GM:ShowHelp( ply )

	ply:ConCommand( "helpmenu" );

end


/*---------------------------------------------------------
   Tribe system
---------------------------------------------------------*/

function GM.SendTribes(ply)
for i,v in pairs(GAMEMODE.Tribes) do
	umsg.Start("recvTribes",ply)
	umsg.Short(v.id)
	umsg.String(i)
	umsg.Short(v.red)
	umsg.Short(v.green)
	umsg.Short(v.blue)
	umsg.End()
	end
end
hook.Add("PlayerInitialSpawn","getTribes",GM.SendTribes)

function CreateTribe( ply, name, red, green, blue, password )
	
	local Password = false
	
	if password and password != "" then
		Password = password
	end
		
	GAMEMODE.NumTribes = GAMEMODE.NumTribes + 1
	GAMEMODE.Tribes[name] = {
	id = GAMEMODE.NumTribes,
	red = red,
	green = green,
	blue = blue,
	Password = Password
	}
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("newTribe",rp)
		umsg.String(name)
		umsg.Short(GAMEMODE.NumTribes)
		umsg.Short(red)
		umsg.Short(green)
		umsg.Short(blue)
	umsg.End()
	
	team.SetUp(GAMEMODE.NumTribes,tostring(name),Color(red,green,blue,255))
	ply:SetTeam(GAMEMODE.NumTribes)
	ply:Message("Successfully Created A Faction",5,Color(255,255,255,255))
	ply:SetNetworkedBool("FactionLeader", true)
end

function CreateTribeCmd( ply, cmd, args, argv )
	if !args[4] or args[4] == "" then
		ply:Message("Syntax is: bw_createfaction \"factionname\" red green blue [password(optional)]") return 
	end
	if args[5] and args[5] != "" then
		CreateTribe( ply, args[1], args[2], args[3], args[4], args[5] )
	else
		CreateTribe( ply, args[1], args[2], args[3], args[4], "" )
	end
end
concommand.Add( "bw_createfaction", CreateTribeCmd )

function joinTribe( ply, cmd, args )
	local pw = ""
	if !args[1] or args[1] == "" then
		ply:Message("Syntax is: bw_join \"faction\" [password(if needed)]") return 
	end
	if args[2] and args[2] != "" then
		pw = args[2]
	end
	for i,v in pairs(GAMEMODE.Tribes) do
		if string.lower(i) == string.lower(args[1]) then
			if v.Password and v.Password != pw then ply:PrintMessage(3,"Incorrect Faction Password") return end
			ply:SetTeam(v.id)
			ply:SetNetworkedBool("FactionLeader", false)
			ply:Message("Successfully Joined A Faction")
		end
	end
end
concommand.Add( "bw_join", joinTribe )

function leaveTribe( ply, cmd, args )
	ply:SetTeam(1)
	ply:Message("Successfully Left A Faction")
	ply:SetNetworkedBool("FactionLeader", false)
end
concommand.Add( "bw_leave", leaveTribe )

function Init_TriggerLogic()
	for k,v in pairs(ents.FindByClass("bigbomb")) do
		v:SetKeyValue( "health", 0 )
		v:SetKeyValue( "minhealthdmg", 100000000000000000000 )
	end
end
hook.Add( "InitPostEntity", "GlassUnbreakable", UnbreakableGlass )