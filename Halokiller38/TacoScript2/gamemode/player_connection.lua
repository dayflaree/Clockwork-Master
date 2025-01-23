
local meta = FindMetaTable( "Player" );

function meta:Disconnect()

	self:ConCommand( "disconnect\n" );

end 

function meta:Kick( reason, name )

	local chat = "";
	
	if( name ) then
	
		if( reason and string.gsub( reason, " ", "" ) ~= "" ) then
			chat = name .. " kicked " .. self:GetRPName() .. ": " .. reason;
		else
			chat = name .. " kicked " .. self:GetRPName();
		end
	
	else
	
		if( reason and string.gsub( reason, " ", "" ) ~= "" ) then
			chat = self:GetRPName() .. " was kicked: " .. reason;
		else
			chat = self:GetRPName() .. " was kicked";
		end
		
	end
	
	SendOverlongMessage(0, TS.MessageTypes.KICK.id, chat, nil)
	
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
			chat = name .. " banned " .. self:GetRPName() .. " for " .. time .. " minutes: " .. oreason;
		else
			chat = name .. " banned " .. self:GetRPName() .. " for " .. time .. " minutes";
		end
		
	else

		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = self:GetRPName() .. " was banned for " .. time .. " minutes: " .. oreason;
		else
			chat = self:GetRPName() .. " was banned for " .. time .. " minutes";
		end
	
	end
	
	SendOverlongMessage(0, TS.MessageTypes.MISC.id, chat, nil)

	game.ConsoleCommand( "banid " .. time .. " " .. self:SteamID() .. "\n" );
	game.ConsoleCommand( "writeid\n" );
	
	game.ConsoleCommand( "kickid \"" .. self:UserID() .. "\" \"" .. reason .. "\"\n" );

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
			chat = name .. " permanently banned " .. self:GetRPName() .. ": " .. oreason;
		else
			chat = name .. " permanently banned " .. self:GetRPName();
		end
		
	else
	
		if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
			chat = self:GetRPName() .. " was permanently banned: " .. oreason;
		else
			chat = self:GetRPName() .. " was permanently banned";
		end
	
	end
	
	if( oreason and string.gsub( oreason, " ", "" ) ~= "" ) then
	
		reason = reason .. ": " .. oreason;
	
	end
	
	SendOverlongMessage(0, TS.MessageTypes.MISC.id, chat, nil)
	
	game.ConsoleCommand( "banid 0 " .. self:SteamID() .. "\n" );
	game.ConsoleCommand( "writeid\n" );
	
	game.ConsoleCommand( "kickid \"" .. self:UserID() .. "\" \"" .. reason .. "\"\n" );


end