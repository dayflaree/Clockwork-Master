
-------------------------------------
-- THIS IS DEFUNCT
-------------------------------------

surface.CreateFont( "akbar", 20, 400, true, false, "EpidemicTitleFont" );

function CreateBPanel2( title, x, y, w, h )

	local pnl = CreateBPanel( title, x, y, w, h );
	
	pnl.Title = title;
	
	pnl:AttachTitleToBody( true );
	pnl.TitleBar:SetVisible( false );
	
	pnl.OutlineAlphaMul = 1;
	pnl.OutlineAlpha = 200;

	pnl.Paint = function( self )
	
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 51, 51, 51, pnl.OutlineAlpha ) );
		draw.RoundedBox( 0, 5, 5, self:GetWide() - 10, self:GetTall() - 10, Color( 0, 0, 0, 255 ) );
		
		surface.SetFont( "EpidemicTitleFont" );
		local tw, th = surface.GetTextSize( self.Title );	
	
		if( pnl.Title ) then
	
			draw.RoundedBox( 0, 7, 7, self:GetWide() - 14, th, Color( 69, 69, 69, 130 ) );
			draw.DrawText( self.Title, "NewChatFont", 10, 8, Color( 200, 200, 200, 255 ) );
		
		end
		
		draw.RoundedBox( 0, 7, 8 + th, self:GetWide() - 14, self:GetTall() - ( th + 15 ), Color( 60, 60, 60, 255 ) );
	
		pnl.OutlineAlpha = pnl.OutlineAlpha + 50 * pnl.OutlineAlphaMul * FrameTime();
		
		if( pnl.OutlineAlpha > 255 ) then
		
			pnl.OutlineAlpha = 255;
			pnl.OutlineAlphaMul = -1;
		
		elseif( pnl.OutlineAlpha < 50 ) then
		
			pnl.OutlineAlpha = 50;
			pnl.OutlineAlphaMul = 1;
		
		end
	
	end
	
	return pnl;

end