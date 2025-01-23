
PANEL.Base = "DPanel"

function PANEL:Init()

	local h = ScrH() * 0.2
	
	self:SetPaintBackground( false )

	self.TopPanel = VGUIRect( 0, h*-1, ScrW(), h )
	self.TopPanel:SetColor( color_black )
	self.TopPanel:SetParent( self )
	
	self.BottomPanel = VGUIRect( 0, ScrH(), ScrW(), h )
	self.BottomPanel:SetColor( color_black )
	self.BottomPanel:SetParent( self )
	
	self.WinnerLabel = vgui.Create( "DLabel", self.BottomPanel )
	self.WinnerLabel:SetFont( "MelonLarge" )
	self.WinnerLabel:SetColor( color_white )
	
	self.WinnerSubtitle = vgui.Create( "DLabel", self.BottomPanel )
	self.WinnerSubtitle:SetFont( "MelonMedium" )
	self.WinnerSubtitle:SetColor( color_white )
	
	self:SetVisible( false )
	
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
		
	self.WinnerLabel:SizeToContents()
	self.WinnerLabel:Center()
	self.WinnerLabel:AlignTop( 32 )
	
	self.WinnerSubtitle:SizeToContents()
	self.WinnerSubtitle:Center()
	self.WinnerSubtitle:MoveBelow( self.WinnerLabel, 16 )
	
end

function PANEL:SetWinner( name, sec )

	self.WinnerLabel:SetText( "You have died." )
	self.WinnerLabel:SizeToContents()
	seconds = sec;

	local function SetText()
	
	seconds = seconds - 1
	self.WinnerSubtitle:SetText( "Wait ".. seconds .." seconds to spawn." )

	if( seconds != 0 ) then
	timer.Simple(1, function()
	SetText();
	end )
	end

	end
	

	timer.Simple(1, function()
	SetText();
	end )

	self.WinnerSubtitle:SetText( "Wait 15 seconds to spawn." )
	
	self:InvalidateLayout()

end

function PANEL:Show()

	local h = ScrH() * 0.2

	self.TopPanel:SetPos( 0, h * -1 )
	self.TopPanel:MoveTo( 0, 0, 1 )
	
	self.BottomPanel:SetPos( 0, ScrH() )
	self.BottomPanel:MoveTo( 0, ScrH()-h, 1 )
	
	self:InvalidateLayout()
	self:SetVisible( true )

end

function PANEL:Hide()

	local h = ScrH() * 0.2

	self.TopPanel:MoveTo( 0, h * -1, 2 )
	self.BottomPanel:MoveTo( 0, ScrH(), 1 )
	
	timer.Simple( 1, function() self:SetVisible( false ) end )

end

