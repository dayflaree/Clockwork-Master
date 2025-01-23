--All credit to rick for the idea 
--:D

local PANEL = { }

function PANEL:Init()

	self:SetTitle( "" );
	self.SetTitle = self._SetTitle;
	self._OnMouseReleased = self.OnMouseReleased;
	self._Think = self.Think;
	
	self.Title = "";
	
	self.TitleVisible = self.ShowTitle;

end

function PANEL:ShowTitle( show )

	self.TitleVisible = show;

end

function PANEL:_SetTitle( title )

	self.Title = title;

end

function PANEL:Paint()

	if( self.TitleVisible ) then
	
		draw.RoundedBox( 4, 0, 0, self:GetWide(), 25, Color( 0, 0, 0, 255 ) );
		draw.DrawText( self.Title, "Default", 2, 3, Color( 255, 255, 255, 255 ) );
	
	end
		
	draw.RoundedBox( 4, 0, 23, self:GetWide(), self:GetTall() - 23, Color( 40, 40, 40, 155 ) );

	
	if( self.PaintHook ) then
		self.PaintHook( self );
	end
	
	return true;

end
vgui.Register( "HudPanel", PANEL, "DFrame" );
