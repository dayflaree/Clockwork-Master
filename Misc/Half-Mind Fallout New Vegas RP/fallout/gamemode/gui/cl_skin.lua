local SKIN = { };
local fadeMaterial = Material("fallout/vgui/glow_tip_line_vertical.png")

SKIN.PrintName 		= "Fallout";
SKIN.Author			= "rusty";
SKIN.DermaVersion	= 1;

SKIN.Colours = {}

SKIN.Colours.Window = {}
SKIN.Colours.Window.TitleActive			= GWEN.TextureColor( 4 + 8 * 0, 508 )
SKIN.Colours.Window.TitleInactive		= GWEN.TextureColor( 4 + 8 * 1, 508 )

SKIN.Colours.Button = { }
SKIN.Colours.Button.Normal				= Color( 252, 178, 69, 255 );
SKIN.Colours.Button.Hover				= Color( 252, 178, 69, 255 );
SKIN.Colours.Button.Down				= Color( 252, 178, 69, 255 );
SKIN.Colours.Button.Disabled			= Color( 128, 128, 128, 255 );

SKIN.Colours.Tab = {}
SKIN.Colours.Tab.Active = {}
SKIN.Colours.Tab.Active.Normal			= GWEN.TextureColor( 4 + 8 * 4, 508 )
SKIN.Colours.Tab.Active.Hover			= GWEN.TextureColor( 4 + 8 * 5, 508 )
SKIN.Colours.Tab.Active.Down			= GWEN.TextureColor( 4 + 8 * 4, 500 )
SKIN.Colours.Tab.Active.Disabled		= GWEN.TextureColor( 4 + 8 * 5, 500 )

SKIN.Colours.Tab.Inactive = {}
SKIN.Colours.Tab.Inactive.Normal		= GWEN.TextureColor( 4 + 8 * 6, 508 )
SKIN.Colours.Tab.Inactive.Hover			= GWEN.TextureColor( 4 + 8 * 7, 508 )
SKIN.Colours.Tab.Inactive.Down			= GWEN.TextureColor( 4 + 8 * 6, 500 )
SKIN.Colours.Tab.Inactive.Disabled		= GWEN.TextureColor( 4 + 8 * 7, 500 )

SKIN.Colours.Label = { }
SKIN.Colours.Label.Default				= Color( 252, 178, 69, 255 );
SKIN.Colours.Label.Bright				= Color( 252, 178, 69, 255 );
SKIN.Colours.Label.Dark					= Color( 128, 128, 128, 255 );
SKIN.Colours.Label.Highlight			= Color( 252, 178, 69, 255 );

SKIN.Colours.Tree = {}
SKIN.Colours.Tree.Lines					= GWEN.TextureColor( 4 + 8 * 10, 508 ) ---- !!!
SKIN.Colours.Tree.Normal				= GWEN.TextureColor( 4 + 8 * 11, 508 )
SKIN.Colours.Tree.Hover					= GWEN.TextureColor( 4 + 8 * 10, 500 )
SKIN.Colours.Tree.Selected				= GWEN.TextureColor( 4 + 8 * 11, 500 )

SKIN.Colours.Properties = {}
SKIN.Colours.Properties.Line_Normal			= GWEN.TextureColor( 4 + 8 * 12, 508 )
SKIN.Colours.Properties.Line_Selected		= GWEN.TextureColor( 4 + 8 * 13, 508 )
SKIN.Colours.Properties.Line_Hover			= GWEN.TextureColor( 4 + 8 * 12, 500 )
SKIN.Colours.Properties.Title				= GWEN.TextureColor( 4 + 8 * 13, 500 )
SKIN.Colours.Properties.Column_Normal		= GWEN.TextureColor( 4 + 8 * 14, 508 )
SKIN.Colours.Properties.Column_Selected		= GWEN.TextureColor( 4 + 8 * 15, 508 )
SKIN.Colours.Properties.Column_Hover		= GWEN.TextureColor( 4 + 8 * 14, 500 )
SKIN.Colours.Properties.Border				= GWEN.TextureColor( 4 + 8 * 15, 500 )
SKIN.Colours.Properties.Label_Normal		= GWEN.TextureColor( 4 + 8 * 16, 508 )
SKIN.Colours.Properties.Label_Selected		= GWEN.TextureColor( 4 + 8 * 17, 508 )
SKIN.Colours.Properties.Label_Hover			= GWEN.TextureColor( 4 + 8 * 16, 500 )

SKIN.Colours.Category = {}
SKIN.Colours.Category.Header				= GWEN.TextureColor( 4 + 8 * 18, 500 )
SKIN.Colours.Category.Header_Closed			= GWEN.TextureColor( 4 + 8 * 19, 500 )
SKIN.Colours.Category.Line = {}
SKIN.Colours.Category.Line.Text				= GWEN.TextureColor( 4 + 8 * 20, 508 )
SKIN.Colours.Category.Line.Text_Hover		= GWEN.TextureColor( 4 + 8 * 21, 508 )
SKIN.Colours.Category.Line.Text_Selected	= GWEN.TextureColor( 4 + 8 * 20, 500 )
SKIN.Colours.Category.Line.Button			= GWEN.TextureColor( 4 + 8 * 21, 500 )
SKIN.Colours.Category.Line.Button_Hover		= GWEN.TextureColor( 4 + 8 * 22, 508 )
SKIN.Colours.Category.Line.Button_Selected	= GWEN.TextureColor( 4 + 8 * 23, 508 )
SKIN.Colours.Category.LineAlt = {}
SKIN.Colours.Category.LineAlt.Text				= GWEN.TextureColor( 4 + 8 * 22, 500 )
SKIN.Colours.Category.LineAlt.Text_Hover		= GWEN.TextureColor( 4 + 8 * 23, 500 )
SKIN.Colours.Category.LineAlt.Text_Selected		= GWEN.TextureColor( 4 + 8 * 24, 508 )
SKIN.Colours.Category.LineAlt.Button			= GWEN.TextureColor( 4 + 8 * 25, 508 )
SKIN.Colours.Category.LineAlt.Button_Hover		= GWEN.TextureColor( 4 + 8 * 24, 500 )
SKIN.Colours.Category.LineAlt.Button_Selected	= GWEN.TextureColor( 4 + 8 * 25, 500 )

SKIN.Colours.TooltipText = GWEN.TextureColor( 4 + 8 * 26, 500 )

SKIN.colTextEntryText			= Color( 255, 255, 255, 255 );
SKIN.colTextEntryTextHighlight	= Color( 255, 255, 255, 10 );
SKIN.colTextEntryTextCursor		= Color( 255, 255, 255, 255 );

local function ButtonPerformLayout( self )

	if ( self and self:IsValid() ) then
	
		self.OnCursorEntered = function()
		
			if (!self:GetDisabled()) then
				surface.PlaySound("fallout/ui/ui_menu_focus.wav")
			end
			
		end
		
		local oldDoClick = self.DoClick
		
		self.DoClick = function(self) 
		
			oldDoClick(self)
			surface.PlaySound("fallout/ui/ui_menu_ok.wav")
			
		end
		
	end

end

function SKIN:PaintButton( panel, w, h )

	if( !panel.ProcessedPerformLayout ) then
		
		panel.ProcessedPerformLayout = true;
		ButtonPerformLayout(panel)
		
	end
	
	if( panel.m_bBackground ) then
		
		local c = Color( 30, 30, 30, 0 );
		
		if( !panel:GetDisabled() ) then
			if( panel.Hovered or panel.m_bSelected ) then
				
				surface.DisableClipping( true );
				surface.SetDrawColor( Color(252, 178, 69, 35) );
				surface.DrawRect( 0, 0, w, h );
				surface.SetDrawColor( Color(252, 178, 69, 255) );
				surface.DrawOutlinedRect( 0, 0, w, h );
				surface.DisableClipping( false );
				
			end
		end
		
		if( panel:GetDisabled() ) then
			
			c = Color( 20, 20, 20, 0 );
			
		end
		
	end
	
	if( panel.TextButtonBackground ) then
		
		if( panel.Hovered and !panel:GetDisabled() ) then
			
			surface.DisableClipping( true );
 			surface.SetDrawColor( Color(252, 178, 69, 35) );
			surface.DrawRect( 0, 0, w, h );
			surface.SetDrawColor( Color(252, 178, 69, 255) );
			surface.DrawOutlinedRect( 0, 0, w , h );
			panel:SetTextColor( Color( 252, 178, 69, 255 ) );
			panel:ApplySchemeSettings();
			surface.DisableClipping( false );
			
		else
			
			panel:SetTextColor( Color( 252, 178, 69, 255 ) );
			panel:ApplySchemeSettings();
			
		end
		
		if (panel:GetDisabled()) then
			panel:SetTextColor( Color( 128, 128, 128, 255 ) );
			panel:ApplySchemeSettings();
		end
	end
	
end

function SKIN:PaintTextEntry( panel, w, h )

	if( panel:GetDrawBackground() ) then
		surface.DisableClipping( false );
		surface.SetDrawColor( Color( 0, 0, 0, 50 ) );
		surface.DrawRect( 0, 0, w, h );
		surface.SetDrawColor( Color( 252, 178, 69, 255 ) );
		surface.DrawRect( 0, 0, w, 2 );
		surface.DrawRect( 0, h - 2, w, 2 );
		surface.SetMaterial( fadeMaterial )
		surface.DrawTexturedRect( 0, 0, 2, h / 4 )
		surface.DrawTexturedRect( w - 1, 0, 2, h / 4 )
		surface.DrawTexturedRectRotated( w - 1, h - h/8, 2, h / 4, 180 )
		surface.DrawTexturedRectRotated( 1, h - h/8, 2, h / 4, 180 )
		surface.DisableClipping( true );
	end
	
	panel:DrawTextEntryText( panel.OverrideColor or self.colTextEntryText, self.colTextEntryTextHighlight, self.colTextEntryTextCursor );

end

local function FramePerformLayout( self )
	
	if( self.btnClose and self.btnClose:IsValid() ) then
		
		self.btnClose:SetPos( self:GetWide() - 80, 6 );
		self.btnClose:SetSize( 64, 24 );
		self.btnClose:SetFont( "Infected.FrameTitle" );
		self.btnClose:SetText( "Close" );
		self.btnClose:SetDrawBackground( false );
		self.btnClose.Paint = function( panel, w, h ) // you're supposed to be able to use SKIN:WindowCloseButton to change this.
			if (panel:IsHovered()) then
				surface.DisableClipping( true );
				surface.SetDrawColor( Color(252, 178, 69, 35) );
				surface.DrawRect( -3, 0, w + 6, h );
				surface.SetDrawColor( Color(252, 178, 69, 255) );
				surface.DrawOutlinedRect( -3, 0, w + 6, h );
				surface.DisableClipping( true );
			end
		end
		self.btnClose.OnCursorEntered = function()
			surface.PlaySound("fallout/ui/ui_menu_focus.wav")
		end
		local oldDoClick = self.btnClose.DoClick
		self.btnClose.DoClick = function()
			oldDoClick()
			surface.PlaySound("fallout/ui/ui_menu_cancel.wav")
		end
		self.btnClose:PerformLayout();
		
	end
	
	if( self.btnMaxim and self.btnMaxim:IsValid() ) then
		
		self.btnMaxim:Remove();
		
	end
	
	if( self.btnMinim and self.btnMinim:IsValid() ) then
		
		self.btnMinim:Remove();
		
	end
	
	if( self.lblTitle and self.lblTitle:IsValid() ) then
		
		self.lblTitle:NoClipping( false )
		self.lblTitle:SetPos( 24, -11 )
		self.lblTitle:SetSize( self:GetWide() - 25, 22 )
		self.lblTitle:SetTextColor(Color(252, 178, 69, 255))
		self.lblTitle:SetFont( "Infected.FrameTitle" );
		
	end
	
end

function SKIN:PaintFrame( panel, w, h )

	surface.DisableClipping( true );
	
	if( !panel.ProcessedPerformLayout ) then
		
		panel.PerformLayout = FramePerformLayout;
		panel.ProcessedPerformLayout = true;
		panel:PerformLayout();
		
	end
	
	local x1, y1, w1, h1 = panel:GetBounds();
	
	local us = x1 / ScrW();
	local vs = y1 / ScrH();
	local ue = ( x1 + w1 ) / ScrW();
	local ve = ( y1 + h1 ) / ScrH();
	surface.SetFont( panel.lblTitle:GetFont() );
	local textSizeW, textSizeH = surface.GetTextSize(panel.lblTitle:GetText())
	
	// this sucks fucking dick. thanks source.
	surface.SetDrawColor( Color( 0, 0, 0, 225 ) );
	surface.DrawRect( -8, -8, w + 16, h + 16 );
	surface.SetDrawColor( Color( 252, 178, 69, 255 ) );
	surface.DrawRect( 0, 0, 22, 4 );
	surface.DrawRect( 26 + textSizeW, 0, w - (26 + textSizeW), 4 );
	surface.DrawRect( 0, h-4, w, 4 );
	surface.SetMaterial( fadeMaterial )
	surface.DrawTexturedRect( 0, 4, 4, h / 8 )
	surface.DrawTexturedRect( w-4, 4, 4, h / 8 )
	surface.DrawTexturedRectRotated( w - 2, h - h/16, 4, h / 8, 180 )
	surface.DrawTexturedRectRotated( 2, h - h/16, 4, h / 8, 180 )
	
	surface.DisableClipping( true );
	
end

function SKIN:PaintSliderKnob( panel, w, h )
	
	if ( panel:GetDisabled() ) then	return self.tex.Input.Slider.H.Disabled( 0, 0, w, h ) end
	
	if ( panel.Depressed ) then
		return self.tex.Input.Slider.H.Down( 0, 0, w, h )
	end
	
	if ( panel.Hovered ) then
		return self.tex.Input.Slider.H.Hover( 0, 0, w, h )
	end
	
	self.tex.Input.Slider.H.Normal( 0, 0, w, h )
	
end

function SKIN:PaintSlider( panel, w, h )
	
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
	surface.DrawLine( 0, h / 2, w, h / 2 );
	
end

function SKIN:PaintButtonDown( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "u" );
		panel:SetFont( "marlett" );
		
	end
	
	self:PaintButton( panel, w, h );

end

function SKIN:PaintButtonUp( panel, w, h )
	
	if( !panel.LaidOut ) then
		
		panel.LaidOut = true;
		panel:SetText( "t" );
		panel:SetFont( "marlett" );
		
	end
	
	self:PaintButton( panel, w, h );

end

function SKIN:PaintVScrollBar( panel, w, h )

	

end

function SKIN:PaintScrollBarGrip( panel, w, h )

	self:PaintButton( panel, w, h );

end

derma.DefineSkin( "FalloutSkin", "Fallout Skin", SKIN );

function GM:ForceDermaSkin()
	
	return "FalloutSkin";
	
end