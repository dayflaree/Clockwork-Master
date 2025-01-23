surface.CreateFont("Calibri", 16, 400, true, false, "calibriMain");
surface.CreateFont("Calibri", 18, 450, true, false, "calibriLarge");

local SKIN = {};

-- Basic information.
SKIN.PrintName = "Omicron Skin";
SKIN.Author = "The Master";
SKIN.DermaVersion = 1;

-- Skin colours and variables.
SKIN.main = Color(137, 137, 137, 255);
SKIN.mainLight = Color(226, 226, 226, 255);
SKIN.mainMedium = Color(108, 108, 108, 255);
SKIN.mainDark = Color(63, 63, 63, 255);

SKIN.mainFont = "calibriMain";
SKIN.mainFontLarge = "calibriLarge";

SKIN.gradient = surface.GetTextureID("gui/gradient");
SKIN.gradientUp = surface.GetTextureID("gui/gradient_up");
SKIN.gradientDown = surface.GetTextureID("gui/gradient_down");

SKIN.buttonMain = Color(94, 94, 94, 255);
SKIN.buttonOutline = Color(194, 138, 48, 255);
SKIN.buttonHighlight = Color(255, 229, 134, 255);
SKIN.buttonActive = Color(255, 215, 93, 255);

SKIN.listSlider = Color(100, 100, 100, 255);
SKIN.listSliderOutline = Color(36, 36, 36, 255);

SKIN.textBox = Color(148, 148, 148, 255);
SKIN.textBoxOutline = Color(55, 55, 55, 255);

SKIN.panelMain = Color(116, 116, 116, 255);
SKIN.panelOutline = Color(4, 4, 4, 255);

SKIN.formMain = Color(88, 88, 88, 255);
SKIN.formTop = Color(22, 22, 22, 255);

SKIN.categoryMain = Color(88, 88, 88, 255);
SKIN.categoryInactive = Color(12, 12, 12, 255);
SKIN.categoryOutline = Color(12, 12, 12, 255);

SKIN.menuMain = Color(49, 49, 49, 255);
SKIN.menuOutline = Color(108, 108, 108, 255);

SKIN.panelListOutline = Color(20, 20, 20, 255);
SKIN.panelListMain = Color(60, 60, 60, 255);
SKIN.panelListHighlight = Color(76, 76, 76, 255);
SKIN.panelListSlider = Color(56, 56, 56, 255);
SKIN.panelListActive = Color(36, 36, 36, 255);

SKIN.listViewMain = Color(50, 50, 50, 255);
SKIN.listViewActive = Color(196, 181, 80, 255);

SKIN.toolTipOutline = Color(104, 106, 101, 255);
SKIN.toolTipMain = Color(47, 49, 45, 255);

/* =================
	Core functions
================= */
function SKIN:DrawGradient(x, y, width, height, colour, reverse)
	-- if (!reverse) then
		-- for i = 0, height do
			-- local minus = math.TimeFraction(0, height, i) * 40;
			
			-- local r = math.Clamp(colour.r - minus, 0, 255);
			-- local g = math.Clamp(colour.g - minus, 0, 255);
			-- local b = math.Clamp(colour.b - minus, 0, 255);
			
			-- surface.SetDrawColor(r, g, b, colour.a);
			-- surface.DrawLine(x, y + i, x + width, y + i);
		-- end;
	-- else
		-- for i = 0, height do
			-- local minus = math.TimeFraction(0, height, i) * 40;
			
			-- local r = math.Clamp(colour.r - minus, 0, 255);
			-- local g = math.Clamp(colour.g - minus, 0, 255);
			-- local b = math.Clamp(colour.b - minus, 0, 255);
			
			-- surface.SetDrawColor(r, g, b, colour.a);
			-- surface.DrawLine(x, y + height - i, x + width, y + height - i);
		-- end;
	-- end;
	
	surface.SetDrawColor(colour)
	surface.DrawRect(x, y, width, height);
	
	surface.SetDrawColor(colour.r - 40, colour.g - 40, colour.b - 40, 255);
	if (!reverse) then
		surface.SetTexture(self.gradientUp);
	else
		surface.SetTexture(self.gradientDown);
	end;
	surface.DrawTexturedRect(x, y, width, height);
end;

/* ===========
	DFrame
=========== */
function SKIN:PaintFrame(panel)	
	draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), self.mainDark); -- Background
	draw.RoundedBox(2, 1, 1, panel:GetWide() - 2, panel:GetTall() - 2, Color(40, 40, 40, 255)); -- Main panel
	draw.RoundedBoxEx(2, 1, 1, panel:GetWide() - 2, 18, self.mainMedium, true, true, false, false); -- Top
end;

function SKIN:LayoutFrame(panel)
    panel.lblTitle:SetFont(self.mainFont);
    
    panel.btnClose:SetPos(panel:GetWide() - 22, 2);
    panel.btnClose:SetSize(16, 16);
    
    panel.lblTitle:SetPos(8, 2);
    panel.lblTitle:SetSize(panel:GetWide() - 25, 16);
end;

/* ===========
	DButton
=========== */
function SKIN:DrawButtonBorder( x, y, w, h, depressed )
    -- if ( !depressed ) then
        -- // Highlight
        -- surface.SetDrawColor( self.colButtonBorderHighlight )
        -- surface.DrawRect( x+1, y+1, w-2, 1 )
        -- surface.DrawRect( x+1, y+1, 1, h-2 )
        
        -- // Corner
        -- surface.DrawRect( x+2, y+2, 1, 1 )
    
        -- // Shadow
        -- surface.SetDrawColor( self.colButtonBorderShadow )
        -- surface.DrawRect( w-2, y+2, 1, h-2 )
        -- surface.DrawRect( x+2, h-2, w-2, 1 )
    -- else
        -- local col = self.colButtonBorderShadow
    
        -- for i=1, 5 do
            -- surface.SetDrawColor( col.r, col.g, col.b, (255 - i * (255/5) ) )
            -- surface.DrawOutlinedRect( i, i, w-i, h-i )
        -- end
    -- end
	
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawOutlinedRect(x, y, w, h);
end;

function SKIN:DrawDisabledButtonBorder(x, y, w, h, depressed)
    surface.SetDrawColor(0, 0, 0, 150);
    surface.DrawOutlinedRect(x, y, w, h);
end;

function SKIN:PaintButton(panel)
	local width, height = panel:GetSize();
	
	if (panel.m_bBackground) then		
		if (panel:GetDisabled()) then
			-- surface.SetDrawColor(self.mainDark);
			-- surface.DrawRect(0, 0, width, height);
			
			self:DrawGradient(0, 0, width, height, self.mainDark);
			
			surface.SetDrawColor(18, 18, 18, 255);
			surface.DrawOutlinedRect(0, 0, width, height);
			
			panel:SetTextColor(self.mainLight);
		elseif (panel.Depressed || panel:GetSelected()) then
			-- surface.SetDrawColor(self.mainLight);
			-- surface.DrawRect(0, 0, width, height);

			-- surface.SetDrawColor(self.buttonActive);
			-- surface.SetTexture(self.gradientDown);
			-- surface.DrawRect(0, 0, width, height);
			self:DrawGradient(0, 0, width, height, self.buttonActive);
			
			surface.SetDrawColor(18, 18, 18, 255);
			surface.DrawOutlinedRect(0, 0, width, height);
			
			panel:SetTextColor(Color(22, 22, 22, 255));
		elseif (panel.Hovered) then
			-- surface.SetDrawColor(self.buttonHighlight);
			-- surface.DrawRect(0, 0, width, height);
			
			self:DrawGradient(0, 0, width, height, self.buttonHighlight);

			surface.SetDrawColor(18, 18, 18, 255);
			surface.DrawOutlinedRect(0, 0, width, height);
			
			panel:SetTextColor(Color(22, 22, 22, 255));
		else
			-- surface.SetDrawColor(self.buttonMain);
			-- surface.DrawRect(0, 0, width, height);
			
			self:DrawGradient(0, 0, width, height, self.buttonMain);
			
			surface.SetDrawColor(18, 18, 18, 255);
			surface.DrawOutlinedRect(0, 0, width, height);
			
			panel:SetTextColor(self.mainLight);
		end;
	end;
end;

function SKIN:PaintOverButton(panel)
end;

function SKIN:SchemeButton(panel)
    panel:SetFont(self.mainFont)
	
    -- if (panel:GetDisabled()) then
        -- panel:SetTextColor(self.mainDark);
	-- else
        -- panel:SetTextColor(self.mainLight);
    -- end
	
    DLabel.ApplySchemeSettings(panel);
end;

/* ===========
	DPanel
=========== */
function SKIN:PaintPanel(panel)
	if (panel.m_bPaintBackground) then
		local w, h = panel:GetSize();
		
		-- surface.SetDrawColor(self.panelMain);
		-- surface.SetTexture(self.gradientUp);
		-- surface.DrawTexturedRect(0, 0, w, h);
		
		self:DrawGradient(0, 0, w, h, self.panelMain);
		
		surface.SetDrawColor(self.panelOutline);
		surface.DrawOutlinedRect(0, 0, w, h);
	end;
end;

/* =================
	DPropertySheet
================= */
function SKIN:PaintPropertySheet(panel)
    local ActiveTab = panel:GetActiveTab();
    local Offset = 0;
    if (ActiveTab) then Offset = ActiveTab:GetTall(); end;
    
    -- surface.SetDrawColor(self.main);
	-- surface.SetTexture(self.gradientDown);
	-- surface.DrawTexturedRect(0, Offset, panel:GetWide(), panel:GetTall() - Offset);
	
	draw.RoundedBox(2, 0, Offset, panel:GetWide(), panel:GetTall() - Offset, self.mainDark);
	draw.RoundedBox(2, 1, Offset, panel:GetWide() - 2, panel:GetTall() - Offset, self.main);
end;

function SKIN:PaintTab(panel)
	if (panel:GetPropertySheet():GetActiveTab() == panel) then
		draw.RoundedBox(4, 0, 0, panel:GetWide(), panel:GetTall() + 4, self.mainDark);
		draw.RoundedBox(4, 1, 1, panel:GetWide() - 2, panel:GetTall() + 2, self.main);
	else
		--draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall() + 4, self.main);
		draw.RoundedBox(4, 1, 1, panel:GetWide() - 2, panel:GetTall() + 2, self.mainDark);
	end;
end;

function SKIN:SchemeTab( panel )

    panel:SetFont( self.fontTab )

    local ExtraInset = 10

    if ( panel.Image ) then
        ExtraInset = ExtraInset + panel.Image:GetWide()
    end
    
    panel:SetTextInset( ExtraInset )
    panel:SizeToContents()
    panel:SetSize( panel:GetWide() + 10, panel:GetTall() + 8 )
    
    local Active = panel:GetPropertySheet():GetActiveTab() == panel
    
    if ( Active ) then
        panel:SetTextColor( self.mainDark )
    else
        panel:SetTextColor( self.mainLight )
    end
    
    panel.BaseClass.ApplySchemeSettings( panel )
end

function SKIN:LayoutTab( panel )
    panel:SetTall( 22 )

    if ( panel.Image ) then
        local Active = panel:GetPropertySheet():GetActiveTab() == panel
        
        local Diff = panel:GetTall() - panel.Image:GetTall()
        panel.Image:SetPos( 7, Diff * 0.6 )
        
        if ( !Active ) then
            panel.Image:SetImageColor( Color( 170, 170, 170, 155 ) )
        else
            panel.Image:SetImageColor( Color( 255, 255, 255, 255 ) )
        end
    end    
end

/* =======================
	DCollapsibleCategory
======================= */
function SKIN:PaintCategoryHeader(panel)
	surface.SetDrawColor(self.mainLight);
	-- surface.DrawRect(4, panel:GetTall() / 2 - 1, 10, 2);
	
	-- if (!panel:GetParent():GetExpanded()) then
		-- surface.DrawRect(8, panel:GetTall() / 2 - 4, 2, 8);
	-- end;
	
	local expanderPos = { x=0, y=0 };
	local expanderSize = 8;
	local expanderWidth = 2;
	expanderPos.y = panel:GetTall() / 2;
	expanderPos.x = expanderPos.y;
	
	surface.DrawRect( expanderPos.x - expanderSize/2, expanderPos.y - expanderWidth/2, expanderSize, expanderWidth  ); -- Dash
	if ( panel:GetParent():GetExpanded() == false ) then
		surface.DrawRect( expanderPos.x - expanderWidth/2, expanderPos.y - expanderSize/2, expanderWidth, expanderSize ); -- -|-
	end
end;

function SKIN:SchemeCategoryHeader(panel)
    panel:SetTextInset(20);
    panel:SetFont(self.mainFont);
    
    if (panel:GetParent():GetExpanded()) then
        panel:SetTextColor(self.mainLight);
    else
        panel:SetTextColor(self.categoryInactive);
    end;
end;

function SKIN:PaintCollapsibleCategory(panel)
    -- draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), self.categoryOutline);
    -- draw.RoundedBox(2, 1, 1, panel:GetWide() - 2, panel:GetTall() - 2, self.categoryMain);
	
	self:DrawGradient(0, 0, panel:GetWide(), panel:GetTall(), self.categoryMain, true);
	surface.SetDrawColor(self.categoryOutline);
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall());
end

/* =========
	DForm
========= */
function SKIN:PaintForm( panel )
	surface.SetDrawColor(self.formTop);
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall());
	
	-- surface.SetDrawColor(self.formMain);
	-- surface.DrawRect(2, 20, panel:GetWide() - 4, panel:GetTall() - 24);
	
	self:DrawGradient(2, 20, panel:GetWide() - 4, panel:GetTall() - 24, self.formMain, true);
end

function SKIN:SchemeForm( panel )
    panel.Label:SetFont(self.mainFontLarge);
    panel.Label:SetTextColor(Color( 255, 255, 255, 255 ));
	panel.Label:SizeToContents();
end;

function SKIN:LayoutForm(panel)
end;

/* ============
	DermaMenu
============ */
function SKIN:PaintMenu( panel )
	surface.SetDrawColor( self.menuMain );
	surface.DrawRect( 1,1,panel:GetWide()-2,panel:GetTall()-2 );
	
	surface.SetDrawColor(self.menuOutline);
	surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall());
end

function SKIN:PaintOverMenu( panel )
end

-- function SKIN:LayoutMenu( panel )
	-- local w = panel:GetMinimumWidth();
	
	-- // Find the widest one
	-- for k, pnl in pairs( panel.Panels ) do	
		-- pnl:PerformLayout();
		-- w = math.max( w, pnl:GetWide() );	
	-- end;

	-- panel:SetWide( w );
	
	-- local y = 0;
	
	-- for k, pnl in pairs( panel.Panels ) do	
		-- pnl:SetWide( w );
		-- pnl:SetPos( 0, y );
		-- pnl:InvalidateLayout( true );
		
		-- y = y + pnl:GetTall();
	-- end;
	
	-- panel:SetTall( y );
-- end;

function SKIN:PaintMenuOption( panel )
	-- Hovering Color for Text
	if ( panel.Hovered ) then	
		panel:SetFGColor( self.mainDark );
		if ( panel.m_bBackground ) then
			--surface.SetDrawColor( 145,134,60,255 );
			surface.SetDrawColor(self.buttonActive);
			surface.DrawRect( 1, 1, panel:GetWide()-2, panel:GetTall()-2 );
		end
	else
		panel:SetFGColor( self.mainLight );
	end
end

function SKIN:LayoutMenuOption( panel )
	// This is totally messy. :/
	panel:SizeToContents()
	panel:SetWide( panel:GetWide() + 30 )
	
	local w = math.max( panel:GetParent():GetWide(), panel:GetWide() )
	panel:SetSize( w, 18 )
	
	if ( panel.SubMenuArrow ) then	
		panel.SubMenuArrow:SetSize( panel:GetTall(), panel:GetTall() );
		panel.SubMenuArrow:CenterVertical();
		panel.SubMenuArrow:AlignRight();
	end	
end

function SKIN:SchemeMenuOption( panel )
	panel:SetFGColor( self.mainLight );
end

/* =============
	DPanelList
============= */
function SKIN:PaintPanelList(panel)
	if (panel.m_bBackground) then
		-- draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), self.panelListOutline);
		surface.SetDrawColor(self.panelListOutline);
		surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall());
		
		-- surface.SetDrawColor(self.panelListMain);
		-- surface.SetTexture(self.gradientDown);
		-- surface.DrawTexturedRect(1, 1, panel:GetWide() - 2, panel:GetTall() - 2);
		
		self:DrawGradient(1, 1, panel:GetWide() - 2, panel:GetTall() - 2, self.panelListMain);
	end;
end

function SKIN:PaintVScrollBar( panel )
	surface.SetDrawColor(self.panelListSlider);
	surface.SetTexture(self.gradient);
	surface.DrawTexturedRect(0, 0, panel:GetWide(), panel:GetTall());
end

function SKIN:LayoutVScrollBar( panel )
    local Wide = panel:GetWide()
    local Scroll = panel:GetScroll() / panel.CanvasSize
    local BarSize = math.max( panel:BarScale() * (panel:GetTall() - (Wide * 2)), 10 )
    local Track = panel:GetTall() - (Wide * 2) - BarSize
    Track = Track + 1
    
    Scroll = Scroll * Track
    
    panel.btnGrip:SetPos( 0, Wide + Scroll )
    panel.btnGrip:SetSize( Wide, BarSize )
    
    panel.btnUp:SetPos( 0, 0, Wide, Wide )
    panel.btnUp:SetSize( Wide, Wide )
    
    panel.btnDown:SetPos( 0, panel:GetTall() - Wide, Wide, Wide )
    panel.btnDown:SetSize( Wide, Wide )
end

function SKIN:PaintScrollBarGrip(panel)
    local w, h = panel:GetSize()
    
    local col = self.panelListSlider;
	
	if (panel.Depressed) then
		col = self.panelListActive;
	elseif (panel.Hovered) then
		col = self.panelListHighlight;
	end;
	
	draw.RoundedBox(2, 0, 0, w, h, col);
	
	surface.SetDrawColor(col.r + 30, col.g + 30, col.b + 30, 255);
	surface.SetTexture(self.gradient);
	surface.DrawTexturedRect(1, 1, w - 2, h - 2);
end


/* =============
	DListView
============= */
function SKIN:PaintListView(panel)
    if (panel.m_bBackground) then
		surface.SetDrawColor(self.listViewMain);
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall());
    end;
end;

function SKIN:PaintListViewLine(panel)
	if (panel:IsSelected()) then
		draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), self.listViewActive);
		
		surface.SetDrawColor(self.listViewMain);
		surface.DrawRect(1, 1, panel:GetWide() - 2, panel:GetTall() - 2);
	elseif (panel.Hovered) then
		local col = Color(self.listViewActive.r - 30, self.listViewActive.g - 30, self.listViewActive.b - 30, 255);
		
		draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), col);
		
		surface.SetDrawColor(self.listViewMain);
		surface.DrawRect(1, 1, panel:GetWide() - 2, panel:GetTall() - 2);
	end;
end;

function SKIN:SchemeListViewLabel(panel)
	panel:SetTextInset(4);
	panel:SetTextColor(self.mainLight);
end;

/* ============
	ToolTip
============ */
function SKIN:PaintTooltip(panel)
	local w, h = panel:GetSize();
	DisableClipping(true);	
	
	draw.RoundedBox(2, 0, 0, panel:GetWide(), panel:GetTall(), self.toolTipOutline);
	
	-- surface.SetDrawColor(self.toolTipMain);
	-- surface.SetTexture(self.gradientUp);
	-- surface.DrawTexturedRect(1, 1, panel:GetWide() - 2, panel:GetTall() - 2);
	
	self:DrawGradient(1, 1, panel:GetWide() - 2, panel:GetTall() - 2, self.toolTipMain);
	
	panel.Contents:SetTextColor(self.mainLight);
	
	panel:DrawArrow(0, 0);
	DisableClipping(false);
end;

/* =============
	DTextEntry
============= */
function SKIN:PaintTextEntry( panel )
	if (panel.m_bBackground) then
		surface.SetDrawColor(self.textBox);
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall());
		
		surface.SetDrawColor(self.textBoxOutline);
		surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall());
	end;
	
	panel:DrawTextEntryText(panel.m_colText, panel.m_colHighlight, panel.m_colCursor);
end;

function SKIN:SchemeTextEntry(panel)
	panel:SetTextColor(Color(0, 0, 0, 255));
	panel:SetHighlightColor(Color(255, 255, 255, 255));
	panel:SetCursorColor(Color(0, 0, 0, 255));
end;

/* ===========
	DLabel
=========== */
function SKIN:PaintLabel(panel)
	return false;
end;

function SKIN:SchemeLabel(panel)
	local col = nil

	if (panel.Hovered && panel:GetTextColorHovered()) then
		col = panel:GetTextColorHovered();
	else
		col = panel:GetTextColor();
    end;
    
    if (col) then
        panel:SetFGColor(col.r, col.g, col.b, col.a);
    else
        panel:SetFGColor(self.mainLight);
    end;
end;

function SKIN:LayoutLabel(panel)
	panel:ApplySchemeSettings();
	
	if (panel.m_bAutoStretchVertical) then
		panel:SizeToContentsY();
	end;
end;

-- Define the skin.
derma.DefineSkin("omicron", "A custom skin made for Omicron.", SKIN);
