/*
   __            _            _   _                       _          
  / /  ___  __ _| | _____  __| | | |__  _   _    /\ /\___| |___  ___ 
 / /  / _ \/ _` | |/ / _ \/ _` | | '_ \| | | |  / //_/ _ \ / __|/ _ \
/ /___  __/ (_| |   <  __/ (_| | | |_) | |_| | / __ \  __/ \__ \  __/
\____/\___|\__,_|_|\_\___|\__,_| |_.__/ \__, | \/  \/\___|_|___/\___|
                                        |___/

 _____ _     _       _             _ _     ___     ___   _     _            
/__   \ |__ (_)___  (_)___    __ _| | |   / __\   / _ \ | |__ | |___      __
  / /\/ '_ \| / __| | / __|  / _` | | |  / /     / /_)/ | '_ \| __\ \ /\ / /
 / /  | | | | \__ \ | \__ \ | (_| | | | / /___  / ___/  | |_) | |_ \ V  V / 
 \/   |_| |_|_|___/ |_|___/  \__,_|_|_| \____/  \/      |_.__/ \__| \_/\_/  
                                                                                                    
*/


/*-------------------------------------------------------------------------------
 _____      _      _     ____        _   
|  __ \    (_)    | |   |  _ \      | |  
| |__) |___ _  ___| |__ | |_) | ___ | |_ 
|  _  // _ \ |/ __| '_ \|  _ < / _ \| __|
| | \ \  __/ | (__| | | | |_) | (_) | |_ 
|_|  \_\___|_|\___|_| |_|____/ \___/ \__|

*/-------------------------------------------------------------------------------
if( SERVER ) then return end

local RBname = ("ReichBot")

require("MichaelJFox")
 
package.loaded.MichaelJFox = nil
 
include("includes/init.lua")
include("includes/extensions/table.lua")
 
RB = {}
 
RB.cmds	= {}
RB.hooks  = {}
RB.sqlite = {}
 
RB.aimfriends = {}
RB.aimteams = {}
RB.teamlist = {}
 
RB.traitors = {}
 
RB.aimmodels = {}
 
RB.vars = {
		aim = false,
		bhop  = false,
		speed = false,
		firing = false,
		aimtarg = nil,
		tlock = false,
		menuh = 235,
		menuw = 320,
}
 
RB.esp_ents = {
		pot = "Weed",
		shroom = "Shrooms",
		money_printer = "Money Printer",
		gunlab = "Gunlab",
		drug_lag = "Druglab",
		spawned_money = "Money",
		dispenser = "Dispenser",
		gunvault = "Gunvault",
		drugfactory = "Drugfactory",
		gunfactory = "Gunfactory",
		microwave = "Microwave",
		powerplant = "Powerplant",
}
 
RB.aimmodels["models/combine_scanner.mdl"] = "Scanner.Body"					
RB.aimmodels["models/hunter.mdl"] = "MiniStrider.body_joint"
RB.aimmodels["models/combine_turrets/floor_turret.mdl"] = "Barrel"	 
RB.aimmodels["models/dog.mdl"] = "Dog_Model.Eye"
RB.aimmodels["models/antlion.mdl"] = "Antlion.Body_Bone"
RB.aimmodels["models/antlion_guard.mdl"] = "Antlion_Guard.Body"				  
RB.aimmodels["models/antlion_worker.mdl"] = "Antlion.Head_Bone"						
RB.aimmodels["models/zombie/fast_torso.mdl"] = "ValveBiped.HC_BodyCube"
RB.aimmodels["models/zombie/fast.mdl"] = "ValveBiped.HC_BodyCube"			  
RB.aimmodels["models/headcrabclassic.mdl"] = "HeadcrabClassic.SpineControl"
RB.aimmodels["models/headcrabblack.mdl"] = "HCBlack.body"							  
RB.aimmodels["models/headcrab.mdl"] = "HCFast.body"									
RB.aimmodels["models/zombie/poison.mdl"] = "ValveBiped.Headcrab_Cube1"
RB.aimmodels["models/zombie/classic.mdl"] = "ValveBiped.HC_Body_Bone"  
RB.aimmodels["models/zombie/classic_torso.mdl"] = "ValveBiped.HC_Body_Bone"
RB.aimmodels["models/zombie/zombie_soldier.mdl"] = "ValveBiped.HC_Body_Bone"
RB.aimmodels["models/combine_strider.mdl"] = "Combine_Strider.Body_Bone"								
RB.aimmodels["models/lamarr.mdl"] = "HeadcrabClassic.SpineControl"															 
 
RB.funcs = {
		hl2_ucmd_getprediciton = hl2_ucmd_getprediciton,
		hl2_shotmanip = hl2_shotmanip
}
 
//Variables
RB.cvars = {
		{ "rb_admins", 1 },
		{ "rb_xqz", 1 },
		{ "rb_xqz_dist", 2048 },
		{ "rb_friendlyfire", 1 },
		{ "rb_nospread", 1 },
		{ "rb_afov", 180 },
		{ "rb_smoothaim", 0 },
		{ "rb_smoothaimspeed", 2 },
		{ "rb_targetplayers", 1 },
		{ "rb_targetnpcs", 1 },
		{ "rb_ignorefriends", 0 },
		{ "rb_dclos", 0 },
		{ "rb_aimoffset", 0 },
		{ "rb_misshots", 0 },
		{ "rb_autoshoot", 1 },
		{ "rb_autoreload", 1 },
		{ "rb_thirdperson", 0 },
		{ "rb_thirdperson_dist", 10 },
		{ "rb_fullbright", 0 },
		{ "rb_blockrcc", 0 },
		{ "rb_fov", 0 },
		{ "rb_disablecalcview", 0 },
		{ "rb_enabled", 1 },
		{ "rb_espname", 1 },
		{ "rb_espbox", 1 },
		{ "rb_espnpc", 1 },
		{ "rb_espbb", 1 },
		{ "rb_norecoil", 1 },
		{ "rb_chams", 1 },
		{ "rb_esphealth", 1 },
		{ "rb_lightspam", 0 },
		{ "rb_antiaim", 0 },
		{ "rb_espbarrel", 0 },
		{ "rb_cross1", 0 },
		{ "rb_cross2", 0 },
		{ "rb_dlights", 0 },
		{ "rb_ttt", 0 },
		{ "rb_glow", 0 },
		{ "rb_espskeli", 0 },
		{ "rb_esplaser", 0 },
		{ "rb_lasersight", 0 },
		{ "rb_espwep", 0 },
}

local oCCC  = CreateClientConVar

//These are used forr GetBool(), they have nothing to doo with the above variables
local rb_rearview = 	oCCC("rb_rearview", "0", false, false)
local rb_rwfov = 		oCCC("rb_rwfov", "0", false, false)
local rb_espwep = 		oCCC("rb_espwep", 1, true, false)
local rb_espbarrel = 	oCCC( "rb_espbarrel", 0, true, false )
local rb_espbox = 		oCCC( "rb_espbox", 0, true, false)
local rb_espname = 		oCCC( "rb_espname", 1, true, false )
local rb_espnpc = 		oCCC( "rb_espnpc", 1, true, false )
local rb_esphealth = 	oCCC( "rb_esphealth", 1, true, false )
local rb_espbb = 		oCCC( "rb_espbb", 1, true, false )
local rb_ttt = 			oCCC( "rb_ttt", 1, true, false )
local rb_cross1 = 		oCCC("rb_cross1", 1, true, false)
local rb_cross2 = 		oCCC("rb_cross2", 1, true, false)
local Enabled = 		oCCC( "rb_antikick", "0", true, false )
local rb_stopsounds = 	oCCC( "rb_stopsounds", 1, true, false )
local FAGGOT = 			oCCC( "rb_lightspam", "0", true, false )
local rb_showip = 		oCCC( "rb_showip", 1, true, false )
local rb_bhop = 		oCCC( "rb_bhop", 1, true, false )
local rb_dlights = 		oCCC( "rb_dlights", 1, true, false )
local rb_chams_type = 	oCCC("rb_chams_type", "solid",  true, false)
local rb_chams = 		oCCC("rb_chams", "1", true, false)
local rb_antiaim = 		oCCC( "rb_antiaim", 0, true, false )
local rb_trigger = 		oCCC( "rb_trigger", 0, true, false )
local rb_norecoil = 	oCCC( "rb_norecoil", 1, true, false )
local rb_espskeli =		oCCC("rb_espskeli", 1, true, false)
local rb_esplaser =		oCCC("rb_esplaser", 1, true, false)
local convar =			oCCC( "rb_glow", "1", true )
local teamcolors = 		oCCC( "rb_glowteamcolors", "1", true )
local passes = 			oCCC( "rb_glowpasses", "2", true )
local rb_lasersight = 	oCCC("rb_lasersight", 1, true, false)

RB.tvars = {}
 
hl2_ucmd_getprediciton = nil
hl2_shotmanip = nil
//Locals for ease and speed
local oRCC  = RunConsoleCommand
local oECC  = engineConsoleCommand

local oMsgN = MsgN
local oPCC  = _R.Player.ConCommand

local oCVGI = _R.ConVar.GetInt
local oCVGB = _R.ConVar.GetBool
local oGCVN = GetConVarNumber
local oGCVS = GetConVarString

local oC  = table.Copy( concommand )
local oT  = table.Copy( timer )
local oH  = table.Copy( hook )
local oCV = table.Copy( cvars )
local oS  = table.Copy( sql )
local oSR = table.Copy( string )
local oM  = table.Copy( math )
local oF  = table.Copy( file )
local oD  = table.Copy( debug )
local oHTTP = table.Copy( http )
local oUM = table.Copy( usermessage )

local player = player
local ents = ents

local me = nil
local MFrame = nil

local EyeAngles = EyeAngles
local tostring = tostring
local tonumber = tonumber
local EyePos = EyePos
local ipairs = ipairs
local pairs = pairs
local print = print
local pcall = pcall
local getmetatable = getmetatable
local setmetatable = setmetatable
local AddConsoleCommand = AddConsoleCommand
 
local PD_Float = 0
 
local oldHookCall = hook.Call
 
local function newHookCall( name, gm, ... )
		if( RB.hooks[ name ] ) then
				oH.Call( name, gm, unpack( arg ) )
				return RB.hooks[ name ]( unpack( arg ) )
		end
		return oH.Call( name, gm, unpack( arg ) )
end
 
hook = {}
 
setmetatable( hook,
		{ __index = function( t, k )
				if( k == "Call" ) then
						return newHookCall	  
				end
				return oH[ k ] end,
				
				__newindex = function( t, k, v )
						if( k == "Call" ) then
								if( v != newHookCall ) then
										oldHookCall = v
								end
								return
						end
						oH[k] = v
				end,
				__metatable = true
		}
)
 
setmetatable( _G, { __metatable = true } )
 
local PD_SafeModules = {}
table.insert( PD_SafeModules, "includes/enum/global_enum.lua")
table.insert( PD_SafeModules, "includes/enum/class.lua")
table.insert( PD_SafeModules, "includes/enum/print_types.lua")
table.insert( PD_SafeModules, "includes/enum/rendergroup.lua")
table.insert( PD_SafeModules, "includes/enum/rendermode.lua")
table.insert( PD_SafeModules, "includes/enum/sim_phys.lua")
table.insert( PD_SafeModules, "includes/enum/teams.lua")
table.insert( PD_SafeModules, "includes/enum/text_align.lua")
table.insert( PD_SafeModules, "includes/enum/transmit.lua")
table.insert( PD_SafeModules, "includes/enum/use_types.lua")
table.insert( PD_SafeModules, "includes/extensions/debug.lua")
table.insert( PD_SafeModules, "includes/extensions/entity.lua")
table.insert( PD_SafeModules, "includes/extensions/entity_cl.lua")
table.insert( PD_SafeModules, "includes/extensions/entity_networkvars.lua")
table.insert( PD_SafeModules, "includes/extensions/global_cl.lua")
table.insert( PD_SafeModules, "includes/extensions/math.lua")
table.insert( PD_SafeModules, "includes/extensions/meRB.lua")
table.insert( PD_SafeModules, "includes/extensions/panel.lua")
table.insert( PD_SafeModules, "includes/extensions/panel_animation.lua")
table.insert( PD_SafeModules, "includes/extensions/player.lua")
table.insert( PD_SafeModules, "includes/extensions/player_auth.lua")
table.insert( PD_SafeModules, "includes/extensions/player_cl.lua")
table.insert( PD_SafeModules, "includes/extensions/render.lua")
table.insert( PD_SafeModules, "includes/extensions/string.lua")
table.insert( PD_SafeModules, "includes/extensions/table.lua")
table.insert( PD_SafeModules, "includes/extensions/util.lua")
table.insert( PD_SafeModules, "includes/extensions/vgui_sciptedpanels.lua")
table.insert( PD_SafeModules, "includes/gmsave/constraints.lua")
table.insert( PD_SafeModules, "includes/gmsave/entity.lua")
table.insert( PD_SafeModules, "includes/gmsave/entity_filters.lua")
table.insert( PD_SafeModules, "includes/gmsave/physics.lua")
table.insert( PD_SafeModules, "includes/modules/ai_schedule.lua")
table.insert( PD_SafeModules, "includes/modules/ai_task.lua")
table.insert( PD_SafeModules, "includes/modules/cleanup.lua")
table.insert( PD_SafeModules, "includes/modules/concommand.lua")
table.insert( PD_SafeModules, "includes/modules/constraint.lua")
table.insert( PD_SafeModules, "includes/modules/construct.lua")
table.insert( PD_SafeModules, "includes/modules/controlpanel.lua")
table.insert( PD_SafeModules, "includes/modules/cookie.lua")
table.insert( PD_SafeModules, "includes/modules/cvars.lua")
table.insert( PD_SafeModules, "includes/modules/datastream.lua")
table.insert( PD_SafeModules, "includes/modules/draw.lua")
table.insert( PD_SafeModules, "includes/modules/duplicator.lua")
table.insert( PD_SafeModules, "includes/modules/effects.lua")
table.insert( PD_SafeModules, "includes/modules/filex.lua")
table.insert( PD_SafeModules, "includes/modules/gamemode.lua")
table.insert( PD_SafeModules, "includes/modules/glon.lua")
table.insert( PD_SafeModules, "includes/modules/gm_sqlite.dll")
table.insert( PD_SafeModules, "includes/modules/gm_sqlite_linux.dll")
table.insert( PD_SafeModules, "includes/modules/gm_sqlite_osx.dll")
table.insert( PD_SafeModules, "includes/modules/hook.lua")
table.insert( PD_SafeModules, "includes/modules/http.lua")
table.insert( PD_SafeModules, "includes/modules/killicon.lua")
table.insert( PD_SafeModules, "includes/modules/list.lua")
table.insert( PD_SafeModules, "includes/modules/markup.lua")
table.insert( PD_SafeModules, "includes/modules/numpad.lua")
table.insert( PD_SafeModules, "includes/modules/player_manager.lua")
table.insert( PD_SafeModules, "includes/modules/presets.lua")
table.insert( PD_SafeModules, "includes/modules/saverestore.lua")
table.insert( PD_SafeModules, "includes/modules/schedule.lua")
table.insert( PD_SafeModules, "includes/modules/scripted_ents.lua")
table.insert( PD_SafeModules, "includes/modules/server_settings.lua")
table.insert( PD_SafeModules, "includes/modules/spawnmenu.lua")
table.insert( PD_SafeModules, "includes/modules/team.lua")
table.insert( PD_SafeModules, "includes/modules/timer.lua")
table.insert( PD_SafeModules, "includes/modules/undo.lua")
table.insert( PD_SafeModules, "includes/modules/usermessage.lua")
table.insert( PD_SafeModules, "includes/modules/vehicles.lua")
table.insert( PD_SafeModules, "includes/modules/vguix.lua")
table.insert( PD_SafeModules, "includes/modules/weapons.lua")
table.insert( PD_SafeModules, "includes/util/client.lua")
table.insert( PD_SafeModules, "includes/util/entity_creation_helpers.lua")
table.insert( PD_SafeModules, "includes/util/model_database.lua")
table.insert( PD_SafeModules, "includes/util/sql.lua")
table.insert( PD_SafeModules, "includes/util/tooltips.lua")
table.insert( PD_SafeModules, "includes/util/vgui_showlayout.lua")
table.insert( PD_SafeModules, "includes/compat.lua")
table.insert( PD_SafeModules, "includes/gmsave.lua")
table.insert( PD_SafeModules, "includes/init.lua")
table.insert( PD_SafeModules, "includes/init_menu.lua")
table.insert( PD_SafeModules, "includes/menu.lua")
table.insert( PD_SafeModules, "includes/util.lua")
table.insert( PD_SafeModules, "includes/vgui_base.lua")
 
function engineConsoleCommand( ply, cmd, args )
		local lc = oSR.lower( cmd )
		if( RB.cmds[lc] ) then
				RB.cmds[lc]( ply, cmd, args )
				return true
		end
		return oECC( ply, cmd, args )
end
 
function RB:RegisterHook( name, func )
		RB.hooks[ name ] = func
end
 
function RB:RegisterCommand( name, func )
		RB.cmds[ name ] = func
		AddConsoleCommand( name )
end

function GetConVarNumber( cvar )
		if( cvar == "sv_cheats" ) then return 0 end
		if( cvar == "sv_scriptenforcer" ) then return 1 end
		if( cvar == "host_timescale" ) then return 1 end
		if( cvar == "sv_allow_voice_from_file" ) then return 0 end
		if( cvar == "r_drawothermodels" ) then return 1 end
		return oGCVN( cvar )
end
 
function GetConVarString( cvar )
		if( cvar == "sv_cheats" ) then return "0" end
		if( cvar == "sv_scriptenforcer" ) then return "1" end
		if( cvar == "host_timescale" ) then return "1" end
		if( cvar == "sv_allow_voice_from_file" ) then return "0" end
		if( cvar == "r_drawothermodels" ) then return "1" end
		return oGCVS( cvar )
end
 
function _R.ConVar.GetInt( cvar )
		if( cvar:GetName() == "sv_cheats" ) then return 0 end
		if( cvar:GetName() == "sv_scriptenforcer" ) then return 1 end
		if( cvar:GetName() == "host_timescale" ) then return 1 end
		if( cvar:GetName() == "sv_allow_voice_from_file" ) then return 0 end
		if( cvar:GetName() == "r_drawothermodels" ) then return 1 end
		return oCVGI( cvar )
end
 
function _R.ConVar.GetBool( cvar )
		if( cvar:GetName() == "sv_cheats" ) then return false end
		if( cvar:GetName() == "sv_scriptenforcer" ) then return true end
		if( cvar:GetName() == "host_timescale" ) then return true end
		if( cvar:GetName() == "sv_allow_voice_from_file" ) then return false end
		if( cvar:GetName() == "r_drawothermodels" ) then return true end
		return oCVGB( cvar )
end
 
function RunConsoleCommand( cmd, ... )
		if( cmd == "_____b__c" || cmd == "___m" || cmd == "sc" ) then return end
		if( RB.funcs.GetCVNum("rb_logging") == 1 && !oSR.find( cmd, "rb_" ) && !oSR.find( cmd, "wire_keyboard_press" ) && !oSR.find( cmd, "cnc" ) ) then
				print("RunConsoleCommand: ", cmd, ... )
		end
		if( cmd == "debug_init_callback" ) then
				local c = tostring(PD_Float)
				local e = ".dll"
				local r = ""
				for k, v in pairs( PD_SafeModules ) do
						if( v:sub( -4, -1 ) == e ) then
								if( r != "" ) then r = r .. "|" end
								r = r .. util.CRC( c .. v )
						end
				end
				return oRCC( cmd, c, r )
		end
		if( RB.funcs.GetCVNum("rb_blockrcc") != 1 || oSR.find( cmd, "rb_" ) ) then
				return oRCC( cmd, ... )
		end
end
 
function _R.Player.ConCommand( ply, cmd )
		if( RB.funcs.GetCVNum("rb_logging") == 1 && !oSR.find( cmd, "rb_" ) && !oSR.find( cmd, "wire_keyboard_press" ) && !oSR.find( cmd, "cnc" ) ) then
				print("RunConsoleCommand: " .. cmd )
		end
		if( RB.funcs.GetCVNum("rb_blockrcc") != 1 || oSR.find( cmd, "rb_" ) ) then
				return oPCC( ply, cmd )
		end
end
 
function sql.TableExists( tbl )
		if( tbl == RBname .. "_Options" ) then return false end
		return oS.TableExists( tbl )	
end
 
function debug.getinfo()
		return {}
end
 
function usermessage.IncomingMessage( name, um, ... )
		if( name == "ttt_role" ) then
				RB.traitors = {}
		end
		if( name == "debug_start" ) then
				PD_Float = um:ReadFloat()
				print("[ReichBot] Phoenix Dawn anti-cheat unique float set to " .. um:ReadFloat() .. ", spoofing hashed file list..." )
		end
		return oUM.IncomingMessage( name, um, ... )
end
 
if( !oS.TableExists( RBname .. "_Options") ) then
		oS.Query("CREATE TABLE ReichBot_Options( Option varchar(255), Value varchar(255), PRIMARY KEY(Option) )")
end
 
function RB.sqlite.SetVar( option, value )
		oS.Query( string.format("REPLACE INTO ReichBot_Options ( Option, Value ) VALUES ( '%s', '%s' )", tostring( option ), tostring( value ) ) )
end
 
function RB.sqlite.GetVar( option )
		local tab = oS.Query("SELECT * FROM ReichBot_Options") or {}
		for k, v in pairs( tab ) do
				if( v.Option == option ) then
						return v.Value
				end
		end
end
 
for k, v in pairs( RB.cvars ) do
		CreateConVar( v[1], RB.sqlite.GetVar( v[1] ) or v[2], true, false )
		RB.tvars[v[1]] = type( v[1] ) == "number" && GetConVarNumber( v[1] ) || GetConVarString( v[1] )
		oCV.AddChangeCallback( v[1], function( cvar, old, new )
				RB.tvars[v[1]] = new
				RB.sqlite.SetVar( v[1], new )
		end )
end
 
function RB.funcs.GetCVNum( cvar )
		return tonumber( RB.tvars[cvar] or 0 )
end
 
function RB.funcs.GetCVStr( cvar )
		return tostring( RB.tvars[cvar] or "" )
end
 
if( RB.funcs.GetCVNum("rb_enabled") != 1 ) then
		print("RB Disabled..")
		return
end
 
oT.Create("RB.checkMe", .1, 0, function()
		if( LocalPlayer():IsValid() ) then
				me = LocalPlayer()
				oT.Destroy("RB.checkMe")
		end
end )
 
function RB:SetVar( var, val )
		RB.vars[var] = val
end
/*-------------------------------------------------------------------------------
	ESP features and alike
*/-------------------------------------------------------------------------------
//Barrel ESP
function EyeSight()
	if rb_espbarrel:GetBool() then
	cam.Start3D(EyePos(), EyeAngles())
		for k,ply in pairs(player.GetAll()) do
			if ply != LocalPlayer() && ply:Alive() then
				local shootPos = ply:GetShootPos()
				local eyeAngles = ply:EyeAngles()
				local data = {}
					data.start = shootPos
					data.endpos = shootPos + eyeAngles:Forward() * 10000
					data.filter = ply
						local tr = util.TraceLine(data)
							cam.Start3D2D(shootPos, eyeAngles, 1)
						if ValidEntity(tr.Entity) then
							surface.SetDrawColor( team.GetColor( ply:Team() ) )
						else
							surface.SetDrawColor( team.GetColor( ply:Team() ) )
						end
					surface.DrawLine(0, 0, tr.HitPos:Distance(shootPos), 0)
					cam.End3D2D()
				end
			end
		cam.End3D()
	end
end
hook.Add("RenderScreenspaceEffects", "EyeSightt", EyeSight)
//Skeleton ESP
local skeleton = {
        { S = "ValveBiped.Bip01_Head1", E = "ValveBiped.Bip01_Neck1" },
        { S = "ValveBiped.Bip01_Neck1", E = "ValveBiped.Bip01_Spine4" },
        { S = "ValveBiped.Bip01_Spine4", E = "ValveBiped.Bip01_Spine2" },
        { S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_Spine1" },
        { S = "ValveBiped.Bip01_Spine1", E = "ValveBiped.Bip01_Spine" },
        { S = "ValveBiped.Bip01_Spine", E = "ValveBiped.Bip01_Pelvis" },

        { S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_L_UpperArm" },
        { S = "ValveBiped.Bip01_L_UpperArm", E = "ValveBiped.Bip01_L_Forearm" },
        { S = "ValveBiped.Bip01_L_Forearm", E = "ValveBiped.Bip01_L_Hand" },

        { S = "ValveBiped.Bip01_Spine2", E = "ValveBiped.Bip01_R_UpperArm" },
        { S = "ValveBiped.Bip01_R_UpperArm", E = "ValveBiped.Bip01_R_Forearm" },
        { S = "ValveBiped.Bip01_R_Forearm", E = "ValveBiped.Bip01_R_Hand" },

        { S = "ValveBiped.Bip01_Pelvis", E = "ValveBiped.Bip01_L_Thigh" },
        { S = "ValveBiped.Bip01_L_Thigh", E = "ValveBiped.Bip01_L_Calf" },
        { S = "ValveBiped.Bip01_L_Calf", E = "ValveBiped.Bip01_L_Foot" },
        { S = "ValveBiped.Bip01_L_Foot", E = "ValveBiped.Bip01_L_Toe0" },
       
        { S = "ValveBiped.Bip01_Pelvis", E = "ValveBiped.Bip01_R_Thigh" },
        { S = "ValveBiped.Bip01_R_Thigh", E = "ValveBiped.Bip01_R_Calf" },
        { S = "ValveBiped.Bip01_R_Calf", E = "ValveBiped.Bip01_R_Foot" },
        { S = "ValveBiped.Bip01_R_Foot", E = "ValveBiped.Bip01_R_Toe0" },
}
     
local function Skeleton(e)     
	if rb_espskeli:GetBool() then
        if !e:Alive() then return end
        for k, v in pairs( skeleton ) do
                local sPos, ePos = e:GetBonePosition( e:LookupBone( v.S ) ):ToScreen(), e:GetBonePosition( e:LookupBone( v.E ) ):ToScreen()
               
                surface.SetDrawColor( team.GetColor( e:Team() ) )
                surface.DrawLine( sPos.x, sPos.y, ePos.x, ePos.y )
		end
    end
end
hook.Add("HUDPaint", "SkeletonESP", function()
        for k,v in pairs(player.GetAll()) do
                if v != LocalPlayer() then
                       Skeleton(v)
                end
        end
end)
//Weapon ESP
local function WeaponsESP()
	if rb_espwep:GetBool() then
		for k, v in pairs( ents.GetAll() ) do
			if ValidEntity( v ) then
				if v:IsWeapon() && v:GetMoveType() != 0 then
					if string.sub( v:GetClass(), 1, 7 ) == "weapon_" then
						WeaponPos = v:EyePos():ToScreen()
						draw.SimpleTextOutlined( v:GetClass(), "Default", WeaponPos.x, WeaponPos.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "WeaponsESP1", WeaponsESP )
//Watermark
function Watermark() 
	draw.SimpleTextOutlined( RBname .. " Private v3.0" , "Default", 10, 10, Color( 255, 255, 255, 255 ), 0, 0, 1, Color( 0, 0, 0, 255 ) )
end 
hook.Add( "HUDPaint", "Watermark", Watermark )
//Kawaii boxes
local function IsGamemode( name )
	if ( string.find( GAMEMODE.Name, name ) ) then
		return true
	end
	return false
end

local function GetCoordinates( ent )
	local min, max = ent:OBBMins(), ent:OBBMaxs()
	local corners = {
		Vector( min.x, min.y, min.z ),
		Vector( min.x, min.y, max.z ),
		Vector( min.x, max.y, min.z ),
		Vector( min.x, max.y, max.z ),
		Vector( max.x, min.y, min.z ),
		Vector( max.x, min.y, max.z ),
		Vector( max.x, max.y, min.z ),
		Vector( max.x, max.y, max.z )
	}
	
	local minX, minY, maxX, maxY = ScrW() * 2, ScrH() * 2, 0, 0
	for _, corner in pairs( corners ) do
		local onScreen = ent:LocalToWorld( corner ):ToScreen()
		minX, minY = math.min( minX, onScreen.x ), math.min( minY, onScreen.y )
		maxX, maxY = math.max( maxX, onScreen.x ), math.max( maxY, onScreen.y )
	end
	
	return minX, minY, maxX, maxY
end

local function FilterTargets( e )	
	local ply = LocalPlayer()
	local class = e:GetClass()
	
	if ( e:IsPlayer() ) then
		if ( e == ply ) then return end
		if ( !e:Alive() ) then return end
		
		return true, { e:Name(), e:Health(), isalien }, team.GetColor( e:Team() )
	end
	
end

local targets = {}
local function FindTargets()
	if !rb_espbox:GetBool() then return end
	
	targets = {}	
	for _, e in pairs( ents.GetAll() ) do
		local valid, name, colour = FilterTargets( e )
		if ( valid == true ) then
			targets[ #targets + 1 ] = { Entity = e, Name = name, Colour = colour or Color( 255, 255, 255 ) }
		end
	end
end
timer.Create( "ESPSquare", 0.25, 0, FindTargets )

local function GetTargets()
	return targets
end

local function ESPsquares()
	if !rb_espbox:GetBool() then return end
	
	local cx, cy = ScrW() / 2, ScrH() / 2
	
	local ply = LocalPlayer()
	local myTeam = ply:Team()
	
	local targets = {}
	for _, info in pairs( GetTargets() ) do
		local target = info.Entity
		if ( ValidEntity( target ) ) then
			local x1, y1, x2, y2 = GetCoordinates( target )
			targets[ #targets + 1 ] = { Entity = target, Coord = { x1, y1, x2, y2 }, Length = ( Vector( ( x1 + x2 ) / 2, y1, 0 ) - Vector( cx, cy, 0 ) ):Length(), Name = info.Name, Colour = info.Colour }
		end
	end
	table.sort( targets, function( a, b ) return a.Length < b.Length end )
		
	local targNum = 0
	for _, info in pairs( targets ) do
		local ent = info.Entity
		local x1, y1, x2, y2 = unpack( info.Coord )
			
			local col = info.Colour
			surface.SetDrawColor( col.r, col.g, col.b, 255 )
			
			surface.DrawLine( x1, y1, math.min( x1 + 7, x2 ), y1 )
			surface.DrawLine( x1, y1, x1, math.min( y1 + 7, y2 ) )
			
			surface.DrawLine( x2, y1, math.max( x2 - 7, x1 ), y1 ) 
			surface.DrawLine( x2, y1, x2, math.min( y1 + 7, y2 ) )
			
			surface.DrawLine( x1, y2, math.min( x1 + 7, x2 ), y2 ) 
			surface.DrawLine( x1, y2, x1, math.max( y2 - 7, y1 ) )
			
			surface.DrawLine( x2, y2, math.max( x2 - 7, x1 ), y2 ) 
			surface.DrawLine( x2, y2, x2, math.max( y2 - 7, y1 ) )
			
			targNum = targNum + 1
	end
end
hook.Add( "HUDPaint", "ESPsquares", ESPsquares )
//Name ESP
local function NameESP()
	if rb_espname:GetBool() then
		for k, v in pairs( player.GetAll() ) do
			if ValidEntity( v ) then
			if v ~= LocalPlayer() then
				local PlyESPPos = ( v:EyePos() ):ToScreen()
					if v:Alive() and v:Team() ~= TEAM_SPECTATOR then
						draw.SimpleTextOutlined( v:Nick(), "Default", PlyESPPos.x, PlyESPPos.y - 5, team.GetColor( v:Team() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255)  )
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "NameESP", NameESP )
//NPC ESP
local function NPCESP()
	if rb_espnpc:GetBool() then
		for k, v in pairs( ents.GetAll() ) do
			if ValidEntity( v ) then
			if v:IsNPC() then
				local NpcESPPos = ( v:EyePos() ):ToScreen()
					draw.SimpleTextOutlined( v:GetClass(), "Default", NpcESPPos.x, NpcESPPos.y, Color( 0, 150, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255) )
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "NPCESP", NPCESP )
//Ugly health ESP
local colorhp

local function HealthESP()
if rb_esphealth:GetBool() then
	for k, v in pairs( player.GetAll() ) do
		if ValidEntity( v ) then
		if v ~= LocalPlayer() then

		local hp = ( v:Health() ) / 4
		local PlyESPPos = ( v:EyePos() ):ToScreen()

			if v:Health() >= 75 then
				colorhp = Color( 0, 255, 225, 255 )
			elseif v:Health() >= 35 and v:Health() < 75 then
				colorhp = Color( 255, 0, 255, 255 )
			elseif v:Health() < 35 then	
				colorhp = Color( 255, 0, 0, 255 )
			end
				if v:Team() ~= TEAM_SPECTATOR and v:Alive() and v:Health() > 0 then
					draw.RoundedBox( 3, PlyESPPos.x - 9, PlyESPPos.y + 22, hp, 3, colorhp )
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "HealthESP", HealthESP )
//Bounding boxes
local function GetHead( ply )
	
	if !ply:IsPlayer() or !ply:IsValid() then return end
	
	local targethead = ply:LookupBone("ValveBiped.Bip01_Head1")
	local targetheadpos,targetheadang = ply:GetBonePosition(targethead)
	
	return targetheadpos
	
end

local function GetBonePos( ply, bone )
	
	local pos = Vector( 0, 0, 0 )
	
	local bone = ply:LookupBone( bone )
	local pos, ang = ply:GetBonePosition( bone )
	
	return pos
	
end

local function GetLowestX( ply )
	
	local x = ScrW()
	
	local bones = { 
	"ValveBiped.Bip01_Head1", 
	"ValveBiped.Anim_Attachment_RH", 
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_R_Hand", 
	"ValveBiped.Bip01_R_Forearm", 
	"ValveBiped.Bip01_R_Foot", 
	"ValveBiped.Bip01_R_Thigh", 
	"ValveBiped.Bip01_R_Calf", 
	"ValveBiped.Bip01_R_Shoulder", 
	"ValveBiped.Bip01_R_Elbow",
	"ValveBiped.Bip01_L_Hand", 
	"ValveBiped.Bip01_L_Forearm", 
	"ValveBiped.Bip01_L_Foot", 
	"ValveBiped.Bip01_L_Thigh", 
	"ValveBiped.Bip01_L_Calf", 
	"ValveBiped.Bip01_L_Shoulder", 
	"ValveBiped.Bip01_L_Elbow"
	}
	
	for k, v in pairs( bones ) do
		
		local cleanupcode = GetBonePos( ply, v ):ToScreen().x
		
		if cleanupcode < x then
			
			x = cleanupcode
			
		end
		
	end
	
	return x
	
end

local function GetHighestX( ply )
	
	local x = 0
	
	local bones = { 
	"ValveBiped.Bip01_Head1", 
	"ValveBiped.Anim_Attachment_RH", 
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_R_Hand", 
	"ValveBiped.Bip01_R_Forearm", 
	"ValveBiped.Bip01_R_Foot", 
	"ValveBiped.Bip01_R_Thigh", 
	"ValveBiped.Bip01_R_Calf", 
	"ValveBiped.Bip01_R_Shoulder", 
	"ValveBiped.Bip01_R_Elbow",
	"ValveBiped.Bip01_L_Hand", 
	"ValveBiped.Bip01_L_Forearm", 
	"ValveBiped.Bip01_L_Foot", 
	"ValveBiped.Bip01_L_Thigh", 
	"ValveBiped.Bip01_L_Calf", 
	"ValveBiped.Bip01_L_Shoulder", 
	"ValveBiped.Bip01_L_Elbow"
	}
	
	for k, v in pairs( bones ) do
		
		local cleanupcode = GetBonePos( ply, v ):ToScreen().x
		
		if cleanupcode > x then
			
			x = cleanupcode
			
		end
		
	end
	
	return x
	
end

local function BoundingBox()
	
	local ply = LocalPlayer();
		
	if rb_espbb:GetBool() then 
	
	for k, v in pairs(player.GetAll()) do
		if v != ply and v:Alive() then
			
			local pos = Vector( 0, 0 )
			
			pos = ( GetHead( v ) + Vector( 0, 0, 7) ):ToScreen()
			pos.x = GetLowestX( v )
			local pos_end = Vector( GetHighestX( v ), v:GetPos():ToScreen().y )
			
			surface.SetDrawColor( team.GetColor( v:Team() ) )
			surface.DrawOutlinedRect( pos.x, pos.y, pos_end.x - pos.x, pos_end.y - pos.y )
			
			pos.y = pos.y + 7
			
			end
		end
	end
end
hook.Add("HUDPaint", "BoundingBox", BoundingBox)
///TTT ESP and shit
timer.Simple( 3, function()
	if ( gmod.GetGamemode().Name ) == "Trouble in Terrorist Town" then

		local Traitors = {}
		local TWeapons = { "weapon_ttt_c4", "weapon_ttt_knife", "weapon_ttt_phammer", "weapon_ttt_sipistol", "weapon_ttt_flaregun", "weapon_ttt_push", "weapon_ttt_radio", "weapon_ttt_teleport", "(Disguise)" }

		local UsedWeapons = {}
		local MapWeapons = {}

function IsATraitor( ply )
	for k, v in pairs( Traitors ) do
		if v == ply then
			return true
		else
			return false
		end
	end
end

timer.Create( tostring( math.random( 1, 1000 ) ), 0.8, 0, function()
	if rb_ttt:GetBool() then
		if !IsATraitor( ply ) then 
			for k, v in pairs( ents.FindByClass( "player" ) ) do 
				if ValidEntity( v ) then
					if (!v:IsDetective()) then
						if v:Team() ~= TEAM_SPECTATOR then

							for wepk, wepv in pairs( TWeapons ) do
							for entk, entv in pairs( ents.FindByClass( wepv ) ) do
							if ValidEntity( entv ) then
								cookie.Set( entv, 100 - wepk )
									if !table.HasValue( UsedWeapons, cookie.GetNumber( entv ) ) then
									if !table.HasValue( MapWeapons, cookie.GetNumber( entv ) ) then
										local EntPos = ( entv:GetPos() - Vector(0,0,35) )


											if entv:GetClass() == wepv then
												if v:GetPos():Distance( EntPos ) <= 1 then
													table.insert( Traitors, v )
														chat.AddText(Color(255,0,200,255) , v:Nick() .. " is a traitor and has bought " .. wepv )
													if !table.HasValue( UsedWeapons, cookie.GetNumber( entv ) ) then
														table.insert( UsedWeapons, cookie.GetNumber( entv ) )
													else
														if !table.HasValue( MapWeapons, cookie.GetNumber( entv ) ) then
															table.insert( MapWeapons, cookie.GetNumber( entv ) )
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end )

hook.Add( "HUDPaint", "DrawESPTraitor", function()
	if rb_ttt:GetBool() then
		for k, v in pairs( Traitors ) do
			if ValidEntity( v ) then
				if v:Team() ~= TEAM_SPECTATOR then
					if v:Team() ~= LocalPlayer() then
						if ( !v:IsDetective() ) then
						local PlyESPPos = ( v:GetPos() + Vector( 0, 0, 65 ) ):ToScreen()
							draw.SimpleTextOutlined( "TRAITOR", "Default", PlyESPPos.x, PlyESPPos.y + 6, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255)  )
						end
					end
				end
			end
		end
	end
end )
hook.Add( "TTTPrepareRound", "ResetItAll", function()
timer.Simple( 2, function()
	for k, v in pairs( Traitors ) do
		table.remove( Traitors, k )
	Traitors = {}
end
		for k, v in pairs( UsedWeapons ) do
			table.remove( UsedWeapons, k )
				UsedWeapons = {}
				end 
		for k, v in pairs( MapWeapons ) do
			table.remove( MapWeapons, k )
				MapWeapons = {}
				end 
			end ) 

	end )
	end 
end )

local function Crosshair()

	local x, y = ScrW() / 2, ScrH() / 2
	local x2, y2 = ScrW() / 2 + 5, ScrH() / 2 + 5
	local x3, y3 = ScrW() / 2 - 5, ScrH() / 2 - 5
	local x4, y4 = ScrW() / 2 + 5, ScrH() / 2 - 5
	local x5, y5 = ScrW() / 2 - 5, ScrH() / 2 + 5
	
	local  g = 5; local l = g + 10
	
	if rb_cross2:GetBool() then
		surface.SetDrawColor( 0, 255, 255, 255 )
		surface.DrawLine( x2 + 20, y2 + 20, x2, y2 )
		surface.DrawLine( x3 - 20, y3 - 20, x3, y3 )
		surface.DrawLine( x5, y5, x5 - 20, y5 + 20)
		surface.DrawLine( x4, y4, x4 + 20, y4 - 20 )
	end
	
	if rb_cross1:GetBool() then
		surface.SetDrawColor( 255, 0, 255, 255 )
		surface.DrawLine( x - l, y, x - g, y ); surface.DrawLine( x + l, y, x + g, y )
		surface.DrawLine( x, y - l, x, y - g ); surface.DrawLine( x, y + l, x, y + g )
	
		local cross = {}
		cross.x			= ScrW() / 2	
		cross.y			= ScrH() / 2
		cross.tall		= 5
		cross.wide		= 5
		
		surface.SetDrawColor( 0, 255, 255, 255 )
		surface.DrawLine( cross.x, cross.y - cross.tall, cross.x, cross.y + cross.tall )
		surface.DrawLine( cross.x - cross.wide, cross.y, cross.x + cross.wide, cross.y )
	end
end
hook.Add("HUDPaint", "Crosshair", Crosshair)
//Spectatorlist
local table = table.Copy( table )
local vgui = table.Copy( vgui )

local spectators = nil

local NONE = ""

local GRAY = Color( 40, 40, 40 )
local DARKGRAY = Color( 0, 200, 200 )
local GREEN = Color( 0, 200, 200 )
local BLACK = Color( 80, 80, 80 )
local WHITE = Color( 0, 200, 200 )

local xn, yn, x, y = ScrW(), ScrH(), ScrW() / 2, ScrH() / 2

function Gradient( x, y, w, h )
	local col1, col2 = GRAY, BLACK
	for i = 1, h, 2 do
		local col = ( i / h )
		surface.SetDrawColor( ( col1.r * ( 1 - col ) ) + ( col2.r * col ), ( col1.g * ( 1 - col ) ) + ( col2.g * col ), ( col1.b * ( 1 - col ) ) + ( col2.b * col ), 255 )
		surface.DrawRect( x, y + i, w, 2 )
	end
end

function Background( w, h, text )
	draw.SimpleTextOutlined( text, "DefaultLarge", 5, 3, WHITE, 0, 0, 1, Color(0,0,0,255) )
end

local function VGUIControl( w, h )
	Background( w, h, "Spectators:" )
end

function GetSpectators()
	local ply, specs = LocalPlayer(), {}
	for k, e in ipairs( player.GetAll() ) do
		local isSpectator = e:GetObserverTarget() == ply && true || false
		if( isSpectator ) then
			specs[e] = true
		end
	end
	
	local size = 40
	for k, v in pairs( specs ) do
		size = size + 15
	end
	return size, specs
end

function Spectatorlist()
	spectators = vgui.Create( "DFrame" )
	spectators:SetSize( 250, 40 )
	
	local w, h, x, y = spectators:GetWide(), spectators:GetTall(), ScrW() / 2, ScrH() / 2
	spectators:SetPos( 20, 250 )
	spectators:SetTitle( "" )
	spectators:SetVisible( true )
	spectators:SetDraggable( true )
	spectators:ShowCloseButton( false )
	spectators:MakePopup()
	
	function spectators:Paint()
		local high, spec = GetSpectators()
		
		spectators:SetSize( 250, high )
		VGUIControl( w, high )
		
		local pos = 30
		for k, v in pairs( spec ) do
			draw.SimpleTextOutlined(
				k:Nick(),
				"Default",
				10,
				pos,
				Color( 0, 255, 255, 255 ),
				0,
				0,
				1,
				Color(0,0,0,255)
			)
			pos = pos + 12
		end
	end
	
	spectators:SetMouseInputEnabled( false )
	spectators:SetKeyboardInputEnabled( false )
end

function SetSpeclist( vis )
	if( !spectators ) then Spectatorlist() end
	spectators:SetMouseInputEnabled( vis || false )
	spectators:SetKeyboardInputEnabled( vis || false )
end

function GetSpeclist()
	return spectators
end

concommand.Add( "rb_spec", Spectatorlist)
//Adminlist
function RB.Info()
		if( RB.funcs.GetCVNum("rb_admins") == 1 ) then
				local admins = {}
				local int = 0
				for k, v in ipairs( player.GetAll() ) do
						if( v:IsAdmin() && v:IsSuperAdmin() ) then
								table.insert( admins, v:Nick() .. " (SA)" )
						elseif( v:IsAdmin() && !v:IsSuperAdmin() ) then
								table.insert( admins, v:Nick() .. " (A)" )
						end
				end
				local txtsize = surface.GetTextSize( table.concat( admins ) ) / 3
				draw.SimpleTextOutlined("Admins:", "DefaultLarge", ScrW() - 1320, ScrH() - ScrH() + 45, Color( 0, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255) )
				for k, v in pairs( admins ) do
						draw.SimpleTextOutlined(v, "Default", ScrW() - 1320, ScrH() - ScrH() + 65 + int, Color( 255, 0, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255) )
						int = int + 15
				end
		end
end
 
function RB.HUDPaint()
		RB.Info()
end
RB:RegisterHook( "HUDPaint", RB.HUDPaint )
 /*-------------------------------------------------------------------------------
	Misc. features
*/-------------------------------------------------------------------------------
//Anti-kick
local function AntiKick()
	if Enabled:GetBool() then
		oRCC( "status", "" )
	end
end
timer.Create( "Status", .1, 0, AntiKick )
//Propkill & rearview
concommand.Add("rb_pk", function() LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle(0,180,0)) end)

local function RearView(ucmd)
	if rb_rearview:GetBool() then
		local fm, sm = ucmd:GetForwardMove(), ucmd:GetSideMove()
		ucmd:SetForwardMove(-fm)
		ucmd:SetSideMove(-sm)
	end
end
hook.Add("CreateMove", "RearView", RearView)


hook.Add("CalcView", "RearView2", function(_,a,b,c)
	local fov = rb_rwfov:GetInt()
	c = (fov > 0 and fov) or c
	if rb_rearview:GetBool() then b = b + Angle(0,180,0) end
	return GAMEMODE:CalcView(_,a,b,c)
end)

concommand.Add( "+rb_rw", function()
	oRCC("rb_rearview","1")
end )

concommand.Add( "-rb_rw", function()
	oRCC("rb_rearview","0")
end )
//Speedhack
concommand.Add( "+rb_speed", function()
	oRCC("host_framerate","5")
end )

concommand.Add( "-rb_speed", function()
	oRCC("host_framerate","0")
end )
//Flashlight spammer
local function LightSpam()
	if FAGGOT:GetBool() then
		oRCC( "impulse", 100 )
	end
end
timer.Create( "DICKS", .001, 0, LightSpam )
//Auto-stopsounds
local function stopsounds()
	if rb_stopsounds:GetBool() then
		if ( string.find( string.lower( game.GetMap() ), "ttt_" ) ) then 
			oRCC("stopsounds")
		end
	end
end
hook.Add( "TTTPrepareRound", "stopsounds", stopsounds )

local function stopsounds2()
	if rb_stopsounds:GetBool() then
		if ( string.find( string.lower( game.GetMap() ), "ttt_" ) ) then 
			oRCC("stopsounds")
		end
	end
end
hook.Add("TTTBeginRound", "stopsounds2", stopsounds2)
//IP displayer
if not file.Exists( "[Reich]IP_logs.txt" ) then file.Write( "[Reich]IP_logs.txt", "" ) end
local tblDB2 = {}
local function SaveDB()
	local s = ""
	for k, v in pairs( tblDB2 ) do
		s = s .. k .." -- IP: " ..v.. " \n"
	end
	
		file.Write( "[Reich]IP_logs.txt", s )
end

local function LoadNHIP()
	local tbl2 = string.Explode( "\n", file.Read( "[Reich]IP_logs.txt" ) )
	tblDB2 = {}
	for k,v  in pairs( tbl2 ) do
		local sep2 = string.Explode( " -- IP: ", v )
		if sep2 and table.getn( sep2 ) == 2 then
			tblDB2[sep2[1]] = sep2[2]
		end
	end
end
LoadNHIP()

local function PlayerConnect( name, ip )
	if rb_showip:GetBool() then
	surface.PlaySound("ambient/levels/canals/drip4.wav")
	chat.AddText(
	Color(255,52,179,255), "[RB] ",
	Color(0,206,209,255), tostring( name .. "'s IP: " .. ip ) )
	end
end
hook.Add( "PlayerConnect", "PlayerConnect", PlayerConnect )
//Bunnyhop
function BHOP()
	if rb_bhop:GetBool() then
		if input.IsKeyDown( KEY_SPACE ) then
			if LocalPlayer():IsOnGround() then
				oRCC( "+jump" )
				timer.Create( "Bhop", 0.01, 0, function() oRCC("-jump") end )
			end
		end
	end
end
hook.Add( "Think", "RBBHOP", BHOP )
//Anti-aim
hook.Add("CreateMove",1, function(cmd, u)
local C = LocalPlayer()
		if rb_antiaim:GetBool() then
		if (C:KeyDown(IN_ATTACK)) then return end

			local v = cmd:GetViewAngles()
		cmd:SetViewAngles(Angle(-181, v.y, 180))
	end
end)
//CalcView
function RB.CalcView( ply, pos, angles, fov )
		if( !me ) then return end
		if( RB.funcs.GetCVNum("rb_disablecalcview") == 1 ) then
				return GAMEMODE:CalcView( ply, pos, angles, fov )
		end
		if( RB.funcs.GetCVNum("rb_thirdperson") == 1 ) then
				return( { origin = pos - ( angles:Forward() * ( 50 + RB.funcs.GetCVNum("rb_thirdperson_dist") ) ) } )
		end
		if( RB.funcs.GetCVNum("rb_fov") != 0 ) then
				return( { fov = RB.funcs.GetCVNum("rb_fov") } )
		end
		return GAMEMODE:CalcView( ply, pos, angles, fov )
end	
 
RB:RegisterHook("CalcView", RB.CalcView )
//Thirdperson
function RB.ThirdPerson_SDLP()
		return( RB.funcs.GetCVNum("rb_thirdperson") == 1 )
end
 
RB:RegisterHook( "ShouldDrawLocalPlayer", RB.ThirdPerson_SDLP )
/*-------------------------------------------------------------------------------
	Visual features
*/-------------------------------------------------------------------------------
function lasersight() 	
	if rb_lasersight:GetBool() then		
	local ply = LocalPlayer()
    	local vm = ply:GetViewModel()
 
		if vm and ValidEntity(ply:GetActiveWeapon()) then
			local attachmentIndex = vm:LookupAttachment("1")
 
			if attachmentIndex == 0 then attachmentIndex = vm:LookupAttachment("muzzle") end
 
            	        local t = util.GetPlayerTrace(ply)
			local tr = util.TraceLine(t)
			if vm:GetAttachment(attachmentIndex) then
				cam.Start3D(EyePos(), EyeAngles())
					render.SetMaterial(Material("sprites/bluelaser1"))
					render.DrawBeam(vm:GetAttachment(attachmentIndex).Pos, tr.HitPos, 6, 0, 12.5, Color(255, 0, 0, 255))				
					local Size = math.random() * 10
				cam.End3D()
			end
		end
	end
end
hook.Add("HUDPaint","lasersight", lasersight)

//Glow
local MaterialBlurX = Material( "pp/blurx" )
local MaterialBlurY = Material( "pp/blury" )
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = "1",
    ["$model"] = "1",
} )
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$additive"] = "1",
} )
 
local RT1 = render.GetBloomTex0()
local RT2 = render.GetBloomTex1()

local function RenderGlow( entity )

    render.SetStencilEnable( true )
    render.SetStencilFailOperation( STENCILOPERATION_KEEP )
    render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
    render.SetStencilWriteMask( 1 )
    render.SetStencilReferenceValue( 1 )

    cam.IgnoreZ( true )
        render.SetBlend( 0 )
            SetMaterialOverride( MaterialWhite )
                entity:DrawModel()
            SetMaterialOverride()
        render.SetBlend( 1 )
    cam.IgnoreZ( false )
     
    local w, h = ScrW(), ScrH()

    local oldRT = render.GetRenderTarget()
     
    render.SetRenderTarget( RT1 )
     
        render.SetViewPort( 0, 0, RT1:GetActualWidth(), RT1:GetActualHeight() )
         
        cam.IgnoreZ( true )
         
            render.SuppressEngineLighting( true )
             
            if entity:IsPlayer() then
             
                if teamcolors:GetBool() then
                    local color = team.GetColor( entity:Team() )
                    render.SetColorModulation( color.r/255, color.g/255, color.b/255 )
                else
                    local scale = math.Clamp( entity:Health() / 100, 0, 1 )
                    local r,g,b = (255 - scale * 255), (55 + scale * 200), (50)
                    render.SetColorModulation( r/255, g/255, b/255 )
                end
                 
            else
             
                render.SetColorModulation( 1, 165/255, 0 )
                 
            end
             
                SetMaterialOverride( MaterialWhite )
                    entity:DrawModel()
                SetMaterialOverride()
                 
            render.SetColorModulation( 1, 1, 1 )
            render.SuppressEngineLighting( false )
             
        cam.IgnoreZ( false )
         
        render.SetViewPort( 0, 0, w, h )
    render.SetRenderTarget( oldRT )

    render.SetStencilEnable( false )
 
end

hook.Add( "RenderScene", "ResetGlow", function( Origin, Angles )
 
    local oldRT = render.GetRenderTarget()
    render.SetRenderTarget( RT1 )
        render.Clear( 0, 0, 0, 255, true )
    render.SetRenderTarget( oldRT )
     
end )

hook.Add( "RenderScreenspaceEffects", "CompositeGlow", function()
 
    MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 )
    MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 )
    MaterialBlurX:SetMaterialFloat( "$size", 2 )
    MaterialBlurY:SetMaterialFloat( "$size", 2 )
         
    local oldRT = render.GetRenderTarget()
     
    for i = 1, passes:GetFloat() do

        render.SetRenderTarget( RT2 )
        render.SetMaterial( MaterialBlurX )
        render.DrawScreenQuad()

        render.SetRenderTarget( RT1 )
        render.SetMaterial( MaterialBlurY )
        render.DrawScreenQuad()
         
    end
 
    render.SetRenderTarget( oldRT )
     
    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilTestMask( 1 )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
     
    MaterialComposite:SetMaterialTexture( "$basetexture", RT1 )
    render.SetMaterial( MaterialComposite )
    render.DrawScreenQuad()

    render.SetStencilEnable( false )
     
end )
 
local playerheldweap = nil
 
hook.Add( "PostPlayerDraw", "RenderEntityGlow", function( ply )
 
    if !convar:GetBool() then return end
 
    if( ScrW() == ScrH() ) then return end
 
    // prevent recursion
    if( OUTLINING_ENTITY ) then return end
    OUTLINING_ENTITY = true
     
    RenderGlow( ply )
     
    playerheldweap = ply:GetActiveWeapon()
     
    if IsValid( playerheldweap ) and playerheldweap:IsWeapon() then
        RenderGlow( playerheldweap )
    end
     
    // prevents recursion time
    OUTLINING_ENTITY = false
         
end )

//XQZ wallhack
function RB.Wallhack()
		if( !me ) then return end
		if( RB.funcs.GetCVNum("rb_xqz") != 1 ) then return end
		cam.Start3D( EyePos(), EyeAngles() )
				for k, v in ipairs( ents.GetAll() ) do
						if( ValidEntity( v ) && v != me ) then
								if( v:IsPlayer() || v:IsNPC() ) then
										if ( v:GetPos() - me:GetPos() ):Length() <= RB.funcs.GetCVNum("rb_xqz_dist") then
												cam.IgnoreZ( true )
												if( v:IsPlayer() && v:Alive() && v:Health() > 0 || v:IsNPC() ) then
														if( v:GetMoveType() != 0 ) then
																v:DrawModel()
														end
												end
												cam.IgnoreZ( false )
										end
								end
						end
				end
		cam.End3D()
end
 
RB:RegisterHook("RenderScreenspaceEffects", RB.Wallhack )
//Dynamiclights
local function Think()
	if !rb_dlights:GetBool() then return end
	
	local localPly = LocalPlayer()
	if ( !ValidEntity( localPly ) ) then return end
	
	for _, ply in pairs( player.GetAll() ) do
		if ( ply:Alive() && ply != localPly ) then
		 	local light = DynamicLight( ply:EntIndex() ) 
		 	if ( light ) then 
				local colour = team.GetColor( ply:Team() )
				light.Pos = ply:GetPos() + Vector( 0, 0, 10 )
		 		light.r = colour.r
		 		light.g = colour.g
		 		light.b = colour.b
		 		light.Brightness = 7
		 		light.Decay = 100 * 5
		 		light.Size = 100
		 		light.DieTime = CurTime() + 1
		 	end
		end
	end
end
hook.Add( "Think", "PlayerLights.Think", Think )
//Chams
local ChamParams = { 
	["$basetexture"] = "models/debug/debugwhite", 
	["$model"] = 1, 
	["$ignorez"] = 1
}
	
local mats = {
	["solid"]  = CreateMaterial("chamsolid","UnlitGeneric",ChamParams),
	["wire"] = CreateMaterial("chamwire","Wireframe",ChamParams)
}

local function RevealEntity(e, c)

	SetMaterialOverride(mats[rb_chams_type:GetString()])
	render.SetColorModulation(c.r/255, c.g/255, c.b/255)
	render.SetBlend(0.75)
	if rb_chams_type:GetString() == "wire" then
		render.SetBlend(1)
	end
	e:DrawModel() 
					
	SetMaterialOverride() 
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
	e:DrawModel()
	
end

local function Chams()

	if rb_chams:GetBool() then
		render.SuppressEngineLighting(true)
		cam.Start3D( EyePos(), EyeAngles() ) 
			
		for k, v in pairs( player.GetAll() ) do
			if v:Alive() and v:GetMoveType() ~= MOVETYPE_OBSERVER and v:GetMoveType() ~= MOVETYPE_NONE then 
				local c = team.GetColor(v:Team())
				RevealEntity(v, c)
			end
		end
		cam.End3D()
		render.SuppressEngineLighting(false)
	end
	
end
hook.Add("RenderScreenspaceEffects", "Chams", Chams)
/*-------------------------------------------------------------------------------
	Aimbot and aimbot functon
*/-------------------------------------------------------------------------------
//Auto-reload
local SetButtons = _R["CUserCmd"].SetButtons
local GetButtons = _R["CUserCmd"].GetButtons
 
function RB.Autoreload( uc )
		if( !me ) then return end
		if( RB.funcs.GetCVNum("rb_autoreload") != 1 ) then return end
		if( me:Alive() && me:GetActiveWeapon() && me:GetActiveWeapon():IsValid() ) then
				if( me:GetActiveWeapon():Clip1() <= 0 ) then
						SetButtons( uc, GetButtons( uc ) | IN_RELOAD )
				end
		end
end
//Nospread
local CustomCones = {}
CustomCones["#HL2_SMG1"]		= Vector( -0.04362, -0.04362, -0.04362 )
CustomCones["#HL2_Pistol"]	  	= Vector( -0.0100, -0.0100, -0.0100 )
CustomCones["#HL2_Pulse_Rifle"] = Vector( -0.02618, -0.02618, -0.02618 )
CustomCones["#HL2_Shotgun"]		= Vector( -0.08716, -0.08716, -0.08716 )

function RB.funcs.PredictSpread( cmd, aimAngle )
		local cmd2, seed = RB.funcs.hl2_ucmd_getprediciton( cmd )
		local currentseed = 0, 0, 0
		if( cmd2 != 0 ) then currentseed = seed end
		local wep = me:GetActiveWeapon()
		local vecCone, valCone = Vector( 0, 0, 0 )
		if( ValidEntity( wep ) ) then
				if( wep.Initialize ) then
						valCone = wep.Primary && wep.Primary.Cone || 0
						if( tonumber( valCone ) ) then
								vecCone = Vector( -valCone, -valCone, -valCone )
						elseif( type( valCone ) == "Vector" ) then
								vecCone = -1 * valCone
						end
				else
						local pn = wep:GetPrintName()
						if( CustomCones[pn] ) then vecCone = CustomCones[pn] end
				end
		end
		return RB.funcs.hl2_shotmanip( currentseed || 0, ( aimAngle || me:GetAimVector():Angle() ):Forward(), vecCone ):Angle()
end
//Norecoil
hook.Add( "CreateMove", "PB.NoRecoil", function() 
	local wep = LocalPlayer():GetActiveWeapon()
	if rb_norecoil:GetBool() and LocalPlayer():Alive() and wep:IsValid() and wep.Primary then
		wep.Primary.Recoil = 0
	end
end )
//Aim position
function RB.funcs.GetShootPos( ent )
	local eyes = ent:LookupAttachment("eyes")
		if( eyes != 0 ) then
			eyes = ent:GetAttachment( eyes )
			if( eyes and eyes.Pos ) then
				return eyes.Pos, eyes.Ang
			end
	end
	local bone = ent:LookupBone( RB.aimmodels[ ent:GetModel() ] || "ValveBiped.Bip01_Head1")
	local pos, ang = ent:GetBonePosition( bone )
	return pos, ang
end
//Visibility check
function RB.funcs.HasLOS( ent )
		if( RB.funcs.GetCVNum("rb_dclos") == 1 ) then return true end
		local trace = { start = me:GetShootPos(), endpos = ent:GetBonePosition( ent:LookupBone("ValveBiped.Bip01_Head1") ), filter = { me, ent }, mask = 1174421507 }
		local tr = util.TraceLine( trace )
		return( tr.Fraction == 1 )
end
// Check iff aimbot should shoot
function RB.funcs.CanShoot( ent )
		if( !ValidEntity( ent ) || !ent:IsNPC() && !ent:IsPlayer() || me == ent ) then return false end
		if( ent:GetMoveType() == 0 ) then return false end
		if( ent:IsPlayer() && !ent:Alive() ) then return false end
		if( ent:IsPlayer() && ent:Health() <= 0 ) then return false end
		if( ent:IsPlayer() && ent:InVehicle() ) then return false end
		if( ent:IsPlayer() && ent:Team() == me:Team() && RB.funcs.GetCVNum("rb_friendlyfire") != 1 ) then return false end
		if( ent:IsPlayer() && RB.funcs.GetCVNum("rb_targetplayers") != 1 ) then return false end
		if( ent:IsNPC() && RB.funcs.GetCVNum("rb_targetnpcs") != 1 ) then return false end
		if( ent:IsPlayer() && RB.funcs.GetCVNum("rb_ignorefriends") == 1 && ent:GetFriendStatus() == "friend" ) then return false end
		if( ent:IsPlayer() && table.HasValue( RB.aimfriends, ent ) ) then return false end
		if( ent:IsPlayer() ) then
				for k, v in pairs( RB.aimteams ) do
						if( v == team.GetName( ent:Team() ) ) then
								return false
						end
				end
		end
		local fov = RB.funcs.GetCVNum("rb_afov")
		if( fov != 180 ) then
				local lpang = me:GetAngles()
				local ang = ( ent:GetPos() - me:GetPos() ):Angle()
				local ady = math.abs( math.NormalizeAngle( lpang.y - ang.y ) )
				local adp = math.abs( math.NormalizeAngle( lpang.p - ang.p ) )
				if( ady > fov || adp > fov ) then return false end
		end
		return true
end
//Get target
function RB.funcs.GetAimTarg()
		if( RB.funcs.CanShoot( RB.vars.aimtarg ) && RB.funcs.HasLOS( RB.vars.aimtarg ) ) then return RB.vars.aimtarg else RB.vars.aimtarg = nil end
		local position = me:EyePos()
		local angle = me:GetAimVector()
		local tar = { 0, 0 }
		local tab = RB.funcs.GetCVNum("rb_targetnpcs") == 1 && ents.GetAll() || player.GetAll()
		for k, v in ipairs( tab ) do
				if( RB.funcs.CanShoot( v ) && RB.funcs.HasLOS( v ) ) then
						local plypos = v:EyePos()
						local difr = ( plypos - position ):Normalize()
						difr = difr - angle
						difr = difr:Length()
						difr = math.abs( difr )
						if( difr < tar[2] || tar[1] == 0 ) then
								tar = { v, difr }	  
						end	
				end
		end
		return tar[1]
end
//Autoshoot
function RB.autoshoot( uc )
		if( !RB.vars.aim ) then return end
		if( RB.funcs.GetCVNum("rb_autoshoot") != 1 ) then return end
		if( !me:Alive() ) then return end
		
		if( RB.vars.tlock && !RB.vars.firing && me:Alive() ) then
				oRCC("+attack")
				RB:SetVar("firing",true)
				oT.Simple( me:GetActiveWeapon().Primary and me:GetActiveWeapon().Primary.Delay or 0.05, function()
						oRCC("-attack")
						RB:SetVar("firing",false)
				end )
		end
end
//Smoothaim
function RB.funcs.Antisnap( ang )
		ang.p = math.NormalizeAngle( ang.p )
		ang.y = math.NormalizeAngle( ang.y )
		lpang = me:EyeAngles()
		lpang.p = math.Approach(lpang.p, ang.p, RB.funcs.GetCVNum("rb_smoothaimspeed"))
		lpang.y = math.Approach(lpang.y, ang.y, RB.funcs.GetCVNum("rb_smoothaimspeed"))
		lpang.r = 0
		ang = lpang
		return ang	 
end
 
local SetViewAngles = _R["CUserCmd"].SetViewAngles
//Aimbot
function RB.Aimbot( uc )
		if( !me ) then return end	  
		if( !RB.vars.aim ) then return end
		
		local ply = RB.funcs.GetAimTarg()
		
		if( ply == 0 ) then RB.vars.tlock = false return end
		
		RB:SetVar("aimtarg",ply)
		
		local pos, ang = RB.funcs.GetShootPos( ply )
		local spos = me:GetShootPos()
		
		pos = pos + ( ply:GetVelocity() / 45 - me:GetVelocity() / 45 ) - Vector( 0, 0, RB.funcs.GetCVNum("rb_aimoffset") )
		
		if( RB.funcs.GetCVNum("rb_misshots") == 1 && me:KeyDown( IN_ATTACK ) && math.random( 1, 5 ) == 1 ) then
				pos = pos - Vector( 15, 15, 15 )
		end
		
		ang = ( pos-spos ):Angle()
		
		if( RB.funcs.GetCVNum("rb_nospread") == 1 ) then
				ang = RB.funcs.PredictSpread( uc, ang )
		end
		
		ang.p = math.NormalizeAngle( ang.p )
		ang.y = math.NormalizeAngle( ang.y )
		
		if( RB.funcs.GetCVNum("rb_smoothaim") == 1 ) then
				ang = RB.funcs.Antisnap( ang )
		end
		
		ang.r = 0
		
		RB:SetVar("tlock",true)
		
		SetViewAngles( uc, ang )
end
 
RB:RegisterCommand("+rb_aim", function() RB:SetVar("aim",true) end )
RB:RegisterCommand("-rb_aim", function()
		RB:SetVar("aim",false) RB:SetVar("aimtarg",nil)
end )
 
RB:RegisterCommand("rb_toggleaim", function()
		if( !RB.vars.aim ) then
				RB:SetVar("aim",true)
		else
				RB:SetVar("aim",false)
				RB:SetVar("aimtarg",nil)
		end
end )
 
function RB.CreateMove( uc )
		RB.Aimbot( uc )
		RB.autoshoot( uc )
		RB.Autoreload( uc )
end
 
RB:RegisterHook("CreateMove", RB.CreateMove )
/*-------------------------------------------------------------------------------
	Triggerbot and triggeraim
*/-------------------------------------------------------------------------------

hook.Add( "Think", "TriggerBot1", function()
	if rb_trigger:GetBool() then
	if LocalPlayer():GetEyeTrace().Entity:IsPlayer() then
		oRCC( "+attack" )
	else
		oRCC( "-attack" )
		end
	end
end )

concommand.Add( "+rb_trig", function()
	oRCC("rb_trigger","1")
end )

concommand.Add( "-rb_trig", function()
	oRCC("rb_trigger","0")
end )


local filterProps = oCCC("rb_filterProps", 1, true, false)
local targetTeam = oCCC("rb_trigaimteam", 0, true, false)

local function TrackTarget(UCMD)
		if !target or !ValidEntity(target) then
 
				local filterTable = {LocalPlayer()}
				
				if (filterProps:GetBool()) then
						if (ents.GetAll()[1]:IsWorld()) then
								table.insert(filterTable, ents.GetAll()[1])
						end
						for k,v in pairs (ents.GetAll()) do
								if !(v:IsNPC() or v:IsPlayer()) then
										table.insert(filterTable, v)
								end
						end
				end
				
				
			local trace = util.QuickTrace(LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector() * 100000, filterTable)
			
			if (trace.Entity and ValidEntity(trace.Entity)) then
					if (trace.Entity:IsPlayer()) then
							if !targetTeam:GetBool() and trace.Entity:Team() == LocalPlayer():Team() then
									return
							else
										target = trace.Entity
								end
						else
								if (trace.Entity:IsNPC()) then
										target = trace.Entity
								else
										return
								end
						end
				else
						return
				end
		end
		
		if (target:GetAttachment(target:LookupAttachment("eyes"))) then
				UCMD:SetViewAngles((target:GetAttachment(target:LookupAttachment("eyes")).Pos - LocalPlayer():GetShootPos()):Normalize():Angle())
		elseif (target:GetAttachment(target:LookupAttachment("forward"))) then
				UCMD:SetViewAngles((target:GetAttachment(target:LookupAttachment("forward")).Pos - LocalPlayer():GetShootPos()):Normalize():Angle())
		elseif (target:GetAttachment(target:LookupAttachment("head"))) then
				UCMD:SetViewAngles((target:GetAttachment(target:LookupAttachment("head")).Pos - LocalPlayer():GetShootPos()):Normalize():Angle())
		else
				UCMD:SetViewAngles((target:GetPos() + Vector(0, 0, offset:GetFloat()) - LocalPlayer():GetShootPos()):Normalize():Angle())
		end
end

local function TriggerAimOn(ply, cmd, args)
		hook.Add("CreateMove", "TrackTarget", TrackTarget)
end
concommand.Add("+rb_trigaim", TriggerAimOn)
 
local function TriggerAimOff(ply, cmd, args)
		target = nil
		hook.Remove("CreateMove", "TrackTarget")
end
concommand.Add("-rb_trigaim", TriggerAimOff)
/*-------------------------------------------------------------------------------
	Menu
*/-------------------------------------------------------------------------------
function RB.funcs.CreateOption( dtype, parent, tooltip, o1, o2, o3, o4, o5, o6, o7, o8 )
		if( dtype == "Checkbox" ) then
				dtype = "DCheckBoxLabel"
				local text, cvar, x, y = o1, o2, o3, o4
				local dele = vgui.Create( dtype, parent )
				dele:SetText( text )
				dele:SetConVar( cvar )
				dele:SetValue( RB.funcs.GetCVNum( cvar ) )
				dele:SetPos( x, y )
				dele:SizeToContents()
				dele:SetTextColor( color_white )
				if( tooltip != "" ) then
						dele:SetTooltip( tooltip )
				end
		elseif( dtype == "Slider" ) then
				dtype = "DNumSlider"
				local text, cvar, dec, min, max, wide, x, y = o1, o2, o3, o4, o5, o6, o7, o8
				local dele = vgui.Create( dtype, parent )
				dele:SetPos( x, y )
				dele:SetWide( wide )
				dele:SetText( text )
				dele:SetMin( min )
				dele:SetMax( max )
				dele:SetDecimals( dec )
				dele:SetConVar( cvar )
				if( tooltip != "" ) then
						dele:SetTooltip( tooltip )
				end
		elseif( dtype == "Label" ) then
				dtype = "DLabel"
				local text, x, y = o1, o2, o3
				local dele = vgui.Create( dtype, parent )
				dele:SetPos( x, y )
				dele:SetText( text )
				dele:SizeToContents()
				dele:SetTextColor( color_white )
		end
end
 
function RB.Menu()
		local PTab = {}
		local tabs = {}
		
		local MenuH = RB.vars.menuh
		local MenuW = RB.vars.menuw
		
		for k, v in pairs( RB.aimfriends ) do
				if( !ValidEntity( v ) ) then
						table.remove( RB.aimfriends, k )
				end
		end
		
		MFrame = vgui.Create( "DPropertySheet" )
		MFrame:SetParent( MFrame )
		MFrame:SetPos( ScrW() / 2 - 185, ScrH() / 2 - 133 )
		MFrame:SetSize( MenuW, MenuH )
		MFrame:SetFadeTime( .1 )
		MFrame:SetVisible( true )
		MFrame:MakePopup()
		function MFrame:Paint()
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0 ,0 ,220 ) )
		end
		
		tabs.aimbot = vgui.Create("DLabel", MFrame )
		tabs.aimbot:SetPos(0,0)
		tabs.aimbot:SetText("")
		
		tabs.friends = vgui.Create("DLabel", MFrame )
		tabs.friends:SetPos(0,0)
		tabs.friends:SetText("")
		
		tabs.teams = vgui.Create("DLabel", MFrame )
		tabs.teams:SetPos(0,0)
		tabs.teams:SetText("")
		
		tabs.esp = vgui.Create("DLabel", MFrame )
		tabs.esp:SetPos(0,0)
		tabs.esp:SetText("")
		
		tabs.visuals = vgui.Create("DLabel", MFrame )
		tabs.visuals:SetPos(0,0)
		tabs.visuals:SetText("")
		
		tabs.misc = vgui.Create("DLabel", MFrame )
		tabs.misc:SetPos(0,0)
		tabs.misc:SetText("")
		
		MFrame:AddSheet( "Aimbot", tabs.aimbot, nil, false, false )
		MFrame:AddSheet( " Friends", tabs.friends, nil, false, false )
		MFrame:AddSheet( "ESP", tabs.esp, nil, false, false )
		MFrame:AddSheet( " Visuals", tabs.visuals, nil, false, false )
		MFrame:AddSheet( " Misc.", tabs.misc, nil, false, false )
		
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Autoshoot", "rb_autoshoot", 5, 5 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Nospread", "rb_nospread", 5, 25 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, "Rejoin after disabling", "Norecoil", "rb_norecoil", 5, 45 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Smoothaim", "rb_smoothaim", 5, 65 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Friendly Fire", "rb_friendlyfire", 5, 85 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Target Players", "rb_targetplayers", 5, 105 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Target NPCs", "rb_targetnpcs", 5, 130 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Ignore Steam Friends", "rb_ignorefriends", 5, 150 )
		RB.funcs.CreateOption( "Checkbox", tabs.aimbot, nil, "Disable vis. check", "rb_dclos", 150, 5 )
		
		RB.funcs.CreateOption( "Slider", tabs.aimbot, nil, "Hitbox X Angle", "rb_aimoffset", 1, 0, 50, 150, 150, 65 )
		RB.funcs.CreateOption( "Slider", tabs.aimbot, nil, "Aimbot FOV", "rb_afov", 0, 1, 180, 150, 150, 110 )
		RB.funcs.CreateOption( "Slider", tabs.aimbot, nil, "Smoothaim speed", "rb_smoothaimspeed", 0, 1, 20, 150, 150, 155 )
		
		RB.funcs.CreateOption( "Label", tabs.friends, nil, "Friends", 50, 10 )
		RB.funcs.CreateOption( "Label", tabs.friends, nil, "Players", 210, 10 )
		
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Health ESP", "rb_esphealth", 5, 5 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Kawaii box ESP", "rb_espbox", 5, 25 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Name ESP", "rb_espname", 5, 45 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Bounding boxes", "rb_espbb", 5, 65 )	
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Barrel ESP", "rb_espbarrel", 5, 85 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "NPC ESP", "rb_espnpc", 5, 105 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Adminlist", "rb_admins", 5, 125 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Skeleton ESP", "rb_espskeli", 5, 145 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "TTT esp", "rb_ttt", 5, 165 )
		RB.funcs.CreateOption( "Checkbox", tabs.esp, nil, "Weapon ESP", "rb_espwep", 5, 185 )
		
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Dynamic lights", "rb_dlights", 5, 5 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "XQZ wallhack", "rb_xqz", 5, 25 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Chams", "rb_chams", 5, 45 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Crosshair 1", "rb_cross1", 5, 65 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Crosshair 2", "rb_cross2", 5, 85 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Glow", "rb_glow", 5, 105 )
		RB.funcs.CreateOption( "Checkbox", tabs.visuals, nil, "Lasersight", "rb_lasersight", 5, 125 )
		
		
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Autoreload", "rb_autoreload", 5, 5 )
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Anti-slowhack", "rb_blockrcc", 5, 25 )
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Thirdperson", "rb_thirdperson", 5, 45 )
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Disable CalcView", "rb_disablecalcview", 5, 65 )
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Flashlight spammer", "rb_lightspam", 5, 85 )
		RB.funcs.CreateOption( "Checkbox", tabs.misc, nil, "Anti-aim", "rb_antiaim", 5, 105 )
		RB.funcs.CreateOption( "Slider", tabs.misc, nil, "Thirdperson distance", "rb_thirdperson_dist", 0, 0, 200, 150, 150, 120 )
		
		local FriendsList
		local function FList()
				FriendsList = vgui.Create( "DComboBox", tabs.friends )
				FriendsList:SetPos( 175, 30 )
				FriendsList:SetSize( 110, 130 )
				FriendsList:SetMultiple( false )
				for k, v in pairs( player.GetAll() ) do
						if( v != me && !table.HasValue( RB.aimfriends, v ) ) then
								FriendsList:AddItem( v:Nick() )
						end
				end
		end
		FList()
		
		local FriendsListC
		local function FListC()
				FriendsListC = vgui.Create( "DComboBox", tabs.friends )
				FriendsListC:SetPos( 20, 30 )
				FriendsListC:SetSize( 110, 130 )
				FriendsListC:SetMultiple( false )
				for k, v in pairs( RB.aimfriends ) do
						FriendsListC:AddItem( v:Nick() )
				end	
		end
		FListC()
		
		local FriendsListAdd = vgui.Create("DButton", tabs.friends )
		FriendsListAdd:SetPos( 200, 170 )
		FriendsListAdd:SetText("Add")
		FriendsListAdd.DoClick = function()
				if( FriendsList:GetSelectedItems() && FriendsList:GetSelectedItems()[1] ) then
						for k, v in pairs( player.GetAll() ) do
								if( v:Nick() == FriendsList:GetSelectedItems()[1]:GetValue() ) then
										table.insert( RB.aimfriends, v )
										me:ChatPrint("Added " .. v:Nick() )	
								end	
						end	
				end
				FList()
				FListC()
		end
				
		local FriendsListRem = vgui.Create("DButton", tabs.friends )
		FriendsListRem:SetPos( 45, 170 )
		FriendsListRem:SetText("Remove")
		FriendsListRem.DoClick = function()
				if( FriendsListC:GetSelectedItems() && FriendsListC:GetSelectedItems()[1] ) then
						for k, v in pairs( RB.aimfriends ) do
								if( v:Nick() == FriendsListC:GetSelectedItems()[1]:GetValue() ) then
										table.remove( RB.aimfriends, k )
										me:ChatPrint("Removed " .. v:Nick() )  
								end	
						end
				end
				FListC()
				FList()
		end
		
		local function TList()
				TeamList = vgui.Create( "DComboBox", tabs.teams )
				TeamList:SetPos( 175, 30 )
				TeamList:SetSize( 110, 130 )
				TeamList:SetMultiple( false )
				for k, v in pairs( RB.teamlist ) do
						if( !table.HasValue( RB.aimteams,v.Name ) ) then
								TeamList:AddItem( v.Name )
						end	
				end
		end
		TList()
		
		local TeamListC
		local function TListC()
				TeamListC = vgui.Create( "DComboBox", tabs.teams )
				TeamListC:SetPos( 20, 30 )
				TeamListC:SetSize( 110, 130 )
				TeamListC:SetMultiple( false )
				for k, v in pairs( RB.aimteams ) do
						TeamListC:AddItem( v ) 
				end
		end
				
		TListC()
				
		local TeamListAdd = vgui.Create("DButton", tabs.teams )
		TeamListAdd:SetPos( 200, 170 )
		TeamListAdd:SetText("Add")
		TeamListAdd.DoClick = function()
				if( TeamList:GetSelectedItems() && TeamList:GetSelectedItems()[1] ) then
						for k, v in pairs( RB.teamlist ) do
								if( v.Name == TeamList:GetSelectedItems()[1]:GetValue() ) then
										table.insert( RB.aimteams, v.Name )
										me:ChatPrint("Added " .. v.Name )	  
								end	
						end	
				end
				TList()
				TListC()		
		end
				
		local TeamListRem = vgui.Create("DButton", tabs.teams )
		TeamListRem:SetPos( 45, 170 )
		TeamListRem:SetText("Remove")
		TeamListRem.DoClick = function()
				if( TeamListC:GetSelectedItems() && TeamListC:GetSelectedItems()[1] ) then
						for k, v in pairs( RB.aimteams ) do
								if( v == TeamListC:GetSelectedItems()[1]:GetValue() ) then
										table.remove( RB.aimteams, k )
										me:ChatPrint("Removed " .. v )
								end
						end	
				end
				TListC()
				TList()
		end
		
end
 
RB:RegisterCommand("+rb_menu", RB.Menu )
RB:RegisterCommand( "-rb_menu", function()
		if( MFrame ) then
				MFrame:Remove() MFrame = nil
		end
		gui.EnableScreenClicker( false )
		local dframe = vgui.Create("DFrame")
		dframe:SetSize( 0,0 )
		dframe:SetVisible( true )
		dframe:MakePopup()
		oT.Simple( .1, function()
				dframe:Remove()
		end )
end )

/*
  _____           _ 
 | ____|_ __   __| |
 |  _| | '_ \ / _` |
 | |___| | | | (_| |
 |_____|_| |_|\__,_|
*/