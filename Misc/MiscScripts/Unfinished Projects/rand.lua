local t = os.time()

function math.randomseed( seed )
	t = seed
end

function math.random( a, b )
	if ( a and !b ) then
		return math.random( 1, a )
	elseif ( a and b ) then
		return math.floor( math.random() * ( b - a ) + a )
	else	
		t = 324238247 * t % 10000000
		return t / 10000000
	end
end

math.randomseed( 1337 )

for i = 1, 10 do
	print( math.random( 100 ) )
end