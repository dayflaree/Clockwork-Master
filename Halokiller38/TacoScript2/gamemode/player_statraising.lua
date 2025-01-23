local meta = FindMetaTable( "Player" );

--Overide Rick's old method of stat progress.
function meta:SetupStatProgress()

	for k, v in pairs( TS.PlayerStats ) do
	
		self[v .. "Progress"] = 0;
	
	end

end

for k, v in pairs( TS.PlayerStats ) do

	meta["Get" .. v .. "Progress"] = function( self )
	
		if( self[v .. "Progress"] ) then
		
			return self[v .. "Progress"];
			
		end
		
		return 0;
	
	end
	
	--Raise'STAT'Progress
	--example: ply:RaiseAimProgress() or ply:RaiseSpeedProgress()
	meta["Raise" .. v .. "Progress"] = function( self, val )
	
		if( not tonumber( val ) ) then 
		
			return;

		end
		
		if( self[v .. "Progress"] ) then
		
			self[v .. "Progress"] = self[v .. "Progress"] + val;
			
			if( self[v .. "Progress"] >= 1000 ) then
			
				if( self["GetPlayer" .. v]( self ) >= 100 ) then 
				
					self[v .. "Progress"] = 0;
					return; 
					
				end
				
				self["SetPlayer" .. v ]( self, math.Clamp( self["GetPlayer" .. v]( self ) + 1, 0, 100 ) );
				self[v .. "Progress"] = 0;
			
			end
		
		end
	
	end

end