local PANEL = { };

function PANEL:Paint( w, h )
	
	return true;

end

derma.DefineControl( "IClearPanel", "", PANEL, "EditablePanel" );

local PANEL = { };

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

function PANEL:Init()
	
	self.LastPaint = 0;
	
	self:SetText( "" );
	self:SetAnimSpeed( 0.5 );
	self:SetAnimated( true );
	
	self:SetAmbientLight( Color( 50, 50, 50 ) );
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) );
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) );
	
	self:SetColor( Color( 255, 255, 255, 255 ) );
	
	self.Entity = ClientsideModel( "models/humans/group01/male_01.mdl", RENDER_GROUP_OPAQUE_ENTITY );
	self.Entity:SetNoDraw( true );
	
	self:SetCamPos( Vector( 50, 50, 50 ) );
	self:SetLookAt( Vector( 0, 0, 55 ) );
	self:SetFOV( 30 );
	
	self.HasModel = false;
	
end

function PANEL:SetModel( strModelName )
	
	self.Entity:SetModel( strModelName );
	self.Entity:SetNoDraw( true );
	
	if( string.len( strModelName ) == 0 ) then
		
		self.HasModel = false;
		
	else
		
		self.HasModel = true;
		
	end
	
end

function PANEL:GetModel()
	
	return self.Entity:GetModel();
	
end

function PANEL:SetSubMaterial( i, j )
	
	self.Entity:SetSubMaterial( i, j );
	
end

function PANEL:OnMouseWheeled( dlta )
	
	if( !self.NoMouseWheel and string.len( self:GetModel() ) > 0 ) then
		
		self:SetFOV( math.Clamp( self:GetFOV() + dlta * -2, 20, 60 ) );
		
	end
	
end

function PANEL:Paint()
	
	if( !IsValid( self.Entity ) ) then return end
	if( !self.HasModel ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self:LayoutEntity( self.Entity )
	
	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetSize() )
		cam.IgnoreZ( true )
		
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a / 255 )
		
		for i=0, 6 do
			local col = self.DirectionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end
		
		local curparent = self
		local rightx = self:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = self:GetTall()
		local previous = curparent
		while(curparent:GetParent() != nil) do
			curparent = curparent:GetParent()
			local x,y = previous:GetPos()
			topy = math.Max(y, topy+y)
			leftx = math.Max(x, leftx+x)
			bottomy = math.Min(y+previous:GetTall(), bottomy + y)
			rightx = math.Min(x+previous:GetWide(), rightx + x)
			previous = curparent
		end
		render.SetScissorRect(leftx,topy,rightx, bottomy, true)
		self.Entity:DrawModel()
		render.SetScissorRect(0,0,0,0, false)
		
		hook.Run("PostDrawCharPanel", self, self.Entity)
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()
	
	if( self.Dark ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	self.LastPaint = RealTime()
	
end

hook.Add( "PostDrawCharPanel", "charpanel", function( panel, entity )
	
	if ( panel.modelList ) then
		
		for k,v in pairs( panel.modelList ) do
		
			if ( v[1].drawModel == true ) then
			
				if( ( v[2] == "hair" ) or ( v[2] == "facialhair" ) ) then
				
					render.SetColorModulation( v[1]:GetColor().r / 255, v[1]:GetColor().g / 255, v[1]:GetColor().b / 255 );
					
				end
				v[1]:SetupBones();
				v[1]:DrawModel();
				render.SetColorModulation( 1, 1, 1 );
				
			end
			
		end
		
	end
	
end )

function PANEL:InitializeModel( mdl, parent, type )

	if( !self.modelList ) then self.modelList = {} end;

	b = ClientsideModel( mdl, RENDERGROUP_OPAQUE );
	if( !b ) then return end;
	b:SetParent( parent );
	b:AddEffects( EF_BONEMERGE );
	b:SetupBones();
	if( string.len( mdl ) == 0 ) then
		
		b.drawModel = false;
		
	else
		
		b.drawModel = true;
		
	end
		
	self.modelList[#self.modelList + 1] = { b, type };
	
	return b;
	
end

function PANEL:ChildSetBodygroup( ent, bodygroup, value )

	ent:SetBodygroup( bodygroup, value );

end

function PANEL:ChildSetColor( ent, color )

	ent:SetColor( color );

end

function PANEL:ChildSetModel( ent, mdl )

	if( !IsValid( ent ) ) then return end;

	ent:SetModel( mdl );
	
	if( string.len( mdl ) == 0 ) then
		
		ent.drawModel = false;
		
	else
		
		ent.drawModel = true;
		
	end

end

function PANEL:ChildSetSkin( ent, skin )

	ent:SetSkin( skin );
	
end

function PANEL:ChildSetSubMaterial( ent, index, material )

	ent:SetSubMaterial( index, material );

end

function PANEL:SetupPlayer( ent )

	local face = self:InitializeModel( ent:Face(), self.Entity, "face" );
	local armsMdl,armsSkin = GAMEMODE:GetModelArms( self.Entity:GetModel(), ent:Face() );
	local arms = self:InitializeModel( armsMdl, self.Entity, "arms" ); -- wont be draw by the model panel in most circumstances
	local hair = self:InitializeModel( ent:Hair(), face, "hair" );
	local facialhair;
	
	if( hair ) then
	
		hair:SetColor( string.ToColor( ent:HairColor() ) );
		
	end
	
	if( ent:Sex() == MALE ) then
	
		facialhair = self:InitializeModel( ent:FacialHair(), face, "facialhair" );
		if( facialhair ) then
			
			facialhair:SetColor( string.ToColor( ent:HairColor() ) );
			
		end
		
	end
	
	if( arms ) then
	
		self:ChildSetSkin( arms, armsSkin );
		
	end
	
	if( face ) then
	
		self:ChildSetSubMaterial( face, face:GetFacemap(), ent:Facemap() );
	
		for _,v in pairs( face:GetEyemap() ) do
		
			self:ChildSetSubMaterial( face, v, ent:Eyemap() );
			
		end
		
	end

end

function PANEL:OnRemove()

	if( self.modelList ) then
	
		for k,v in pairs( self.modelList ) do
		
			v[1]:Remove();
		
		end
		
		self.modelList = nil;
		
	end

	if( IsValid( self.Entity ) ) then
	
		self.Entity:Remove();
		
	end

end

function PANEL:ChildRemove( ent )

	for k,v in pairs( self.modelList ) do
	
		if( v[1] == ent ) then
		
			self.modelList[k] = nil;
			ent:Remove();
			
		end
		
	end
	
end

function PANEL:RemoveAllChildren()

	if( !self.modelList ) then return end

	for k,v in pairs( self.modelList ) do
	
		self:ChildRemove(v[1])
		
	end
	
	self.modelList = nil;
	
end

PANEL.Anims = { };
PANEL.Anims["idle"] = { "idle_subtle", "idle_all" };
PANEL.Anims["walk"] = { "walk_all", "WalkUnarmed_all", "walk_all_moderate" };

function PANEL:StartAnimation( set )
	
	if( !self.Anims[set] ) then return end
	
	local seq = -1;
	
	for _, v in pairs( self.Anims[set] ) do
		
		if( seq <= 0 ) then
			
			seq = self.Entity:LookupSequence( v );
			
		end
		
		if( seq > 0 ) then
			
			self.bAnimated = true;
			self.Entity:ResetSequence( seq );
			break;
			
		end
		
	end
	
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed );
end

function PANEL:StartScene( name )
	
	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end
	
	self.Scene = ClientsideScene( name, self.Entity )
	
end

function PANEL:SetLookAtEyes()
	
	local attach = self.Entity:LookupAttachment( "eyes" );
	
	if( attach ) then
		
		local angpos = self.Entity:GetAttachment( attach );
		
		if( angpos ) then
			
			self:SetLookAt( angpos.Pos - Vector( 0, 0, 2 ) );
			return;
		
		end
		
	end
	
	self:SetLookAt( Vector( 0, 0, 64 ) );
	
end

function PANEL:OnMousePressed( code )
	
	if( self.DoClick ) then
		
		self:DoClick();
		
	end
	
	if( self.HasModel ) then
		
		self:MouseCapture( true );
		self.MouseDetect = true;
		
		local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
		input.SetCursorPos( centerx, centery );
		
		self.MX = centerx;
		self.MY = centery;
		
	end
	
end

function PANEL:OnMouseReleased( code )
	
	if( self.HasModel ) then
		
		self:MouseCapture( false );
		self.MouseDetect = false;
		
	end
	
end

function PANEL:LayoutEntity( Entity )
	
	if( self.bAnimated ) then
		self:RunAnimation();
	end
	
	if( self.MouseDetect ) then
		
		local xpos = gui.MouseX();
		local ypos = gui.MouseY();
		
		local dx = xpos - self.MX;
		local dy = ypos - self.MY;
		
		input.SetCursorPos( self.MX, self.MY );
		
		Entity:SetAngles( Entity:GetAngles() + Angle( 0, dx, 0 ) );
		
	else
		
		local ang = Entity:GetAngles();
		ang = ang * 0.9;
		Entity:SetAngles( ang );
		
	end
	
	if( self.HeadFollowMouse ) then
		
		local mx = gui.MouseX() / ScrW();
		local my = gui.MouseY() / ScrH();
		
		local rxa, rxb = Entity:GetPoseParameterRange( 6 );
		local rya, ryb = Entity:GetPoseParameterRange( 7 );
		
		local px = Lerp( mx, rxa, rxb );
		local py = Lerp( my, rya, ryb );
		
		Entity:SetPoseParameter( "head_yaw", px );
		Entity:SetPoseParameter( "head_pitch", py );
		
	end
	
end

vgui.Register( "ICharPanel", PANEL, "DModelPanel" );

PANEL = { };

function PANEL:Init()
	
	self.ContentScroll = vgui.Create( "DScrollPanel", self );
	self.ContentScroll:SetPos( 10, 40 );
	self.ContentScroll:SetSize( GAMEMODE.ChatWidth - 20, GAMEMODE.ChatHeight - 80 );
	function self.ContentScroll:Paint( w, h )
		
		surface.SetDrawColor( 0, 0, 0, 70 );
		surface.DrawRect( 0, 0, w, h );
		
		surface.SetDrawColor( 0, 0, 0, 100 );
		surface.DrawOutlinedRect( 0, 0, w, h );
		
	end
	
	self.Content = vgui.Create( "EditablePanel" );
	self.Content:SetPos( 0, 0 );
	self.Content:SetSize( GAMEMODE.ChatWidth - 20, 20 );
	self.Content.Paint = function( content, pw, ph )
		
		local y = 0;
		
		for k, v in pairs( GAMEMODE.ChatLines ) do
			
			local start = v[1];
			local filter = v[2];
			local font = v[3];
			local color = v[4];
			local text = v[5];
			local ply = v[6];
			local formatted = v[7];
			
			if( table.HasValue( filter, GAMEMODE.ChatboxFilter ) ) then
				
				local expl = string.Explode( "\n", formatted );
				
				for _, v in pairs( expl ) do
					
					surface.SetFont( font );
					local _, h = surface.GetTextSize( v );
					
					local mx, my = self.ContentScroll:GetCanvas():GetPos();
					
					if( my + y > -20 ) then
						
						draw.DrawTextShadow( string.sub( v, 1, 196 ), font, 0, y, color, Color( 0, 0, 0, 255 ), 0 );
						
					end
					
					y = y + h;
					
				end
				
			end
			
		end
		
		if( ph != math.max( y, 20 ) ) then
			
			content:SetTall( math.max( y, 20 ) );
			self.ContentScroll:PerformLayout();
			
			if( self.ContentScroll.VBar ) then
				
				self.ContentScroll.VBar:SetScroll( math.huge );
				
			end
			
		end
		
	end
	
	self.ContentScroll:AddItem( self.Content );
	
end

function PANEL:Paint( w, h )
	
	local x1, y1, w1, h1 = self:GetBounds();
	
	local us = x1 / ScrW();
	local vs = y1 / ScrH();
	local ue = ( x1 + w1 ) / ScrW();
	local ve = ( y1 + h1 ) / ScrH();
	
	draw.DrawBlur( 0, 0, w, h, us, vs, ue, ve, 1 );
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	return true

end

derma.DefineControl( "IChatPanel", "", PANEL, "EditablePanel" );

local PANEL = { };

function PANEL:Init()
	
	local y = 0;
	
	for _, v in pairs( player.GetAll() ) do
		
		local a = vgui.Create( "ICharPanel", self );
		a:SetPos( 0, y );
		a:SetSize( 84, 84 );
		a.Entity:SetAngles( Angle() );
		a:SetCamPos( Vector( 50, 20, 67 ) );
		a:SetLookAtEyes();
		a:SetFOV( 15 );
		a:SetModel( v:GetModel() );
		a:SetupPlayer( v );
		a.NoMouseWheel = true;
		
		function a:DoClick()
			
			if( v:SteamID64() ) then
				
				gui.OpenURL( "http://steamcommunity.com/profiles/" .. v:SteamID64() .. "/" );
				
			end
			
		end
		
		for i = 0, #v:GetMaterials() - 1 do
			
			a:SetSubMaterial( i, v:GetSubMaterial( i ) );
			
		end
		
		y = y + 84;
		
	end
	
end

function PANEL:Paint( w, h )
	
	DisableClipping( false );
	
	local y = 0;
	local i = 0;
	
	for _, v in pairs( player.GetAll() ) do
		
		if( i % 2 == 0 ) then
			
			draw.RoundedBox( 0, 4, y, w - 8, 84, Color( 0, 0, 0, 120 ) );
			
		end
		
		i = i + 1;
		
		surface.SetFont( "Infected.PlayerName" );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetTextPos( 84 + 10, y + 4 );
		surface.DrawText( v:RPName() );
		
		local wh, hh = surface.GetTextSize( v:Ping() );
		surface.SetTextPos( 500 - wh - 12 - 10, y + 4 );
		surface.DrawText( v:Ping() );
		
		surface.SetFont( "Infected.LabelSmaller" );
		surface.SetTextPos( 84 + 10, y + 4 + 30 );
		surface.DrawText( v:Nick() );
		
		local c = Vector( v:PlayerTitleColor() );
		
		surface.SetTextColor( Color( c.x, c.y, c.z, 255 ) );
		surface.SetTextPos( 84 + 10, y + 4 + 30 + 20 );
		surface.DrawText( v:PlayerTitle() );
		
		y = y + 84;
		
	end
	
	y = y + 84;
	
	self:SetTall( y );
	GAMEMODE.D.Scoreboard.Scroll:PerformLayout();
	
	DisableClipping( true );

end

derma.DefineControl( "IScoreboard", "", PANEL, "EditablePanel" );