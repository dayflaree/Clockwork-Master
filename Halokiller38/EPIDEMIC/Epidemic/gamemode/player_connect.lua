
local meta = FindMetaTable( "Player" );

function meta:Kick( reason, name )
	
	local chat = "";
	
	if( name ) then
	
		if( reason and string.gsub( reason, " ", "" ) ~= "" ) then
			chat = name .. " kicked " .. self:Nick() .. ": " .. reason;
		else
			chat = name .. " kicked " .. self:Nick();
		end
	
	else
	
		if( reason and string.gsub( reason, " ", "" ) ~= "" ) then
			chat = self:Nick() .. " was kicked: " .. reason;
		else
			chat = self:Nick() .. " was kicked";
		end
		
	end
	
	if( not reason ) then
	
		reason = "";
	
	end
	
	umsg.Start( "MiscCon" );
		umsg.String( chat );
	umsg.End();

	game.ConsoleCommand( "kickid \"" .. self:UserID() .. "\" \"" .. reason .. "\"\n" );

end

function meta:Ban( time, reason, name )
	
	if( time < 1 ) then

		self:PermaBan( reason, name );
		return;

	end

	local oreason = reason;
	local chat = "";
	
	if( name ) then
	
		reason = "Banned by " .. name .. " for " .. time .. " minutes";

	else
	
		reason = "Banned for " .. time .. " minutes";			
	
	end

	
	if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
	
		reason = reason .. ": " .. oreason;
	
	end

	if( name ) then

		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = name .. " banned " .. self:Nick() .. " for " .. time .. " minutes: " .. oreason;
		else
			chat = name .. " banned " .. self:Nick() .. " for " .. time .. " minutes";
		end
		
	else

		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = self:Nick() .. " was banned for " .. time .. " minutes: " .. oreason;
		else
			chat = self:Nick() .. " was banned for " .. time .. " minutes";
		end
	
	end
	
	umsg.Start( "MiscCon" );
		umsg.String( chat );
	umsg.End();

	
	if( not reason ) then
	
		reason = "";
	
	end

	game.ConsoleCommand( "banid " .. time .. " " .. self:SteamID() .. "\n" );
	game.ConsoleCommand( "writeid\n" );
	
	game.ConsoleCommand( "kickid \"" .. self:UserID() .. "\" \"" .. reason .. "\"\n" );

end

function BanOffline( time, sid, banner )
	
	local chat = "";
	
	if( time < 1 ) then

		if( banner ) then
			
			chat = banner .. " permanently banned SteamID " .. sid;
			
		else
			
			chat = "SteamID " .. sid .. " was permanently banned";
			
		end

	else
		
		if( banner ) then
			
			chat = banner .. " banned SteamID " .. sid .. " for " .. time .. " minutes";
			
		else
			
			chat = "SteamID " .. sid .. " was banned for " .. time .. " minutes";
			
		end
		
	end
	
	umsg.Start( "MiscCon" );
		umsg.String( chat );
	umsg.End();
	
	game.ConsoleCommand( "banid " .. time .. " " .. sid .. "\n" );
	game.ConsoleCommand( "writeid\n" );

end

function meta:PermaBan( reason, name )

	local oreason = reason;
	local chat = "";

	if( name ) then
	
		reason = "Permanently banned by " .. name;

	else
	
		reason = "Permanently banned";			
	
	end

	if( name ) then

		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = name .. " permanently banned " .. self:Nick() .. ": " .. oreason;
		else
			chat = name .. " permanently banned " .. self:Nick();
		end
		
	else
	
		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = self:Nick() .. " was permanently banned: " .. oreason;
		else
			chat = self:Nick() .. " was permanently banned";
		end
	
	end
	
	if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
	
		reason = reason .. ": " .. oreason;
	
	end
	
	umsg.Start( "MiscCon" );
		umsg.String( chat );
	umsg.End();
	
	game.ConsoleCommand( "banid 0 " .. self:SteamID() .. "\n" );
	game.ConsoleCommand( "writeid\n" );
	
	game.ConsoleCommand( "kickid \"" .. self:UserID() .. "\" \"" .. reason .. "\"\n" );


end
