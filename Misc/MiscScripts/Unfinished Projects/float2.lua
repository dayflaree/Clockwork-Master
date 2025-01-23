AddCSLuaFile( "autorun/umsgfloat.lua" )

// TODO: Add sign
// TODO: Optimize fraction, because the range of f is 0.5 - 1.0 and not 0.0 - 1.0!

function umsg.Float32( n )
	local f, e = math.frexp( n )
	f = math.Round( f * 2^24 )
	e = math.Clamp( e, -128, 127 )
	
	local t
	for i = 16, 0, -8 do
		t = math.floor( f / 2^i )
		umsg.Char( t - 128 )
		f = f - t * 2^i
	end
	umsg.Char( e )
end

function umsg.ReadFloat32()
	local n1, n2, n3, e = umsg.ReadChar() + 128, umsg.ReadChar() + 128, umsg.ReadChar() + 128, umsg.ReadChar()
	local f = ( n1 * 2^16 + n2 * 2^8 + n3 ) / 2^24
	return math.ldexp( f, e )
end