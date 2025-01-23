local icon = surface.GetTextureID( "gui/silkicons/plugin" )

local frame = vgui.Create( "DFrame" )
frame:SetPos( 200, 200 )
frame:SetSize( 128, 60 )
frame:SetTitle( "Texture drawing" )
frame.PaintOver = function()
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( icon )
	
	surface.DrawTexturedRect( 10, 30, 16, 16 )
	surface.DrawTexturedRectUV( 40, 30, 16, 16, 16, -16 )
	surface.DrawTexturedRectUV( 70, 30, 16, 16, -16, 16 )
	surface.DrawTexturedRectUV( 100, 30, 16, 16, -16, -16 )
end
frame:MakePopup()