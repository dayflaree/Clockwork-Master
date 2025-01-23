include('shared.lua')

local mBeam = Material( "effects/laser_tracer" )

function ENT:Draw()
	if self.Entity:GetOwner() == LocalPlayer() then
		
		local pl = LocalPlayer()
		local tracedata = {}
		tracedata.start = pl:GetShootPos()
		tracedata.endpos = tracedata.start+(pl:GetAimVector()*2048)
		tracedata.mask = MASK_WATERWORLD
		tracedata.filter = pl
		
		local tr = util.TraceLine(tracedata)
		
		render.SetMaterial( mBeam )
		
		local pCoord = {}
		pCoord[1] = 0.25
		pCoord[2] = 0.75
		local vStart = tr.Hit and tr.HitPos + tr.HitNormal * 10 or self.Entity:GetPos()
		
		local iLength = 0
		local vEnd = Vector( 0,0,0 )
		local cColor = Color( 0,0,0,0 )
		
		// 3 beams
		// Alpha
		local iAlpha = 200
		local iLength = 10
		local iWidth = 2
		local iColor = 255

		cColor = Color( iColor, 0, 0, iAlpha )

		fx = self.Entity:GetNWInt( "firstx" )
		fy = self.Entity:GetNWInt( "firsty" )
		fz = self.Entity:GetNWInt( "firstz" )

		if fx + fy + fz == 0 then return end
	
		local p = Vector( fx, fy, fz )
		local q = self.Entity:GetPos()
		local center = ( p + q ) * 0.5
		local diameter = p:Distance( q )
		local diff = math.abs( p.z - q.z )
		
		local points = {}		

		--------------------------

		local numPoints =  30 //math.Round( p:Distance( q ) * 0.1 )
		local incr = 360 / numPoints
		for i=1, numPoints do
			local rad = (i * incr + 180) * math.pi/180
			local px = center.x + math.cos(rad) * diameter * 0.5
			local py = center.y + math.sin(rad) * diameter * 0.5

			tracedata = {}
			tracedata.start = Vector( px, py, q.z + diameter )
			tracedata.endpos = Vector( px, py, q.z + diameter )+Vector( 0, 0, (diameter * -2) - 10 )
			tracedata.mask = MASK_WATERWORLD
			tracedata.filter = self.Entity

			tr = util.TraceLine(tracedata) 

			if !tr.StartSolid then
				local pz = tr.HitPos.z
				table.insert( points, Vector( px, py, pz ) )
			end
		end
		
		--------------------------

		if #points <= 0 then return end

		local curPoint = points[1]
		for i=2, #points do
			render.DrawBeam( curPoint, points[i], iWidth, pCoord[1], pCoord[2], cColor )
			curPoint = points[i]
		end
		render.DrawBeam( points[#points], points[1], iWidth, pCoord[1], pCoord[2], cColor )	
	end
end
