
local meta = FindMetaTable( "Player" );

SSPlayerVars = { }

function CreatePlayerSSVariable( name, value )

	if( SERVER ) then
	
		SSPlayerVars[name] = { value = value };
	
		meta["SetPlayer" .. name] = function( self, val )

			if( self:GetTable()[name] ~= val ) then
			
				local update = true;
			
				if( meta["OnUpdatePlayer" .. name] ) then
				
					update = meta["OnUpdatePlayer" .. name]( self, self:GetTable()[name], val ) or true;
				
				end

				if( update ) then
			
					local oldval = self:GetTable()[name];
					self:GetTable()[name] = val;

					if( self["OnUpdatedPlayer" .. name] ) then
					
						self["OnUpdatedPlayer" .. name]( self, oldval, self:GetTable()[name] );
					
					end
					
				end
				
			end
	
		end
		
		meta["GetPlayer" .. name] = function( self )
		
			return self:GetTable()[name];
		
		end
	
	end

end

PlayerVars = { }

function CreatePlayerVariable( name, type, default, canreset )

	if( SERVER ) then
	
		if( default ~= nil ) then
		
			PlayerVars[name] = { default = default, canreset = canreset };
		
		end

		meta["SetPlayer" .. name] = function( self, val )
			
			if( val == nil ) then return; end
			
			if( not self:GetTable().Vars ) then
				
				self:GetTable().Vars = { }
			
			end
			
			if( self:GetTable().Vars[name] ~= val ) then
			
				local update = true;
			
				if( self["OnUpdatePlayer" .. name] ) then
				
					update = self["OnUpdatePlayer" .. name]( self, self:GetTable().Vars[name], val ) or true;
				
				end
			
				if( update ) then
					
					local oldval = self:GetTable().Vars[name];
					self:GetTable().Vars[name] = val;
					
					umsg.Start( "R" .. name, self );
						umsg[type]( val );
					umsg.End();
					
					if( self["OnUpdatedPlayer" .. name] ) then
					
						self["OnUpdatedPlayer" .. name]( self, oldval, self:GetTable().Vars[name] );
					
					end
					
				end
				
			end
	
		end
		
		meta["GetPlayer" .. name] = function( self )
		
			if( not self:GetTable().Vars ) then
				
				self:GetTable().Vars = { }
			
			end
		
			return self:GetTable().Vars[name];
		
		end
		
	end
	
	if( CLIENT ) then
	
		if( not ClientVars ) then
			
			ClientVars = { }
		
		end
		
		if( default ~= nil ) then
		
			ClientVars[name] = default;
			PlayerVars[name] = { default = default, canreset = canreset };

		end
	
		local function setvar( msg )

			local val =  msg["Read" .. type]( msg );	
			local oldval = ClientVars[name];
			
			ClientVars[name] = val;
	
			if( _G["OnUpdatedPlayer" .. name] ) then
			
				_G["OnUpdatedPlayer" .. name]( oldval, val );
			
			end	
		
		end
		usermessage.Hook( "R" .. name, setvar );
	
	end

end

function FormatLine( str, font, size )

	local start = 1;
	local c = 1;
	
	surface.SetFont( font );
	
	local endstr = "";
	local n = 0;
	local lastspace = 0;
	local lastspacemade = 0;
	
	while( string.len( str ) > c ) do
	
		local sub = string.sub( str, start, c );
	
		if( string.sub( str, c, c ) == " " ) then
			lastspace = c;
		end

		if( surface.GetTextSize( sub ) >= size and lastspace ~= lastspacemade ) then
			
			local sub2;
			
			if( lastspace == 0 ) then
				lastspace = c;
				lastspacemade = c;
			end
			
			if( lastspace > 1 ) then
				sub2 = string.sub( str, start, lastspace - 1 );
				c = lastspace;
			else
				sub2 = string.sub( str, start, c );
			end
			
			endstr = endstr .. sub2 .. "\n";
			
			lastspace = c + 1;
			lastspacemade = lastspace;
			
			start = c + 1;
			n = n + 1;
		
		end
	
		c = c + 1;
	
	end
	
	if( start < string.len( str ) ) then
	
		endstr = endstr .. string.sub( str, start );
	
	end
	
	return endstr, n;

end

CurrentMap = nil;

function GetMap()
	
	if( !CurrentMap ) then
		
		CurrentMap = game.GetMap();
		
	end
	
	return CurrentMap;

end


