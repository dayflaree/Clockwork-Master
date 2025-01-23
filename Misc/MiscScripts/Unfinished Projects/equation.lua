function Equation( formula )
	RunString( "function _f( x ) return " .. string.sub( formula, 3 ) .. " end" )
	
	local f = _f
	_f = nil
	return f
end

local f = Equation( "y=x^2+3" )
print( f( 3 ) )