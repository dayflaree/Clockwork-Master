// Progress bar VGUI item

local PANEL = {}

function PANEL:Init()
	self:SetTall( 20 )
	self.progress = 0
end

function PANEL:SetProgress( percent )
	self.progress = percent
end

function PANEL:Paint()
	surface.SetDrawColor( 70, 70, 70, 255 )
	surface.DrawRect( 0, 0, self:GetSize() )
	
	surface.SetDrawColor( 157, 196, 79, 255 )
	surface.DrawRect( 0, 0, self:GetWide() * self.progress / 100, self:GetTall() )
	
	draw.SimpleText( math.ceil( self.progress ) .. "%", "DefaultBold", self:GetWide() / 2, self:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "ProgressBar", PANEL )