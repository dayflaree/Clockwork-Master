local r = 200
local segments = 30
local delta = math.pi*2 / segments
local cx, cy = ScrW() / 2, ScrH() / 2
local vertices = {}
local matBlur = Material( "pp/blurscreen" )

local a, b, c, d
for ang = 0, math.pi*2, delta do
	a = cx + math.cos( ang ) * r
	b = cy + math.sin( ang ) * r
	c = cx + math.cos( ang + delta ) * r
	d = cy + math.sin( ang + delta ) * r
	
	table.Add( vertices, {
		{ x = cx, y = cy, u = cx / ScrW(), v = cy / ScrH() },
		{ x = a, y = b, u = a / ScrW(), v = b / ScrH() },
		{ x = c, y = d, u = c / ScrW(), v = d / ScrH() }
	} )
end

hook.Add( "HUDPaint", "CircleBlur", function()
	surface.SetMaterial( matBlur )
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	for i = 0.16, 1, 0.16 do
		matBlur:SetMaterialFloat( "$blur", 10 * i )
		render.UpdateScreenEffectTexture()
		surface.DrawPoly( vertices )
	end
end )