local function float32( n )
	local f, e = math.frexp( n )
	return math.Round( f * 2^23 ), math.Clamp( e, -127, 128 ) + 127
end

local function float32inv( f, e )
	return math.ldexp( f / 2^23, e - 127 )
end

print( float32inv( float32( -math.pi ) ) )
print( -math.pi )