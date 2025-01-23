gle = {}

local encoders
encoders = {
	["string"] = function( value )
		value = value:gsub( "\n", "\\n" )
		value = value:gsub( "\t", "\\t" )
		value = value:gsub( "\"", "\\\"" )
		return "\"" .. value .. "\""
	end,
	["number"] = function( value )
		if ( math.abs( value ) == math.huge ) then error( "math.huge is not a supported numeric type!" ) end
		return value
	end,
	["boolean"] = function( value )
		return value and "true" or "false"
	end,
	["table"] = function( value, indent )
		local output, encoder
		
		local array, count = true, 0
		for k, v in pairs( value ) do
			count = count + 1
			if ( k != count ) then array = false break end
		end
		
		if ( array ) then
			output = "[\n"
			
			for i = 1, count do
				encoder = encoders[ type( value[i] ) ]
				if ( !encoder ) then error( "No encoder found for type " .. type( value[i] ) .. "!" ) end
				
				output = output .. string.rep( "\t", indent + 1 ) .. encoder( value[i], indent + 1 ) .. ( i < count and "," or "" ) .. "\n"
			end
			
			return output .. string.rep( "\t", indent ) .. "]"
		else
			output = "{\n"
			
			count = 0
			for key, val in pairs( value ) do
				encoder = encoders[ type( val ) ]
				if ( !encoder ) then error( "No encoder found for type " .. type( val ) .. "!" ) end
				
				output = output .. string.rep( "\t", indent + 1 ) .. "\"" .. tostring( key ) .. "\": " .. encoder( val, indent + 1 ) .. ",\n"
				count = count + 1
			end
			if ( count > 0 ) then output = output:Left( #output - 2 ) .. "\n" end
			
			return output .. string.rep( "\t", indent ) .. "}"
		end
	end
}

function gle.encode( tbl )
	return encoders["table"]( tbl, 0 )
end

local tbl = {
	"Hello, world!",
	math.pi,
	true,
	false,
	{
		"test\nhaha	",
		"haha",
		"lol",
		{
			"Hello",
			"World",
			math.pi
		},
		"trolol",
		{
			"one",
			"two",
			"three",
			["test"] = 123,
		}
	}
}

file.Write( "gleoutput.txt", gle.encode( evolve.PlayerInfo ) )