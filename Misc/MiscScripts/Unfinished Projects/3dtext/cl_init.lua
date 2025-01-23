include( "shared.lua" )

function ENT:Initialize( )
	surface.CreateFont( "Trebuchet18", 500, 700, true, false, "rulesTitle" )
end

function ENT:DrawText( text, x, y, font )
	surface.SetFont( font )
	surface.SetTextPos( x, y )
	surface.DrawText( text )
end

function ENT:Draw( )
	self:DrawModel()
	
	cam.Start3D2D( self.Entity:GetPos( ) + Vector( 0, 0, 0 ), self.Entity:GetAngles(), 0.5 )
		surface.SetTextColor( 255, 255, 255, 255 )
		self:DrawText( self:GetNWString( "Text", "The best use of dynamite is to think outside" ), 0, -150, "rulesTitle" )
		self:DrawText( self:GetNWString( "Text", "the box and not just make it explode." ), 180, -20, "rulesTitle" )
	cam.End3D2D( )
end