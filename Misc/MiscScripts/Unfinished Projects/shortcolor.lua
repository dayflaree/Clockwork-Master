local function compressBytes( a, b, c )
	local n = math.floor( a/8 ) + 32 * math.floor( b/8 ) + 1024 * math.floor( c/8 )
	return math.floor( n / 256 ), n % 256
end

local function decompressBytes( b1, b2 )
	local n, b, c = b1 * 256 + b2
	c = math.floor( n / 1024 )	n = n - c * 1024
	b = math.floor( n / 32 )	n = n - b * 32
	return n*8, b*8, c*8
end

local a, b, c = math.random( 255 ), math.random( 255 ), math.random( 255 )
print( a, b, c )
print( compressBytes( a, b, c ) )
print( decompressBytes( compressBytes( a, b, c ) ) )