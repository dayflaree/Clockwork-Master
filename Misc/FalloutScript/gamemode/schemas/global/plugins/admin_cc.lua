PLUGIN.Name = "Admin Commands"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "A set of default admin commands"; -- The description or purpose of the plugin

function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	
	if(!LEMON.IsDoor(trent)) then ply:PrintMessage(3, "You must be looking at a door!"); return; end

	if(table.getn(args) < 1) then ply:PrintMessage(3, "Specify a doorgroup!"); return; end
	
	local pos = trent:GetPos()
	local Door = {}
	Door["x"] = math.ceil(pos.x);
	Door["y"] = math.ceil(pos.y);
	Door["z"] = math.ceil(pos.z);
	Door["group"] = args[1];
	
	table.insert(LEMON.Doors, Door);
	
	LEMON.SendChat(ply, "Door added");
	
	local keys = util.TableToKeyValues(LEMON.Doors);
	file.Write("CakeScript/MapData/" .. game.GetMap() .. ".txt", keys);
	
end

function Admin_Goto( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

local target = LEMON.FindPlayer(args[1]);

if(target:Alive() and target:IsPlayer()) then
ply:SetPos(target:GetPos() + Vector( -50, 50, 20 ) );
else
LEMON.SendChat( ply, "Player is either dead or doesn't exist!" );
end

end
concommand.Add( "rp_goto", Admin_Goto )

function Admin_Bring( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

local target = LEMON.FindPlayer(args[1])
if(target:Alive() and target:IsPlayer()) then
target:SetPos( ply:GetPos() + Vector( -50, 50, 20 ) )
--Msg( ply:GetPos() )  --debug purposes
else
LEMON.SendChat( ply, "Player is either dead or doesn't exist!" );
end

end
concommand.Add( "rp_bring", Admin_Bring )

function Admin_LocalSound( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

util.PrecacheSound( args[1] );
ply:EmitSound( args[1] );

end

function Admin_GlobalSound( ply, cmd, args )
if(!ply:IsAdmin()) then return false; end

util.PrecacheSound( args[1] );

for k,v in pairs( player.GetAll() ) do

v:ConCommand("play ".. args[1] );

end

end

function Admin_SetModel( ply, cmd, args )

if(!ply:IsSuperAdmin()) then return false; end

local target = LEMON.FindPlayer(args[1]);

if(target:Alive() and target:IsPlayer()) then

target:SetModel( args[2] );
LEMON.SetCharField(target, "model", args[2] );

else

LEMON.SendChat( ply, "Player is either dead or doesn't exist!" );

end

end

function Admin_GiveMoney( ply, cmd, args )
	if( #args != 2 ) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin givemoney \"name\" \"amount\" )" );
		return;
		
	end

	local amt = tonumber(args[2]);
	local target = LEMON.FindPlayer(args[1]);
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end

    target:ChangeMoney( amt );
	LEMON.SendChat( ply, "Gave ".. target:Name() .." $".. amt .." dollars." );

end

-- rp_admin kick "name" "reason"
function Admin_Kick( ply, cmd, args )

	if( #args != 2 ) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin kick \"name\" \"reason\" )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	
	local pl = LEMON.FindPlayer( plyname );
	
	if( pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"" .. reason .. "\"\n" );
		
		LEMON.AnnounceAction( ply, "kicked " .. pl:Name( ) );
		
	else
	
		LEMON.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end


function Admin_Observe( ply, cmd, args )
	
	if( not ply:IsAdmin() ) then return; end

	if( not ply:GetTable().Observe ) then



		ply:GodEnable();
		ply:SetNoDraw( true );
		
		if( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():SetNoDraw( true );
		end
		
		ply:SetNotSolid( true );
		ply:SetMoveType( 8 );
		
		ply:GetTable().Observe = true;
		
	else

		ply:GodDisable();
		ply:SetNoDraw( false );
		
		if( ply:GetActiveWeapon() ) then
			ply:GetActiveWeapon():SetNoDraw( false );
		end
		
		ply:SetNotSolid( false );
		ply:SetMoveType( 2 );
		
		ply:GetTable().Observe = false;
		
	end

end


-- rp_admin ban "name" "reason" minutes
function Admin_Ban( ply, cmd, args )

	if( #args != 3 ) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	if(mins > LEMON.ConVars[ "MaxBan" ]) then
	
		LEMON.SendChat( ply, "Max minutes is " .. LEMON.ConVars[ "MaxBan" ] .. " for regular ban. Use superban.");
		return;
	
	end
	
	local pl = LEMON.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
		game.ConsoleCommand( "writeid\n" );
		
		LEMON.AnnounceAction( ply, "banned " .. pl:Name( ) );
		
	else
	
		LEMON.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

-- rp_admin superban "name" "reason" minutes
function Admin_SuperBan( ply, cmd, args )

	if( #args != 3 ) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin superban \"name\" \"reason\" minutes )" );
		return;
		
	end
	
	local plyname = args[ 1 ];
	local reason = args[ 2 ];
	local mins = tonumber( args[ 3 ] );
	
	local pl = LEMON.FindPlayer( plyname );
	
	if( pl != nil and pl:IsValid( ) and pl:IsPlayer( ) ) then
	
		local UniqueID = pl:UserID( );
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" );
		
		if( mins == 0 ) then
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Permanently banned ( " .. reason .. " )\"\n" );
			LEMON.AnnounceAction( ply, "permabanned " .. pl:Name( ) );
	
		else
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" );
			LEMON.AnnounceAction( ply, "banned " .. pl:Name( ) );
			
		end
		
		game.ConsoleCommand( "writeid\n" );
		
	else
	
		LEMON.SendChat( ply, "Cannot find " .. plyname .. "!" );
		
	end
	
end

function Admin_SetConVar( ply, cmd, args )

	if( #args != 2 ) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin setvar \"varname\" \"value\" )" );
		return;
		
	end
	
	if( LEMON.ConVars[ args[ 1 ] ] ) then
	
		local vartype = type( LEMON.ConVars[ args [ 1 ] ] );
		
		if( vartype == "string" ) then
		
			LEMON.ConVars[ args[ 1 ] ] = tostring(args[ 2 ]);
			
		elseif( vartype == "number" ) then
		
			LEMON.ConVars[ args[ 1 ] ] = LEMON.NilFix(tonumber(args[ 2 ]), 0); -- Don't set a fkn string for a number, dumbass! >:<
		
		elseif( vartype == "table" ) then
		
			LEMON.SendChat( ply, args[ 1 ] .. " cannot be changed, it is a table." ); -- This is kind of like.. impossible.. kinda. (Or I'm just a lazy fuck)
			return;
			
		end
		
		LEMON.SendChat( ply, args[ 1 ] .. " set to " .. args[ 2 ] );
		LEMON.CallHook( "SetConVar", ply, args[ 1 ], args[ 2 ] );
		
	else
	
		LEMON.SendChat( ply, args[ 1 ] .. " is not a valid convar! Use rp_admin listvars" );
		
	end
	
end

function Admin_ListVars( ply, cmd, args )

	LEMON.SendChat( ply, "---List of CakeScript ConVars---" );
	
	for k, v in pairs( LEMON.ConVars ) do
		
		LEMON.SendChat( ply, k .. " - " .. tostring(v) );
		
	end
	
end

function Admin_SetFlags( ply, cmd, args)
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	table.remove(args, 1); -- Get rid of the name
	
	LEMON.SetCharField(target, "flags", args); -- KLOL!
	target:ConCommand( "rp_flag ".. args[1] ); --:D

	LEMON.SendChat( ply, target:Name() .. "'s flags were set to \"" .. table.concat(args, " ") .. "\"" );
	LEMON.SendChat( target, "Your flags were set to \"" .. table.concat(args, " ") .. "\" by " .. ply:Name());
	
end

function Admin_Help( ply, cmd, args )

	LEMON.SendChat( ply, "---List of CakeScript Admin Commands---" );
	
	for cmdname, cmd in pairs( LEMON.AdminCommands ) do
	
		local s = cmdname .. " \"" .. cmd.desc .. "\"";
		
		if(cmd.CanRunFromConsole) then
		
			s = s .. " console";

		else
		
			s = s .. " noconsole";
			
		end
		
		if(cmd.CanRunFromAdmin) then
		
			s = s .. " admin";
			
		end
		
		if(cmd.SuperOnly) then
		
			s = s .. " superonly";
			
		end
		
		LEMON.SendChat( ply, s );
		
	end
	
end
	
-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init( )

	LEMON.ConVars[ "MaxBan" ] = 2880; -- What is the maximum ban limit for regular admins?
	
	LEMON.AdminCommand( "help", Admin_Help, "List of all admin commands", true, true, false );
	LEMON.AdminCommand( "kick", Admin_Kick, "Kick someone on the server", true, true, false );
	LEMON.AdminCommand( "ban", Admin_Ban, "Ban someone on the server", true, true, false );
	LEMON.AdminCommand( "superban", Admin_SuperBan, "Ban someone on the server ( Permanent allowed )", true, true, false );
	LEMON.AdminCommand( "setconvar", Admin_SetConVar, "Set a Convar", true, true, true );
	LEMON.AdminCommand( "listvars", Admin_ListVars, "List convars", true, true, true );
	LEMON.AdminCommand( "setflags", Admin_SetFlags, "Set a players flags", true, true, false );
	LEMON.AdminCommand( "adddoor", Admin_AddDoor, "Add a door to a doorgroup", true, true, true );
	LEMON.AdminCommand( "observe", Admin_Observe, "Observe mode.", true, true, false );
	LEMON.AdminCommand( "givemoney", Admin_GiveMoney, "Give a player money.", true, true, true );
	LEMON.AdminCommand( "setmodel", Admin_SetModel, "Set a players model.", true, true, true );
	LEMON.AdminCommand( "globalsound", Admin_GlobalSound, "Play a sound everyone can here.", true, true, true );
	LEMON.AdminCommand( "localsound", Admin_LocalSound, "Emit a sound.", true, true, true );
	
end

