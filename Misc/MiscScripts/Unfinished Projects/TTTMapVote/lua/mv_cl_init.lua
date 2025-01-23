/*-------------------------------------------------------------------------------------------------------------------------
	Vars
-------------------------------------------------------------------------------------------------------------------------*/

local voteMenu 
local w, h = 400, 600
local voteStart
local mapcandidates = {
	"zm_roy_the_ship",
	"zm_hospital_remix",
	"zm_downtown_v1",
	"ttt_enclave_b1",
	"ttt_clue_pak",
	"ttt_canyon_a4",
	"ttt_camel_v1",
	"ttt_amsterville_b5",
	"rp_christmastown",
	"dm_richland",
	"dm_island17",
}
local maps = {}
local votes = {}
local vote

/*-------------------------------------------------------------------------------------------------------------------------
	Draw stuff
-------------------------------------------------------------------------------------------------------------------------*/

local logo = surface.GetTextureID("VGUI/ttt/score_logo")

local colors = {
   bg = Color( 30, 30, 30, 235 ),
   bar = Color( 220, 180, 0, 255 )
}

local y_logo_off = 72

local function Paint( self )
	Derma_DrawBackgroundBlur( self )
	
	/*-------------------------------------------------------------------------------------------------------------------------
		Base scoreboard
	-------------------------------------------------------------------------------------------------------------------------*/
	
	draw.RoundedBox( 8, 0, y_logo_off, self:GetWide(), self:GetTall() - y_logo_off, colors.bg )
	
	draw.RoundedBox( 8, 0, y_logo_off + 25, self:GetWide(), 32, colors.bar )
	
	surface.SetTexture( logo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 5, 0, 256, 256 )
	
	/*-------------------------------------------------------------------------------------------------------------------------
		Vote time left
	-------------------------------------------------------------------------------------------------------------------------*/
	
	local timeOver = ( CurTime() - voteStart ) / ( GetGlobalFloat( "VoteEndTime" ) - voteStart )
	
	surface.SetDrawColor( colors.bar.r, colors.bar.g, colors.bar.b, 255 )
	surface.DrawOutlinedRect( 10, self:GetTall() - 20, self:GetWide() - 20, 10 )
	surface.DrawRect( 10 + 2, self:GetTall() - 18, timeOver * ( self:GetWide() - 24 ), 6 )
end

local function DrawCircle( x, y, radius )
	local center = Vector( x, y )
	local scale = Vector( radius, radius )
	local segmentdist = 360 / ( 2 * math.pi * math.max( scale.x, scale.y ) / 2 )
	surface.SetDrawColor( 255, 0, 0, 255 )
 
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( center.x + math.cos( math.rad( a ) ) * scale.x, center.y - math.sin( math.rad( a ) ) * scale.y, center.x + math.cos( math.rad( a + segmentdist ) ) * scale.x, center.y - math.sin( math.rad( a + segmentdist ) ) * scale.y )
	end
end

local function PerformLayout( self )
	local hw = w - 180 - 8
	self.Help:SetSize( hw, 32 )
	self.Help:SetPos( w - self.Help:GetWide() - 8, y_logo_off + 27 )
	
	for i = 1, 6 do
		self.MapButtons[i]:SetPos( 8, y_logo_off + 70 + i * 60 )
		self.MapButtons[i]:SetSize( self:GetWide() - 16, 50 )
		self.MapButtons[i].Paint = function( self )
			draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
			
			draw.DrawText( maps[i], "cool_large", 20, self:GetTall() / 2 - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			if ( i == vote ) then
				draw.DrawText( votes[i] or 0, "cool_large", self:GetWide() - 25, self:GetTall() / 2 - 10, Color( 220, 180, 0, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.DrawText( votes[i] or 0, "cool_large", self:GetWide() - 25, self:GetTall() / 2 - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
	end
end

local function ApplySchemeSettings( self )
	self.Help:SetFont( "cool_large" )
	self.Help:SetFGColor( COLOR_BLACK )
end

hook.Add( "Initialize", "VoteOverride", function()
	/*-------------------------------------------------------------------------------------------------------------------------
		We're only voting for maps, so we don't need the additional menu.
	-------------------------------------------------------------------------------------------------------------------------*/
	
	function GAMEMODE:ShowMapChooserForGamemode()
		return
	end
	
	/*-------------------------------------------------------------------------------------------------------------------------
		Override the default vote menu
	-------------------------------------------------------------------------------------------------------------------------*/
	
	function GAMEMODE:ShowGamemodeChooser()
		voteStart = CurTime()
		
		voteMenu = vgui.Create( "DFrame" )
		voteMenu:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
		voteMenu:SetSize( w, h )
		voteMenu:ShowCloseButton( false )
		voteMenu:SetTitle( "" )
		voteMenu.Paint = Paint
		voteMenu.PerformLayout = PerformLayout
		voteMenu.ApplySchemeSettings = ApplySchemeSettings
		voteMenu:MakePopup()

		voteMenu.Help = vgui.Create( "Label", voteMenu )
		voteMenu.Help:SetText( "Pick a new map" )
		voteMenu.Help:SetContentAlignment( 6 )
		
		voteMenu.MapButtons = {}
		
		for i = 1, 6 do
			voteMenu.MapButtons[i] = vgui.Create( "DButton", voteMenu )
			voteMenu.MapButtons[i].DoClick = function()
				RunConsoleCommand( "TTT_Vote", i )
				vote = i
			end
			voteMenu.MapButtons[i]:SetText( "" )
		end
	end
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Maps
-------------------------------------------------------------------------------------------------------------------------*/

usermessage.Hook( "TTT_Maps", function( um )
	for i = 1, 6 do
		maps[i] = mapcandidates[ um:ReadChar() ]
	end
	PrintTable( maps )
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Update votes
-------------------------------------------------------------------------------------------------------------------------*/

usermessage.Hook( "TTT_Vote", function( um )
	for i = 1, 6 do
		votes[i] = um:ReadChar()
	end
end )