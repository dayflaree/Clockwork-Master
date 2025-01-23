gle = {}

local encoders = {
	["number"] = function( value )
		return value
	end,
	["string"] = function( value )
		return "\"" .. value .. "\""
	end,
	["boolean"] = function( value )
		return value and "true" or "false"
	end
}

function gle.encode( tbl )
	local output = "{\n"
	local encoder
	
	for k, v in pairs( tbl ) do
		encoder = encoders[ type( v ) ]
		
		if ( !encoder ) then
			error( string.format( "No encoder found for type %s!", type( v ) ) )
		end
		
		output = output .. "\t\"" .. tostring( k ) .. "\": " .. encoder( v ) .. ",\n"
	end
	output = output:sub( 0, #output - 2 ) .. "\n"
	
	return output .. "}"
end

print( gle.encode
	{
		"Hello, world!",
		math.pi,
		true,
		false,
		{
		}
	}
)