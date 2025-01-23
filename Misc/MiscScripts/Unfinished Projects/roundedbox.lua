local function rect( x, y, w, h, u1, v1, u2, v2 )
	return {
		{ x = x, y = y, u = u1, v = v1 },
		{ x = x + w, y = y, u = u2, v = v1 },
		{ x = x + w, y = y + h, u = u2, v = v2 },
		
		{ x = x + w, y = y + h, u = u2, v = v2 },
		{ x = x, y = y + h, u = u1, v = v2 },
		{ x = x, y = y, u = u1, v = v1 }
	}
end

local function circle( cx, cy, r, segments, min, max, u1, v1, u2, v2 )
	local a, b, c, d
	local delta = math.pi*2/segments
	local vertices = {}
	
	local hdu = (u2-u1)/2
	local hdv = (v2-v1)/2
	local cu = u1 + hdu
	local cv = v1 + hdv
	
	for ang = min or 0, ( max or math.pi*2 ) - delta*0.9, delta do
		a = cx + math.cos( ang ) * r
		b = cy + math.sin( ang ) * r
		c = cx + math.cos( ang + delta ) * r
		d = cy + math.sin( ang + delta ) * r
		
		table.Add( vertices, {
			{ x = cx, y = cy, u = cu, v = cv },
			{ x = a, y = b, u = cu + math.cos( ang ) * hdu, v = cv + math.sin( ang ) * hdv },
			{ x = c, y = d, u = cu + math.cos( ang + delta ) * hdu, v = cv + math.sin( ang + delta ) * hdv }
		} )
	end
	
	return vertices
end

function draw.TexturedRoundedBox( border, x, y, w, h, color, u1, v1, u2, v2 )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	u1, v1, u2, v2 = u1 or 0, v1 or 0, u2 or 1, v2 or 1
	local du, dv = u2 - u1, v2 - v1
	
	local verts = {}
	
	table.Add( verts, rect( x, y + border, w, h - border*2, u1, v1 + border/h*dv, u2, v2 - border/h*dv ) )
	table.Add( verts, rect( x + border, y, w - border*2, border, u1 + border/w*du, v1, u2 - border/w*du, v1 + border/h*dv ) )
	table.Add( verts, rect( x + border, y + h - border, w - border*2, border, u1 + border/w*du, v2 - border/h*dv, u2 - border/w*du, v2 ) )
	
	table.Add( verts, circle( x + border, y + border, border, border, 1 * math.pi, 1.5 * math.pi, u1, v1, u1 + border/w*2*du, v1 + border/h*2*dv ) )
	table.Add( verts, circle( x + w - border, y + border, border, border, 1.5 * math.pi, 2 * math.pi, u2 - border/w*2*du, v1, u2, v1 + border/h*2*dv ) )
	table.Add( verts, circle( x + w - border, y + h - border, border, border, 0, 0.5 * math.pi, u2 - border/w*2*du, v2 - border/h*2*dv, u2, v2 ) )
	table.Add( verts, circle( x + border, y + h - border, border, border, 0.5 * math.pi, math.pi, u1, v2 - border/h*2*dv, u1 + border/w*2*du, v2 ) )
	
	surface.DrawPoly( verts )
end

local mat = surface.GetTextureID( "VGUI/entities/npc_antlion" )
hook.Add( "HUDPaint", "lol", function()
	surface.SetTexture( mat )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 100, 100, 400, 300 )
	
	draw.TexturedRoundedBox( 64, 570, 100, 400, 300, Color( 255, 255, 255, 255 ), 0, 0, 1, 1 )
end )