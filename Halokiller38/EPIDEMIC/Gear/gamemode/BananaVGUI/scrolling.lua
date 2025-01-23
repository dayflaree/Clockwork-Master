

-------------------------------------------------------
-- SCROLL BUTTON
-------------------------------------------------------
local BUTTON = { }

function BUTTON:Init()

	self:SetSize( 12, 12 );
	self.HighlightColor = Color( 20, 20, 120, 255 );
	self.Color = Color( 40, 40, 40, 255 );

end

function BUTTON:OnCursorEntered()

	self.Entered = true;

end

function BUTTON:OnCursorExited()

	self.Entered = false;

end

function BUTTON:Paint()

	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) );
	
	if( self.Entered ) then
	
		draw.RoundedBox( 2, 2, 2, self:GetWide() - 4, self:GetTall() - 4, self.HighlightColor );
	
	else
	
		draw.RoundedBox( 2, 2, 2, self:GetWide() - 4, self:GetTall() - 4, self.Color );
	
	end
	
	draw.RoundedBox( 2, 2, 2, self:GetWide() - 4, ( self:GetTall() - 4 ) * .33, Color( 255, 255, 255, 15 ) );

end

vgui.Register( "BScrollButton", BUTTON, "Panel" );



-------------------------------------------------------
-- HORIZONTAL SCROLL BAR
-------------------------------------------------------
local HBAR = { }


vgui.Register( "BHScrollBarButton", HBAR, "Panel" );


-------------------------------------------------------
-- VERTICAL SCROLL BAR
-------------------------------------------------------
local VBAR = { }

function VBAR:Init()

	self.DragMode = false;
	self.DragMouseY = 0;
	self.HighlightColor = Color( 20, 20, 120, 255 );
	self.Color = Color( 40, 40, 40, 255 );

end

function VBAR:CalculateBar()

	local parentheight = self:GetParent():GetTall();
	local scrollamount = self:GetParent().VScrollDistance;
	
	local _, t = self:GetParent().ScrollUpButton:GetPos();
	t = t + self:GetParent().ScrollUpButton:GetTall();
	local _, u = self:GetParent().ScrollDownButton:GetPos();
	local maxscrollbarheight = u - t;
	
	--The shortest the bar will go is 12x6.
	--The longest is the maxscrollbarheight value
	
	local height = math.Clamp( maxscrollbarheight - scrollamount, 6, maxscrollbarheight );

	--Now that we have the supposed height of the scroll bar, let's calculate how far it should scroll per pixel
	--Remember we cannot exceed the max scroll distance
	
	local distperpix = scrollamount / ( maxscrollbarheight - height );
	
	self:SetSize( self:GetWide(), height );
	self.Height = height;
	self.DistPerPixel = distperpix;
	
	local _, ymax = self:GetParent().ScrollDownButton:GetPos();
	ymax = ymax - height;
	self.LowestY = ymax;
	
end

function VBAR:OnCursorEntered()

	self.Entered = true;

end

function VBAR:OnCursorExited()

	self.Entered = false;

end

function VBAR:OnMousePressed()

	self.DragMode = true;
	_, self.DragOriginalY = self:GetPos();
	_, self.DragMouseY = gui.MousePos();

end

function VBAR:CalculateScrollAmount()

	local x, y = self:GetPos();
	local _, y2 = self:GetParent().ScrollUpButton:GetPos();
	y2 = y2 + self:GetParent().ScrollUpButton:GetTall();
	
	local distmoved = y - y2;

	self:GetParent().VScrollAmount = distmoved * self.DistPerPixel;
	

end

function VBAR:OnMouseReleased()

	self.DragMode = false;

end

function VBAR:ShiftVertical( startdist, distmoved )

	local _, my = gui.MousePos();
	local x, y = self:GetPos();
	
	local _, ymin = self:GetParent().ScrollUpButton:GetPos();
	ymin = ymin + self:GetParent().ScrollUpButton:GetTall();
	
	local _, ymax = self:GetParent().ScrollDownButton:GetPos();
	ymax = ymax - self.Height;
	
	local newy = math.Clamp( startdist + distmoved, ymin, ymax );
	local distmoved = newy - ymin;
	
	self:SetPos( x, newy );
	
	self:GetParent().VScrollAmount = distmoved * self.DistPerPixel;
	
	if( distmoved ~= 0 ) then
	
		if( self:GetParent().OnScrollBarUpdate ) then
			self:GetParent().OnScrollBarUpdate( distmoved );
		end
		
	end

	for k, v in pairs( self:GetParent().ScrollingObjects ) do
		
		if( not v:IsValid() ) then
		
			self:GetParent().ScrollingObjects[k] = nil;
		
		else
		
			local x, y = v:GetPos();
			
			v:SetPos( x, v.OriginalY - distmoved * self.DistPerPixel );
		
		end
			
	end

end

function VBAR:Think()

	if( not input.IsMouseDown( MOUSE_LEFT ) ) then
	
		self.DragMode = false;
	
	end

	if( self.DragMode ) then
	
		local _, my = gui.MousePos();
		local distmoved = my - self.DragMouseY;
		
		self:ShiftVertical( self.DragOriginalY, distmoved );
	
	end

end

function VBAR:Paint()

	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) );
	
	if( self.Entered ) then
	
		draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, self.HighlightColor );
	
	else
	
		draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, self.Color );
	
	end
	
	draw.RoundedBox( 2, 1, 1, ( self:GetWide() - 2 ) * .33, self:GetTall() - 2, Color( 255, 255, 255, 15 ) );

end

vgui.Register( "BVScrollBarButton", VBAR, "Panel" );
