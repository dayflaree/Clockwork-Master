function table.Compare( tbl1, tbl2 )
	for k, v in pairs( tbl1 ) do
		if ( type(v) == "table" and type(tbl2[k]) == "table" ) then
			if ( !table.Compare( v, tbl2[k] ) ) then return false end
		else
			if ( v != tbl2[k] ) then return false end
		end
	end
	for k, v in pairs( tbl2 ) do
		if ( type(v) == "table" and type(tbl1[k]) == "table" ) then
			if ( !table.Compare( v, tbl1[k] ) ) then return false end
		else
			if ( v != tbl1[k] ) then return false end
		end
	end
	return true
end

print( table.Compare( {1,2,3}, {1,2,3} ) )
print( table.Compare( {1,2,3}, {1,2,4} ) )
print( table.Compare( {1,2,3}, {1,2,3,4} ) )
print( table.Compare( {1,2,3,4}, {1,2,3} ) )

print( table.Compare( {1,2,3}, {1,2,3,{4,5}} ) )
print( table.Compare( {1,2,3,{4,5}}, {1,2,3,{4,5}} ) )
print( table.Compare( {1,2,3,{4,5}}, {1,2,3,{4,6}} ) )
print( table.Compare( {1,2,3,{4,5}}, {1,2,3,{4,5,6}} ) )
print( table.Compare( {1,2,3,{4,5,6}}, {1,2,3,{4,5}} ) )