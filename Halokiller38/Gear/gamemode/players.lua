
function CreatePlayersMetaTable()

	Players = { }
	
	local meta = FindMetaTable( "Player" );
	
	for k, v in pairs( meta ) do
		
		if( type( meta[k] ) == "function" ) then
		
			Players[k] = function( self, ... )
				
				local arg = {...}; -- fuck you azuisleet
				
				for n, m in pairs( player.GetAll() ) do
			
					m[k]( m, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8] );
				
				end
			
			end
		
		end
		
	end
	
	local meta = FindMetaTable( "Entity" );
	
	for k, v in pairs( meta ) do
		
		if( type( meta[k] ) == "function" ) then
		
			Players[k] = function( self, ... )
		
				for n, m in pairs( player.GetAll() ) do
			
					m[k]( m, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8] );
				
				end
			
			end
		
		end
		
	end
	
end
