/*-------------------------------------------------------------------------------------------------------------------------
	Transparent DFrame control
-------------------------------------------------------------------------------------------------------------------------*/

local PANEL = {}

local matBlurScreen = Material( "pp/blurscreen" )

function PANEL:Init()
end

function PANEL:Think()
	if ( self.SX != self:GetWide() or self.SY != self:GetTall() ) then
		self:BuildShape()		
		self.SX, self.SY = self:GetSize()
	end
end

function PANEL:BuildShape()
	local x1 = self.x / ScrW()
	local y1 = self.y / ScrH()
	local x2 = ( self.x + self:GetWide() ) / ScrW()
	local y2 = ( self.y + self:GetTall() )  / ScrH()

	self.Shape = {
		{ x = 0, y = 0, u = x1, v = y1 },
		{ x = self:GetWide(), y = 0, u = x2, v = y1 },
		{ x = self:GetWide(), y = self:GetTall(), u = x2, v = y2 },
		
		{ x = self:GetWide(), y = self:GetTall(), u = x2, v = y2 },
		{ x = 0, y = self:GetTall(), u = x1, v = y2 },
		{ x = 0, y = 0, u = x1, v = y1 },
	}
end

function PANEL:Paint()
	if ( !self.Shape ) then self:BuildShape() end
	
	local x, y = self:ScreenToLocal( 0, 0 )
	
	// Background
	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	for i = 1, 1, 0.33 do
		matBlurScreen:SetMaterialFloat( "$blur", 5 * i )
		render.UpdateScreenEffectTexture()
		surface.DrawPoly( self.Shape )
	end
	
	draw.NoTexture()
	surface.SetDrawColor( 100, 100, 100, 150 )
	surface.DrawPoly( self.Shape )
	
	// Border
	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	
	return true
end

vgui.Register( "DFrameTransparent", PANEL, "DFrame" )