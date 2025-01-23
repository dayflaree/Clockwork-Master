
local meta = FindMetaTable( "Player" );

function meta:SayGlobalChat( text )
	
 	umsg.Start( "GC" );
		umsg.String( self:RPNick() );
		umsg.String( text );
	umsg.End();

end


function meta:PrintBlueMessage( text )

	umsg.Start( "PBM", self );
		umsg.String( text );
	umsg.End();

end


function PrintMaintMessage( text )

	umsg.Start( "PMaM" );
		umsg.String( text );
	umsg.End();

end


function meta:ChatToAdmins( msg )

	local rec = RecipientFilter();
	
	if( not self:HasAnyAdminFlags() ) then
	
		rec:AddPlayer( self );
		self:PrintMessage( 2, "[TO ADMINS]" .. self:RPNick() .. "(" .. self:SteamID() .. "): " .. msg );
	
	end
	
	for k, v in pairs( player.GetAll() ) do
	
		if( v:HasAnyAdminFlags() ) then
		
			rec:AddPlayer( v );
			v:PrintMessage( 2, "[TO ADMINS]" .. self:RPNick() .. "(" .. self:SteamID() .. "): " .. msg );
		
		end
	
	end
	
	umsg.Start( "ac", rec );
		umsg.String( self:RPNick() );
		umsg.String( msg );
	umsg.End();

end

function meta:SendPM( name, msg )

	local result, ret = SearchPlayerName( name );
	
	if( result ) then
		
		local rec = RecipientFilter();
		
		if( self ~= ret ) then
		
			rec:AddPlayer( self );
			
		end
		
		ret.LastPMTarget = self;
		
		rec:AddPlayer( ret );
	
		umsg.Start( "PMM", rec );
			umsg.String( "[TO: " .. ret:RPNick() .. "]" .. self:RPNick() .. ": " .. msg ); 
		umsg.End();
		
		
		ret:PrintMessage( 2,  "[TO: " .. ret:RPNick() .. "]" .. self:RPNick() .. ": " .. msg );
		self:PrintMessage( 2,  "[TO: " .. ret:RPNick() .. "]" .. self:RPNick() .. ": " .. msg );
	
	else
	
		self:PrintBlueMessage( ret );
	
	end

end

function meta:NarrateChatAction( text, loud )

	if( not self:Alive() ) then
		return;
	end

	local tbl = ents.FindInSphere( self:GetPos(), loud and 550 or 240 );
	
	local descname = "[" .. string.sub( self:GetPlayerPhysDesc(), 1, 25 ) .. "..]";

	local rec = RecipientFilter();
	local rec2 = RecipientFilter();

	for k, v in pairs( tbl ) do
	
		if( v:IsPlayer() ) then
		
			if( ( self:GetTable().Recognized[v:SteamID() .."+" .. v:GetPlayerMySQLCharID()] and v:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == v ) then
			
				rec:AddPlayer( v );
				
				v:PrintMessage( 2, "[" .. self:GetRPName() .. "]" .. text );

			else
			
				rec2:AddPlayer( v );
				
				v:PrintMessage( 2, descname .. " " .. text );
			
			end
		
		end	
		
	end
	
	if( loud ) then
		umsg.Start( "lit", rec );
	else
		umsg.Start( "it", rec );
	end
		umsg.String( text );
	umsg.End();
	
	if( loud ) then
		umsg.Start( "lit", rec2 );
	else
		umsg.Start( "it", rec2 );
	end
		umsg.String( text );
	umsg.End();	
		

end

function meta:SayLocalChat( text, area, msg, nonamefilter, nosemicolon, radio, broadcast )
	
	if( not self:Alive() ) then
		return;
	end
	
	if( area > 90 ) then
	
		self:GetTable().LastSpokeIC = CurTime();
	
	end
	
	local lookAtPly = nil;
	local tr = self:GetEyeTrace();
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
		
		lookAtPly = tr.Entity;
		
	end
	
	local tbl = { }
	
	for k, v in pairs( player.GetAll() ) do
	
		if( v:GetPos():Distance( self:GetPos() ) <= area ) then
		
			table.insert( tbl, v );
		
		end
		
	end

	local rec = RecipientFilter();

	if( nonamefilter ) then
	
		for k, v in pairs( tbl ) do
		
			if( v:IsPlayer() ) then
			
				rec:AddPlayer( v );
				
				if( nosemicolon ) then
					
					v:PrintMessage( 2, self:GetRPName() .. "(" .. self:SteamID() .. ") " .. text );
			
				else
				
					v:PrintMessage( 2, self:GetRPName() .. "(" .. self:SteamID() .. "): " .. text );
				
				end
			
			end
			
		end
		
		umsg.Start( msg, rec );
			umsg.String( self:GetRPName() );
			umsg.String( text );
			umsg.Entity( lookAtPly );
		umsg.End();
	
	else
	
		local descname = "[" .. string.sub( self:GetPlayerPhysDesc(), 1, 25 ) .. "..]";
	
		local rec2 = RecipientFilter();
	
		for k, v in pairs( tbl ) do
		
			if( v:IsPlayer() ) then
			
				if( ( self:GetTable().Recognized[v:SteamID() .."+" .. v:GetPlayerMySQLCharID()] and v:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == v ) then
				
					rec:AddPlayer( v );
					
					if( nosemicolon ) then
					
						v:PrintMessage( 2, self:GetRPName() .. "(" .. self:SteamID() .. ") " .. text );
					
					else
					
						v:PrintMessage( 2, self:GetRPName() .. "(" .. self:SteamID() .. "): " .. text );
				
					end
		
				else
				
					rec2:AddPlayer( v );
					
					if( nosemicolon ) then
					
						v:PrintMessage( 2, descname .. "(" .. self:SteamID() .. ") " .. text );
					
					else
					
						v:PrintMessage( 2, descname .. "(" .. self:SteamID() .. "): " .. text );
				
					end
				
				end
			
			end
			
		end	
		
		umsg.Start( msg, rec );
			umsg.String( self:GetRPName() );
			umsg.String( text );
			umsg.Entity( lookAtPly );
		umsg.End();
		
		umsg.Start( msg, rec2 );
			umsg.String( descname );
			umsg.String( text );
			umsg.Entity( lookAtPly );
		umsg.End();	
	
		if( radio ) then
		
			local f = function() 
		
				local rec = RecipientFilter();
				local rec2 = RecipientFilter();
				
				for k, v in pairs( player.GetAll() ) do
				
					if( v:HasItem( "radio" ) and v.CurRadioFreq == self.CurRadioFreq ) then
					
						if( ( self:GetTable().Recognized[v:SteamID() .. "+" .. v:GetPlayerMySQLCharID()] and v:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == v ) then
						
							rec:AddPlayer( v );
							v:PrintMessage( 2, "@" .. v.CurRadioFreq .. " - "  .. self:GetRPName() .. ": " .. text );
						
						else
						
							rec2:AddPlayer( v );
							v:PrintMessage( 2, "@" .. v.CurRadioFreq .. " - "  .. descname .. ": " .. text );
						
						end
					
					end
				
				end
				
				umsg.Start( "r", rec );
					umsg.String( self:GetRPName() );
					umsg.String( text );
				umsg.End();
				
				umsg.Start( "r", rec2 );
					umsg.String( descname );
					umsg.String( text );
				umsg.End();	
				
				for _, v in pairs( ents.FindByClass( "epd_item" ) ) do
					
					if( v.ItemID == "broadcastradio" ) then
						
						local rec = RecipientFilter();
						local rec2 = RecipientFilter();
						
						for _, n in pairs( ents.FindInSphere( v:GetPos(), 240 ) ) do
							
							if( n:IsPlayer() ) then
								
								if( ( self:GetTable().Recognized[n:SteamID() .. "+" .. n:GetPlayerMySQLCharID()] and n:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == n ) then
									
									rec:AddPlayer( n );
									n:PrintMessage( 2, "Broadcast Radio @" .. self.CurRadioFreq .. " - "  .. self:GetRPName() .. ": " .. text );
									
								else
									
									rec2:AddPlayer( n );
									n:PrintMessage( 2, "Broadcast Radio @" .. self.CurRadioFreq .. " - "  .. descname .. ": " .. text );
									
								end
								
							end
							
						end
						
						umsg.Start( "br", rec );
							umsg.String( self:GetRPName() );
							umsg.String( text );
						umsg.End();
						
						umsg.Start( "br", rec2 );
							umsg.String( descname );
							umsg.String( text );
						umsg.End();	
						
					end
					
				end
			
			end
			
			timer.Simple( .2, f );	
				
		end
		
		if( broadcast ) then
		
			local f = function() 
		
				local rec = RecipientFilter();
				local rec2 = RecipientFilter();
				
				for k, v in pairs( player.GetAll() ) do
				
					if( v:HasItem( "radio" ) ) then
					
						if( ( self:GetTable().Recognized[v:SteamID() .. "+" .. v:GetPlayerMySQLCharID()] and v:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == v ) then
						
							rec:AddPlayer( v );
							v:PrintMessage( 2, "@" .. v.CurRadioFreq .. " - "  .. self:GetRPName() .. ": " .. text );
						
						else
						
							rec2:AddPlayer( v );
							v:PrintMessage( 2, "@" .. v.CurRadioFreq .. " - "  .. descname .. ": " .. text );
						
						end
					
					end
				
				end
				
				umsg.Start( "r", rec );
					umsg.String( self:GetRPName() );
					umsg.String( text );
				umsg.End();
				
				umsg.Start( "r", rec2 );
					umsg.String( descname );
					umsg.String( text );
				umsg.End();
				
				for _, v in pairs( ents.FindByClass( "epd_item" ) ) do
					
					if( v.ItemID == "broadcastradio" ) then
						
						local rec = RecipientFilter();
						local rec2 = RecipientFilter();
						
						for _, n in pairs( ents.FindInSphere( v:GetPos(), 240 ) ) do
							
							if( n:IsPlayer() ) then
								
								if( ( self:GetTable().Recognized[n:SteamID() .. "+" .. n:GetPlayerMySQLCharID()] and n:GetTable().Recognized[self:SteamID() .. "+" .. self:GetPlayerMySQLCharID()] ) or self == n ) then
									
									rec:AddPlayer( n );
									n:PrintMessage( 2, "Broadcast Radio @" .. self.CurRadioFreq .. " - "  .. self:GetRPName() .. ": " .. text );
									
								else
									
									rec2:AddPlayer( n );
									n:PrintMessage( 2, "Broadcast Radio @" .. self.CurRadioFreq .. " - "  .. descname .. ": " .. text );
									
								end
								
							end
							
						end
						
						umsg.Start( "br", rec );
							umsg.String( self:GetRPName() );
							umsg.String( text );
						umsg.End();
						
						umsg.Start( "br", rec2 );
							umsg.String( descname );
							umsg.String( text );
						umsg.End();	
						
					end
					
				end
			
			end
			
			timer.Simple( .2, f );	
				
		end
	
	end

end

Sentences = { };

Sentences["Short"] = {
	"hi01",
	"hi02",
	"ok01",
	"ok02",
	"no01",
	"no02",
	"ow01",
	"ow02",
}

Sentences["Med"] = {
	"question20",
	"question21",
	"question25",
	"question27",
	"question29",
	"question30",
	"question01",
	"question07",
	"question08",
	"question12",
	"question13",
	"question15",
	"question18",
	"question19",
}

Sentences["Long"] = {
	"question02",
	"question04",
	"question06",
	"question09",
	"question10",
	"question11",
	"question14",
	"gordead_ques15",
	"abouttime02",
}

function PlaySentence( ply, len )
	
	if( len < 10 ) then
		
		ply:EmitSound( "vo/npc/male01/" .. table.Random( Sentences["Short"] ) .. ".wav", 1, 100 );
		
	elseif( len < 30 ) then
		
		ply:EmitSound( "vo/npc/male01/" .. table.Random( Sentences["Med"] ) .. ".wav", 1, 100 );
		
	else
		
		ply:EmitSound( "vo/npc/male01/" .. table.Random( Sentences["Long"] ) .. ".wav", 1, 100 );
		
	end
	
end

function ccConSay( ply, cmd, args )
	
	if( not ply ) then
		
		local str = string.Implode( " ", args );
		umsg.Start( "CSAY" );
			umsg.String( str );
		umsg.End();
		
	end
	
end
concommand.Add( "csay", ccConSay );

function GM:PlayerSay( ply, text )
	
	if( ply:GetTable().CanNextChat > CurTime() ) then
	
		return "";
	
	end
	
	ply:GetTable().CanNextChat = CurTime() + .3;

	local correctcmd = nil;
	local crntlen;
	
	for k, v in pairs( ChatCommands ) do
	
		local len = string.len( v.cmd );
		local chatsub = string.sub( text, 1, len );
		
		if( string.lower( chatsub ) == string.lower( v.cmd ) ) then
		
			if( correctcmd ) then
			
				if( crntlen < len ) then
				
					correctcmd = k;
					crntlen = len;
				
				end
			
			else
			
				correctcmd = k;
				crntlen = len;
		
			end
		
		end
	
	end

	if( correctcmd ) then
	
		local ret = ( ChatCommands[correctcmd].cb( ply, ChatCommands[correctcmd].cmd, string.sub( text, crntlen + 1 ) ) or "" );	
	
		if( ret ~= "" and ret ~= " " ) then
		
			ply:SayGlobalChat( ret );
			return "(" .. ply:RPNick() .. ") " .. ret;
			
		end
		
		return "";
	
	elseif( string.sub( text, 1, 1 ) == "/" ) then
	
		return "";
	
	end
	
	ply:SayLocalChat( text, 240, "ic" );
	PlaySentence( ply, string.len( text ) );
	
	return "";

end