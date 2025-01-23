
surface.CreateFont( "Bebas", 18, 400, true, false, "VGUITitle" );

-------------------------------------------------------
-- MODEL PANEL
-------------------------------------------------------

local MODEL = { }

function MODEL:Paint()

	 -- Copy paste from Gmod code --
     if ( !IsValid( self.Entity ) ) then return end
	 
	 if( !self.vLookatPos ) then self:SetLookAt( Vector( 0, 0, 40 ) ) end
	 if( !self.vCamPos ) then self:SetCamPos( Vector( 50, 50, 50 ) ) end
       
     local x, y = self:LocalToScreen( 0, 0 )  
       
     self:LayoutEntity( self.Entity )  
       
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
       
     render.SuppressEngineLighting( false )  
     cam.IgnoreZ( false )  
     cam.End3D()  
       
     self.LastPaint = RealTime()  
    -- End copy paste --
    
    if( self.PaintHook ) then
    	self.PaintHook( self );
    end
      
end

vgui.Register( "BModelPanel", MODEL, "DModelPanel" );

-------------------------------------------------------
-- LINK
-------------------------------------------------------

local LINK = { }

function LINK:Init()

	self.Text = "";
	self.Font = "NewChatFont";
	
	self.Entered = false;
	
	self.Action = nil;
	
	self.NormalColor = self.NormalColor or Color( 255, 255, 255, 255 );
	self.HighlightColor = self.HightlightColor or Color( 100, 100, 100, 255 );
	
	self.Alpha = 255;
	self.FadeIn = false;
	self.FadeOut = false;
	self.FadeSpeed = 50;
	
	self.Glow = false;
	self.GlowAlpha = 0;
	self.GlowDir = 1;

end

function LINK:SetNormalColor( color )

	self.NormalColor = color;

end


function LINK:SetHighlightColor( color )

	self.HighlightColor = color;

end

function LINK:SetAction( func )

	self.Action = func;

end

function LINK:OnCursorEntered()

	self.Entered = true;

end

function LINK:OnCursorExited()

	self.Entered = false;

end

function LINK:OnMouseReleased( mc )

	if( mc == MOUSE_LEFT ) then

		if( self.Action ) then
		
			self.Action( self );
			--self.Glow = !self.Glow;
		
		end
		
	else
	
		if( self.RightAction ) then
		
			self.RightAction( self );
		
		end		
	
	end

end

function LINK:FadingOut( speed )

	self.FadeOut = true;
	self.FadeSpeed = speed;	
	self.FadeIn = false;

end

function LINK:FadingIn( speed )

	self.FadeIn = true;
	self.FadeOut = false;
	self.Alpha = 0;
	self.FadeSpeed = speed;

end

function LINK:FadeDelay( delay )

	self.DelayStart = CurTime();
	self.DelayTime = delay;

end

function LINK:SetText( str, font, align )

	if( font == nil ) then
		font = self.Font;
	end

	surface.SetFont( font );
	local w, h = surface.GetTextSize( str );

	self:SetSize( w, h );
	
	self.Text = str;
	self.Font = font;
	
	if( align == true or align == 1 ) then
	
		local xoffset = w / 2;
		
		local x, y = self:GetPos();
		
		self:SetPos( x - xoffset, y );
	
	elseif( align == 2 ) then
	
		local xoffset = w;
		
		local x, y = self:GetPos();
		
		self:SetPos( x - xoffset, y );		
	
	end

end

function LINK:Paint()

	self.GlowAlpha = self.GlowAlpha + 800 * FrameTime() * self.GlowDir;

	if( self.GlowAlpha > 255 ) then
	
		self.GlowAlpha = 255;
		self.GlowDir = -1;
	
	end
	
	if( self.GlowAlpha < 0 ) then
	
		self.GlowAlpha = 0;
		self.GlowDir = 1;
	
	end


	if( self.Glow ) then
	
		draw.DrawTextGlowing( self.Text, self.Font, 0, 0, Color( 255, 255, 255, 255 ), 0, 0, 2, Color( 255, 255, 255, self.GlowAlpha ) ); 		
		return;
	
	end

	if( not self.Entered ) then
	
		self.NormalColor.a = self.Alpha;
		draw.DrawText( self.Text, self.Font, 0, 0, self.NormalColor );

	else
	
		self.HighlightColor.a = self.Alpha;
		draw.DrawText( self.Text, self.Font, 0, 0, self.HighlightColor );
		
	end

	if( not self.DelayStart or CurTime() - self.DelayStart > self.DelayTime ) then

		if( self.FadeIn ) then
		
			self.Alpha = math.Clamp( self.Alpha + self.FadeSpeed * FrameTime(), 0, 255 );
		
		end
		
		if( self.FadeOut ) then
		
			self.Alpha = math.Clamp( self.Alpha - self.FadeSpeed * FrameTime(), 0, 255 );
		
		end
		
	end
	
end

vgui.Register( "BLink", LINK, "Panel" );


-------------------------------------------------------
-- BUTTON
-------------------------------------------------------

surface.CreateFont( "Bebas", 18, 200, true, false, "ButtonFont" );

local BUTTON = { }

function BUTTON:Init()

	self.Text = "";
	self.Font = "ButtonFont";
	
	self.Entered = false;
	
	self.Action = nil;
	
	self.Outline = 4;
	
	self.HighlightRed = false;
	self.AlwaysHighlight = false;
	
	self.MouseDown = false;

end

function BUTTON:SetAction( func )

	self.Action = func;

end

function BUTTON:OnCursorEntered()

	self.Entered = true;

end

function BUTTON:OnCursorExited()

	self.Entered = false;

end

function BUTTON:Think()

	if( self.MouseDown ) then
	
		if( self.MouseDownThink ) then
		
			self.MouseDownThink( self );
		
		end
		
	end
	
	if( self.ThinkHook ) then
	
		self.ThinkHook();
	
	end

end

function BUTTON:OnMousePressed()

	self.MouseDown = true;

end

function BUTTON:OnMouseReleased()

	if( self.Action ) then
	
		self.Action( self );
	
	end
	
	self.MouseDown = false;

end

function BUTTON:SetText( str, font )

	if( font == nil ) then
		font = self.Font;
	end

	surface.SetFont( font );
	local w, h = surface.GetTextSize( str );
	
	w = w + 10;
	h = h + 6;
	
	self:SetSize( w, h );
	
	self.Text = str;
	self.Font = font;

end

function BUTTON:Paint()

	draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color( 255, 255, 255, 255 ) );
	
	if( not self.Entered and not self.AlwaysHighlight ) then
	
		draw.RoundedBox( 2, self.Outline, self.Outline, self:GetWide() - self.Outline * 2, self:GetTall() - self.Outline * 2, Color( 20, 20, 20, 255 ) );
	
	elseif( self.Entered or self.AlwaysHighlight ) then
	
		if( self.HighlightRed ) then
	
			draw.RoundedBox( 2, self.Outline, self.Outline, self:GetWide() - self.Outline * 2, self:GetTall() - self.Outline * 2, Color( 150, 20, 20, 255 ) );
	
		else
	
			draw.RoundedBox( 2, self.Outline, self.Outline, self:GetWide() - self.Outline * 2, self:GetTall() - self.Outline * 2, Color( 80, 80, 80, 255 ) );

		end
		
	end

	draw.DrawText( self.Text, self.Font, self:GetWide() / 2, self:GetTall() / 2 - 10, Color( 255, 255, 255, 255 ), 1 );

end

vgui.Register( "BButton", BUTTON, "Panel" );

-------------------------------------------------------
-- CLOSE BUTTON
-------------------------------------------------------
local CLOSE = { }

function CLOSE:Init()

	self:SetSize( 16, 16 );
	self.CloseTargets = { }
	self.Color = Color( 40, 40, 40, 255 );

end

function CLOSE:SetTargets( ... )
	
	local arg = { ... };
	
	arg["n"] = nil;
	self.CloseTargets = arg;

end

function CLOSE:Paint()

	draw.DrawText( "x", "VGUITitle", 4, 0, Color( 100, 100, 100, 200 ), 0, 1 );

end

function CLOSE:OnMouseReleased()

	for k, v in pairs( self.CloseTargets ) do
	
		if( v ~= self:GetParent() and v:IsValid() ) then
			
			if( v:GetTable().OnClose ) then
				v:GetTable().OnClose();	
			end
			v:Remove();
			v = nil;
		
		end
	
	end
	
	if( self:GetParent() ) then
	
		self:GetParent():Remove();
	
	end

end

vgui.Register( "BCloseButton", CLOSE, "Panel" );

-------------------------------------------------------
-- TITLE BAR
-------------------------------------------------------

local TITLE = { }

function TITLE:Init()

	self.Text = "";
	self.Dragging = false;
	self.CanDrag = true;
	self.Color = Color( 255, 255, 255, 255 );
	
	self.Shine = false;
	
	self.BodyAttach = false;

end

function TITLE:OnMousePressed() 

	if( not self.CanDrag ) then
	
		return;
	
	end

	self.Dragging = true;
	self.DragXOffset, self.DragYOffset = gui.MousePos();
	
	local x, y = self:GetPos();
	
	self.DragXOffset = self.DragXOffset - x;
	self.DragYOffset = self.DragYOffset - y;

end

function TITLE:OnMouseReleased()

	self.Dragging = false;

end

function TITLE:Think()

	if( not input.IsMouseDown( MOUSE_LEFT ) ) then
	
		self.Dragging = false;
	
	end

	if( self.Dragging ) then

		local mx, my = gui.MousePos();
		
		mx = mx - self.DragXOffset;
		my = my - self.DragYOffset;
	
		self:SetPos( mx, my );
		
		if( not self.BodyAttach ) then
		
			self.Child:SetPos( mx, my + self:GetTall() );
		
		else
		
			self.Child:SetPos( mx, my );
		
		end
		
	end

end

function TITLE:Paint()

	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), self.Color );
	
	if( self.Shine ) then
	
		draw.RoundedBox( 2, 0, 0, self:GetWide(), 8, Color( 150, 150, 150, 40 ) );
	
	end
	
	draw.DrawText( self.Text, "VGUITitle", 5, 2, Color( 0, 0, 0, 255 ) ); 

end

function TITLE:SetText( title )

	self.Text = title;

end

vgui.Register( "BTitleBar", TITLE, "Panel" );

-------------------------------------------------------
-- MAIN PANEL
-------------------------------------------------------

local PANEL = { }

function PANEL:Init()

	self.BodyColor = Color( 20, 20, 20, 250 );
	self.OutlineColor = Color( 255, 255, 255, 255 );
	
	self.StartTime = CurTime();
	
	self.ScrollingObjects = { }
	
	self.VScrollPosition = 0;
	self.HScrollPosition = 0;
	self.VScrollDistance = 0;
	self.HScrollDistance = 0;
	self.VScrollAmount = 0;
	
	self.ScrollBarEnabled = false;
	
	self.Outline = true;
	self.OutlineWidth = 3;
	
	self.LowestY = 0;
	
	self._Remove = self.Remove;
	
	self.Remove = function()
	
		for k, v in pairs( BananaVGUIList ) do

			if( v == self ) then
			
				BananaVGUIList[k] = nil;
			
			end
			
			if( v:IsValid() ) then
			
				if( v:GetParent() == self ) then
				
					v:Remove();
				
				end
			
			end
		
		end
	
		if( self.TitleBar and self.TitleBar:IsValid() ) then
			self.TitleBar:Remove();
		end
		
		self._Remove( self );
		
		HideMouse();
	
	end
	
	self.RequiresMouse = true;

end

function PANEL:SetOutline( b, val )

	self.Outline = b;
	self.OutlineWidth = val;	

end

function PANEL:SetOutlineColor( color )

	self.OutlineColor = color;

end

function PANEL:RemoveScrollBarParts()

	if( self.ScrollUpButton ) then
		self.ScrollUpButton:Remove();
	end
	
	if( self.ScrollDownButton ) then
		self.ScrollDownButton:Remove();
	end

	if( self.ScrollLeftButton ) then
		self.ScrollLeftButton:Remove();
	end
	
	if( self.ScrollRightButton ) then
		self.ScrollRightButton:Remove();
	end
	
	if( self.VScrollBar ) then
		self.VScrollBar:Remove();
	end



end



function PANEL:CalculateScrollBar()
	
		local offset = 0;

		if( self.VScrollBar ) then
			_, offset = self.VScrollBar:GetPos();
			offset = offset - 12;
		end	

		self:RemoveScrollBarParts();
	
		local v = false;
		local h = false;
		
		if( self.HScrollDistance > 0 ) then
		
			h = true;
		
		end
		
		if( self.VScrollDistance > 0 ) then
		
			v = true;
		
		end
	
		if( v ) then
	
			self.ScrollUpButton = vgui.Create( "BScrollButton", self );
			self.ScrollUpButton:SetPos( self:GetWide() - 12, 0 );
			
			self.ScrollUpButton.OnMousePressed = function()
			
				if( self.VScrollBar ) then
				
					local _, y = self.VScrollBar:GetPos();
				
					self.VScrollBar:ShiftVertical( y, -100 * FrameTime() );
				
				end
			
			end
			
			self.ScrollUpButton:SetVisible( false );
			
			self.ScrollDownButton = vgui.Create( "BScrollButton", self );
			self.ScrollDownButton:SetPos( self:GetWide() - 12, self:GetTall() - 12 );
			self.ScrollDownButton.Direction = 1;
		
			self.ScrollDownButton.OnMousePressed = function()
			
				if( self.VScrollBar ) then
				
					local _, y = self.VScrollBar:GetPos();
				
					self.VScrollBar:ShiftVertical( y, 100 * FrameTime() );
				
				end
			
			end
			
			self.ScrollDownButton:SetVisible( false );
		
			self.VScrollBar = vgui.Create( "BVScrollBarButton", self );
			self.VScrollBar:SetPos( self:GetWide() - 12, 12 + offset );
			self.VScrollBar:SetSize( 12, 12 );
			self.VScrollBar:CalculateBar();
		
		end
		
		if( h ) then
		
		--	self.ScrollLeftButton = vgui.Create( "BScrollButton", self );
		--	self.ScrollLeftButton:SetPos( 0, self:GetTall() - 12 );
			
		--	self.ScrollRightButton = vgui.Create( "BScrollButton", self );
		--	self.ScrollRightButton:SetPos( self:GetWide() - 12, self:GetTall() - 12 );
				
		
		end
		
		if( v and h ) then
		
			self.ScrollDownButton:SetPos( self:GetWide() - 12, self:GetTall() - 24 );
			self.ScrollRightButton:SetPos( self:GetWide() - 24, self:GetTall() - 12 );
		
		end	

end

function PANEL:EnableScrolling( b )

	self.ScrollBarEnabled = b;

	if( b ) then
	
		self:CalculateScrollBar();
		
	else
	
		self:RemoveScrollBarParts();

	
	end

end

function PANEL:SetScrollColors( color, hcolor )

	if( self.ScrollUpButton ) then
		self.ScrollUpButton.Color = color or self.ScrollUpButton.Color;
		self.ScrollUpButton.HighlightColor = hcolor or self.ScrollUpButton.HighlightColor;
	end
	
	if( self.ScrollDownButton ) then
		self.ScrollDownButton.Color = color or self.ScrollDownButton.Color;
		self.ScrollDownButton.HighlightColor = hcolor or self.ScrollDownButton.HighlightColor;
	end

	if( self.ScrollLeftButton ) then
		self.ScrollLeftButton.Color = color or self.ScrollLeftButton.Color;
		self.ScrollLeftButton.HighlightColor = hcolor or self.ScrollLeftButton.HighlightColor;
	end
	
	if( self.ScrollRightButton ) then
		self.ScrollRightButton.Color = color or self.ScrollRightButton.Color;
		self.ScrollRightButton.HighlightColor = hcolor or self.ScrollRightButton.HighlightColor;
	end
	
	if( self.VScrollBar ) then
		self.VScrollBar.Color = color or self.VScrollBar.Color;
		self.VScrollBar.HighlightColor = hcolor or self.VScrollBar.HighlightColor;
	end

end

function PANEL:SetTitleBarColor( color ) 

	self.TitleBar.Color = color;
	self.TitleBar.CloseButton.Color = color;

end

function PANEL:SetBodyColor( color ) 

	self.BodyColor = color;

end

function PANEL:CanDrag( b ) 

	self.TitleBar.CanDrag = b;

end

function PANEL:AttachTitleToBody( b )

	self.TitleBar.BodyAttach = b;

	local x, y = self:GetPos();

	if( not b ) then
	
		self:SetPos( x, y + self.TitleBar:GetTall() );
	
	else
	
		local tx, ty = self.TitleBar:GetPos();
	
		self:SetPos( tx, ty );
	
	end


end

function PANEL:CanSeeTitle( b )

	if( self.TitleBar ) then
	
		self.TitleBar:SetVisible( b );
		self.TitleBar.CloseButton:SetVisible( b );
	
	end	

end

function PANEL:CanClose( b )

	if( self.TitleBar and self.TitleBar.CloseButton ) then
	
		self.TitleBar.CloseButton:SetVisible( b );
	
	end

end

function PANEL:Paint()

	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), self.BodyColor );

	if( self.VScrollBar ) then
	
		draw.RoundedBox( 0, self:GetWide() - 12, 12, 12, self:GetTall() - 24, Color( 0, 0, 0, 150 ) );
	
	end

	if( self.Outline ) then
	
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self.OutlineWidth, self.OutlineColor );
		draw.RoundedBox( 0, 0, 0, self.OutlineWidth, self:GetTall(), self.OutlineColor );
		draw.RoundedBox( 0, 0, self:GetTall() - self.OutlineWidth, self:GetWide(), self.OutlineWidth, self.OutlineColor );
		draw.RoundedBox( 0, self:GetWide() - self.OutlineWidth, 0, self.OutlineWidth, self:GetTall(), self.OutlineColor );
		
	end
	
	if( self.PaintHook ) then
	
		self:PaintHook();
	
	end

end

function PANEL:ApplySchemeSettings()
	
	for k, v in pairs( self.ScrollingObjects ) do
	
		if( v.IsLabel ) then
		
			v:SetFGColor( v.r, v.g, v.b, v.a );
		
		end
	
	end

end

function PANEL:FindLowestY()

	for k, v in pairs( self.ScrollingObjects ) do
	
		local h;
		local y = v.OriginalY;
	
		if( v.IsLabel ) then
		
			surface.SetFont( v.Font );
			
			if( v.SpecialChatLabel ) then
				h = v.TextHeight;
			else
				_, h = surface.GetTextSize( v:GetValue() );
			end

			h = h + y;

		elseif( v.IsButton ) then
		
			h = button:GetTall() + y;
		
		end
		
		if( self.LowestY < h ) then
		
			self.LowestY = h;

			if( self.LowestY > self:GetTall() ) then
			
				self.VScrollDistance = self.LowestY - self:GetTall();
				
			end
			
		end
	
	end

end

function PANEL:AddLink( text, font, x, y, color, action, ncolor )

	if( not color ) then
	
		color = Color( 255, 255, 255, 255 );
	
	end
	
	if( not y ) then
		y = self.BottomY or 0;
	end

	local link = vgui.Create( "BLink", self );
	link:SetPos( x, y );
	link:SetText( text, font );
	link.OriginalX = x;
	link.OriginalY = y;
	link.Action = action;
	
	link.IsLink = true;
	link.IsLabel = true; --Behaves similarly to a label
	
	if( color ) then
	
		link.HighlightColor = color;
		
	end
	
	if( ncolor ) then
	
		link.NormalColor = ncolor;
	
	end
	
	link.Font = font;
	
	table.insert( self.ScrollingObjects, link );
	
	surface.SetFont( font );
	local w, h = surface.GetTextSize( text );
	
	h = h + y;
	self.BottomY = h;

	if( self.LowestY < h ) then
	
		self.LowestY = h;
		
		if( self.LowestY > self:GetTall() ) then
		
			self.VScrollDistance = self.LowestY - self:GetTall();
			
			if( self.ScrollBarEnabled ) then
			
				self:CalculateScrollBar();
				
			end
			
		end
		
	end
	
	return link;

end

function PANEL:AddLabel( text, font, x, y, color, wrap )

	if( not color ) then
	
		color = Color( 255, 255, 255, 255 );
	
	end
	
	if( not y ) then
		y = self.BottomY or 0;
	end

	if( wrap ) then
	
		text = FormatLine( text, font, math.Clamp( self:GetWide() - x - 20, 1, self:GetWide() ) );
	
	end

	local label = vgui.Create( "Label", self );
	label:SetPos( x, y );
	label:SetFont( font );
	label:SetText( text );
	label:SizeToContents();
	label.OriginalX = x;
	label.OriginalY = y;
	
	label.IsLabel = true;
	label.r = color.r;
	label.g = color.g;
	label.b = color.b;
	label.a = color.a;
	
	label.IsLabel = true;
	label.Font = font;
	
	table.insert( self.ScrollingObjects, label );
	
	surface.SetFont( font );
	local w, h = surface.GetTextSize( text );
	
	h = h + y;
	self.BottomY = h;

	if( self.LowestY < h ) then
	
		self.LowestY = h;
		
		if( self.LowestY > self:GetTall() ) then
		
			self.VScrollDistance = self.LowestY - self:GetTall();
			
			if( self.ScrollBarEnabled ) then
			
				self:CalculateScrollBar();
				
			end
			
		end
		
	end
	
	return label;

end

function PANEL:RemoveObjects()

	for k, v in pairs( self.ScrollingObjects ) do
	
		if( v:IsValid() ) then
			v:Remove();
		end
		
		self.ScrollingObjects[k] = nil;
	
	end

end

function PANEL:AddSpace( x, y, w, h ) 
	
	h = h + y;
	self.BottomY = h;
	
	if( self.LowestY < h ) then
	
		self.LowestY = h;
		
		if( self.LowestY > self:GetTall() ) then
		
			self.VScrollDistance = self.LowestY - self:GetTall();
			
			if( self.ScrollBarEnabled ) then
			
				self:CalculateScrollBar();
				
			end
			
		end
		
	end

end


function PANEL:AddObject( obj )

	local x, y = obj:GetPos();
	local w, h = obj:GetSize();
	
	obj.OriginalX = x;
	obj.OriginalY = y;
	
	obj.IsMiscObject = true;
	
	table.insert( self.ScrollingObjects, obj );
	
	h = h + y;
	self.BottomY = h;
	
	if( self.LowestY < h ) then
	
		self.LowestY = h;
		
		if( self.LowestY > self:GetTall() ) then
		
			self.VScrollDistance = self.LowestY - self:GetTall();
			
			if( self.ScrollBarEnabled ) then
			
				self:CalculateScrollBar();
				
			end
			
		end
		
	end
	
	return obj;

end

function PANEL:AddButton( text, x, y, action )

	local button = vgui.Create( "BButton", self );
	button:SetPos( x, y );
	button:SetText( text );
	button.OriginalX = x;
	button.OriginalY = y;
	button.Action = action;
	
	button.IsButton = true;
	
	table.insert( self.ScrollingObjects, button );
	
	local h = button:GetTall() + y;
	self.BottomY = h;
	
	if( self.LowestY < h ) then
	
		self.LowestY = h;
		
		if( self.LowestY > self:GetTall() ) then
		
			self.VScrollDistance = self.LowestY - self:GetTall();
			
			if( self.ScrollBarEnabled ) then
			
				self:CalculateScrollBar();
				
			end
			
		end
		
	end
	
	return button;
	
end

function PANEL:RemoveTitleBar()

	if( self.TitleBar ) then
	
		self.TitleBar:Remove();
		self.TitleBar = nil;
	
	end

end

function PANEL:ShiftObjects( x, y )

	for k, v in pairs( self.ScrollingObjects ) do
	
		local ox, oy = v:GetPos();
		v:SetPos( ox + x, oy + y );
	
	end
	
end

vgui.Register( "BPanel", PANEL, "Panel" );


local PANEL = {}

function PANEL:Init()

	self.Wang = vgui.Create ( "DNumberWang", self )
	self.Wang.OnValueChanged = function( wang, val ) self:ValueChanged( val ) end
	
	self.Slider = vgui.Create( "DSlider", self )
	self.Slider:SetLockY( 0.5 )
	self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
	self.Slider:SetTrapInside( true )
	self.Slider:SetImage( "vgui/slider" )
	Derma_Hook( self.Slider, "Paint", "Paint", "NumSlider" )
	
	self:SetTall( 35 )
	
	self:SetMinMax( 66, 78 );
	self:SetValue( 72 );
	self:SetDecimals( 0 );

end

function PANEL:SetMinMax( min, max )
	self.Wang:SetMinMax( min, max )
end

function PANEL:SetValue( val )
	self.Wang:SetValue( val )
end

function PANEL:GetValue()
	return self.Wang:GetValue()
end

function PANEL:SetDecimals( d )
	return self.Wang:SetDecimals( d )
end

function PANEL:GetDecimals()
	return self.Wang:GetDecimals()
end

function PANEL:PerformLayout()

	self.Wang:SizeToContents()
	self.Wang:SetPos( self:GetWide() - self.Wang:GetWide(), 0 )
	self.Wang:SetTall( 20 )
	
	self.Slider:SetPos( 0, 22 )
	self.Slider:SetSize( self:GetWide(), 13 )
	
	self.Slider:SetSlideX( self.Wang:GetFraction() )

end

function PANEL:ValueChanged( val )

	self.Slider:SetSlideX( self.Wang:GetFraction( val ) )
	self:OnValueChanged();

end

function PANEL:OnValueChanged()

	

end

function PANEL:TranslateSliderValues( x, y )

	self.Wang:SetFraction( x )
	
	return self.Wang:GetFraction(), y

end

vgui.Register( "BAgeSlider", PANEL, "Panel" ); -- special vgui


--Clean up
if( BananaVGUIList ) then

	for k, v in pairs( BananaVGUIList ) do
	
		if( v:IsValid() ) then
		
			v:Remove();
		
		end
		
		BananaVGUIList[k] = nil;
	
	end
	
	BananaVGUIList = nil;

end

BananaVGUIList = { }

function CreateOkPanel( title, msg )

	surface.SetFont( "ActionMenuOptionDesc" );
	local w, h = surface.GetTextSize( msg );
	
	if( surface.GetTextSize( title ) > w ) then
	
		w = surface.GetTextSize( title ) + 8;
	
	end

	local pnlw = w + 20;
	local pnlh = h + 40;

	local pnl = CreateBPanel( title, ScrW() / 2 - pnlw / 2, ScrH() / 2 - pnlh / 2, pnlw, pnlh );
	
	local x, y;
	x = 7;
	y = 5;
	
	local lbl = pnl:AddLabel( msg, "ActionMenuOptionDesc", x, y );

	pnl:AddButton( "Ok", w / 2, 25, function() pnl.TitleBar:Remove(); pnl:Remove(); gui.EnableScreenClicker( true ); end ); 
	
	table.insert( BananaVGUIList, pnl );
	
	return pnl;

end

function CreateBPanel( title, x, y, w, h )

	local pnl = vgui.Create( "BPanel" );
	pnl:SetPos( x, y + 19 );
	pnl:SetSize( w, h );
	
	pnl.Title = title;
	
	pnl.TitleBar = vgui.Create( "BTitleBar" );
	pnl.TitleBar:SetPos( x, y );
	pnl.TitleBar:SetSize( w, 19 );
	pnl.TitleBar.Child = pnl;
	
	pnl.TitleBar.CloseButton = vgui.Create( "BCloseButton", pnl.TitleBar );
	pnl.TitleBar.CloseButton:SetPos( w - 16, 2 );
	pnl.TitleBar.CloseButton:SetSize( 16, 16 );	
	pnl.TitleBar.CloseButton:SetTargets( pnl );

	if( title ) then
	
		pnl.TitleBar:SetText( title );
	
	else
	
		pnl.TitleBar:SetVisible( false );
	
	end
	
	table.insert( BananaVGUIList, pnl );
	
	return pnl;

end

function vgui.CreateLink()

	local link = vgui.Create( "BLink" );
	table.insert( BananaVGUIList, link );
	return link;

end

function vgui.CreateTextEntry()

	local entry = vgui.Create( "BLink" );
	table.insert( BananaVGUIList, entry );
	return entry;

end

function vgui.CreateAgeSlider()

	local entry = vgui.Create( "BAgeSlider" );
	table.insert( BananaVGUIList, entry );
	return entry;

end

function HideMouse()

	for k, v in pairs( BananaVGUIList ) do
	
		if( v:IsValid() and v:IsVisible() and v.RequiresMouse ) then
			if( v:GetParent():IsValid() ) then
				if( v:GetParent():IsVisible() ) then
					return;
				end
			else
				return;
			end
		end
		
	end
	
	gui.EnableScreenClicker( false );

end
