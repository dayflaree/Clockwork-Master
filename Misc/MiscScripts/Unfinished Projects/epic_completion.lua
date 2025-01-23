function printStuff( com, ply, args )
	print( table.concat( args, " " ) )
end

function completePrintStuff( com, arg )
	local suggestions = {}
	for i = 97, 122 do
		table.insert( suggestions, arg .. string.char( i ) )
	end
	return suggestions
end
concommand.Add( "printstuff", printStuff, completePrintStuff )