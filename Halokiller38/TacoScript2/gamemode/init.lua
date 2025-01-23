-------------------------------------
-- TacoScript 2
-- November 11, 2008
-- Rick Dark
-- Horsey
-- milk
-- Zaubermuffin
-------------------------------------

DeriveGamemode( "Gear" );
DeriveGamemode( "sandbox" );

GM.Name = "TacoScript 2 - HL2RP";

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "sh_animation_tables.lua" );
AddCSLuaFile( "sh_animations.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_umsg.lua" );
AddCSLuaFile( "cl_chat.lua" );
AddCSLuaFile( "cl_playermenu.lua" );
AddCSLuaFile( "player_shared.lua" );
AddCSLuaFile( "player_variables.lua" );
AddCSLuaFile( "cl_charactermenu.lua" );
AddCSLuaFile( "cl_inventory.lua" );
AddCSLuaFile( "cl_dev.lua" );
AddCSLuaFile( "cl_weaponselect.lua" );
AddCSLuaFile( "entity_shared.lua" );
AddCSLuaFile( "cl_storage.lua" );
AddCSLuaFile( "cl_help.lua" );
AddCSLuaFile( "cl_update.lua" );
AddCSLuaFile( "cl_acccreation.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_itemspawning.lua" );
AddCSLuaFile( "cl_animcmds.lua" );
AddCSLuaFile( "cl_radiomenu.lua" );

include( "shared.lua" );
include( "player_variables.lua" );
include( "player_bools.lua" );
include( "player_util.lua" );
include( "player_chat.lua" );
include( "player_inventory.lua" );
include( "player_connection.lua" );
include( "player_hooks.lua" );
include( "player_update.lua" );
include( "player_shared.lua" );
include( "player_flags.lua" );
include( "player_npcs.lua" );
include( "player_statraising.lua" );
include( "player_itemspawning.lua" );
include( "map_parsing.lua" );
include( "server_hooks.lua" );
include( "server_util.lua" );
include( "chat_commands.lua" );
include( "con_commands.lua" );
include( "engine_concmds.lua" );
include( "sh_animation_tables.lua" );
include( "sh_animations.lua" );
include( "resources.lua" );
include( "action_menu.lua" );
include( "process_bar.lua" );
include( "admin_concmds.lua" );
include( "entity_shared.lua" );
include( "storage.lua" );
include( "mysql_main.lua" );
include( "mysql_data.lua" );
include( "door_ownership.lua" );
include( "combine_sounds.lua" );
include( "dispatch_lines.lua" );

include( "items/item_includes.lua" );
include( "items/item_interaction.lua" );

--include( "gban.lua" );

if( TS2InitializedOnce ) then
	GAMEMODE:InitPostEntity();
end

TS.MakeDirectoryExist( "TS2" );
TS.MakeDirectoryExist( "TS2/mapdata" );
TS.MakeDirectoryExist( "TS2/logs" );

--Some Gear hooks aren't needed.
hook.Remove( "PlayerSay", "GearPlayerSay" );

PostGamemodeLoad();

if( not TS2InitializedOnce ) then

	local fileread = file.Read;
	
	function file.Read( dir )
	
		if( string.find( dir, "gamemodes" ) or
			string.find( dir, "lua" ) ) then
			
			return "";
			
		end
		
		return fileread( dir );
	
	end

end

CreateConVar( "npc_thinknow", 1 );

_G["RunString"] = function() end

function SetPropDescription( ply, arg )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 160;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsProp() and not tr.Entity:IsDoor() ) then

		if( tr.Entity.Creator ~= ply ) then
		
			ply:PrintMessage( 3, "Cannot set description on someone elses prop!" );
			return;
		
		end

		tr.Entity.Desc = arg;
		
		TS.WriteLog( "propdescs", ply:Name() .. "( " .. ply:SteamID() .. " ) set a prop's description to " .. tostring( arg ) );
		
	elseif tr.Entity:IsDoor() then
	
		if tr.Entity.MainOwner == ply then
		
			tr.Entity.DoorDesc = arg;
			
			ply:PrintMessage( 3, "Set door description!" );
			
			TS.WriteLog( "propdescs", ply:Name() .. "( " .. ply:SteamID() .. " ) set a door's description to " .. tostring( arg ) );
		
		else
		
			ply:PrintMessage( 3, "Not door owner!" );
			
		end
		
	end

end
