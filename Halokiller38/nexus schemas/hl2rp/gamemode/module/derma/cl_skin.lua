local SKIN = {}

SKIN.PrintName 		= "BlackSkin"
SKIN.Author 		= "BlackOps7799"
SKIN.DermaVersion	= 1

surface.CreateFont( "Tahoma", 16, 1000, true, false, "BlackSkinTitle" )

SKIN.colOutline	= Color( 0, 0, 0, 250 )
SKIN.colPropertySheet 			= Color( 100, 171, 221, 255 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabText		 			= Color( 0, 0, 0, 200 )
SKIN.fontButton					= "DefaultSmall"
SKIN.fontTab					= "DefaultSmall"
SKIN.fontFrame					= "BlackSkinTitle"

local gradientdown 	= surface.GetTextureID( "gui/gradient_down" )
local logo = surface.GetTextureID( "VGUI/TitleBarIcon" )

function SKIN:LayoutFrame( panel )

	panel.lblTitle:SetFont( self.fontFrame )
	
	panel.btnClose:SetPos( panel:GetWide() - 22, 4 )
	panel.btnClose:SetSize( 18, 18 )
	
	panel.lblTitle:SetPos( 22, 2 )
	panel.lblTitle:SetSize( panel:GetWide() - 25, 20 )

end

function SKIN:PaintFrame( Frame )

	surface.SetDrawColor( Color(100,100,100,200) )
	surface.DrawRect( 0, 0, Frame:GetWide(), Frame:GetTall() )
	
	surface.SetDrawColor( Color(0,0,0,200) )
	surface.DrawRect( 0, 0, Frame:GetWide(), 22 )
		
	surface.SetTexture( gradientdown )
	surface.SetDrawColor( 100, 100, 100, 200 )
	surface.DrawTexturedRect( 0, 0, Frame:GetWide(), 22/3 )
	
	surface.SetTexture( logo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 3, 3, 16, 16 )
	
	surface.SetDrawColor( Color(0,0,0,255) )
	surface.DrawOutlinedRect( 0, 0, Frame:GetWide(), Frame:GetTall() )

end

derma.DefineSkin( "blackskin", "black styled skin", SKIN )