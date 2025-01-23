function ccAdminUnown( ply, cmd, args )

	if( not ply:IsAdmin() and not ply:IsRick() ) then return; end

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			if( tr.Entity.MainOwner or not tr.Entity.MainOwner:IsValid() ) then
			
				tr.Entity.MainOwner = nil;
				tr.Entity.DoorDesc = nil;
				
				ply:PrintMessage( 2, "Unowned door." );
				
			else
			
				ply:PrintMessage( 2, "No one owns this door." );
				
			end
			
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end

end
concommand.Add( "rpa_unown", ccAdminUnown );

function ccAdminUnlock( ply, cmd, args )

	if( not ply:IsAdmin() and not ply:IsRick() ) then return; end

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			tr.Entity:Fire( "unlock", "", 0 );
			ply:PrintMessage( 2, "Door unlocked." );
			
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end

end
concommand.Add( "rpa_unlock", ccAdminUnlock );

function ccAdminLock( ply, cmd, args )

	if( not ply:IsAdmin() and not ply:IsRick() ) then return; end

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			tr.Entity:Fire( "lock", "", 0 );
			ply:PrintMessage( 2, "Door locked." );
			
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end


end
concommand.Add( "rpa_lock", ccAdminLock );

function ccAdminFindDoorOwner( ply, cmd, args )

	if( not ply:IsAdmin() and not ply:IsRick() ) then return; end

	local trace = { } 
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
	
		if( tr.Entity:IsDoor() ) then
		
			if( not tr.Entity.MainOwner or not tr.Entity.MainOwner:IsValid() ) then
			
				ply:PrintMessage( 2, "No one owns this door." );
				return;
			
			end
			
			ply:PrintMessage( 2, tr.Entity.MainOwner:GetRPName() .. " (" .. tr.Entity.MainOwner:Nick() .. ") owns this door." );
	
		
		else
		
			ply:PrintMessage( 2, "This isn't a door." );
		
		end
	
	end


end
concommand.Add( "rpa_findowner", ccAdminFindDoorOwner );

function ccYouTube( ply, cmd, arg )

	if( not ply:CanUseSuperAdminCommand() ) then return; end
	
	local song = arg[1];
	
	if( not song ) then
		Console( ply, "rpa_youtube <YouTube ID> - Play a YouTube song" );
		return;
	end
	
	for k, v in pairs( player.GetAll() ) do
	
		umsg.Start( "PYT", v );
			umsg.String( song );
		umsg.End();
	
	end
	
	TS.WriteLog( "youtube", ply:GetRPName() .. " (" .. ply:SteamID() .. ")" .. " played " .. song );

end
concommand.Add( "rpa_youtube", ccYouTube );

function ccKillYouTube( ply, cmd, arg )

	if( not ply:CanUseSuperAdminCommand() ) then return; end

	for k, v in pairs( player.GetAll() ) do
	
		umsg.Start( "KYT", v );
		umsg.End();
	
	end
	
	TS.WriteLog( "youtube", ply:GetRPName() .. " (" .. ply:SteamID() .. ")" .. " killed YouTube panel" );

end
concommand.Add( "rpa_killyoutube", ccKillYouTube );

function ccBanID( ply, cmd, arg )

	if( not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] ) then
		Console( ply, "rpa_banid \"<Steam ID>\" <Time> - Ban a Steam ID" );
		return;
	end
	
	if( not arg[2] ) then
		Console( ply, "Must provide time in minutes");
		return;
	end
	
	game.ConsoleCommand( "banid " .. arg[2] .. " " .. arg[1] .. "\n" );

	ply:PrintMessage( 3, "Banned " ..  arg[1] .. " for " .. arg[2] );
	
	TS.WriteLog( "bans", ply:GetRPName() .. "(" .. ply:SteamID() .. ")" .. " banned " .. arg[1] .. " for " .. arg[2] );

end
concommand.Add( "rpa_banid", ccBanID );

function ccUnBanID( ply, cmd, arg )

	if( not ply:IsRick() ) then return; end
	
	if( not arg[1] ) then
		Console( ply, "rpa_unbanid \"<Steam ID>\" - Unban a Steam ID" );
		return;
	end
	
	game.ConsoleCommand( "removeid " .. arg[1] .. "\n" );
	game.ConsoleCommand( "writeid\n" );

	ply:PrintMessage( 3, "Unbanned " ..  arg[1] );
	
	TS.WriteLog( "bans", ply:GetRPName() .. "(" .. ply:SteamID() .. ")" .. " unbanned " .. arg[1] );

end
concommand.Add( "rpa_unbanid", ccUnBanID );

function ccExplode( ply, cmd, arg )

	if( not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] ) then
		Console( ply, "rpa_explode <Name> - Explode a player" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );

	if( succ ) then
	
		local norm = result:GetAngles():Up();
		result:SetVelocity( norm * 500 + result:GetAngles():Forward() * math.random( -40, 40 ) );
	
		result:Kill();
		
		local explode = ents.Create( "env_explosion" );
			explode:SetPos( result:GetPos() );
			explode:Spawn();
			explode:Fire("Explode", "", 0 );
	
		TS.PrintMessageAll( 3, ply:GetRPName() .. " exploded " .. result:GetRPName() );
	
	end
	
end
concommand.Add( "rpa_explode", ccExplode );

function ccCreateNPC( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not arg[1] ) then
		Console( ply, "rpa_createnpc <Class> - Create a TS2 NPC" );
		return;
	end
	
	CreateTS2NPC( ply, arg[1] );
	
end
--concommand.Add( "rpa_createnpc", ccCreateNPC );

function ccSetGlobalProps( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not tonumber( arg[1] ) ) then
		Console( ply, "rpa_setglobalprops <Number> - Sets how many overall props there can be on the server" );
		return;
	end
	
	local limit = tonumber( arg[1] );
	
	TS.GlobalPropLimit = limit;
	
	TS.PrintMessageAll( 3, ply:GetRPName() .. " updated the global prop limit to " .. limit );
	
end
concommand.Add( "rpa_setglobalprops", ccSetGlobalProps );

function ccMutePlayer( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then
		Console( ply, "rpa_mute <Name> - Makes the player unable to speak in ooc until unmuted." );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );

	if( succ ) then
	
		if( result:IsRick() or result:IsSuperAdmin() ) then return; end
	
		if( result.Muted ) then
		
			ply:PrintMessage( 3, "Player is already muted!" );
			return;
		
		end
		
		result.Muted = true;
		
		ply:PrintMessage( 3, "Successfully muted " .. result:GetRPName() .. "!" );
		result:PrintMessage( 3, "You been muted by " .. ply:GetRPName() .. "!" );
	
	end

end
concommand.Add( "rpa_mute", ccMutePlayer );

function ccUnMutePlayer( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then
		Console( ply, "rpa_unmute <Name> - Makes the player able to speak once again if muted." );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );

	if( succ ) then
	
		if( !result.Muted ) then
		
			ply:PrintMessage( 3, "Player isn't muted!" );
			return;
		
		end
		
		result.Muted = false;
		
		ply:PrintMessage( 3, "Successfully unmuted " .. result:GetRPName() .. "!" );
		result:PrintMessage( 3, "You been unmuted by " .. ply:GetRPName() .. ", you are able to speak in OOC once again." );
	
	end

end
concommand.Add( "rpa_unmute", ccUnMutePlayer );

function ccViewLua( ply, cmd, arg )

	if( not arg[1] or not arg[2] ) then
		return;
	end
	
	local reciever = player.GetByID( arg[1] );
	local luafile = arg[2];
	
	if( reciever:IsAdmin() or reciever:IsRick() ) then
	
		reciever:PrintMessage( 2, luafile );
		
	end

end

function ccGetLua( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then
		Console( ply, "rpa_getlua <Name> - Get the lua folders of a player." );
		return;
	end

	local name = arg[1];

	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );

	if( succ ) then
	
		local uniqueid = math.random( 1, 9999 );
		
		concommand.Add( uniqueid, ccViewLua );

		umsg.Start( "VLI", result );
			umsg.Short( uniqueid );
			umsg.Long( ply:EntIndex() );
		umsg.End();
	
	end

end
concommand.Add( "rpa_getlua", ccGetLua );

function ccGetIP( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then
		Console( ply, "rpa_getip <Name> - Get the IP of a player." );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		ply:PrintMessage( 2, result:GetRPName() .. "'s IP Address: " .. result:IPAddress() );
	
	end

end
concommand.Add( "rpa_getip", ccGetIP );

function ccListWeapons( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	for k, v in pairs( weapons.GetList() ) do
	
		if( string.find( v.ClassName, "ts2_" ) ) then
		
			if( v.ClassName != "ts2_kanyewest" or "ts2_stormninja" or "ts2_godfist" ) then
	
				ply:PrintMessage( 2, v.ClassName );
			
			end
			
		end
	
	end

end
concommand.Add( "rpa_weaponlist", ccListWeapons );

function ccStopSounds( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	--Most console commands are blocked, including stopsounds so we'll use a usermessage instead.
	umsg.Start( "StopAllSounds" );
	umsg.End();
	
	ply:PrintMessage( 2, "Stopping all sounds.." );

end
concommand.Add( "rpa_stopsounds", ccStopSounds );

function ccChangeMap( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_changemap <Map Name> - Change map - without the .bsp" );
		return;
	end
	
	local mapname = arg[1];
	
	if( string.find( mapname, "construct" ) or
		string.find( mapname, "flatgrass" ) ) then
		
		ply:PrintMessage( 2, "No." );
		return;
		
	end
	
	if( string.find( mapname, ".bsp" ) ) then
		mapname = string.gsub( mapname, ".bsp", "" );
	end
	
	TS.PrintMessageAll( 3, ply:GetRPName() .. " is changing the map to " .. mapname );

	timer.Simple( 2, game.ConsoleCommand, "changelevel " .. mapname .. "\n" );

end
concommand.Add( "rpa_changemap", ccChangeMap );

function ccMusicPlayer( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		
		ply:PrintMessage( 2, "Enter the sound path to play the sound!" );
		return;
	
	end
	
	for k, v in pairs( player.GetAll() ) do
	
		v:EmitSound( arg[1], 50, 100 );
	
	end
	
end
concommand.Add( "rpa_playmusic", ccMusicPlayer );

function ccSetScale( ply, cmd, arg )
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] or not arg[2] ) then 
		Console( ply, "rpa_setscale <Name> <Scale> - Set a player's model scale" );
		return;
	end
	
	local name = arg[1];
	
	local scale = arg[2];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		
		result:SetScale(scale)
		
		ply:PrintMessage( 3, "Set " .. result:GetRPName() .. "'s height scale to " .. scale );
		result:PrintMessage( 3, "Your height scale has been set!" );
		
		TS.WriteLog( "setscale", ply:GetRPName() .. " (" .. ply:SteamID() .. ")" .. " set " .. result:GetRPName() .. " (" .. ply:SteamID() .. ") to " .. scale );
	
	end
	
end
concommand.Add( "rpa_setscale", ccSetScale );

function ccSetPScale( ply, cmd, arg )
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] or not arg[2] ) then 
		Console( ply, "rpa_psetscale <Name> <Scale> - Set a player's model scale" );
		return;
	end
	
	local name = arg[1];
	
	local scale = arg[2];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		
		result:SetScale(scale)
		result:CharSaveData("scale", scale)
		
		ply:PrintMessage( 3, "Set " .. result:GetRPName() .. "'s height scale to " .. scale );
		result:PrintMessage( 3, "Your height scale has been set!" );
		
		TS.WriteLog( "setscale", ply:GetRPName() .. " (" .. ply:SteamID() .. ")" .. " set " .. result:GetRPName() .. " (" .. ply:SteamID() .. ") to " .. scale );
	
	end
	
end
concommand.Add( "rpa_psetscale", ccSetPScale );

function ccMakeTall( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_maketall <Name> - Scale player's model larger" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		for k, v in ipairs( player.GetAll() ) do
			v:SendLua( "player.GetByID(" .. result:EntIndex() .. "):SetModelScale( Vector( 1.1, 1.1, 1.1 ), Vector( 16, 16, 0 ) )" );
		end
		
		result:SetViewOffset( Vector( 0, 0, 73 ) );
		result:SetHull( Vector( -18, -18, 0 ), Vector( 18, 18, 73 ) );
		
		ply:PrintMessage( 3, "Made " .. result:GetRPName() .. " tall!" );
		result:PrintMessage( 3, "You've been made tall!" );
	
	end
	
end
concommand.Add( "rpa_maketall", ccMakeTall );

function ccMakeShort( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_makeshort <Name> - Scale player's model smaller" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		for k, v in ipairs( player.GetAll() ) do
			v:SendLua( "player.GetByID(" .. result:EntIndex() .. "):SetModelScale( Vector( 0.9, 0.9, 0.9 ), Vector( 16, 16, 0 ) )" );
		end
		
		result:SetViewOffset( Vector( 0, 0, 55 ) );
		result:SetHull( Vector(-14, -14, 0 ), Vector( 14, 14, 55 ) );
		
		ply:PrintMessage( 3, "Made " .. result:GetRPName() .. " short!" );
		result:PrintMessage( 3, "You've been made short!" );
	
	end

end
concommand.Add( "rpa_makeshort", ccMakeShort );

function ccMakeNormal( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_makenormal <Name> - Scale player's model back to normal" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		for k, v in ipairs( player.GetAll() ) do
			v:SendLua( "player.GetByID(" .. result:EntIndex() .. "):SetModelScale( Vector( 1, 1, 1 ), Vector( 16, 16, 0 ) )" );
		end
		
		result:ResetHull();
		result:SetViewOffset( Vector( 0, 0, 64 ) );
		
		ply:PrintMessage( 3, "Made " .. result:GetRPName() .. " normal!" );
		result:PrintMessage( 3, "You've been made back to normal!" );
	
	end

end
concommand.Add( "rpa_makenormal", ccMakeNormal );

function ccSlap( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_slap <Name> - Slap someone" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		local norm = result:GetAngles():Up();
		result:SetVelocity( norm * 500 + result:GetAngles():Forward() * math.random( -1000, 1000 ) );
		
		TS.PrintMessageAll( 3, ply:GetRPName() .. " slapped " .. result:GetRPName() );
		TS.PrintMessageAll( 2, ply:GetRPName() .. " slapped " .. result:GetRPName() );
		
	end

end
concommand.Add( "rpa_slap", ccSlap );

function ccChangeModel( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_changeplayermodel <Name> <Model> - Permanently change player's model" );
		return;
	end
	
	local name = arg[1];
	local model = arg[2];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		result:SetModel( model );
		result.CitizenModel = model;
		
		ply:PrintMessage( 3, "Successfully set " .. result:GetRPName() .. "'s player model!" );
		result:PrintMessage( 3, "Your model has been changed!" );
		
	end
	
end
concommand.Add( "rpa_psetmodel", ccChangeModel );
concommand.Add( "rpa_changeplayermodel", ccChangeModel );

function ccSetModel( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_setplayermodel <Name> <Model> - Temporarily change player's model" );
		return;
	end
	
	local name = arg[1];
	local model = arg[2];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
	
		result:SetModel( model );
		
		ply:PrintMessage( 3, "Successfully set " .. result:GetRPName() .. "'s player model!" );
		result:PrintMessage( 3, "Your model has been changed!" );
		
	end
	
end
concommand.Add( "rpa_setplayermodel", ccSetModel );

function ccRMap( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end
	
	TS.PrintMessageAll( 3, ply:GetRPName() .. " is restarting the map!" );
	
	timer.Simple( 2, game.ConsoleCommand, "changelevel " .. game.GetMap() .. "\n" );

end
concommand.Add( "rpa_restartmap", ccRMap );

function ccCloak( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	--Check if they're cloaked or not
	if( ply.InCloak ) then
		
		ply.InCloak = false;
		
		ply:MakeNotInvisible();
		
		ply:PrintMessage( 3, "You are now un-cloaked!" );
		
		ply:SetPlayerCloaked( false );

	else
	
		ply.InCloak = true;
		
		ply:MakeInvisible();
		
		ply:PrintMessage( 3, "You are now cloaked!" );
		
		ply:SetPlayerCloaked( true );
		
	end

end
concommand.Add( "rpa_cloak", ccCloak );

function ccAdminSearch( ply, cmd, args )
	if not ply:CanUseAdminCommand() then return; end
	if not args[1] then
		ply:PrintMessage( 2, "Specify a term!")
	end
	term = string.lower( args[1] );
	
	local i = 0;
	
	for k, v in pairs( player.GetAll() ) do

		if string.match( string.lower( v:GetRPName() ), term )
		or string.match( string.lower( v:Name() ), term )
		or string.match( string.lower( v:GetPlayerTitle() ), term )
		or string.match( string.lower( v:GetPlayerTitle2() ), term )
		or string.match( string.lower( v:GetModel() ), term ) then
		
			i = i + 1;
			
			ply:PrintMessage( 2, v:GetRPName() .. " (" .. v:Name() .. ") matched:" );
			
			if string.match( string.lower( v:Name() ), term ) then
				ply:PrintMessage( 2, "    OOC Name: " .. v:Name() );
			end
			
			if string.match( string.lower( v:GetRPName() ), term ) then
				ply:PrintMessage( 2, "    IC Name: " .. v:GetRPName() );
			end
			
			if string.match( string.lower( v:GetPlayerTitle() ), term ) then
				ply:PrintMessage( 2, "    Title: " .. v:GetPlayerTitle() );
			end
			
			if string.match( string.lower( v:GetPlayerTitle2() ), term ) then
				ply:PrintMessage( 2, "    Title 2: " .. v:GetPlayerTitle2() );
			end
			
			if string.match( string.lower( v:GetModel() ), term ) then
				ply:PrintMessage( 2, "    Model: " .. v:GetModel() );
			end
			
		end
		
	end
	
	print( "Found " .. i .. " matches." );
	
end
concommand.Add( "rpa_search", ccAdminSearch );

function ccGetInfo( ply, cmd, arg )
	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end	
	if( not arg[1] ) then 
		Console( ply, "rpa_getinfo <Name> - Get a player's character and OOC information" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then

		ply:PrintMessage( 2, "Displaying data for: " .. result:GetRPName() );
		ply:PrintMessage( 2, "    OOC Name: " .. result:Name() );
		ply:PrintMessage( 2, "    SteamID: " .. result:SteamID() );	
		ply:PrintMessage( 2, "    Flags:  " );
		ply:PrintMessage( 2, "        Combine: " .. result.CombineFlags );
		ply:PrintMessage( 2, "        Player: " .. result.PlayerFlags );
		ply:PrintMessage( 2, "    Stats: " );
		ply:PrintMessage( 2, "        Strength: " .. result:GetPlayerStrength() );	
		ply:PrintMessage( 2, "        Endurance: " .. result:GetPlayerEndurance() );
		ply:PrintMessage( 2, "        Speed: " .. result:GetPlayerSpeed() );	
		ply:PrintMessage( 2, "        Aim: " .. result:GetPlayerAim() );
		ply:PrintMessage( 2, "    Title: " .. result:GetPlayerTitle() );	
		ply:PrintMessage( 2, "    Title 2: " .. result:GetPlayerTitle2() );
		ply:PrintMessage( 2, "    Tokens: " .. result.Tokens );
		ply:PrintMessage( 2, "    Health: " .. result:Health() );
		ply:PrintMessage( 2, "    Armor: " .. result.BodyArmorHealth );
		ply:PrintMessage( 2, "    Model: " .. result:GetModel() );
		ply:PrintMessage( 2, "    Default Model: " .. result.CitizenModel );
		ply:PrintMessage( 2, "    Weapons:" );
		for k, v in pairs( result:GetWeapons() ) do
			ply:PrintMessage( 2, "        " .. v:GetClass() );
		end
		ply:PrintMessage( 2, "    Inventory: ");
		ply:PrintMessage( 2, "        " .. result:GetInfoItems() );

	end
	
end
concommand.Add( "rpa_getinfo", ccGetInfo );

function ccSlay( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_slay <Name> - Slay a player" );
		return;
	end

	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		
		ply:SendOverlongMessage(TS.MessageTypes.MISC.id, ply:GetRPName() .. " slayed " .. result:GetRPName())

		TS.PrintMessageAll( 2, ply:GetRPName() .. " slayed " .. result:GetRPName() );
		result:Die();
	
	end

end
concommand.Add( "rpa_slay", ccSlay );

function ccCreateItem( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_createitem <ID> - Create item with ID" );
		return;
	end
	
	local NoSpawn = { "ts2_kanyewest", "ts2_stormninja", "ts2_godfist", "ts2_tgun" };
	
	if( table.HasValue( NoSpawn, arg[1]) and (not ply:IsRick() or ply:Team() == 3) ) then
		ply:PrintMessage( 3, "How about NO" );
		return;
	end
	
	if( not TS.ItemsData[arg[1]] ) then return; end
	
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 150;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	TS.CreateItemProp( arg[1], tr.HitPos );

end
concommand.Add( "rpa_createitem", ccCreateItem );

function ccConsoleChat( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:IsRick() ) then return; end

	if( not arg[1] ) then return; end

	local chat = "";
	
	for n = 1, #arg do
		chat = chat .. arg[n] .. " ";
	end

	SendOverlongMessage(0, TS.MessageTypes.CONSOLE.id, chat, nil)
end
concommand.Add( "csay", ccConsoleChat );

function ccBring( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_bring <Name> - Bring a player" );
		return;
	end
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
			
		trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAngles():Forward() * 50;
		trace.filter = ply;
		
		tr = util.TraceLine( trace );

	
		if( tr.Hit ) then

			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAngles():Forward() * -50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAngles():Right() * -50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ply:EyePos();
			trace.endpos = trace.start + ply:GetAngles():Right() * 50;
			trace.filter = ply;
			
			tr = util.TraceLine( trace );
			
		end
		
		
		result:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	end

end
concommand.Add( "rpa_bring", ccBring );

function ccGoTo( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_goto <Name> - Go to a player" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
		
		local trace = { }
		trace.start = result:EyePos();
		trace.endpos = trace.start + result:GetAngles():Up() * 90;
		trace.filter = result;
		
		local tr = util.TraceLine( trace );
	
		if( tr.Hit ) then

			trace = { }
			trace.start = result:EyePos();
			trace.endpos = trace.start + result:GetAngles():Forward() * 50;
			trace.filter = result;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then

			trace = { }
			trace.start = result:EyePos();
			trace.endpos = trace.start + result:GetAngles():Forward() * -50;
			trace.filter = result;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = result:EyePos();
			trace.endpos = trace.start + result:GetAngles():Right() * -50;
			trace.filter = result;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = result:EyePos();
			trace.endpos = trace.start + result:GetAngles():Right() * 50;
			trace.filter = result;
			
			tr = util.TraceLine( trace );
			
		end
		
		
		ply:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	end

end
concommand.Add( "rpa_goto", ccGoTo );

function ccAdminYell( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() and not ply:IsRick() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_yell <Text> - Yell at the server angrily" );
		return;
	end

	local msg = "";
	
	for n = 1, #arg do
	
		if( msg ~= "" ) then
			msg = msg .. " ";
		end
	
		msg = msg .. arg[n];
	
	end
	
	
	local name;
	
	if( ply:EntIndex() == 0 ) then
		name = "Console";
		SendOverlongMessage(0, TS.MessageTypes.ADMINYELL.id, msg, nil)
	else
		name = ply:GetRPName();
		ply:SendOverlongMessage(TS.MessageTypes.ADMINYELL.id, msg, nil)
	end
end
concommand.Add( "rpa_yell", ccAdminYell );

function ccPermaBan( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_pban <Name> <Reason> - Permaban name with reason" );
		return;
	end
	
	local msg = "";
	
	if( arg[2] ) then
	
		for n = 2, #arg do
		
			if( msg ~= "" ) then
				msg = msg .. " ";
			end
		
			msg = msg .. arg[n];
		
		end
		
	end

	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );

	if( succ ) then
		
		result:PermaBan( msg, ply:GetRPName() );
	
	end

end
concommand.Add( "rpa_pban", ccPermaBan );

function ccBan( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] or not tonumber( arg[2] ) ) then 
		Console( ply, "rpa_ban <Name> <Time> <Reason> - Ban name for time minutes with reason" );
		return;
	end
	
	local name = arg[1];
	local btime = tonumber( arg[2] );
	
	if( btime < 1 or btime > 1440 ) then
		Console( ply, "Must be between 1 and 1440" );
		return;
	end
	
	local msg = "";
	
	if( arg[3] ) then
	
		for n = 3, #arg do
		
			if( msg ~= "" ) then
				msg = msg .. " ";
			end
		
			msg = msg .. arg[n];
		
		end
		
	end
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		
		result:Ban( btime, msg, ply:GetRPName() );
	
	end

end
concommand.Add( "rpa_ban", ccBan );

function ccKick( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_kick <Name> <Reason> - Kick name with reason" );
		return;
	end

	local msg = "";
	
	if( arg[2] ) then
	
		for n = 2, #arg do
		
			if( msg ~= "" ) then
				msg = msg .. " ";
			end
		
			msg = msg .. arg[n];
		
		end
		
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		
		result:Kick( msg, ply:GetRPName() );
	
	end

end
concommand.Add( "rpa_kick", ccKick );

function ccOOCDelay( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] or not tonumber( arg[1] ) ) then 
		Console( ply, "rpa_oocdelay <Delay> - Set an OOC delay; Current delay is: " .. TS.OOCDelay );
		return;
	end
	
	local delay = tonumber( arg[1] );
	
	if( delay < 0 or delay > 600 ) then
		Console( ply, "Must be between 0 and 600." );
		return;
	end
	
	TS.OOCDelay = delay;
	
	umsg.Start( "ODC" );
		umsg.String( ply:GetRPName() );
		umsg.Float( delay );
	umsg.End();
	
	for k, v in pairs( player.GetAll() ) do
	
		if( not v:IsAdmin() )then
	
			v.NextTimeCanChatOOC = CurTime() + delay;
	
		end
		
	end
	
	TS.PrintMessageAll( 2, "Admin " .. ply:GetRPName() .. " (" .. ply:SteamID() .. ") has set the OOC delay to " .. delay ); 
	
end
concommand.Add( "rpa_oocdelay", ccOOCDelay );

function ccMaxStats( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseSuperAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_maxstats <Name> - Give player max stats" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
		
		result:SetPlayerStrength( 100 );
		result:SetPlayerSpeed( 100 );
		result:SetPlayerEndurance( 100 );
		result:SetPlayerAim( 100 );
		
		Console( result, ply:GetRPName() .. " has given you max stats.", true );
		Console( ply, "Gave max stats to " .. result:GetRPName() .. ".", true );
		
		TS.WriteLog( "maxstats", ply:GetRPName() .. "(" .. ply:SteamID() .. ")" .. " gave " .. result:GetRPName() .. " max stats." );
		
	end

end
concommand.Add( "rpa_givemaxstats", ccMaxStats );

function ccObserve( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:IsSuperAdmin() and not ply:IsRick() ) then return; end
	
	if( ply.ObserveMode ) then
	
		ply:Observe( false );
	
	else
	
		ply:Observe( true );
	
	end

end
concommand.Add( "rpa_observe", ccObserve );
concommand.Add( "rp_noclip", ccObserve ); --legacy support, oh I love being a Dev -- Storm_Ninja

function ccSeeAll( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	umsg.Start( "SeeAll", ply ); umsg.End();

end
concommand.Add( "rpa_seeall", ccSeeAll );

function ccForceF1( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_forcef1 <Name> - Force the help menu open on a player" );
		return;
	end
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
	
		umsg.Start( "SH", result );
		umsg.End();
		
		result:PrintMessage( 3, "You have been forced to read F1!" );
		ply:PrintMessage( 3, "Forced F1 on: " .. result:GetRPName() );
	
	end

end
concommand.Add( "rpa_forcef1", ccForceF1 );

function ccBanPhysgun( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_banphysgun <Name> - Ban a player's physgun" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );

	if( succ ) then
		
		if( not result:IsPhysBanned() ) then
			
			filex.Append( "TS2/data/physgunbans.txt", ";" .. result:SteamID() );
		
			table.insert( TS.PhysgunBans, result:SteamID() );
			
			if( result:HasWeapon( "weapon_physgun" ) ) then
				result:StripWeapon( "weapon_physgun" );
			end
			
			ply:PrintMessage( 2, "Sucessfully banned " .. result:GetRPName() .. "'s physgun!" );
			result:PrintMessage( 3, "Your physgun has been banned by " .. ply:GetRPName() .. " (" .. ply:Name() .. ")." );
			
		else
		
			ply:PrintMessage( 2, "Player's physgun is already banned!" );
		
		end
		
	end

end
concommand.Add( "rpa_banphysgun", ccBanPhysgun );

function ccUnbanPhysgun( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	if( not arg[1] ) then 
		Console( ply, "rpa_unbanphysgun <Name> - Unban a player's physgun" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
	
		if( result:IsPhysBanned() ) then
		
			file.Write( "TS2/data/physgunbans.txt", string.gsub( ( file.Read( "TS2/data/physgunbans.txt" ) or "" ), ";" .. result:SteamID(), "" ) );
		
			for k, v in pairs( TS.PhysgunBans ) do
			
				if( v == result:SteamID() ) then
					TS.PhysgunBans[k] = nil;
					break;
				end
			
			end
			
			if( not result:HasWeapon( "weapon_physgun" ) ) then
				result:Give( "weapon_physgun" );
			end
			
			ply:PrintMessage( 2, "Successfully unbanned " .. result:GetRPName() .. "'s physgun!" );
			result:PrintMessage( 3, "Your physgun has been unbanned!" );
			
		else
			
			ply:PrintMessage( 2, "Player's physgun isn't banned!" );
		
		end
		
	end

end
concommand.Add( "rpa_unbanphysgun", ccUnbanPhysgun );

function ccItemList( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end
	
	for k, v in pairs( TS.ProcessedItems ) do
	
		ply:PrintMessage( 2, "Name: " .. v.Name .. "\n" .. "ID: " .. v.ID );
	
	end
	
end
concommand.Add( "rpa_itemlist", ccItemList );

function ccSetAnim(ply, cmd, arg)
	-- Set the anim for themselves
	if not ply:CanUseAdminCommand() or #arg ~= 1 then
		ply:PrintMessage(2, "Phail!")
		return
	end
	
	if tonumber(arg[1]) == 0 then
		ply:SnapOutOfStance()
	else
		ply:SnapIntoStance(tonumber(arg[1]))
	end
end
concommand.Add("rpa_setanim", ccSetAnim)

-----------------------------
--MY SQL COMMANDS------------
-----------------------------

function ccSetTokens( ply, cmd, arg )
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_setmoney <Name> <Amount> - Set a player's money" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( not arg[2] ) then
		arg[2] = " ";
	end

	if( succ ) then
	
		result.Tokens = tonumber(arg[2]);
	
		umsg.Start( "UDPM", result )
			umsg.Float( result.Tokens );
		umsg.End();
		
		local query = "UPDATE `tb_characters` SET `charTokens` = '" .. arg[2] .. "' WHERE `userID` = '" .. result:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( result:GetRPName() ) .. "'";	
		TS.AsyncQuery(query);
		
		ply:PrintMessage( 2, "Set " .. result:GetRPName() .. "'s tokens to " .. arg[2] );
		
		TS.WriteLog( "adminmoney", ply:GetRPName() .. " (" .. ply:SteamID() .. ")" .. " set " .. result:GetRPName() .. "'s (" .. result:SteamID() .. ") tokens to " .. arg[2] );
		
	end
	
end
concommand.Add( "rpa_setmoney", ccSetTokens );

function ccFlagPlayerT( ply, cmd, arg )
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_setcombineflag <Name> <Flag> - Set a player's Combine Flag(s)" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( not arg[2] ) then
		arg[2] = " ";
	end

	if( succ ) then
		
		result.CombineFlags = arg[2];
		
		local query = "UPDATE `tb_characters` SET `combineflags` = '" .. arg[2] .. "' WHERE `userID` = '" .. result:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( result:GetRPName() ) .. "'";	
		TS.AsyncQuery(query)
		
		ply:PrintMessage( 3, "Updated Combine flags for: " .. result:GetRPName() .. " ( " .. result.CombineFlags .. " )" );
		result:PrintMessage( 3, "Your Combine flags have been updated by " .. ply:GetRPName() .. "." );
		result:PrintMessage( 3, "Combine flags: " .. result.CombineFlags );
		
	end
	
end
concommand.Add( "rpa_setcombineflag", ccFlagPlayerT );

function ccFlagPlayer( ply, cmd, arg )
	
	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_setplayerflag <Name> <Flag> - Set a player's Player Flag(s)" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( not arg[2] ) then
		arg[2] = " ";
	end
	
	if( succ ) then
		
		result.PlayerFlags = arg[2];

		ply:PrintMessage( 3, "Updated Player Flags for: " .. result:GetRPName() .. " ( " .. result.PlayerFlags .. " )" );
		result:PrintMessage( 3, "Your Player Flags have been updated by " .. ply:GetRPName() .. "." );
		result:PrintMessage( 3, "Player Flags: " .. result.PlayerFlags );
		
		local query = "UPDATE `tb_characters` SET `playerflags` = '" .. arg[2] .. "' WHERE `userID` = '" .. result:GetSQLData( "uid" ) .. "' AND `charName` = '" .. TS.Escape( result:GetRPName() ) .. "'";	
		TS.AsyncQuery(query)
		
	end
	
end
concommand.Add( "rpa_setplayerflag", ccFlagPlayer );

function ccAddAdvTT( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_addtt <Name> - Give a player Tool Trust" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
	
		if( result:GetSQLData( "group_id" ) == 2 or result:GetSQLData( "group_id" ) == 3 ) then
		
			ply:PrintMessage( 2, "Person already has Tool Trust!" );
			return;			
		
		end
		
		local query = "UPDATE `tb_users` SET `groupID` = '2' WHERE `STEAMID` = '" .. result:SteamID() .. "'";	
		TS.AsyncQuery(query, function()

			ply:PrintMessage( 2, "Given Tool Trust to: " .. result:GetRPName() .. ". (" .. result:SteamID() .. ")" );
			result:PrintMessage( 3, ply:GetRPName() .. " has given you Tool Trust." );
			
			result:LoadSQLData();
			
			if( not result:HasWeapon( "gmod_tool" ) ) then
				result:Give( "gmod_tool" );
			end
		end, function(q, err)
			ply:PrintMessage(2, "Failed to give tool trust: "..err)
		end)
	end
	
end
concommand.Add( "rpa_addadvtt", ccAddAdvTT );
concommand.Add( "rpa_addtt", ccAddAdvTT );

function ccRemoveAdvTT( ply, cmd, arg )

	if( ply:EntIndex() ~= 0 and not ply:CanUseAdminCommand() ) then return; end

	if( not arg[1] ) then 
		Console( ply, "rpa_removett <Name> - Remove a player's Tool Trust" );
		return;
	end
	
	local name = arg[1];
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, false, succ, result );
	
	if( succ ) then
	
		if( result:GetSQLData( "group_id" ) == 1 ) then
		
			ply:PrintMessage( 2, "Person doesen't have Tool Trust!" );
			return;			
		
		end
		
		local query = "UPDATE `tb_users` SET `groupID` = '1' WHERE `STEAMID` = '" .. result:SteamID() .. "'";	
		TS.AsyncQuery( query, function()

			ply:PrintMessage( 2, "Removed Tool Trust from: " .. result:GetRPName() .. ". (" .. result:SteamID() .. ")" );
			result:PrintMessage( 3, ply:GetRPName() .. " has removed your Tool-Trust!" );
			
			result:LoadSQLData();
			
			if( result:HasWeapon( "gmod_tool" ) ) then
				result:StripWeapon( "gmod_tool" );
			end
		end, function(q, err)
			ply:PrintMessage(2, "Failed to remove tool trust: "..err)
		end)
	
	end
	
end
concommand.Add( "rpa_removeadvtt", ccRemoveAdvTT );
concommand.Add( "rpa_removett", ccRemoveAdvTT );
