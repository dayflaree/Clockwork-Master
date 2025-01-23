function planeLineIntersection( planePoint, planeNormal, linePoint, lineDirection )
	local d = ( planePoint - linePoint ):Dot( planeNormal ) / lineDirection:Dot( planeNormal )
	
	if ( d == 0 ) then
		return false
	else
		return d * lineDirection + linePoint
	end
end

print( planeLineIntersection( vector_origin + Vector( 3, 5, 1 ), Vector( 0, 0, 1 ), Vector( 0, 0, 8 ), Vector( 0, 0, -1 ) ) )