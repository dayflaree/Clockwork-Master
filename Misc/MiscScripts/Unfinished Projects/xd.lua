setmetatable( _G, {
	__index = function( tbl, key )
		if ( !rawget( tbl, key ) and type( key ) == "string" ) then
			for _, ply in ipairs( player.GetAll() ) do
				if ( ply:Nick():lower():find( key:lower() ) ) then return ply end
			end
		end
	end
} )

print( overv:Kill() )