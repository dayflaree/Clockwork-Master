local blur
local matBlurScreen = Material( "pp/blurscreen" )

local wnd = vgui.Create( "DFrame" )
wnd:SetSize( 800, 600 )
wnd:SetPos( ScrW() / 2 - wnd:GetWide() / 2, ScrH() / 2 - wnd:GetTall() / 2 )
wnd:SetTitle( "Sample window" )
wnd:ShowCloseButton( true )
wnd:SetDraggable( false )
wnd:MakePopup()

wnd.Paint = function()
	surface.SetDrawColor( 130, 130, 130, 255 )
	surface.DrawRect( 1, 1, wnd:GetWide() - 2, 20 )
	surface.DrawOutlinedRect( 1, 1, wnd:GetWide() - 2, wnd:GetTall() - 2 )
	
	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawOutlinedRect( 0, 0, wnd:GetWide(), wnd:GetTall() )
	
	surface.SetDrawColor( 110, 110, 110, 255 )
	surface.DrawLine( 2, 21, wnd:GetWide() - 2, 21 )
	
	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	local x1, y1 = wnd:LocalToScreen( 2, 21 )
	local x2, y2 = wnd:LocalToScreen( wnd:GetWide() - 2, wnd:GetTall() - 2 )
	x1 = x1 + 5 y1 = y1 + 5
	x2 = x2 - 5 y2 = y2 - 5
	
	matBlurScreen:SetMaterialFloat( "$blur", 5 )
	render.UpdateScreenEffectTexture()
	surface.DrawPoly( {
		{ x = 2, y = 21, u = x1/ScrW(), v = y1/ScrH() },
		{ x = wnd:GetWide() - 4, y = 21, u = x2/ScrW(), v = y1/ScrH() },
		{ x = wnd:GetWide() - 4, y = wnd:GetTall() - 2, u = x2/ScrW(), v = y2/ScrH() },
		{ x = 2, y = wnd:GetTall() - 2, u = x1/ScrW(), v = y2/ScrH() }
	} )
	
	surface.SetDrawColor( 100, 100, 100, 150 )
	surface.DrawRect( 2, 21, wnd:GetWide() - 4, wnd:GetTall() - 23 )
end