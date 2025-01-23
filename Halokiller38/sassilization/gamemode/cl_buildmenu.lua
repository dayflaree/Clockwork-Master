BuildMenu = {}

local texNo = surface.GetTextureID( "overlays/vip_entry" )
local ghostTrace = {}

local PANEL = {}

function PANEL:Init()
	
	self.Building = 1
	self.Buildings = {}
	self.tabh = 96
	self.tabw = 96
	self.padding = 4
	self:SetTall( self.tabh + 8 )
	
end

function PANEL:PerformLayout() end

function PANEL:Setup()
	
	if !ITEMS then return end
	
	local LP = LocalPlayer()
	if !ValidEntity(LP) then return end
	
	local reposition
	for i, bldg in pairs(BUILDINGS) do
		local allowed = true
		if bldg.name ~= "City" and LP:GetNWInt( "_cities" ) < 1 then
			allowed = false
		end
		if bldg.name == "Gate" then
			if (!ITEMS.gate or ITEMS.gate == 0) and !ALLOWALL then
				allowed = false
			end
		end
		if bldg.name == "ShieldMono" then
			if (!ITEMS.monolith or ITEMS.monolith == 0) and !ALLOWALL then
				allowed = false
			end
		end
		if bldg.name == "Workshop" then
			if (!ITEMS.workshop or ITEMS.workshop == 0) and !ALLOWALL then
				allowed = false
			end
		end
		if bldg.name == "Shrine" then
			if LocalPlayer():GetNWInt( "_workshops" ) < 1 or (!ITEMS.shrine and !ALLOWALL) then
				allowed = false
			end
		end
		if bldg.name == "Horsie" then
			allowed = false
			if LP:GetNWInt( "_workshops" ) >= 100 then
				local allowees = {"UNKNOWN", "10499372", "12454744", "5220505"}
				for _, id in pairs( allowees ) do
					if string.find( LP:GetNWInt("steamid"), id ) then
						allowed = true
						break
					end
				end
			end
		end
		if allowed then
			if !self.Buildings[i] then
				reposition = true
				local button = vgui.Create("BuildingIcon", self)
				button.Building = i
				button.bldg = table.Copy( bldg )
				button.mdl = bldg.model
				button.Text = bldg.name
				button.index = i
				button:SetSize(self.tabw, self.tabh)
				self.Buildings[i] = button
			elseif !self.Buildings[i]:IsVisible() then
				reposition = true
				self.Buildings[i]:SetVisible( true )
			end
		elseif !allowed then
			if self.Buildings[i] and self.Buildings[i]:IsVisible() then
				reposition = true
				self.Buildings[i]:SetVisible( false )
			end
			if self.Building == i then
				reposition = true
				self.Building = 1
			end
		end
	end
	
	local i, count = 0, 0
	for _, btn in pairs( self.Buildings ) do
		if btn:IsVisible() then
			count = count + 1
		end
	end
	for _, btn in pairs( self.Buildings ) do
		if btn:IsVisible() then
			btn:SetPos( ((count-i-1) * self.tabw) + self.padding * (count-i), 5 )
			i = i + 1
		end
	end
	
	self:SetWide( i * self.tabw + self.padding * i + self.padding - 1 )
	
	local x, y = self:GetPos()
	local newX, newY = self:GetPos()
	local w, h, total = ScrW(), ScrH(), UnitMenu.Panel:GetWide() + self:GetWide()
	if inCrouch and !inWalk and !LocalPlayer():KeyDown( IN_SCORE ) || reposition then
		newX, newY = 0, h - self:GetTall()
		if total > w then
			if x != newX || y != newY || reposition then
				UnitMenu.Panel:SetPos( newX + self:GetWide(), h - UnitMenu.Panel:GetTall() )
			end
		end
	elseif total <= w then
		newX, newY = 0, h - self:GetTall()
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
	draw.RoundedBox(0, self:GetWide()-1, 0, 1, self:GetTall(), Color(255,255,255,255))
	
	if (GAMEMODE.ShowScoreboard) then return end
	if (inCrouch and self.invalid) then
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
	elseif !(inCrouch and !inWalk) then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(50,50,50,100))
	end
	if inWalk and !inCrouch then
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,100))
	end
	
end

function PANEL:Think()
	
	local x, y = self:GetPos()
	local w = self:GetWide()
	
	self:Setup()
	
	if (GAMEMODE.ShowScoreboard) then
		SetWorldCursor( "none" )
		self:ReleaseGhostEntity()
		self.invalid = false
		return
	end
	
	if self.Building then
		if !self.Buildings[self.Building] then
			self.Building = 1
			return
		end
		if inCrouch and !inWalk then
			if (ValidEntity( self.GhostEntity )) then
				SetWorldCursor( "blank" )
			elseif !self.invalid then
				SetWorldCursor( "none" )
			end
			self:SetMouseInputEnabled( true )
			if !vgui.CursorVisible() then
				gui.EnableScreenClicker( true )
			elseif (	gui.MouseX() <= x+w	and
					gui.MouseY() >= y	) then
				self:ReleaseGhostEntity()
				self.invalid = false
				return
			end
			self.GhostEntity = self.GhostEntity or self:MakeGhostEntity( self.Buildings[self.Building].bldg )
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
	
	if self.Building == 1 and !ProcessedHints[ "City1" ] then
		GAMEMODE:AddHint( "OpenMenu2", 15 )
	end
	
end

function PANEL:MakeGhostEntity( bldg )  
	
	self:ReleaseGhostEntity()
	
	if (!util.IsValidProp( bldg.model )) then return end
	
	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity) then return end
	
	self.GhostEntity:SetModel( bldg.model )
	self.GhostEntity:SetPos( Vector( 0, 0, 0 ) )
	self.GhostEntity:SetAngles( Angle( 0, 0, 0 ) + bldg.angOff )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	return self.GhostEntity
	
end

local steadyProps = { "models/jaanus/tower.mdl", "" }
local previewEnts = {}

local UPGRADES = {
	{"workshop",50,"workshop_down","models/jaanus/workshop.mdl"},
	{"workshop",50,"workshop","models/jaanus/workshop.mdl"},
	{"tower",20,"archertower_01", "models/jaanus/archertower_02.mdl"},
	{"tower",20,"archertower_02", "models/jaanus/archertower_03.mdl"},
	{"tower",20,"archertower_03", "models/jaanus/archertower_03.mdl"}
}

local function ValidateConnectedWall( wall, conn )
	
	if !ValidEntity(conn) then return end
	if !conn:GetClass() == "bldg_wall" then return end
	if conn:IsDead() then return end
	if string.lower(conn:GetModel()) == "models/jaanus/tower.mdl" then
		local yaw = math.Round((wall:GetPos()-conn:GetPos()):Angle().y)
		local wyaw =  math.Round(wall:GetAngles().y)
		if (	yaw+90 == wyaw	||
			yaw-90 == wyaw	||
			yaw-270 == wyaw	||
			yaw+270 == wyaw	) then
			return true
		else return end
	elseif wall:GetAngles().y != conn:GetAngles().y then return end
	return true
	
end

local function ValidateGateWall( wall )
	
	if wall:IsDead() then return end
	if string.lower(wall:GetModel()) != "models/jaanus/wall.mdl" then return end
	
	local owner = wall:GetOwner()
	if !ValidEntity( owner ) then return end
	if !(owner==LocalPlayer() || owner:GetNWBool( "Ally "..LocalPlayer():UserID() )) then return end
	
	local towerleft, towerright, outerleft, innerleft, innerright, outerright
	local trace, walls, guards = {}, {}, {}
	trace.start = wall:LocalToWorld(wall:OBBCenter())
	trace.endpos = trace.start + wall:GetRight() * wall_spacing
	trace.filter = {wall}
	local tr = util.TraceLine( trace )
	if ValidateConnectedWall( wall, tr.Entity ) then
		innerright = tr.Entity
		trace.start = innerright:LocalToWorld(innerright:OBBCenter())
		trace.endpos = trace.start + innerright:GetRight() * wall_spacing
		table.insert( trace.filter, innerright )
		tr = util.TraceLine( trace )
		if ValidateConnectedWall( wall, tr.Entity ) then
			outerright = tr.Entity
			trace.start = outerright:LocalToWorld(outerright:OBBCenter())
			trace.endpos = trace.start + outerright:GetRight() * wall_spacing
			table.insert( trace.filter, outerright )
			tr = util.TraceLine( trace )
			if ValidateConnectedWall( wall, tr.Entity ) then
				towerright = tr.Entity
			else return end
		else return end
	else return end
	trace.start = wall:LocalToWorld(wall:OBBCenter())
	trace.endpos = trace.start + wall:GetRight() * -wall_spacing
	tr = util.TraceLine( trace )
	if ValidateConnectedWall( wall, tr.Entity ) then
		innerleft = tr.Entity
		trace.start = innerleft:LocalToWorld(innerleft:OBBCenter())
		trace.endpos = trace.start + innerleft:GetRight() * -wall_spacing
		table.insert( trace.filter, innerleft )
		tr = util.TraceLine( trace )
		if ValidateConnectedWall( wall, tr.Entity ) then
			outerleft = tr.Entity
			trace.start = outerleft:LocalToWorld(outerleft:OBBCenter())
			trace.endpos = trace.start + outerleft:GetRight() * -wall_spacing
			table.insert( trace.filter, outerleft )
			tr = util.TraceLine( trace )
			if ValidateConnectedWall( wall, tr.Entity ) then
				towerleft = tr.Entity
			else return end
		else return end
	else return end
	local walls = {outerleft, innerleft, innerright, outerright}
	local guards = {towerleft, towerright}
	local all, lastz = {wall}
	all = table.Add( all, walls )
	all = table.Add( all, guards )
	for k, v in pairs( all ) do
		if lastz and math.abs( v:GetPos().z - lastz ) > gate_maxvary then
			return
		end
		lastz = v:GetPos().z
	end
	return true, walls, guards
	
end

usermessage.Hook( "ClearGatePreview", function( um )
	
	for i=1,4 do
		local ent = Entity( um:ReadShort() )
		if ValidEntity( ent ) then
			ent.oldnodraw = true
		end
	end
	for i=1,2 do
		local ent = Entity( um:ReadShort() )
		if ValidEntity( ent ) then
			ent.oldmdl = "models/jaanus/tower.mdl"
		end
	end
	
end )

function ClearPreviewEnts()
	if #previewEnts > 0 then
		for _, ent in pairs( previewEnts ) do
			if ValidEntity( ent ) then
				if ent.oldmdl then ent:SetModel( ent.oldmdl ) end
				ent.oldmdl = nil
				if ent.oldcol then ent:SetColor( ent.oldcol.r,ent.oldcol.g,ent.oldcol.b,ent.oldcol.a ) end
				ent.oldcol = nil
				if ent.oldnodraw then
					ent:SetNoDraw(true)
				else
					ent:SetNoDraw(false)
				end
				ent.oldnodraw = nil
			end
		end
	end
	previewEnts = {}
end

function PANEL:UpdateGhostEntity( ent, player ) 
	
 	if ( !ent ) then return end
 	if ( !ent:IsValid() ) then return end 
	
	if !inCrouch || player:KeyDown( IN_SCORE ) then
		self:ReleaseGhostEntity()
		return
	end
	
	ClearPreviewEnts()
	
	local bldg	= self.Buildings[self.Building].bldg
 	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
 	local trace 	= util.TraceLine( tr )
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
	if tr.HitNoDraw then
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
	
	tr.mask = MASK_WATER
	local traceline = util.TraceLine(tr)
	
	if traceline.Hit then
		if trace.Fraction > traceline.Fraction then
			ent.valid = false
 			ent:SetNoDraw( true )
			ClearWallPreview( ent )
 			return
		end
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
	if tr.HitNoDraw then
		validation = false
	end

	if LocalPlayer():GetNWInt( "_food" ) < bldg.food || LocalPlayer():GetNWInt( "_iron" ) < bldg.iron then
		validation = false
	end

	if bldg.name == "City" and LocalPlayer():GetNWInt( "_gold" ) < bldg.gold then
		validation = false
	end

	if validation then
		ent.valid = true
		ent:SetColor( 255, 255, 255, 200 )
	else
		ent.valid = false
		ent:SetColor( 255, 0, 0, 150 )
	end

	if (ValidEntity(trace.Entity) and trace.Entity:IsStructure()) then
		for k, v in pairs( UPGRADES ) do
			if string.lower(bldg.name) == v[1] then
				if string.find( trace.Entity:GetModel():lower(), v[3] ) then
					local owner = trace.Entity:GetOwner()
					if !trace.Entity:IsDead() and ValidEntity( owner ) and (owner == player || player:GetNWBool("Ally "..owner:UserID()) == true) then
						if trace.Entity:GetNWBool("spawning") then
							ent:SetColor( 255, 0, 0, 150 )
						end
						ent:SetModel( v[4] )
						ent:SetPos( trace.Entity:GetPos() )
						ent:SetAngles( trace.Entity:GetAngles() )
						ent:SetNoDraw( false )
						return true
					end
				end
			end
		end
		local lastwall = false
		local valid, walls, guards = ValidateGateWall( trace.Entity )
		if bldg.name == "Gate" and valid then
			if valid then
				ent:SetPos( trace.Entity:GetPos() )
				ent:SetAngles( trace.Entity:GetAngles() )
				ent:SetNoDraw( false )
				lastwall = trace.Entity
				lastwall:SetNoDraw( true )
				table.insert( previewEnts, lastwall )
				for _, wall in pairs( walls ) do
					wall:SetNoDraw( true )
					table.insert( previewEnts, wall )
				end
				for _, tower in pairs( guards ) do
					tower.oldmdl = tower:GetModel()
					tower:SetModel("models/Jaanus/tower.mdl")
					local r,g,b,a = tower:GetColor()
					tower.oldcol = Color( r,g,b,a )
					if validation then
						tower:SetColor( 255, 255, 255, 200 )
					else
						tower:SetColor( 255, 0, 0, 150 )
					end
					tower:SetNoDraw( false )
					table.insert( previewEnts, tower )
				end
				return true
			end
		end
 	elseif trace.HitWorld then
		for n, m in pairs( ents.FindInSphere( trace.HitPos, 60 ) ) do
			for k, v in pairs( UPGRADES ) do
				if string.lower(bldg.name) == v[1] then
					if string.find( m:GetModel():lower(), v[3] ) and trace.HitPos:Distance(m:GetPos()) < v[2] then
						local owner = m:GetOwner()
						if !m:IsDead() and ValidEntity( owner ) and (owner == player || player:GetNWBool("Ally "..owner:UserID()) == true) then
							if m:GetNWBool("spawning") then
								ent:SetColor( 255, 0, 0, 150 )
							end
							ent:SetModel( v[4] )
							ent:SetPos( m:GetPos() )
							ent:SetAngles( m:GetAngles() )
							ent:SetNoDraw( false )
							return true
						end
					end
				end
			end
		end
	end

	if !trace.HitWorld then
		ent.valid = false
 		ent:SetNoDraw( true )
		ClearWallPreview( ent )
		return
	end

	if trace.HitWorld and bldg.name == "Gate" then
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

	if ent:GetModel() ~= bldg.model then
		ent.valid = true
		ent:SetModel( bldg.model )
	end

 	local Ang = trace.HitNormal:Angle() 
 	Ang.pitch = Ang.pitch + 90

	if !table.HasValue( steadyProps, string.lower(ent:GetModel()) ) then
 		ent:SetAngles( Ang + bldg.angOff )
	else
		ent:SetAngles( Angle( 0, 0, 0 ) )
	end

 	local min = bldg.OBBMins
	local max = bldg.OBBMaxs

	local pos = trace.HitPos - trace.HitNormal * min.z
 	ent:SetPos( pos )
	
	--Does it fit?!
	local trace = {}
	trace.mask = MASK_SOLID
	trace.filter = ent
	trace.start = pos
	trace.endpos = pos + (Ang:Forward() * min.x) + (Ang:Right() * min.y)
	local tr1 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr1.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (Ang:Forward() * min.x) + (Ang:Right() * max.y)
	local tr2 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr2.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (Ang:Forward() * max.x) + (Ang:Right() * min.y)
	local tr3 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr3.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	trace.endpos = pos + (Ang:Forward() * max.x) + (Ang:Right() * max.y)
	local tr4 = util.TraceLine( trace )
	trace.mask = MASK_NPCSOLID
	local check = util.TraceLine( trace )
	if (check.HitPos != tr4.HitPos) then
		ent:SetColor( 255, 0, 0, 150 )
		ent.valid = false
	end
	trace.mask = MASK_SOLID
	
	if (ent.valid) then
		if (string.lower(bldg.name) != "wall" and string.lower(bldg.name) != "tower") &&
		(	tr1.Fraction < .8		||
			!ConfirmBoundary( tr1.HitPos )	||
			tr2.Fraction < .8		||
			!ConfirmBoundary( tr2.HitPos )	||
			tr3.Fraction < .8		||
			!ConfirmBoundary( tr3.HitPos )	||
			tr4.Fraction < .8		||
			!ConfirmBoundary( tr4.HitPos )	) then
			ent:SetColor( 255, 0, 0, 150 )
			ent.valid = false
		else
			trace.start = pos + (Ang:Forward() * min.x) + (Ang:Right() * min.y)
			trace.endpos = trace.start + Vector( 0, 0, -6 )
			local tr1 = util.TraceLine( trace )
			trace.start = pos + (Ang:Forward() * min.x) + (Ang:Right() * max.y)
			trace.endpos = trace.start + Vector( 0, 0, -6 )
			local tr2 = util.TraceLine( trace )
			trace.start = pos + (Ang:Forward() * max.x) + (Ang:Right() * min.y)
			trace.endpos = trace.start + Vector( 0, 0, -6 )
			local tr3 = util.TraceLine( trace )
			trace.start = pos + (Ang:Forward() * max.x) + (Ang:Right() * max.y)
			trace.endpos = trace.start + Vector( 0, 0, -6 )
			local tr4 = util.TraceLine( trace )
			if (	tr1.Fraction == 1		||
				!ConfirmBoundary( tr1.HitPos )	||
				tr2.Fraction == 1		||
				!ConfirmBoundary( tr2.HitPos )	||
				tr3.Fraction == 1		||
				!ConfirmBoundary( tr3.HitPos )	||
				tr4.Fraction == 1		||
				!ConfirmBoundary( tr4.HitPos )	) then
				ent:SetColor( 255, 0, 0, 150 )
				ent.valid = false
			end
		end
	end
	
	if ent.valid and bldg.model == "models/jaanus/tower.mdl" and !player:KeyDown( IN_SPEED ) then
		self.nextWallPreview = self.nextWallPreview or CurTime()
		if self.lastGhostPos != ent:GetPos() then
			ClearWallPreview( ent )
			GenerateWallPreview( ent )
			self.nextWallPreview = CurTime() + 0.1
		elseif CurTime() > self.nextWallPreview then
			self.nextWallPreview = CurTime() + 3
			ClearWallPreview( ent )
			GenerateWallPreview( ent )
		end
		if ent.nodraw then return end
	else
		ClearWallPreview( ent )
	end
	
	self.lastGhostPos = ent:GetPos()
 	ent:SetNoDraw( false )
	return true
	
end

function PANEL:ReleaseGhostEntity() 
 	 
 	if ( self.GhostEntity ) then 
 		if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end
		ClearWallPreview( self.GhostEntity )
		ClearPreviewEnts()
 		self.GhostEntity:Remove() 
 		self.GhostEntity = nil 
 	end 
 	 
end
vgui.Register("BuildPanel", PANEL, "Panel")
BuildMenu.Panel = vgui.Create( "BuildPanel" )






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
	
	if self:GetParent().Building == self.Building then return end
	
	self:GetParent():ReleaseGhostEntity()
	self:GetParent().Building = self.Building
	surface.PlaySound("buttons/lever7.wav")
	
end

function PANEL:Paint()
	
	local bgColor = Color(200, 220, 220, 180)
	local fgColor = color_black
	if self:GetParent().Building == self.Building then
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
	
	local food = string.gsub(tostring(self.bldg.food), "0%.", ".")
	local iron = string.gsub(tostring(self.bldg.iron), "0%.", ".")
	local gold = string.gsub(tostring(self.bldg.gold), "0%.", ".")
	
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
vgui.Register( "BuildingIcon", PANEL, "Button" )

local WallPreview = {}
WallPreview.ents = {}

local function IsTower( ent )
	return string.lower(ent:GetModel()) == "models/jaanus/tower.mdl"
end

function ClearWallPreview( ghost )
	
	ghost.nodraw = nil
	if table.Count( WallPreview.ents ) == 0 then return end
	
	for _, ent in pairs( WallPreview.ents ) do
		if ValidEntity( ent ) then
			ent:Remove()
		end
	end
	
end

local function GetWallPreviewPositions( ghost, wall1, wall2 )
	local start = wall1:GetPos() + ( wall1:GetUp() * 10)
	local trace = {}
	trace.start = start
	trace.endpos = wall2:GetPos() + ( wall2:GetUp() * 10)
	trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine( trace )
	if tr.HitWorld then return end
	local distance = math.Round( trace.start:Distance(trace.endpos) )
	local count = math.Round( distance / wall_spacing )
	local angle = (trace.endpos - trace.start):Angle()
	local i, chunk, walls = nil, distance / count, {}
	for i=1, count - 1 do
		trace.start = start + ( angle:Up() * 10 ) + ( i * angle:Forward() * chunk )
		trace.endpos = trace.start + Vector( 0, 0, -100 )
		trace.mask = MASK_NPCWORLDSTATIC
		tr = util.TraceLine( trace )
		
		trace.mask = MASK_WATER
		
		local traceline = util.TraceLine(trace)
		
		if traceline.Hit then
			if tr.Fraction > traceline.Fraction then return end
		end
		
		if tr.Hit then
			table.insert( walls, tr.HitPos - tr.HitNormal )
		end
	end
	local gold = BUILDINGS[2].gold * #walls
	local iron = BUILDINGS[2].iron * #walls
	local food = BUILDINGS[2].food * #walls
	if wall1 == ghost then
		gold = gold + BUILDINGS[2].gold
		iron = iron + BUILDINGS[2].iron*2
		food = food + BUILDINGS[2].food*2
	end
	local LP = LocalPlayer()
	if LP:GetNWInt( "_iron" ) < iron || LP:GetNWInt( "_food" ) < food then
		return walls, Angle( 0, angle.y + 90, 0 )
	else
		return walls, Angle( 0, angle.y + 90, 0 ), true
	end
end

function GenerateWallPreview( ghost )
	
	//Step one --Get the two wall towers to connect
	
	local LP = LocalPlayer()
	local distance, wall1, wall2 = wall_distance
	local possibles = ents.FindInSphere( ghost:GetPos(), wall_distance )
	
	for _, ent in pairs( possibles ) do
		if IsTower( ent ) and (ent:GetOwner() == LP || ent:GetOwner():GetNWBool( "Ally "..LP:UserID() )) then
			local dis = ent:GetPos():Distance( ghost:GetPos() )
			if dis <= distance then
				distance = dis
				wall1 = ent
			end
		end
	end
	
	if distance <= wall_spacing+3 then return end
	if !wall1 then return end
	
	distance = wall_distance
	for _, ent in pairs( possibles ) do
		if IsTower( ent ) and ent != wall1 and (ent:GetOwner() == LP || ent:GetOwner():GetNWBool( "Ally "..LP:UserID() )) then
			local dis = ent:GetPos():Distance( ghost:GetPos() )
			if dis <= distance then
				distance = dis
				wall2 = ent
			end
		end
	end
	
	if wall2 and ((wall1:GetPos()+wall2:GetPos())*0.5):Distance(ghost:GetPos()) < 20 and wall1:GetPos():Distance(wall2:GetPos()) < wall_distance*0.5 then
		local trace = {}
		trace.start = wall1:GetPos() + Vector( 0, 0, 5 )
		trace.endpos = wall2:GetPos() + Vector( 0, 0, 5 )
		trace.filter = {ghost, wall1}
		trace.filter = table.Add( trace.filter, player.GetAll() )
		trace = util.TraceLine( trace )
		if trace.Entity == wall2 then
			ghost:SetNoDraw( true )
			ghost.nodraw = true
		else
			wall2 = wall1
			wall1 = ghost
		end
	else
		wall2 = wall1
		wall1 = ghost
	end
	
	//Step two --Find all the connection wall positions
	
	local walls, ang, affordable = GetWallPreviewPositions( ghost, wall1, wall2 )
	if !walls then return end
	if #walls == 0 then return end
	
	//Step three --Spawn and place all the connection walls
	for _, pos in pairs( walls ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetModel( "models/jaanus/wall.mdl" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn()
 		ent:SetMoveType( MOVETYPE_NONE )
		ent:SetNotSolid( true )
		ent:SetRenderMode( RENDERMODE_TRANSALPHA )
		ent:SetColor( 255, affordable and 255 or 0, affordable and 255 or 0, 100 )
		table.insert( WallPreview.ents, ent )
	end
			
end