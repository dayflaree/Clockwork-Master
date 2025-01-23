   local surface = surface
   local draw = draw
   local Color = Color

   local SKIN = {}

   SKIN.PrintName    = "LemonadeScript Skin"
   SKIN.Author       = "Looter"
   SKIN.DermaVersion = 1

   SKIN.bg_color         = Color( 50, 50, 50, 255 )
   SKIN.bg_color_sleep             = Color( 20, 20, 20, 255 )
   SKIN.bg_color_dark      = Color( 10, 10, 10, 255 )
   SKIN.bg_color_bright            = Color( 70, 70, 70, 255 )
 
   SKIN.fontFrame        = "Default"

   SKIN.control_color    = Color( 50, 50, 50, 255 )
   SKIN.control_color_highlight        = Color( 70, 70, 70, 255 )
   SKIN.control_color_active     = Color( 50, 50, 50, 255 )
   SKIN.control_color_bright     = Color( 90, 90, 90, 255 )
   SKIN.control_color_dark         = Color( 20, 20, 20, 255 )

   SKIN.bg_alt1             = Color( 50, 50, 50, 255 )
   SKIN.bg_alt2             = Color( 55, 55, 55, 255 )

   SKIN.listview_hover   = Color( 70, 70, 70, 255 )
   SKIN.listview_selected = Color( 255, 0, 0, 215 )

   SKIN.text_bright      = Color( 255, 255, 255, 255 )
   SKIN.text_normal      = Color( 255, 255, 255, 255 )
   SKIN.text_dark        = Color( 255, 255, 255, 255 )
   SKIN.text_highlight   = Color( 255, 255, 255, 255 )

   SKIN.texGradientUp      = Material( "gui/gradient_up" )
   SKIN.texGradientDown    = Material( "gui/gradient_down" )
 
   SKIN.combobox_selected      = SKIN.listview_selected

   SKIN.panel_transback            = Color( 50, 50, 50, 50 )
   SKIN.tooltip                = Color( 255, 255, 255, 255 )

   SKIN.colPropertySheet       = Color( 50, 50, 50, 255 )
   SKIN.colTab        = SKIN.colPropertySheet
   SKIN.colTabInactive   = Color( 25, 25, 25, 155 )
   SKIN.colTabShadow         = Color( 25, 25, 25, 255 )
   SKIN.colTabText           = Color( 255, 255, 255, 255 )
   SKIN.colTabTextInactive   = Color( 255, 255, 255, 155 )
   SKIN.fontTab                = "Default"

   SKIN.colCollapsibleCategory  = Color( 255, 255, 255, 20 )

   SKIN.colCategoryText            = Color( 255, 255, 255, 255 )
   SKIN.colCategoryTextInactive        = Color( 200, 200, 200, 255 )
   SKIN.fontCategoryHeader   = "TabLarge"

   SKIN.colNumberWangBG            = Color( 50, 50, 50, 255 )
   SKIN.colTextEntryBG   = Color( 50, 50, 50, 255 )
   SKIN.colTextEntryBorder   = Color( 20, 20, 20, 255 )
   SKIN.colTextEntryText         = Color( 255, 255, 255, 255 )
   SKIN.colTextEntryTextHighlight    = Color( 255, 255, 255, 255 )

   SKIN.colMenuBG        = Color( 50, 50, 50, 200 )
   SKIN.colMenuBorder      = Color( 0, 0, 0, 200 )
  
   SKIN.colButtonText      = Color( 255, 255, 255, 255 )
   SKIN.colButtonTextDisabled    = Color( 255, 255, 255, 55 )
   SKIN.colButtonBorder            = Color( 20, 20, 20, 255 )
   SKIN.colButtonBorderHighlight      = Color( 255, 255, 255, 50 )
   SKIN.colButtonBorderShadow    = Color( 0, 0, 0, 100 )
   SKIN.fontButton    = "Default"
   
function SKIN:PaintTooltip( panel )

	local w, h = panel:GetSize()
	
	DisableClipping( true )
	
	for i=1, 4 do
	
		local BorderSize = i*2
		local BGColor = Color( 0, 0, 0, (255 / i) * 0.3 )
		
		self:DrawGenericBackground( BorderSize, BorderSize, w, h, BGColor )

		self:DrawGenericBackground( -BorderSize, BorderSize, w, h, BGColor )

		self:DrawGenericBackground( BorderSize, -BorderSize, w, h, BGColor )

		self:DrawGenericBackground( -BorderSize, -BorderSize, w, h, BGColor )

		
	end


	self:DrawGenericBackground( 0, 0, w, h, self.tooltip )
	panel:DrawArrow( 0, 0 )

	DisableClipping( false )
end
   
function SKIN:SchemeMenuOption( panel )

	panel:SetFGColor( 255, 255, 255, 255 )
	
end
  
function SKIN:DrawGenericBackground( x, y, w, h, color )

    surface.SetDrawColor( 70, 70, 70, 255 )
    surface.DrawRect( x, y, w, h )
    surface.SetDrawColor( 50, 50, 50, 255 )
    surface.DrawOutlinedRect( x, y, w, h )
    
end

derma.DefineSkin( "LS", "Skin for LemonadeScript.", SKIN ) 
