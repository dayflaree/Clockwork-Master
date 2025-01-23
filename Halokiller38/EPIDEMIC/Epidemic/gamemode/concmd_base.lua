
EngConCmds = { }

function NewConCommand( name, delay, func )

	table.insert( EngConCmds, { Name = name, Delay = delay, Func = func } );
	
	local function firstcall( ply, cmd, arg )

		if( TestDummyIDs[ply:SteamID()] ) then return; end

		local call = false;
		
		if( not ply:GetTable()["NextCmdCall" .. name] ) then
	
			call = true;
		
		elseif( CurTime() > ply:GetTable()["NextCmdCall".. name] ) then
	
			call = true;
		
		end

		if( call ) then

			ply:GetTable()["NextCmdCall" .. name] = CurTime() + delay;

			func( ply, cmd, arg );
		
		end
	
	end
	concommand.Add( name, firstcall );

end

function EngConCommand( name, argc, delay, func )

	table.insert( EngConCmds, { Name = name, Argc = argc, Delay = delay, Func = func } );
	
	local function firstcall( ply, cmd, arg )

		if( TestDummyIDs[ply:SteamID()] ) then return; end

		local call = false;
		
		if( not ply:GetTable()["NextCmdCall" .. name] ) then
	
			call = true;
		
		elseif( CurTime() > ply:GetTable()["NextCmdCall".. name] ) then
	
			call = true;
		
		end

		if( call ) then

			ply:GetTable()["NextCmdCall" .. name] = CurTime() + delay;

			if( argc and #arg ~= argc ) then
			
				return;
			
			end
			
			func( ply, cmd, arg );
		
		end
	
	end
	concommand.Add( name, firstcall );

end

AdminConCmds = { }

function AdminConCommand( name, flags, chatcmd, func )

	table.insert( AdminConCmds, { Name = name, ChatCmd = chatcmd, Flags = flags, Func = func } );
	
	local f = function( ply, cmd, arg )
	
		ply:ConCommand( name .. " " .. arg .. "\n" );
	
	end
	ChatCommand( chatcmd, f );
	
	local function firstcall( ply, cmd, arg )

		if( TestDummyIDs[ply:SteamID()] ) then return; end

		if( ply:EntIndex() == 0 or ply:HasAdminFlags( flags ) or ply:HasAdminFlags("+") ) then 

			func( ply, cmd, arg );
			PrintToConsole( ply, "Successfully ran command." );
			
		else
		
			ply:PrintMessage( 2, "You do not have the appropriate flags to run this command." );
		
		end
	
	end
	concommand.Add( name, firstcall );

end

AMConCmds = { }

function AMConCommand( name, func )

	table.insert( AdminConCmds, { Name = name, Func = func } );
	
	local function firstcall( ply, cmd, arg )

		if( TestDummyIDs[ply:SteamID()] ) then return; end

		if( ply:GetTable().ActionMenu and ply:GetTable().ActionMenu.Entity and ply:GetTable().ActionMenu.Entity:IsValid() ) then 

			func( ply, cmd, arg );

		end

		ply:GetTable().ActionMenu = nil;
	
	end
	concommand.Add( name, firstcall );

end

