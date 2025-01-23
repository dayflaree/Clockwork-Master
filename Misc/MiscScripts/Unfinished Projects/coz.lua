local function f( n )
	local product = n
	for i = n - 1, 1, -1 do
		product = product * i
	end
	return product
end

local function sin( x )
	return x - x^3/f(3) + x^5/f(5) - x^7/f(7) + x^9/f(9) - x^11/f(11) + x^13/f(13) - x^15/f(15) + x^17/f(17) - x^19/f(19) + x^21/f(21) - x^23/f(23) + x^25/f(25) - x^27/f(27) + x^29/f(29) - x^31/f(31) + x^33/f(33) - x^35/f(35) + x^37/f(37) - x^39/f(39) + x^41/f(41) - x^43/f(43)
end

local function cos( x )
	return sin( x + math.pi / 2 )
end

for ang = 0, math.pi * 2, math.pi / 12 do
	print( cos( ang ) )
end