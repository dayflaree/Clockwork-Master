local function sqr( n ) return n*n end
local sqrt = math.sqrt

local function intersectOverv(s,d,c,r)
	s = s - c;

	local discriminant = sqr( 2 * s:Dot( d ) ) - 4 * d:Dot( d ) * ( s:Dot( s ) - sqr( r ) );

	local n1 = ( -2 * s:Dot( d ) + sqrt( discriminant ) ) / ( 2 * d:Dot( d ) );
	local n2 = ( -2 * s:Dot( d ) - sqrt( discriminant ) ) / ( 2 * d:Dot( d ) );

	local s1 = s + d * n1 + c;
	local s2 = s + d * n2 + c;
	
	return s1,s2
end

print( intersectOverv( Vector( 0, 0, 5 ), Vector( 0, 0, 1 ), Vector( 0, 0, 0 ), 3 ) )