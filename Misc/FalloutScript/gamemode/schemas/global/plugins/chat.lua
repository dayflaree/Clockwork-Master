PLUGIN.Name = "Chat Commands"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "A set of default chat commands"; -- The description or purpose of the plugin

function OOCChat( ply, text )

	-- OOC Chat
	
	if(ply.LastOOC + LEMON.ConVars[ "OOCDelay" ] < CurTime() ) then
	
		ply.LastOOC = CurTime();
		return "|"..ply:Nick().."[OOC]: " .. text;
	
	elseif( ply:IsAdmin() or ply:IsSuperAdmin() ) then
	
		return "|"..ply:Nick().."[OOC]: " .. text
		
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + LEMON.ConVars[ "OOCDelay" ] - CurTime());
		LEMON.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!");
		
		return "";
		
	end
	
end

function ChangeTitle( ply, text )

ply:ConCommand( "rp_title ".. text );

return "";
	
end

function Advertise( ply, text )

	if(LEMON.ConVars[ "AdvertiseEnabled" ] == "1") then
	
		if( tonumber( LEMON.GetCharField( ply, "money" ) ) >= LEMON.ConVars[ "AdvertisePrice" ] ) then
			
			ply:ChangeMoney( 0 - LEMON.ConVars[ "AdvertisePrice" ] );
		
			for _, pl in pairs(player.GetAll()) do
			
				LEMON.SendChat(pl, "[AD] " .. ply:Nick() .. ": " .. text)
		
			end
			
		else
		
			LEMON.SendChat(ply, "You do not have enough money! You need " .. LEMON.ConVars[ "AdvertisePrice" ] .. " to send an advertisement.");
			
		end	
		
	else
	
		LEMON.ChatPrint(ply, "Advertisements are not enabled");
		
	end
	
	return "";
	
end

function oEvent( ply, text ) --Another O Chat function

	if( ply:IsAdmin() or ply:IsSuperAdmin() ) then --Lets check and see if the player is allowed to use this feature

			for _, ply in pairs(player.GetAll()) do --Now we need to send this event to everyone
			
				LEMON.SendChat(ply, "[EVENT] " .. text) --Send it!
		
			end
	else
	
		LEMON.ChatPrint(ply, "You're not authorized to use this!"); --FAIL THEM IF THEY ARE NOT ADMIN!
		
	end
	
	return "";
	
end

--Otoris's simple write system start
function oWrite( ply, text )

	if ply:GetNWInt("maxoletters") > 4 then
	return
	end

	if text == "" then
	
		LEMON.SendChat( ply, "You need to enter text to write a letter. To go down one line use // " ) --Out put message if they don't enter any text for their letter
	
	else -- Else we go ahead and send the text the player entered to a client side script for display
		
		local ftext = string.gsub(text, "//", "\n") --This will replace the users // with \n This is used for a return/enter symbol
		local length = string.len(ftext) -- This returns the length of the player text, unfortunatly you can only pass through so much text in a NetworkedString :(

		local numParts = math.floor(length / 39) + 1 --As far as I can tell this divides the length of the players text by 39 + 1 the math part rounds to a whole number instead of a decimal
		
		local oletter = ents.Create( "item_letter" ) -- Then create the entity in the world, pretty simple eh? ^_^ LEMON.CreateItem( "letter", ply:CalcDrop( ), Angle( 0,0,0 ) )
		
		oletter:SetModel( "models/props_c17/paper01.mdl" )
		oletter:SetPos( ply:CalcDrop() ) --custom drop vector in this gamemode, use it when droping any type of items/entities	
		oletter:Spawn() --Spawn our entity
		
		--oletter:SetNWString( "letter", text ) --Set the letters contents
		oletter:GetTable().Letter = true
		oletter:SetNWInt("numPts", numParts) --Set the number parts of the letter in a whole number
		oletter:SetNWEntity( "OLetterOwner", ply ) --Sets the owner of the letter. Used for limits and such.
		oletter.ID = ply:SteamID() --Sets the letters ID to the players steam id so we can add a remove letter command later.
		local startpos = 1
		local endpos = 39
		for k=1, numParts do --instead of k, v in pairs the k = 1 and v is replaced by the value of numParts
			oletter:SetNWString("part" .. tostring(k), string.sub(ftext, startpos, endpos)) --This sets the letters text as far as I can tell ^_^
			startpos = startpos + 39
			endpos = endpos + 39
		end
		--print( ply:GetNWString( "pwrite" ) )
	end
	
	return ""
	
end
--Otoris's simple radio :D start
function oSetRadio( ply, text )
	
	if tonumber( text ) >= 30 && tonumber( text ) <= 300 then --Create our frequency limits here they can only enter in the numbers between 30 to 300
		ply:SetNWInt( "pradiostation", tonumber( text ) ) --Set there radio station. We turn the text which is passed as a string to a number so we can preform math and such on it and send it as a Integer instead of a string
		LEMON.SendChat( ply, "You set your radio to station ".. ply:GetNWInt( "pradiostation" ) .."!" ) --Notify the player that they set their radio correctly

	else
	
		LEMON.SendChat( ply, "Station format isn't correct! Station must be a and number must be greater than 99 and less than or equal to 300" ) --Inform them why they fail.
		
	end

	return ""
	
end

function oSendRadio( ply, text )

	if ply:GetNWInt( "pradiostation" ) == nil then --This will tell them their radio station hasn't been set. Because the Integer of the players radio station is equal to nil
	
		LEMON.SendChat( ply, "You haven't set your radio station! Set your station with /setr stationnumberhere " ) --Educate!
		
	end
	
	for k, v in pairs( player.GetAll() ) do --Find all the players
		
		if v:GetNWInt( "pradiostation" ) == ply:GetNWInt( "pradiostation" ) then --Find only the players with the same radio station as the submitter
			
			LEMON.SendChat( v, "[Radio ".. ply:GetNWInt( "pradiostation" ) .."] ".. ply:Nick() ..": ".. text ) --Lets send it to all the players who have their radios set! Also print who is sending the transmission and the station. OH and don't forget the text
		
		end
	end
	
	return ""
	
end
-- end Otoris's simple radio!


function Chat_ModPlayerVars(ply)

	ply.LastOOC = -100000; -- This is so people can talk for the first time without having to wait.
	ply.LastPlaySound = -100000
end

local meta = FindMetaTable( "Player" );

function Dropgun(ply)

	if( not ply:GetActiveWeapon():IsValid() ) then
	
		ply:PrintMessage( 3, "Must have a weapon out" );
		return "";
	
	end

	ply:ConCommand("rp_dropweapon");
	return "";

end

function GiveWeapon( ply, args )

	if( not ply:GetActiveWeapon():IsValid() ) then
	
		ply:PrintMessage( 3, "Must have a weapon out" );
		return "";
	
	end

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 200;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() ) then
	
		if( tr.Entity:EyePos():Distance( ply:EyePos() ) <= 50 ) then
		
			local activeweap = ply:GetActiveWeapon();
			
			ply:StripWeapon( activeweap:GetClass() );

			--Remove weapon
			tr.Entity:GetTable().ForceGive = true;
			tr.Entity:Give( activeweap:GetClass() );
		    tr.Entity:GetTable().ForceGive = false;
		else
		
			ply:PrintMessage( 3, "Not close enough to player" );
		
		end
		
	else
	
		ply:PrintMessage( 3, "Must be looking at a player" );
	
	end
	
	return "";

end

function ccAdminChat( ply, text )
if(!ply:IsAdmin()) then return false; end

for k,v in pairs( player.GetAll() ) do

if( v:IsAdmin() ) then
LEMON.SendChat(v, "[ADMIN] ".. ply:Nick() ..": ".. text )
end

end

return "";

end

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	LEMON.ConVars[ "AdvertiseEnabled" ] = "1"; -- Can players advertise
	LEMON.ConVars[ "AdvertisePrice" ] = 5; -- How much do advertisements cost
	LEMON.ConVars[ "OOCDelay" ] = 2; -- How long do you have to wait between OOC Chat
	LEMON.ConVars[ "LetterPrice" ] = 5 -- Need to make it so if the player has a piece of paper in there inventory it will allow them to write on that paper
	LEMON.ConVars[ "YellRange" ] = 1.5; -- How much farther will yell chat go
	LEMON.ConVars[ "ShoutRange" ] = 1.5 -- How much farther will shout chat go!
	LEMON.ConVars[ "WhisperRange" ] = 0.2; -- How far will whisper chat go
	LEMON.ConVars[ "MeRange" ] = 1.0; -- How far will me chat go
	LEMON.ConVars[ "LOOCRange" ] = 1.0; -- How far will LOOC chat go
	LEMON.ConVars[ "ItRange" ] = 1.0 --How far to send the /it command
	
	LEMON.SimpleChatCommand( "/me", LEMON.ConVars[ "MeRange" ], "*** $1 $3" ); -- Me chat
	LEMON.SimpleChatCommand( "/it", LEMON.ConVars[ "ItRange" ], "*** $3" ) --Cause an event unrelated to yourself to happen such as *** A mouse scurries across the floor.
	LEMON.SimpleChatCommand( "/y", LEMON.ConVars[ "YellRange" ], "$1 [YELL]: $3" ); -- Yell chat
	LEMON.SimpleChatCommand( "/s", LEMON.ConVars[ "ShoutRange" ], "$1 [SHOUT]: $3" ) --Shouting is cooler than yelling ;)
	LEMON.SimpleChatCommand( "/w", LEMON.ConVars[ "WhisperRange" ], "$1 [WHISPER]: $3" ); -- Whisper chat
	LEMON.SimpleChatCommand( ".//", LEMON.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat
	LEMON.SimpleChatCommand( "[[", LEMON.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat

	LEMON.ChatCommand( "/write", oWrite ) --Write a letter!
	LEMON.ChatCommand( "/setr", oSetRadio ) --Set your Radio station with this
	LEMON.ChatCommand( "/event", oEvent ) --Admin event broadcasting
	LEMON.ChatCommand( "/r", oSendRadio ) --Talk into your radio
	LEMON.ChatCommand( "/ad", Advertise ) -- Advertisements
	LEMON.ChatCommand( "/adv", Advertise ); -- Advertisements
	LEMON.ChatCommand( "/ooc", OOCChat ); -- OOC Chat
	LEMON.ChatCommand( "/o", OOCChat ); -- OOC Chat
	LEMON.ChatCommand( "//", OOCChat ); -- OOC Chat
	LEMON.ChatCommand( "/dropgun", Dropgun );
	--LEMON.ChatCommand( "/dropweapon", Dropgun );
	LEMON.ChatCommand( "/givegun", GiveWeapon ); --Give the player you are facing the weapon in your hand
	LEMON.ChatCommand( "/a", ccAdminChat ); --All hail admin chat!
	LEMON.ChatCommand( "/title", ChangeTitle ); --Set your title, note that it does allow spaces if you have quotes around your title
	
	LEMON.AddHook("Player_Preload", "chat_modplayervars", Chat_ModPlayerVars); -- Put in our OOCDelay variable

end

