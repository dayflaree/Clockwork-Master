/*-------------------------------------------------------------------------------------------------------------------------
	Store item control
-------------------------------------------------------------------------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	self:SetTall( 55 )
	
	self.model = vgui.Create( "DModelPanel", self )
	self:SetModel( "models/props_junk/watermelon01.mdl" )	
	self.model:SetPos( 5, 5 )
	self.model:SetSize( 43, 43 )
	self.model.OldPaint = self.model.Paint
	self.model.Paint = function()
		if ( self.category == "trail" and self.texture ) then
			surface.SetTexture( self.texture )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 1, 1, self:GetWide(), self:GetTall() )
		elseif ( self.category != "trail" ) then
			self.model:OldPaint()
		end
	end
	
	self.itemname = vgui.Create( "DLabel", self )
	self.itemname:SetPos( 55, 5 )
	self.itemname:SetTextColor( color_white )
	self.itemname:SetFont( "DefaultBold" )
	
	self.itemdescription = vgui.Create( "DLabel", self )
	self.itemdescription:SetPos( 55, 18 )
	self.itemdescription:SetTextColor( color_white )
	self.itemdescription:SetFont( "DefaultSmall" )
	
	self.itemprice = vgui.Create( "DLabel", self )
	self.itemprice:SetPos( self:GetWide() - 300, 35 )
	self.itemprice:SetTextColor( color_white )
	self.itemprice:SetFont( "DefaultBold" )
	
	self.buttonlabel = vgui.Create( "DLabel", self )
	self.buttonlabel:SetPos( 80, 35 )
	self.buttonlabel:SetTextColor( color_white )
	self.buttonlabel:SetFont( "DefaultBold" )
	
	self.buttonlabel2 = vgui.Create( "DLabel", self )
	self.buttonlabel2:SetPos( 145, 35 )
	self.buttonlabel2:SetTextColor( color_white )
	self.buttonlabel2:SetFont( "DefaultBold" )
	
	self.buttonenabled2 = true
end

function PANEL:OnCursorMoved( x, y )
	self.buttonhover = x >= 55 and y >= 36 and x <= 105 and y <= 50
	self.buttonhover2 = x >= 110 and y >= 36 and x <= 180 and y <= 50
end

function PANEL:OnCursorExited()
	self.buttonhover = false
	self.buttonhover2 = false
	
	if ( self.category == "hat" ) then
		store.preview:SetHat( store.hat )
	elseif ( self.category == "model" ) then
		store.preview:SetModel( ( store.model and store.model.id != 1 ) and store.model.model or store.DefaultModel( LocalPlayer() ) )
	elseif ( self.category == "trail" ) then
		store.preview:SetTrail( store.trail )
	end
end

function PANEL:Think()
	if ( self.buttonhover2 and self.category == "hat" and input.IsMouseDown( MOUSE_LEFT ) and self.item.id != 1 and !table.HasValue( store.ownedhats, self.item.id ) and !self.previewing ) then
		store.preview:SetHat( self.item )
		self.previewing = true
	elseif ( self.buttonhover2 and self.category == "model" and input.IsMouseDown( MOUSE_LEFT ) and self.item.id != 1 and !table.HasValue( store.ownedmodels, self.item.id ) and !self.previewing ) then
		store.preview:SetModel( self.item.model )
		self.previewing = true
	elseif ( self.buttonhover2 and self.category == "trail" and input.IsMouseDown( MOUSE_LEFT ) and self.item.id != 1 and !table.HasValue( store.ownedmodels, self.item.id ) and !self.previewing ) then
		store.preview:SetTrail( self.item )
		self.previewing = true
	end
end

function PANEL:OnMouseReleased( mc )
	if ( self.buttonenabled and self.buttonhover ) then
		RunConsoleCommand( "store_item", self.category, table.HasValue( store["owned"..self.category.."s"], self.item.id ) and "sell" or "buy", self.item.id )
	elseif ( self.buttonenabled2 and self.buttonhover2 ) then
		if ( self.category == "hat" and self.item.id != 1 and !table.HasValue( store.ownedhats, self.item.id ) ) then
			store.preview:SetHat( store.hat )
		elseif ( self.category == "model" and self.item.id != 1 and !table.HasValue( store.ownedmodels, self.item.id ) ) then
			store.preview:SetModel( ( store.model and store.model.id != 1 ) and store.model.model or store.DefaultModel( LocalPlayer() ) )
		elseif ( self.category == "trail" and self.item.id != 1 and !table.HasValue( store.ownedtrails, self.item.id ) ) then
			store.preview:SetTrail( store.trail )
		else
			RunConsoleCommand( "store_equip", self.category, self.item.id )
		end
	end
	
	self.previewing = false
end

function PANEL:Paint()
	surface.SetDrawColor( 128, 128, 128, 255 )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	surface.DrawOutlinedRect( 5, 5, 45, 45 )
	
	// Buy/sell button
	if ( self.buttonenabled and self.buttonhover ) then
		surface.SetDrawColor( 63*1.5, 65*1.5, 72*1.5, 255 )
	else
		surface.SetDrawColor( 63, 65, 72, 255 )
	end
	surface.DrawRect( 55, 36, 50, 14, self:GetTall() )
	surface.SetDrawColor( 128, 128, 128, 255 )
	surface.DrawOutlinedRect( 55, 36, 50, 14, self:GetTall() )
	
	// Preview/equip button
	if ( self.buttonenabled2 and self.buttonhover2 ) then
		surface.SetDrawColor( 63*1.5, 65*1.5, 72*1.5, 255 )
	else
		surface.SetDrawColor( 63, 65, 72, 255 )
	end
	surface.DrawRect( 110, 36, 70, 14, self:GetTall() )
	surface.SetDrawColor( 128, 128, 128, 255 )
	surface.DrawOutlinedRect( 110, 36, 70, 14, self:GetTall() )
	
	// Update view stuff
	if ( self.category != "trail" ) then
		self.model:SetCamPos( Vector( 1, 1, 1 ) * self.model.Entity:BoundingRadius() * 1.4 )
		self.model:SetLookAt( self.model.Entity:OBBCenter() )
	end
end

function PANEL:PerformLayout()
	self.model:SetPos( 5, 5 )
	self.itemname:SetPos( 55, 5 )
	self.itemdescription:SetPos( 55, 21 )
	
	if ( self.category != "trail" ) then
		self:SetModel( self.item.model )
		if ( self.model:GetAnimated() ) then self.model.Entity:ResetSequence( self.model.Entity:LookupSequence( "run_all" ) ) end
	end
	
	self.itemname:SetText( self.item.name )
	self.itemname:SizeToContents()
	self.itemdescription:SetText( self.item.description )
	self.itemdescription:SizeToContents()
	
	if ( table.HasValue( store["owned"..self.category.."s"], self.item.id ) or self.item.id == 1 ) then
		self.itemprice:SetText( self.item.id != 1 and ( store.CalculateSellPrice( self.item.price ) .. " coins" ) or "Not sellable" )
		self.itemprice:SizeToContents()
		self.itemprice:SetTextColor( color_white )
		
		self.buttonenabled = self.item.id != 1
		self.buttonlabel:SetText( "Sell" )
		self.buttonlabel:SetTextColor( self.item.id != 1 and color_white or Color( 128, 128, 128, 255 ) )
		
		self.buttonlabel2:SetText( "Equip" )
	else
		self.buttonenabled = store.money >= self.item.price
		
		self.itemprice:SetText( self.item.price .. " coins" )
		self.itemprice:SetTextColor( self.buttonenabled and color_white or Color( 128, 128, 128, 255 ) )
		self.itemprice:SizeToContents()
		
		self.buttonlabel:SetText( "Buy" )
		self.buttonlabel:SetTextColor( self.buttonenabled and color_white or Color( 128, 128, 128, 255 ) )
		
		self.buttonlabel2:SetText( "Preview" )
	end
	
	self.buttonlabel:SizeToContents()
	self.buttonlabel:SetPos( 80 - self.buttonlabel:GetWide() / 2, 35 )
	self.buttonlabel2:SizeToContents()
	self.buttonlabel2:SetPos( 145 - self.buttonlabel2:GetWide() / 2, 35 )
	
	self.itemprice:SetPos( self:GetWide() - self.itemprice:GetWide() - 5, 35 )
end

function PANEL:SetItem( item, category )
	self.item = item
	self.category = category
	
	self.model:SetAnimated( category == "model" )
	self.model:SetAnimSpeed( 1 )
	
	if ( category == "trail" and item.previewtexture ) then
		self.texture = surface.GetTextureID( item.previewtexture )
	end
	
	self:InvalidateLayout()
end

function PANEL:SetModel( model )
	// Hack to make BoundingDistance() work
	local t = ClientsideModel
	ClientsideModel = function( model ) local e = ents.Create( "prop_physics" ) e:SetModel( model ) return e end
	self.model:SetModel( model )
	ClientsideModel = t
end

vgui.Register( "StoreItem", PANEL )