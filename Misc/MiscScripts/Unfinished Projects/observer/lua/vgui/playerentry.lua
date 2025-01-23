// Player VGUI list item

local adminColor = Color( 154, 226, 64, 255 )
local userColor = Color( 118, 196, 255, 255 )

local PANEL = {}

function PANEL:Init()
	self:SetTall( 44 )
end

function PANEL:SetPlayer( ply )
	self.ply = ply
	self.avatar = vgui.Create( "AvatarImage", self )
	self.avatar:SetPos( 7, 7 )
	self.avatar:SetSize( 30, 30 )
	self.avatar:SetPlayer( ply )
end

function PANEL:SetHighlight( b )
	self.highlighted = b
end

function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), self.highlighted and Color( 100, 100, 100, 255 ) or Color( 30, 30, 30, 255 ) )
	
	draw.RoundedBox( 4, 4, 4, 36, 36, color_black )
	draw.RoundedBox( 4, 5, 5, 34, 34, self.ply:IsAdmin() and adminColor or userColor )
	
	surface.SetFont( "MenuLarge" )
	if ( surface.GetTextSize( self.ply:Nick() ) < self:GetWide() - 53 ) then	
		draw.SimpleText( self.ply:Nick(), "MenuLarge", 48, 2, self.ply:IsAdmin() and adminColor or userColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	else
		draw.SimpleText( self.ply:Nick():Left( 20 ) .. "...", "MenuLarge", 48, 2, self.ply:IsAdmin() and adminColor or userColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	
	draw.SimpleText( self.ply:SteamID(), "DefaultSmall", 49, 17, self.ply:IsAdmin() and adminColor or userColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

vgui.Register( "PlayerEntry", PANEL )