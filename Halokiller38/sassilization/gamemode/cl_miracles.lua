CreedBox = {}

MIRACLE_GRAVITATE		= 1
MIRACLE_BOMBARD			= 2
MIRACLE_HEAL			= 3
MIRACLE_DECIMATE		= 4
MIRACLE_BLAST			= 5
MIRACLE_PARALYSIS		= 6
MIRACLE_PLUMMET			= 7


local NoticeMaterial = {}
NoticeMaterial[ MIRACLE_GRAVITATE ] 		= surface.GetTextureID( "cobra/gravitate32" )
NoticeMaterial[ MIRACLE_BOMBARD ] 		= surface.GetTextureID( "cobra/bombard32" )
NoticeMaterial[ MIRACLE_HEAL ] 			= surface.GetTextureID( "cobra/heal32" )
NoticeMaterial[ MIRACLE_DECIMATE ] 		= surface.GetTextureID( "cobra/decimate32" )
NoticeMaterial[ MIRACLE_BLAST ] 		= surface.GetTextureID( "cobra/blast32" )
NoticeMaterial[ MIRACLE_PARALYSIS ] 		= surface.GetTextureID( "cobra/paralyze32" )
NoticeMaterial[ MIRACLE_PLUMMET ] 		= surface.GetTextureID( "cobra/plummet32" )

local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}

function GM:AddMiracle( type, length )

	local tab = {}
	tab.recv 	= CurTime()
	tab.len 	= tonumber(length)
	tab.velx	= 0
	tab.vely	= 5
	tab.x		= ScrW()*0.5--360
	tab.y		= ScrH()*0.5--23
	tab.a		= 255
	tab.type	= tonumber(type)
	
	table.insert( HUDNotes, tab )
	
	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
	
end


local function DrawNotice( self, k, v, i )

	local x = v.x
	local y = v.y
	
	if ( !v.w ) then v.w, v.h = 32, 32 end
	
	local w = v.w
	local h = v.h
	
	// Draw Icon
	
	surface.SetDrawColor( 255, 255, 255, v.a )
	surface.SetTexture( NoticeMaterial[ v.type ] )
	surface.DrawTexturedRect( x, y, w, h )

	
	local ideal_y = 140--23
	local ideal_x = 8 + (HUDNote_c - i) * (w + 4)--360 + (HUDNote_c - i) * (w + 4)
	
	local timeleft = v.len - (CurTime() - v.recv)
	local color = Color( 255, 255, 255, 255 )

	if ( math.Round(timeleft) <= 2 ) then color = Color( 240, 80, 80, 255 ) end
	if ( timeleft > 0.8 ) then
		draw.DrawText( math.Round(timeleft), "ScoreboardText", x+w*0.5+1, y+w+1, Color(0,0,0,255),1,1)
		draw.DrawText( math.Round(timeleft), "ScoreboardText", x+w*0.5, y+w, color,1,1)
	end
	
	// Cartoon style about to go thing
	if ( timeleft < 0.8  ) then
		ideal_y = 180
	end
	
	// Gone!
	if ( timeleft < 0.5  ) then
	
		ideal_x = -48
		ideal_y = 180
	
	end
	
	local spd = FrameTime() * 8
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
	local dist = ideal_x - v.x
	v.velx = v.velx + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
	
	// Friction.. kind of FPS independant.
	v.velx = v.velx * (0.95 - FrameTime() * 5 )
	v.vely = v.vely * (0.95 - FrameTime() * 5 )

end


function GM:PaintMiracles()

	if ( ENDROUND ) then return end
	if ( !HUDNotes ) then return end
		
	local i = 0
	for k, v in pairs( HUDNotes ) do
	
		if ( v != 0 ) then
		
			i = i + 1
			DrawNotice( self, k, v, i)		
		
		end
		
	end
	
	for k, v in pairs( HUDNotes ) do
	
		if ( v != 0 && v.recv + v.len < CurTime() ) then
		
			HUDNotes[ k ] = 0
			HUDNote_c = HUDNote_c - 1
			
			if (HUDNote_c == 0) then HUDNotes = {} end
		
		end

	end

end

local PANEL = {}

function PANEL:Init()
	self:SetVisible(true)
	self.Show = false
	self.Spirits = {}
	self.SpiritCount = 0
	self.focalLength = 100
end

function PANEL:PerformLayout()
	self:SetSize(128, 128)
	self:SetPos(180, 7)
end

function PANEL:Paint() end

function PANEL:Think()
	local current = self.SpiritCount
	local actual = LocalPlayer():GetNWInt( "_spirits" )
	if current == actual then return end
	local amount = math.abs( actual - current )
	if current < actual then
		for i=1, amount do
			self:AddSpirit()
			self.SpiritCount = self.SpiritCount + 1
		end
	elseif actual < current then
		for i=1, amount do
			self:SubtractSpirit()
			self.SpiritCount = self.SpiritCount - 1
		end
	end
end

function PANEL:Hide()
	self.Show = false
	self:SetVisible(false)
end

function PANEL:Display()
	self.Show = true
	self:SetVisible(true)
end

function PANEL:AddSpirit()
	local spirit = vgui.Create("Spirit", self)
	spirit:SetPos( 50, 50 )
	spirit:SetSize(16, 32)
	spirit.Origin = { x = 58, y = 54 }
	spirit.Bound = { w = 86, h = 64 }
	spirit.Pos = Vector( spirit.Origin.x, spirit.Origin.y, spirit.Bound.w*0.5 )
	spirit.Dir = Vector( math.Rand( -2, 2 ), math.Rand( -2, 2 ), math.Rand( -2, 2 ) )
	spirit.Right = spirit.Origin.x + ( spirit.Bound.w * 0.5 )
	spirit.Left = spirit.Origin.x - ( spirit.Bound.w * 0.5 )
	spirit.Top = spirit.Origin.y - ( spirit.Bound.h * 0.5 )
	spirit.Bottom = spirit.Origin.y + ( spirit.Bound.h * 0.5 )
	spirit.Back = 0
	spirit.Front = spirit.Bound.w
	table.insert( self.Spirits, spirit )
end

function PANEL:SubtractSpirit()
	local spirit = self.Spirits[1]
	table.remove( self.Spirits, 1 )
	spirit:Remove()
end

vgui.Register("CreedPanel", PANEL, "Panel")
CreedBox.Panel = vgui.Create( "CreedPanel" )

-----------
--Spirits--
-----------

local stex = surface.GetTextureID("sassilization/soul")

PANEL = {}

function PANEL:Init() end

function PANEL:Paint()

	local w, h = self:GetWide(), self:GetTall()
	local px = w*0.5
	local py = h*0.5
	local scale = self:GetParent().focalLength / ( self:GetParent().focalLength + self.Pos.z )
	surface.SetDrawColor( 255, 255, 255, 100*scale )
	surface.SetTexture( stex )
	surface.DrawTexturedRect( px - px*scale, py - py*scale, w*scale, h*scale )

end

function PANEL:Think()
	local bri = self.Right - (32 * (self.Pos.z/self.Bound.w) )
	local ble = self.Left + (32 * (self.Pos.z/self.Bound.w) )
	local bbo = self.Bottom - (12 * (self.Pos.z/self.Bound.h) )
	local bto = self.Top + (32 * (self.Pos.z/self.Bound.h) )
	if self.Pos.x > bri then
		self.Dir.x = math.abs(self.Dir.x) * -1
	end
	if self.Pos.x < ble then
		self.Dir.x = math.abs(self.Dir.x)
	end
	if self.Pos.y > bbo then
		self.Dir.y = math.abs(self.Dir.y) * -1
	end
	if self.Pos.y < bto then
		self.Dir.y = math.abs(self.Dir.y)
	end
	if self.Pos.z > self.Front then
		self.Dir.z = math.abs(self.Dir.z) * -1
	end
	if self.Pos.z < self.Back then
		self.Dir.z = math.abs(self.Dir.z)
	end
	self.Pos = self.Pos + self.Dir
	self:SetPos( self.Pos.x, self.Pos.y )
end

vgui.Register("Spirit", PANEL, "Panel")