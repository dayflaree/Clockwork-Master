UnitMenu = {}

local texNo = surface.GetTextureID( "overlays/vip_entry" )
local ghostTrace = {}

local PANEL = {}

function PANEL:Init()
	self.Unit = 1
	self.Units = {}
	self.tabh = 96
	self.tabw = 96
	self.padding = 4
	self:SetTall( self.tabh + 8 )
end

function PANEL:PerformLayout() end

function PANEL:Setup()
	
	if !ITEMS then return {} end
	
	local LP = LocalPlayer()
	if !ValidEntity(LP) then return end
	
	local reposition
	for i, unit in pairs(UNITS) do
		local allowed = true
		if !(tonumber( i ) and unit.name) then allowed = false end 
		if unit.name == "Peasant" then allowed = false end
		if LP:GetNWInt( "_cities" ) < 1 then allowed = false end
		if unit.name == "Archer" then
			if LP:GetNWInt( "_workshops" ) < 1 or (!ITEMS.archer and !ALLOWALL) then
				allowed = false
			end
		end
		if unit.name == "ScallyWag" then
			if LP:GetNWInt( "_workshops" ) < 1 or (!ITEMS.scallywag and !ALLOWALL) then
				allowed = false
			end
		end
		if unit.name == "Galleon" then
			if LP:GetNWInt( "_workshops" ) < 1 or (!ITEMS.galleon and !ALLOWALL) then
				allowed = false
			end
		end
		if unit.name == "Catapult" then
			if LP:GetNWInt( "_workshops" ) < 100 or (!ITEMS.catapult and !ALLOWALL) then
				allowed = false
			end
		end
		if unit.name == "Ballista" then
			if LP:GetNWInt( "_workshops" ) < 100 or (!ITEMS.ballista and !ALLOWALL) then
				allowed = false
			end
		end
		if unit.name == "Horsie" then
			allowed = false
		end
		if allowed then
			if !self.Units[i] then
				reposition = true
				local button = vgui.Create("UnitIcon", self)
				button.Unit = i
				button.unit = table.Copy( unit )
				button.mdl = unit.model
				button.Text = unit.name
				button.index = i
				button:SetSize(self.tabw, self.tabh)
				self.Units[i] = button
			elseif !self.Units[i]:IsVisible() then
				reposition = true
				self.Units[i]:SetVisible( true )
			end
		elseif !allowed then
			if self.Units[i] and self.Units[i]:IsVisible() then
				reposition = true
				self.Units[i]:SetVisible( false )
			end
			if self.Unit == i then
				reposition = true
				self.Unit = 1
			end
		end
	end
	
	local i = 1
	for _, btn in pairs( self.Units ) do
		if btn:IsVisible() then
			btn:SetPos( ((i-1) * self.tabw) + self.padding * i, 5 )
			i = i + 1
		end
	end
	
	self:SetWide( i == 1 and 0 or ((i-1) * self.tabw + self.padding * i) )
	
	local x, y = self:GetPos()
	local newX, newY = self:GetPos()
	local w, h, total = ScrW(), ScrH(), BuildMenu.Panel:GetWide() + self:GetWide()
	if inWalk and !inCrouch and !LocalPlayer():KeyDown( IN_SCORE ) || reposition then
		newX, newY = w - self:GetWide(), h - self:GetTall()
		if total > w then
			if x != newX || y != newY || reposition then
				BuildMenu.Panel:SetPos( newX - BuildMenu.Panel:GetWide(), h - BuildMenu.Panel:GetTall() )
			end
		end
	elseif total <= w then
		newX, newY = w - self:GetWide(), h - self:GetTall()
	end
	if x != newX || y != newY || reposition then
		self:SetPos( newX, newY )
	end
	
end

function PANEL:Paint()
	
	draw.RoundedBox(0, 2, 2, self:GetWide(), self:GetTall(), Color(50,50,75,100))
	draw.RoundedBox(0, 1, 1, self:GetWide(), 1, Color(0,0,0,255))
	draw.RoundedBox(0, 1, 1, 1, self:GetTall(), Color(0,0,0,255))
	draw.RoundedBox(0, 0, 0, self:GetWide(), 1, Color(255,255,255,255))
	draw.RoundedBox(0, 0, 0, 1, self:GetTall(), Color(255,255,255,255))
	
	if (GAMEMODE.ShowScoreboard) then return end
	if (inWalk and self.invalid) then
		DisableClipping( true )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture( texNo )
			local size = 1.28/ghostTrace.Fraction
			local x, y = self:ScreenToLocal( gui.MouseX() - size*0.5, gui.MouseY() - size*0.5 )
			surface.DrawTexturedRect( x, y, size, size )
		DisableClipping( false )
	end
	
end

function PANEL:PaintOver()
	
	local LP = LocalPlayer()
	if !ValidEntity(LP) then return end
	
	if LP:KeyDown( IN_SCORE ) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(50,50,50,100))
		return
	elseif !(inWalk and !inCrouch) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(50,50,50,100))
	end
	if inCrouch and !inWalk then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,100))
	end
	
end

function PANEL:Think()
	
	local x, y = self:GetPos()
	
	self:Setup()
	
	if (GAMEMODE.ShowScoreboard) then
		SetWorldCursor( "none" )
		self:ReleaseGhostEntity()
		self.invalid = false
		return
	end
	
	if self.Unit then
		if !self.Units[self.Unit] then
			self.Unit = 1
			return
		end
		if inWalk and !inCrouch then
			if (ValidEntity( self.GhostEntity )) then
				SetWorldCursor( "blank" )
			elseif !self.invalid then
				SetWorldCursor( "none" )
			end
			self:SetMouseInputEnabled( true )
			if !vgui.CursorVisible() then
				gui.EnableScreenClicker( true )
			elseif (	gui.MouseX() >= x	and
					gui.MouseY() >= y	) then
				self:ReleaseGhostEntity()
				self.invalid = false
				return
			end
			self.GhostEntity = self.GhostEntity or self:MakeGhostEntity( self.Units[self.Unit].unit )
 			self.invalid = !self:UpdateGhostEntity( self.GhostEntity, LocalPlayer() )
		else
			self:SetMouseInputEnabled( false )
			self:ReleaseGhostEntity()
			if !inCrouch and !inWalk and !LocalPlayer():KeyDown( IN_SCORE ) then
				gui.EnableScreenClicker( false )
			end
			return
		end
	end
	
end

function PANEL:MakeGhostEntity( unit )  
	
	self:ReleaseGhostEntity()
	
	if (!util.IsValidProp( unit.model )) then return end
	
	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity) then return end
	
	self.GhostEntity:SetModel( unit.model )
	self.GhostEntity:SetPos( Vector( 0, 0, 0 ) )
	self.GhostEntity:SetAngles( Angle( 0, 0, 0 ) )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	return self.GhostEntity
	
end

local steadyProps = {}
steadyProps["models/jaanus/scallywag_unbroken.mdl"]=true

function PANEL:UpdateGhostEntity( ent, player ) 
	
 	if ( !ent ) then return end
 	if ( !ent:IsValid() ) then return end 
	
	if !inWalk || player:KeyDown( IN_SCORE ) then
		self:ReleaseGhostEntity()
		return
	end
	
	local unit	= self.Units[self.Unit].unit
 	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
 	local trace 	= util.TraceLine( tr )
	local waterbase	= unit.waterbase
	local water	= false
	local validation = true
	ghostTrace = table.Copy(trace)
	ent.valid = true
	
	if trace.HitNormal.z <= 0 then
		ent.valid = false
 		ent:SetNoDraw( true )
		ClearWallPreview( ent )
 		return
	end
	if !trace.Hit or trace.HitSky then
		ent.valid = false
 		ent:SetNoDraw( true )
		ClearWallPreview( ent )
 		return
 	end
	if player:WaterLevel() >= 2 then
		ent.valid = false
 		ent:SetNoDraw( true )
		ClearWallPreview( ent )
 		return
	end
	
	tr.mask = MASK_NPCSOLID
	local check = util.TraceLine( tr )
	if check.HitPos != trace.HitPos then
		local check = {}
		check.start = trace.HitPos + trace.HitNormal
		check.endpos = EyePos()
		check.mask = MASK_NPCSOLID_BRUSHONLY
		check = util.TraceLine( check )
		if(check.HitNormal == Vector(0,0,0)) then
			validation = false
		end
	end
	
	tr.mask = MASK_WATER
	local traceline = util.TraceLine(tr)
	
	if traceline.Hit then
		if trace.Fraction > traceline.Fraction then
			if !waterbase then
				ent.valid = false
 				ent:SetNoDraw( true )
 				return
			else
				water = true
			end
		elseif trace.Fraction <= traceline.Fraction then
			if waterbase then
				ent.valid = false
 				ent:SetNoDraw( true )
				return
			else
				water = false
			end
		end
	end
	if water then
		if waterbase then
			trace = table.Copy( traceline )
		else
			ent.valid = false
 			ent:SetNoDraw( true )
			return
		end
	end
	
	if trace.Entity and !trace.Entity:IsWorld() then
		ent.valid = false
 		ent:SetNoDraw( true )
 		return
 	end
	
	if trace.HitNoDraw then
		ent.valid = false
 		ent:SetNoDraw( true )
		return
	end
	
	if player:GetNWInt( "_food" ) < unit.food || player:GetNWInt( "_iron" ) < unit.iron then
		validation = false
	end

	if validation then
		ent.valid = true
		ent:SetColor( 255, 255, 255, 200 )
	else
		ent.valid = false
		ent:SetColor( 255, 0, 0, 150 )
	end

 	if !trace.HitWorld then
		ent.valid = false
 		ent:SetNoDraw( true )
		return
	end

	if trace.HitNormal:Angle().p > 300 || trace.HitNormal:Angle().p < 240 then
		validation = false
	end

	if validation then
		ent.valid = true
		ent:SetColor( 255, 255, 255, 200 )
	else
		ent.valid = false
		ent:SetColor( 255, 0, 0, 150 )
	end

	if ent:GetModel() ~= unit.model then
		ent:SetModel( unit.model )
	end

 	local Ang = trace.HitNormal:Angle() 
 	Ang.pitch = Ang.pitch + 90

	if !steadyProps[string.lower(ent:GetModel())] then
 		ent:SetAngles( Ang )
	else
		ent:SetAngles( Angle( 0, 0, 0 ) )
	end

 	local min = unit.OBBMins
	local max = unit.OBBMaxs
	local size = unit.size

 	local pos = trace.HitPos - trace.HitNormal * min.z
 	ent:SetPos( pos )

	local dir = Ang
	local trace = {}
	trace.mask = MASK_SOLID
	trace.filter = ent
	trace.start = pos
	trace.endpos = pos + (dir:Forward() * min.x) + (dir:Right() * min.y)
	local tr1 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr1.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (dir:Forward() * min.x) + (dir:Right() * max.y)
	local tr2 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr2.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (dir:Forward() * max.x) + (dir:Right() * min.y)
	local tr3 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr3.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (dir:Forward() * max.x) + (dir:Right() * max.y)
	local tr4 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr4.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	local up = Vector( 0, 0, 1 )
	
	if (ent.valid) then
		if (	tr1.Hit and (tr1.HitNormal:Angle().p > 300 || tr1.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr1.HitPos ) ||
			tr2.Hit and (tr2.HitNormal:Angle().p > 300 || tr2.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr2.HitPos ) ||
			tr3.Hit and (tr3.HitNormal:Angle().p > 300 || tr3.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr3.HitPos ) ||
			tr4.Hit and (tr4.HitNormal:Angle().p > 300 || tr4.HitNormal:Angle().p < 240) || !ConfirmBoundary( tr4.HitPos ) ) then
			ent.valid = false
			ent:SetColor( 255, 0, 0, 150 )
		end
	end

	if size then
		local blocked = false
		local units = {"unit_swordsman", "unit_archer", "unit_ballista", "unit_catapult", "unit_scallywag", "unit_galleon"}
		local nearby = {}
		for _, unit in pairs( units ) do
			nearby = table.Add( nearby, ents.FindByClass( unit ) )
		end
		for _, ent in pairs( nearby ) do
			if ent:NearestPoint( pos ):Distance( pos ) <= size then
				blocked = true
				break
			end
		end
		if blocked then
			ent.valid = false
			ent:SetColor( 255, 0, 0, 150 )
		end
	end

 	ent:SetNoDraw( false )
	return true
	
end

function PANEL:ReleaseGhostEntity() 
 	 
 	if ( self.GhostEntity ) then 
 		if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end 
 		self.GhostEntity:Remove() 
 		self.GhostEntity = nil 
 	end 
 	 
end
vgui.Register("UnitPanel", PANEL, "Panel")
UnitMenu.Panel = vgui.Create( "UnitPanel" )

-----------
--Buttons--
-----------

PANEL = {}

function PANEL:Init()
	
	/*
	local panel = vgui.Create( "DModelPanel", self )
	panel:SetMouseInputEnabled( false )
	panel.LayoutEntity = function( panel, ent )
		ent:SetAngles( Angle( 0, 45, 0 ) )
	end
	self.DMP = panel
	*/
	
end

function PANEL:PerformLayout()
	
	/*
	if self.DMP and self.DMP.Entity then
		self.DMP:SetPos( 0, self:GetTall()*0.5-32 )
		self.DMP:SetSize( 64, 64 )
		local b = ents.Create( "prop_physics" ) b:SetModel( self.DMP.Entity:GetModel() )
		local center = b:OBBCenter()
		self.DMP:SetCamPos( Vector( center.x, b:OBBMins():Distance(b:OBBMaxs()), center.z*1.25 ) )
		self.DMP:SetLookAt( Vector( center.x, center.y, center.z ) )
		b:Remove()
	end
	*/
	
end

function PANEL:Think()
	
	/*
	local model = self.mdl
	if !model then return end
	
	if self:LocalToScreen( self.DMP:GetPos() ) > ScrW() - 64 then
		self.DMP:SetVisible( false )
	else
		self.DMP:SetVisible( true )
	end
	
	if !self.DMP.Entity then
		self.DMP:SetModel( model )
	elseif model != self.DMP.Entity:GetModel() then
		self.DMP:SetModel( model )
	end
	*/
	
end

function PANEL:OnCursorEntered()
	
	self.Armed = true
	
end

function PANEL:OnCursorExited()
	
	self.Armed = false
	
end

function PANEL:DoClick()
	
	if self:GetParent().Unit == self.Unit then return end
	
	self:GetParent():ReleaseGhostEntity()
	self:GetParent().Unit = self.Unit
	surface.PlaySound("buttons/lever7.wav")
	
end

function PANEL:Paint()
	
	local bgColor = Color(200, 220, 220, 180)
	local fgColor = color_black
	if self:GetParent().Unit == self.Unit then
		bgColor = Color(220, 220, 220, 255)
		fgColor = color_black
	elseif self.Selected then
		bgColor = Color(250, 250, 250, 200)
		fgColor = color_black
	elseif self.Armed then
		bgColor = Color(200, 220, 220, 200)
		fgColor = color_white
	end
	
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), bgColor)
	draw.SimpleText(self.Text, "Default", 4, 4, Color(0,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(self.Text, "Default", 3, 3, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	
	local food = string.gsub(tostring(self.unit.food), "0%.", ".")
	local iron = string.gsub(tostring(self.unit.iron), "0%.", ".")
	local gold = string.gsub(tostring(self.unit.gold), "0%.", ".")
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( texFood )
	surface.DrawTexturedRect( self:GetWide() - 18, self:GetTall()*0.10, 16, 16 )
	draw.SimpleText(food, "Default", self:GetWide() - 20, self:GetTall()*0.10, Color(0,0,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	surface.SetTexture( texIron )
	surface.DrawTexturedRect( self:GetWide() - 18, self:GetTall()*0.40, 16, 16 )
	draw.SimpleText(iron, "Default", self:GetWide() - 20, self:GetTall()*0.40, Color(0,0,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	surface.SetTexture( texGold )
	surface.DrawTexturedRect( self:GetWide() - 18, self:GetTall()*0.70, 16, 16 )
	draw.SimpleText(gold, "Default", self:GetWide() - 20, self:GetTall()*0.70, Color(0,0,0,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	
	PreviewTextures[string.lower(self.Text)] = PreviewTextures[string.lower(self.Text)] or surface.GetTextureID("sassilization/icons/"..string.lower(self.Text))
	surface.SetTexture( PreviewTextures[string.lower(self.Text)] )
	surface.DrawTexturedRect( 2, 20, 64, 64 )
	
	return true
	
end

vgui.Register( "UnitIcon", PANEL, "Button" )