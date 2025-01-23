GM.ChatCommands = { };

function GM:AddChatCommand( cmd, col, func )
	
	table.insert( self.ChatCommands, { cmd, col, func } );
	
end

function GM:GetChatCommand( text )
	
	local tab = self.ChatCommands;
	
	table.sort( tab, function( a, b )
		
		return string.len( a[1] ) > string.len( b[1] );
		
	end );
	
	for _, v in pairs( tab ) do
		
		if( text ) then
			
			if( string.find( string.lower( text ), string.lower( v[1] ), nil, true ) == 1 ) then
				
				return v;
				
			end
			
		end
		
	end
	
	return false;
	
end

function GM:OnChat( ply, text )
	
	if( self:GetChatCommand( text ) ) then
		
		local cc = self:GetChatCommand( text );
		local f = string.Trim( string.sub( text, string.len( cc[1] ) + 1 ) );
		
		if( SERVER ) then
			
			local ret = cc[3]( ply, f, nil, cc );
			
			if (ret) then
				net.Start( "nSay" );
					net.WriteEntity( ply );
					net.WriteString( text );
				net.Send( ret );
			end
			
		else
			
			if( ply == LocalPlayer() ) then
				
				cc[3]( ply, f, true, cc );
				
			else
				
				cc[3]( ply, f, nil, cc );
				
			end
			
		end
		
	else
		
		if( text == "" ) then return end
		
		local p = text:match("[%.%?!]")
		local verb = (p == "!") and "exclaims" or (p == "?") and "asks" or "says"
		
		if( SERVER ) then
			
			local rf = { };
			
			for _, v in pairs( player.GetAllBut( ply ) ) do
				
				if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
					
					table.insert( rf, v );
					
				end
				
			end
			
			net.Start( "nCCLocal" );
				net.WriteEntity( ply );
				net.WriteString( text );
			net.Send( rf );
			
			self:Log( "chat", "IC", ply:RPName() .. ": " .. text, ply );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", Color( 252, 178, 69, 255 ), ply:RPName().." "..verb.. ", \""..text.."\"", nil, ply );
			
		end
		
	end
	
end

if( CLIENT ) then

	local function nCCLocal( len )
		
		local ply = net.ReadEntity();
		local arg = net.ReadString();
		
		local p = arg:match("[%.%?!]")
		local verb = (p == "!") and "exclaims" or (p == "?") and "asks" or "says"
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", Color( 255, 180, 100, 255 ), ply:RPName().." "..verb.. ", \""..arg.."\"", nil, ply );
		
	end
	net.Receive( "nCCLocal", nCCLocal );
	
end

local function ccWhisper( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "W", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 90 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatSmall", cc[2], ply:RPName() .. " whispers, \"" .. arg.."\"", nil, ply );
		
	end
	
end
GM:AddChatCommand( "/w", Color( 252, 178, 69, 255 ), ccWhisper );

local function ccYell( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "Y", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 1000 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatBig", cc[2], ply:RPName() .. " shouts, \""..arg.."\"", nil, ply );
		
	end
	
end
GM:AddChatCommand( "/y", Color( 255, 50, 50, 255 ), ccYell );
GM:AddChatCommand( "/yell", Color( 255, 50, 50, 255 ), ccYell );
GM:AddChatCommand( "/shout", Color( 255, 50, 50, 255 ), ccYell );

local function ccMe( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	local name = ply:RPName()
	local text = arg
	local p, cont = text:match("^([!,.':])(%w+)")
	
	if p and (p ~= "'" or cont == "s" or cont == "ll" or cont:match("^[d've]+$")) then
		local suff, rem = text:match("(%S+)(.-)$")
		name = name .. suff
		text = rem
	else
		text = " " .. text
	end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "ME", name .. text, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], name .. text, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/me", Color( 252, 178, 69, 255 ), ccMe );

local function ccLMe( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	local name = ply:RPName()
	local text = arg
	local p, cont = text:match("^([!,.':])(%w+)")
	
	if p and (p ~= "'" or cont == "s" or cont == "ll" or cont:match("^[d've]+$")) then
		local suff, rem = text:match("(%S+)(.-)$")
		name = name .. suff
		text = rem
	else
		text = " " .. text
	end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "LMe", name .. text, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 1000 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], name .. text, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/lme", Color( 252, 178, 69, 255 ), ccLMe );

local function ccIt( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "I", "[" .. ply:RPName() .. "] " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], arg, "[" .. ply:RPName() .. "] ", ply );
		
	end
	
end
GM:AddChatCommand( "/it", Color( 252, 178, 69, 255 ), ccIt );

local function ccLIt( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "LI", "[" .. ply:RPName() .. "] " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 1000 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], arg, "[" .. ply:RPName() .. "] ", ply );
		
	end
	
end
GM:AddChatCommand( "/lit", Color( 252, 178, 69, 255 ), ccLIt );

local function ccLocalOOC( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "LOOC", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", cc[2], ply:RPName() .. ": [L-OOC] " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "[[", Color( 170, 211, 255, 255 ), ccLocalOOC );
GM:AddChatCommand( ".//", Color( 170, 211, 255, 255 ), ccLocalOOC );
GM:AddChatCommand( "/looc", Color( 170, 211, 255, 255 ), ccLocalOOC );

local function ccOOC( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "OOC", ply:RPName() .. ": " .. arg, ply );
		
		return player.GetAllBut( ply );
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", cc[2], "[OOC] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "//", Color( 130, 190, 255, 255 ), ccOOC );
GM:AddChatCommand( "/ooc", Color( 130, 190, 255, 255 ), ccOOC );

local function ccAdmin( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "A", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:IsAdmin() ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", cc[2], "[Admin] " .. ply:RPName() .. " (" .. ply:Name() .. "): " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/a", Color( 255, 70, 70, 255 ), ccAdmin );

local function ccRadio( ply, arg, l, cc )

	if( arg == "" ) then return end;
	
	if( l ) then

		if( #ply:GetItemsOfType("radio") == 0 ) then return end;

		for _,v in pairs( ply:GetItemsOfType("radio") or {} ) do

			if( ply.Inventory[v].Vars.power == 0 ) then

				return;
				
			else
			
				break;
				
			end
			
		end
		
	end
	
	local p = arg:match("[%.%?!]")
	local verb = (p == "!") and "exclaims" or (p == "?") and "asks" or "says"
	
	if( SERVER ) then

		if( #ply:GetItemsOfType("radio") == 0 ) then return end;

		for _,v in pairs( ply:GetItemsOfType("radio") ) do

			if( ply.Inventory[v].Vars.power == 0 ) then

				return;
				
			else
			
				break;
			
			end
			
		end
	
		local radioKey = ply:GetItemsOfType( "radio" )[1];
		GAMEMODE:Log( "chat", "R", ply:RPName()..": "..arg, ply );
		
		local rf = {};
		
		for _,v in pairs( player.GetAllBut( ply ) ) do

			local radios = v:GetItemsOfType( "radio" )

			if( !radios ) then return end;
			
			for _,key in pairs(radios) do

				local vars = v.Inventory[key].Vars;

				if( tonumber( vars.freq ) == tonumber( ply.Inventory[radioKey].Vars.freq ) ) then

					if( tonumber( vars.power ) == 1 ) then

						table.insert(rf, v);
						
					end
					
				end
				
			end
			
		end
		
		GAMEMODE:OnChat( ply, arg )

		return rf;
		
	else
	
		GAMEMODE:AddChat( { CB_ALL, CB_IC, CB_RADIO }, "Infected.ChatNormal", cc[2], "[@"..LocalPlayer():RadioFreq().."] "..ply:RPName()..": "..arg, nil, ply );
		if( l ) then
		
			GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", Color( 252, 178, 69, 255 ), ply:RPName().." "..verb.. ", \""..arg.."\"", nil, ply );
		
		end
	
	end
	
end
GM:AddChatCommand( "/r", Color(175, 175, 175, 255), ccRadio );

local function ccEvent( ply, arg, l, cc )
	
	if( arg == "" ) then return end;
	
	if( !ply:IsAdmin() ) then return end;
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "EVENT", ply:Name() .. ": " .. arg, ply );
		
		return player.GetAllBut( ply );
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", cc[2], arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/event", Color( 180, 200, 255, 255 ), ccEvent );

local function ccPM( ply, arg, l, cc )

	if( arg == "" ) then return end;
	
	local args = string.Explode( " ", arg );
	local targ = ply:FindPlayer( args[1] );
	args[1] = "";
	local str_tbs = string.Implode( " ", args );
	
	if( !IsValid( targ ) ) then	return end
	if( targ == ply ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "PM", ply:RPName() .. " to " .. targ:RPName() .. ":" .. str_tbs, ply );
		
		return targ;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_PM }, "Infected.ChatNormal", cc[2], "[PM] " .. ply:RPName() .. ":" .. str_tbs, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/pm", Color( 100, 190, 100, 255 ), ccPM );