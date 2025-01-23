/*-------------------------------------------------------------------------------------------------------------------------
	Item preview control
-------------------------------------------------------------------------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
	// Initialize entities for previewing
	self.hatentity = ents.Create( "prop_physics" )
	self.hatentity:SetModel( "models/props_junk/watermelon01.mdl" )
	self.hatentity:SetNoDraw( true )
end

function PANEL:SetHat( hat )
	self.hat = hat
end

function PANEL:SetTrail( trail )
	self.trail = trail
	if ( trail ) then self.trailmaterial = Material( trail.texture ) end
end

function PANEL:LayoutItemEntities()
	if ( self.hat ) then 
		local index = self.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
		local pos, ang = self.Entity:GetBonePosition( index )

		self.hatentity:SetModel( self.hat.model )
		self.hatentity:SetPos( pos + ang:Up() * self.hat.position.x + ang:Right() * self.hat.position.y + ang:Forward() * self.hat.position.z )
		//self.hatentity:SetAngles( ang + self.hat.angle )
		self.hatentity:SetModelScale( self.hat.scale )
		
		local ang2 = Angle( ang.p, ang.y, ang.r )
		ang2:RotateAroundAxis( ang:Right(), self.hat.angle.p )
		ang2:RotateAroundAxis( ang:Up(), self.hat.angle.y )
		ang2:RotateAroundAxis( ang:Forward(), self.hat.angle.r )
		self.hatentity:SetAngles( ang2 )
	end
end

function PANEL:Paint()
	DisableClipping( true )
		draw.RoundedBox( 4, 512 - store.preview.x, 52 - store.preview.y, 283, store.window:GetTall() - 59, Color( 171, 171, 171, 255 ) )
		draw.RoundedBox( 4, 517 - store.preview.x, 57 - store.preview.y, 273, store.window:GetTall() - 69, Color( 52, 54, 59, 255 ) )
	DisableClipping( false )
	
	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )
	self.Entity:SetAngles( Angle( 0, 50 + math.sin( RealTime() * 0.25 ) * 60, 0 ) ) // Tweak angles to see only the front of the player
	self:LayoutItemEntities()

	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	self.Entity:DrawModel()
	if ( self.hat ) then self.hatentity:DrawModel() end
	if ( self.trail and #self.trail.texture > 0 ) then
		render.SetMaterial( self.trailmaterial )
		render.DrawBeam( Vector( 0, 0, 0 ), Vector( 0, -50, 0 ), 15, 0, 0, self.trail.color )
	end

	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()
end

vgui.Register( "ItemPreview", PANEL, "DModelPanel" )