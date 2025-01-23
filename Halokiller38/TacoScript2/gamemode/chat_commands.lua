local function dropweapon( ply, cmd, text )

	ply:ConCommand( "rp_dropweap\n" );
	
end
TS.ChatCmd( "/dropweapon", dropweapon );
TS.ChatCmd( "/dropgun", dropweapon );

local function giveweapon( ply, cmd, text )

	ply:ConCommand( "rp_giveweap\n" );
	
end
TS.ChatCmd( "/giveweapon", giveweapon );
TS.ChatCmd( "/givegun", giveweapon );

local function buydoor( ply, cmd, text )

	ply:ConCommand( "rp_buydoor\n" );
	
end
TS.ChatCmd( "/buy", buydoor );

local function selldoor( ply, cmd, text )

	ply:ConCommand( "rp_selldoor\n" );
	
end
TS.ChatCmd( "/sell", selldoor );

local function lockdoor( ply, cmd, text )

	ply:ConCommand( "rp_lock\n" );
	
end
TS.ChatCmd( "/lock", lockdoor );

local function unlockdoor( ply, cmd, text )

	ply:ConCommand( "rp_unlock\n" );
	
end
TS.ChatCmd( "/unlock", unlockdoor );

local function CID( ply, cmd, text )

	local err = "Incorrect format! Correct format: /cid #####";

	if string.len( text ) ~= 5 then
		ply:PrintMessage( 3, err );
		return;
	end

	local val = tonumber( text );
	
	if not val then
		ply:PrintMessage( 3, err );
		return;
	end
	
	ply:SetCID( val );
	ply:PrintMessage( 3, "Set CID to: " .. val .. "." );
	
end
TS.ChatCmd( "/cid ", CID );

local function giveplayermoney( ply, cmd, text )

	local amt = math.Round( tonumber( text ) );

	if not amt then
		ply:PrintMessage( 3, "Incorrect amount!" );
		return;
	end
	
	if amt < 1 then
		ply:PrintMessage( 3, "You can't give someone nothing!" );
		return;
	end
	
	local trace = {};
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 180;
	trace.filter = ply;

	local tr = util.TraceLine( trace );
	
	if tr.Entity:IsPlayer() then
		
		if( ( ply.Tokens - amt ) < 0 ) then
		
			ply:PrintMessage( 3, "Not enough money!" );
			return;
			
		end
		
	
		local tokentext = " tokens!";
		
		if amt == 1 then
			tokentext = " token!";
		end
	
		ply:SubMoney( amt );
		ply:PrintMessage( 3, "Gave " .. tr.Entity:GetRPName() .. " " .. amt .. tokentext );
	
		tr.Entity:AddMoney( amt );
		tr.Entity:PrintMessage( 3, ply:GetRPName() .. " gave you " .. amt .. tokentext );
		
	else
	
		ply:PrintMessage( 3, "Must face player!" );
	
	end
	
end
TS.ChatCmd( "/givemoney ", giveplayermoney );

local function searchplayer( ply, cmd, args )

	local trace = {};
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 180;
	trace.filter = ply;

	local tr = util.TraceLine( trace );
	
	if not tr.Entity:IsPlayer() then
	
		ply:PrintMessage( 2, "Must face player!" );
		
	else
	
		tr.Entity:PrintMessage( 2, ply:GetRPName() .. " searched you!" );
		ply:PrintMessage( 2, tr.Entity:GetRPName() .. "'s inventory: " .. "WHAT" );
		
	end
	
end
TS.ChatCmd( "/search", searchplayer );

local function ccadevice( ply, cmd, text )

	if( not ply:HasItem( "crdevice" ) ) then
	
		ply:PrintMessage( 3, "You need a Civil Request Device to do this!" );
		return;
	
	end
	
	ply:TalkToCCARadio( text );
	ply:SayLocalChat( text );
	
end
TS.ChatCmd( "/cr ", ccadevice );

local function ccadevicewhisper( ply, cmd, text )

	if( not ply:HasItem( "crdevice" ) ) then
	
		ply:PrintMessage( 3, "You need a Civil Request Device to do this!" );
		return;
	
	end
	
	ply:TalkToCCARadio( "[WHISPER] " .. text );
	ply:WhisperLocalChat( text );
	
end
TS.ChatCmd( "/crw ", ccadevicewhisper );

local function propdescription( ply, cmd, text )

	if( string.gsub( text, " ", "" ) == "" ) then
	
		ply:PrintMessage( 3, "Description cannot be blank!" );
		return;

	end

	if( string.len( text ) > 160 ) then
	
		ply:PrintMessage( 3, "Description cannot be over 160 characters!" );
		return;
	
	end
	
	SetPropDescription( ply, text );

end
TS.ChatCmd( "/setdescription ", propdescription );
TS.ChatCmd( "/sd ", propdescription );

local function event( ply, cmd, text )

	if( not ply:CanUseAdminCommand() and not ply:HasCombineFlag( "N" ) ) then return; end
	
	ply:SayGlobalEvent( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [EVENT]:" .. text ); 
end
TS.ChatCmd( "/ev ", event );

local function AdminSay( ply, cmd, text )
	
	if( not ply:IsAdmin() ) then
		ply:SendOverlongMessage(TS.MessageTypes.ADMIN.id, "[TO ADMINS] " .. text, ply)
		text = "! " .. text;
	end
	
	for k, v in ipairs( player.GetAll() ) do
		if( v:IsAdmin() ) then
			ply:SendOverlongMessage(TS.MessageTypes.ADMIN.id, "[ADMINS] " .. text, v)
		end
	end
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [ADMIN]:" .. text );

end
TS.ChatCmd( "!a ", AdminSay );

local function YellRadio( ply, cmd, text )

	if( not ply:HasItem( "radio" ) ) then
	
		ply:PrintMessage( 3, "You need a radio to do this!" );
		return;
	
	end
	
	local curradiofreq = ply.Frequency;
	
	if( curradiofreq == 0 ) then
	
		ply:PrintMessage( 3, "You need to tune your radio in!" );
		return;
	
	end
	
	ply:YellToRadio( text );
	ply:YellLocalChat( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [RADIO-YELL]:" .. text );
	
end
TS.ChatCmd( "/ry ", YellRadio );

local function WhisperRadio( ply, cmd, text )

	if( not ply:HasItem( "radio" ) ) then
	
		ply:PrintMessage( 3, "You need a radio to do this!" );
		return;
	
	end
	
	local curradiofreq = ply.Frequency;
	
	if( curradiofreq == 0 ) then
	
		ply:PrintMessage( 3, "You need to tune your radio in!" );
		return;
	
	end
	
	ply:WhisperToRadio( text );
	ply:WhisperLocalChat( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [RADIO-WHISPER]:" .. text );
	
end
TS.ChatCmd( "/rw ", WhisperRadio );

local function SayRadio( ply, cmd, text )

	if( not ply:HasItem( "radio" ) ) then
	
		ply:PrintMessage( 3, "You need a radio to do this!" );
		return;
	
	end
	
	local curradiofreq = tonumber( ply.Frequency );
	
	if( curradiofreq == 0 ) then
	
		ply:PrintMessage( 3, "You need to tune your radio in!" );
		return;
	
	end
	
	ply:TalkToRadio( text );
	ply:SayLocalChat( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [RADIO]:" .. text );
	
end
TS.ChatCmd( "/r ", SayRadio );

local function RadioDispatch( ply, cmd, text )

	if not ply:IsCP() and not ply:IsCA() and not ply:IsOW() then
	
		ply:PrintMessage( 3, "You must be flagged as Combine to do this!" );
		return;
		
	end
	
	ply:RadioDis( text );

end
TS.ChatCmd( "/rdis ", RadioDispatch );

local function ooc( ply, cmd, text )

	if( CurTime() < ply.NextTimeCanChatOOC ) then 
		return "";
	end
	
	if string.find(ply.PlayerFlags, "M") then
		ply:PrintMessage(3, "You are muted from speaking in OOC!");
		return;
	end

	if( (TS.OOCDelay > 0 )and( not ply:IsAdmin()) ) then
	
		umsg.Start( "SNCTOOC", ply );
			umsg.Float( TS.OOCDelay );
		umsg.End();
	
		ply.NextTimeCanChatOOC = CurTime() + TS.OOCDelay;
	
	end
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [OOC]:" .. text );

	return text;

end
TS.ChatCmd( "//", ooc );
TS.ChatCmd( "/ooc", ooc );

local function title( ply, cmd, text )

	if( CurTime() - ply.LastTitleUpdate < 2 ) then
		return;
	end
	
	if( not string.find( text, " " ) ) then return; end
	
	if( string.len( text ) > TS.MaxTitleLength ) then
	
		ply:PrintMessage( 3, "Your title is too long!" );
		return;
	
	end
	
	text = string.gsub( text, "\n", "" );
	text = string.gsub( text, "\r", "" );
	
	ply:SetPlayerTitle( string.sub( text, 2 ) );
	ply:SendTitle()
	
	-- broadcast.
	ply:SendTitle()
	
	ply:PrintMessage( 3, "Title changed to " .. string.sub( text, 2 ) );
	
	ply.LastTitleUpdate = CurTime();
	
end
TS.ChatCmd( "/title", title );

local function title2( ply, cmd, text )

	if( CurTime() - ply.LastTitleUpdate < 2 ) then
		return;
	end
	
	if( not string.find( text, " " ) ) then return; end
	
	if( string.len( text ) > TS.MaxTitleLength ) then
	
		ply:PrintMessage( 3, "Your second title is too long!" );
		return;
	
	end
	
	text = string.gsub( text, "\n", "" );
	text = string.gsub( text, "\r", "" );
	
	ply:SetPlayerTitle2( string.sub( text, 2 ) );
	ply:SendTitle2()
	
	ply:PrintMessage( 3, "Title 2 changed to " .. string.sub( text, 2 ) );
	
	ply.LastTitleUpdate = CurTime();
	
end
TS.ChatCmd( "/title2", title2 );

local function afk(ply, cmd, text)
	if CurTime() - ply.LastTitleUpdate < 2 then
		return
	end
	
	if string.len(text) > TS.MaxTitleLength then
		ply:PrintMessage(3, "Your reason is too long!")
		return
	end
	
	text = string.sub(text, 2)
	
	if ply.Away then
		-- with reason?
		if string.find(text, "[^ ]") then
			ply:SetPlayerTitle2(text)
			ply:SendTitle2()
			ply:PrintMessage(3, "Updated your away reason.")
		else
			-- un-afk
			ply:SetPlayerTitle(ply.Away.Title1)
			ply:SetPlayerTitle(ply.Away.Title2)
			ply:SendTitle()
			ply:SendTitle2()
			
			ply.Away = nil
			ply:PrintMessage(3, "You are no longer away.")
		end
	else
		ply.Away = { 
			Title1 = ply:GetPlayerTitle(),
			Title2 = ply:GetPlayerTitle2()
		}
		
		ply:SetPlayerTitle("// AFK")
		ply:SetPlayerTitle2(text)
		ply:SendTitle()
		ply:SendTitle2()
		ply:PrintMessage(3, "You are now away.")
	end
	
	ply.LastTitleUpdate = CurTime()+3 -- additional penalty
end
TS.ChatCmd( "/afk", afk)

local function getup( ply, cmd, text )

	if( not ply:GetPlayerConscious() and ply:GetPlayerConsciousness() >= 45 ) then
	
		ply:Conscious();
	
	end

end
TS.ChatCmd( "/getup", getup );

local function yell( ply, cmd, text )

	ply:YellLocalChat( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [YELL]:" .. text );

end
TS.ChatCmd( "/y ", yell );

local function whisper( ply, cmd, text )

	ply:WhisperLocalChat( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [WHISPER]:" .. text );

end
TS.ChatCmd( "/w ", whisper );

local function looc( ply, cmd, text )
	
	ply:SayLocalOOCChat(text);
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [LOCAL-OOC]:" .. text );

end
TS.ChatCmd( "[[", looc );
TS.ChatCmd( ".//", looc );

local function me( ply, cmd, text )

	ply:DoICAction( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [ACTION]:" .. text );

end
TS.ChatCmd( "/me", me );

local function write( ply, cmd, text )

	local res, i, x, y = ply:HasItem( "paper" );
	
	if( res ) then

		ply.SelectedPaper = { Inv = i, x = x, y = y };

		umsg.Start( "LWP", ply );
			umsg.String( text );
		umsg.End();
		
	end

end
TS.ChatCmd( "/write", write );

local function dispatch( ply, cmd, text )
	if not ply:IsCP() and not ply:IsCA() and not ply:IsOW() then
		return
	end
	ply:SendOverlongMessage(TS.MessageTypes.DISPATCH.id, text, nil)
end
TS.ChatCmd( "/dis ", dispatch );
TS.ChatCmd( "/dispatch ", dispatch );

local function broadcast( ply, cmd, text )

	if ply:IsCA() or ply:IsCP() then
	
		ply:SendOverlongMessage(TS.MessageTypes.BROADCAST.id, text, nil)
	
		return;
		
	end
	
	ply:PrintMessage( 3, "You must be flagged as a City Administrator to do this!" );
	
end
TS.ChatCmd( "/br ", broadcast );
TS.ChatCmd( "/bc ", broadcast );
TS.ChatCmd( "/broadcast ", broadcast );


local function advert( ply, cmd, text )

	ply:SubMoney( 15 );
	
	ply:SendOverlongMessage(TS.MessageTypes.ADVERTISMENT.id, text, nil)
	
end
TS.ChatCmd( "/adv ", advert );
TS.ChatCmd( "/advert ", advert );

local function pm( ply, cmd, text )

	if( not string.find( text, " " ) or not string.find( string.sub( text, string.find( text, " " ) + 1 ), " " ) ) then return; end

	local namepos = string.find( text, " " ) + 1;
	local msgpos = string.find( string.sub( text, string.find( text, " " ) + 1 ), " " );

	local name = string.sub( text, namepos, msgpos );
	text = string.sub( text, msgpos + 1 );
	
	local succ, result = TS.FindPlayerByName( name );
	TS.ErrorMessage( ply, true, succ, result );
	
	if( succ ) then
		result:SendOverlongMessage(TS.MessageTypes.PRIVMSG.id, "[PM to " .. result:GetRPName() .. "]" .. text, ply)
		ply:SendOverlongMessage(TS.MessageTypes.PRIVMSG.id, "[PM from " .. ply:GetRPName() .. "]" .. text, result)
						
		TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [PM to " .. result:GetRPName() .. "]: " .. text );
		TS.WriteToChatLog( result:GetRPName() .. "( " .. result:SteamID() .. " ) [PM from " .. ply:GetRPName() .. "]: " .. text );
		
	end

end
TS.ChatCmd( "/pm", pm );

local function it( ply, cmd, text )

	ply:SayICAction( text );
	
	TS.WriteToChatLog( ply:GetRPName() .. "( " .. ply:SteamID() .. " ) [IT]: " .. text );

end
TS.ChatCmd( "/it ", it );

local function lean( ply, cmd, text )

	if( ply:IsCP() ) then return; end

	ply:ConCommand( "rp_ic_lean\n" );
	
end
TS.ChatCmd( "/lean", lean );

local function sitground( ply, cmd, text )

	if( ply:IsCP() ) then return; end

	ply:ConCommand( "rp_ic_sitground\n" );
	
end
TS.ChatCmd( "/sitground", sitground );

local function stand( ply, cmd, text )

	if( ply.InStanceAction ) then
	
		if( ply.StanceGroundSit ) then
		
			ply:ConCommand( "rp_ic_sitground\n" );
			
		elseif( ply.StanceSit  ) then
		
			ply:ConCommand( "rp_ic_sit\n" );
			
		elseif( ply.StanceLean ) then
		
			ply:ConCommand( "rp_ic_lean\n" );
			
		end
		
	end
	
end
TS.ChatCmd( "/stand", stand );

local function sit( ply, cmd, text )

	if( ply:IsCP() ) then return; end

	ply:ConCommand( "rp_ic_sit\n" );
	
end
TS.ChatCmd( "/sit", sit );

local function atw( ply, cmd, text )

	if( ply:IsCP() ) then return; end

	ply:ConCommand( "rp_ic_atw\n" );
	
end
TS.ChatCmd( "/atw", atw );

local function goto( ply, cmd, text )

	ply:ConCommand( "rpa_goto " .. text .. "\n" );
	
end
TS.ChatCmd( "!goto", goto );

local function bring( ply, cmd, text )

	ply:ConCommand( "rpa_bring " .. text .. "\n" );
	
end
TS.ChatCmd( "!bring", bring );

local function slay( ply, cmd, text )

	ply:ConCommand( "rpa_slay " .. text .. "\n" );

end
TS.ChatCmd( "!slay", slay );

local function slap( ply, cmd, text )

	ply:ConCommand( "rpa_slap " .. text .. "\n" );

end
TS.ChatCmd( "!slap", slap );

local function explode( ply, cmd, text )

	ply:ConCommand( "rpa_explode " .. text .. "\n" );

end
TS.ChatCmd( "!explode", explode );

local function kick( ply, cmd, text )

	ply:ConCommand( "rpa_kick " .. text .. "\n" );

end
TS.ChatCmd( "!kick", kick );

local function ban( ply, cmd, text )

	ply:ConCommand( "rpa_ban " .. text .. "\n" );

end
TS.ChatCmd( "!ban", ban );	

local function cloak( ply, cmd, text )

	ply:ConCommand( "rpa_cloak\n" );

end
TS.ChatCmd( "!cloak", cloak );
