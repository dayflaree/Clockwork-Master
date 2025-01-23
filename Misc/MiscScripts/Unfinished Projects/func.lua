local function foo()
	local tau = math.pi * 2
	print( math.cos( tau ) * 1337 )
end

function debug.getsource( f )
	local i = debug.getinfo( f )
	if ( i.linedefined ) then
		local lines = string.Explode( "\n", file.Read( i.short_src, true ) )
		return table.concat( lines, "\n", i.linedefined, i.lastlinedefined )
	end
end

print( debug.getsource( foo ) )
PrintTable( debug.getinfo( foo ) )