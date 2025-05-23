--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local THEME = openAura.theme:Begin();

-- Called when fonts should be created.
function THEME:CreateFonts()
	surface.CreateFont("Arial", ScaleToWideScreen(16), 700, true, false, "hl2_ThickArial");
	surface.CreateFont("Verdana", ScaleToWideScreen(17), 600, true, false, "hl2_PlayerInfoText");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(2048), 600, true, false, "hl2_Large3D2D");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(29), 600, true, false, "hl2_IntroTextSmall");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(24), 600, true, false, "hl2_IntroTextTiny");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(34), 600, true, false, "hl2_CinematicText");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(76), 600, true, false, "hl2_IntroTextBig");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(18), 600, true, false, "hl2_MainText");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(22), 600, true, false, "hl2_TargetIDText");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(124), 600, true, false, "hl2_MenuTextHuge");
	surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(76), 600, true, false, "hl2_MenuTextBig");
end;

-- Called when to initialize the theme.
function THEME:Initialize()
	openAura.option:SetColor( "information", Color(241, 208, 94, 255) );
	openAura.option:SetColor( "background", Color(0, 0, 0, 255) );
	openAura.option:SetColor( "target_id", Color(167, 213, 114, 255) );
	openAura.option:SetFont("bar_text", "hl2_TargetIDText");
	openAura.option:SetFont("main_text", "hl2_MainText");
	openAura.option:SetFont("hints_text", "hl2_IntroTextTiny");
	openAura.option:SetFont("large_3d_2d", "hl2_Large3D2D");
	openAura.option:SetFont("menu_text_big", "hl2_MenuTextBig");
	openAura.option:SetFont("menu_text_huge", "hl2_MenuTextHuge");
	openAura.option:SetFont("target_id_text", "hl2_TargetIDText");
	openAura.option:SetFont("cinematic_text", "hl2_CinematicText");
	openAura.option:SetFont("date_time_text", "hl2_IntroTextSmall");
	openAura.option:SetFont("intro_text_big", "hl2_IntroTextBig");
	openAura.option:SetFont("menu_text_tiny", "hl2_IntroTextTiny");
	openAura.option:SetFont("menu_text_small", "hl2_IntroTextSmall");
	openAura.option:SetFont("intro_text_tiny", "hl2_IntroTextTiny");
	openAura.option:SetFont("intro_text_small", "hl2_IntroTextSmall");
	openAura.option:SetFont("player_info_text", "hl2_PlayerInfoText");
end;

local DIRTY_TEXTURE = surface.GetTextureID("halfliferp/dirty");
local SCRATCH_TEXTURE = surface.GetTextureID("halfliferp/scratch");

-- Called just before a bar is drawn.
function THEME.module:PreDrawBar(barInfo)
	surface.SetDrawColor(255, 255, 255, 150);
	surface.SetTexture(SCRATCH_TEXTURE);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.width, barInfo.height);
	
	barInfo.drawBackground = false;
	barInfo.drawProgress = false;
	
	if (barInfo.text) then
		barInfo.text = string.upper(barInfo.text);
	end;
end;

-- Called just after a bar is drawn.
function THEME.module:PostDrawBar(barInfo)
	surface.SetDrawColor(barInfo.color.r, barInfo.color.g, barInfo.color.b, barInfo.color.a);
	surface.SetTexture(SCRATCH_TEXTURE);
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.progressWidth, barInfo.height);
end;

-- Called just before the weapon selection info is drawn.
function THEME.module:PreDrawWeaponSelectionInfo(info)
	surface.SetDrawColor( 255, 255, 255, math.min(200, info.alpha) );
	surface.SetTexture(DIRTY_TEXTURE);
	surface.DrawTexturedRect(info.x, info.y, info.width, info.height);
	
	info.drawBackground = false;
end;

-- Called just before the local player's information is drawn.
function THEME.module:PreDrawPlayerInfo(boxInfo, information, subInformation)
	surface.SetDrawColor(255, 255, 255, 100);
	surface.SetTexture(DIRTY_TEXTURE);
	surface.DrawTexturedRect(boxInfo.x, boxInfo.y, boxInfo.width, boxInfo.height);
	
	boxInfo.drawBackground = false;
end;

-- Called after the character menu has initialized.
function THEME.hooks:PostCharacterMenuInit(panel) end;

-- Called every frame that the character menu is open.
function THEME.hooks:PostCharacterMenuThink(panel) end;

-- Called after the character menu is painted.
function THEME.hooks:PostCharacterMenuPaint(panel) end;

-- Called after a character menu panel is opened.
function THEME.hooks:PostCharacterMenuOpenPanel(panel) end;

-- Called after the main menu has initialized.
function THEME.hooks:PostMainMenuInit(panel) end;

-- Called after the main menu is rebuilt.
function THEME.hooks:PostMainMenuRebuild(panel) end;

-- Called after a main menu panel is opened.
function THEME.hooks:PostMainMenuOpenPanel(panel, panelToOpen) end;

-- Called after the main menu is painted.
function THEME.hooks:PostMainMenuPaint(panel) end;

-- Called every frame that the main menu is open.
function THEME.hooks:PostMainMenuThink(panel) end;

THEME.skin.frameBorder = Color(255, 255, 255, 255);
THEME.skin.frameTitle = Color(255, 255, 255, 255);

THEME.skin.bgColorBright = Color(255, 255, 255, 255);
THEME.skin.bgColorSleep = Color(70, 70, 70, 255);
THEME.skin.bgColorDark = Color(50, 50, 50, 255);
THEME.skin.bgColor = Color(40, 40, 40, 225);

THEME.skin.controlColorHighlight = Color(70, 70, 70, 255);
THEME.skin.controlColorActive = Color(175, 175, 175, 255);
THEME.skin.controlColorBright = Color(100, 100, 100, 255);
THEME.skin.controlColorDark = Color(30, 30, 30, 255);
THEME.skin.controlColor = Color(60, 60, 60, 255);

THEME.skin.colPropertySheet = Color(255, 255, 255, 255);
THEME.skin.colTabTextInactive = Color(0, 0, 0, 255);
THEME.skin.colTabInactive = Color(255, 255, 255, 255);
THEME.skin.colTabShadow = Color(0, 0, 0, 170);
THEME.skin.colTabText = Color(255, 255, 255, 255);
THEME.skin.colTab = Color(0, 0, 0, 255);

THEME.skin.fontCategoryHeader = "hl2_ThickArial";
THEME.skin.fontMenuOption = "hl2_ThickArial";
THEME.skin.fontFormLabel = "hl2_ThickArial";
THEME.skin.fontButton = "hl2_ThickArial";
THEME.skin.fontFrame = "hl2_ThickArial";
THEME.skin.fontTab = "hl2_ThickArial";

-- A function to draw a generic background.
function THEME.skin:DrawGenericBackground(x, y, w, h, color)
	surface.SetDrawColor(color);
	surface.DrawRect(x, y, w, h);
end;

-- Called when a frame is layed out.
function THEME.skin:LayoutFrame(panel)
	panel.lblTitle:SetFont(self.fontFrame);
	panel.lblTitle:SetText( panel.lblTitle:GetText():upper() );
	panel.lblTitle:SetTextColor( Color(0, 0, 0, 255) );
	panel.lblTitle:SizeToContents();
	panel.lblTitle:SetExpensiveShadow(nil);
	
	panel.btnClose:SetDrawBackground(true);
	panel.btnClose:SetPos(panel:GetWide() - 22, 2);
	panel.btnClose:SetSize(18, 18);
	panel.lblTitle:SetPos(8, 2);
	panel.lblTitle:SetSize(panel:GetWide() - 25, 20);
end;

-- Called when a form is schemed.
function THEME.skin:SchemeForm(panel)
	panel.Label:SetFont(self.fontFormLabel);
	panel.Label:SetText( panel.Label:GetText():upper() );
	panel.Label:SetTextColor( Color(255, 255, 255, 255) );
	panel.Label:SetExpensiveShadow( 1, Color(0, 0, 0, 200) );
end;

-- Called when a tab is painted.
function THEME.skin:PaintTab(panel)
	if (panel:GetPropertySheet():GetActiveTab() == panel) then
		self:DrawGenericBackground(1, 1, panel:GetWide() - 2, panel:GetTall() + 8, self.colTab);
	else
		self:DrawGenericBackground(1, 2, panel:GetWide() - 2, panel:GetTall() + 8, self.colTabInactive);
	end;
end;

-- Called when a list view is painted.
function THEME.skin:PaintListView(panel)
	if (panel.m_bBackground) then
		surface.SetDrawColor(255, 255, 255, 255);
		panel:DrawFilledRect();
	end;
end;
	
-- Called when a list view line is painted.
function THEME.skin:PaintListViewLine(panel)
	local color = Color(50, 50, 50, 255);
	local textColor = Color(255, 255, 255, 255);
	
	if ( panel:IsSelected() ) then
		color = Color(255, 255, 255, 255);
		textColor = Color(0, 0, 0, 255);
	elseif (panel.Hovered) then
		color = Color(100, 100, 100, 255);
	elseif (panel.m_bAlt) then
		color = Color(75, 75, 75, 255);
	end;
	
	for k, v in pairs(panel.Columns) do
		v:SetTextColor(textColor);
	end;
 
	surface.SetDrawColor(color.r, color.g, color.b, color.a);
	surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() );
end;

-- Called when a list view label is schemed.
function THEME.skin:SchemeListViewLabel(panel)
	panel:SetTextInset(3);
	panel:SetTextColor( Color(255, 255, 255, 255) );
end;

-- Called when a menu is painted.
function THEME.skin:PaintMenu(panel)
	surface.SetDrawColor( Color(0, 0, 0, 255) );
	panel:DrawFilledRect(0, 0, w, h);
end;

-- Called when a menu is painted over.
function THEME.skin:PaintOverMenu(panel) end;

-- Called when a menu option is schemed.
function THEME.skin:SchemeMenuOption(panel)
	panel:SetFGColor(255, 255, 255, 255);
end;

-- Called when a menu option is painted.
function THEME.skin:PaintMenuOption(panel)
	local textColor = Color(255, 255, 255, 255);
	
	if (panel.m_bBackground and panel.Hovered) then
		local color = nil;

		if (panel.Depressed) then
			color = Color(225, 225, 225, 255);
		else
			color = Color(255, 255, 255, 255);
		end;

		surface.SetDrawColor(color.r, color.g, color.b, color.a);
		surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() );
		
		textColor = Color(0, 0, 0, 255);
	end;
	
	panel:SetFGColor(textColor);
end;

-- Called when a menu option is layed out.
function THEME.skin:LayoutMenuOption(panel)
	panel:SetFont(self.fontMenuOption);
	panel:SizeToContents();
	panel:SetWide(panel:GetWide() + 30);
	panel:SetSize(math.max( panel:GetParent():GetWide(), panel:GetWide() ), 18);
	
	if (panel.SubMenuArrow) then
		panel.SubMenuArrow:SetSize( panel:GetTall(), panel:GetTall() );
		panel.SubMenuArrow:CenterVertical();
		panel.SubMenuArrow:AlignRight();
	end;
end;

-- Called when a button is painted.
function THEME.skin:PaintButton(panel)
	local w, h = panel:GetSize();
	local textColor = Color(255, 255, 255, 255);
	
	if (panel.m_bBackground) then
		local color = Color(0, 0, 0, 255);
		local borderColor = Color(255, 255, 255, 255);
		
		if ( panel:GetDisabled() ) then
			color = self.controlColorDark;
		elseif ( panel.Depressed or panel:GetSelected() ) then
			color = Color(255, 255, 255, 255);
			textColor = Color(0, 0, 0, 255);
		elseif (panel.Hovered) then
			color = self.controlColorHighlight;
		end;

		self:DrawGenericBackground(0, 0, w, h, borderColor);
		self:DrawGenericBackground(1, 1, w - 2, h - 2, color);
	end;
	
	panel:SetFGColor(textColor);
end;

-- Called when a scroll bar grip is painted.
function THEME.skin:PaintScrollBarGrip(panel)
	local w, h = panel:GetSize();
	local color = Color(255, 255, 255, 255);

	self:DrawGenericBackground(0, 0, w, h, color);
	self:DrawGenericBackground( 2, 2, w - 4, h - 4, Color(0, 0, 0, 255) );
end;

openAura.theme:Finish(THEME);