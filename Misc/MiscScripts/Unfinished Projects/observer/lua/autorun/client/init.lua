// Include files
include( "vgui/playerentry.lua" )

// Menu code
local menu, selectedPlayer
local qualityPresets = { Draft = 30, Poor = 20, Medium = 15, Good = 10, Better = 5, Best = 3 }
local umsgsPerTick = 4

local dirty, data, quality, expectedData, captureWidth, captureHeight, captureEnt, captureDensity
local rt = GetRenderTarget( "observer_rt", 512, 512 )
local mat = CreateMaterial( "observer_mat", "UnlitGeneric", { } )

// (Re)paint the current screenshot
local function paintScreenshot()
	mat:SetMaterialTexture( "$basetexture", rt )
	
	local sx, sy = 512 / captureWidth, 512 / captureHeight
	
	local w, h = ScrW(), ScrH()
	local oldRT = render.GetRenderTarget()
	render.SetRenderTarget( rt )
		render.SetViewPort( 0, 0, 512, 512 )
			render.Clear( 53, 54, 59, 255, true )
			
			cam.Start2D()
				for x = 1, #data do
					for y = 1, #data[1] do
						surface.SetDrawColor( data[x][y].r, data[x][y].g, data[x][y].b, 255 )
						surface.DrawRect( x*sx, y*sy, math.ceil( sx ), math.ceil( sy ) )
					end
				end
			cam.End2D()
		render.SetViewPort( 0, 0, w, h )
	render.SetRenderTarget( oldRT )
	
	menu.view.view:SetMaterial( mat )
	menu.view.view:SetSize( menu.view:GetWide(), menu.view:GetWide() * captureHeight/captureWidth )
	menu.view.view:SetPos( 0, menu.view:GetTall() / 2 - menu.view.view:GetTall() / 2 )
end

// Create the menu and initialise data
local function createMenu()
	menu = vgui.Create( "DFrame" )
	menu:SetSize( 700, 450 )
	menu:Center()
	menu:SetTitle( "Observer" )
	menu:SetVisible( true )
	menu:MakePopup()
	local icon = vgui.Create( "DImage", menu )
	icon:SetPos( 5, 4 )
	icon:SetSize( 16, 16 )
	icon:SetImage( "gui/silkicons/application_view_tile" )
	menu.lblTitle:SetPos( 23, 2 )
	
	// Player selection
	menu.playerList = vgui.Create( "DPanelList", menu )
	menu.playerList:SetPos( 5, 27 )
	menu.playerList:SetSize( 250, menu:GetTall() - 32 )
	menu.playerList:SetSpacing( 5 )
	menu.playerList:SetPadding( 5 )
	menu.playerList:EnableVerticalScrollbar( true )
	
	// Add view
	menu.view = vgui.Create( "DPanelList", menu )
	menu.view:SetPos( 10 + menu.playerList:GetWide(), 27 )
	menu.view:SetSize( menu:GetWide() - menu.playerList:GetWide() - 15, menu:GetTall() - 72 )
	menu.view.view = vgui.Create( "DImage", menu.view )
	menu.view.view.PaintOver = function()
		if ( dirty and data and type( data ) == "table" ) then
			paintScreenshot()
			dirty = false
		end
	end
	dirty = true
	
	// Add quality presets and capture button
	menu.controls = vgui.Create( "DPanelList", menu )
	menu.controls:SetSize( menu:GetWide() - menu.playerList:GetWide() - 15, 35 )
	menu.controls:SetPos( 10 + menu.playerList:GetWide(), menu:GetTall() - menu.controls:GetTall() - 5 )
	
	menu.quality = vgui.Create( "DMultiChoice", menu.controls )
	menu.quality:SetPos( 8, 8 )
	menu.quality:SetSize( menu.controls:GetWide() - 104, 20 )
	menu.quality:AddChoice( "Draft" )
	menu.quality:AddChoice( "Medium" )
	menu.quality:AddChoice( "Good" )
	menu.quality:AddChoice( "Better" )
	menu.quality:AddChoice( "Best" )
	menu.quality:SetEditable( false )
	menu.quality.OnSelect = function( self, index, value )
		quality = value
	end
	quality = quality or "Draft"
	menu.quality:SetText( quality )
	
	menu.progress = vgui.Create( "ProgressBar", menu.controls )
	menu.progress:SetPos( 8, 8 )
	menu.progress:SetSize( menu.controls:GetWide() - 104, 20 )
	menu.progress:SetVisible( type( data ) == "string" )
	if ( menu.progress:IsVisible() ) then
		menu.progress:SetProgress( #data / expectedData * 100 ) 
	end
	
	menu.capture = vgui.Create( "DButton", menu.controls )
	menu.capture:SetSize( 80, 20 )
	menu.capture:SetPos( menu.controls:GetWide() - 8 - menu.capture:GetWide(), 8 )
	menu.capture:SetText( "Capture" )
	menu.capture.DoClick = function()
		menu.capture:SetDisabled( true )
		RunConsoleCommand( "observer_capture", selectedPlayer:EntIndex(), qualityPresets[quality] )
	end
	menu.capture:SetDisabled( expectedData )
	
	// Fill player list
	for _, ply in ipairs( player.GetAll() ) do
		local entry = vgui.Create( "PlayerEntry" )
		
		entry:SetPlayer( ply )
		ply.observerListItem = entry
		
		entry.OnMouseReleased = function()
			selectedPlayer.observerListItem:SetHighlight( false )
			ply.observerListItem:SetHighlight( true )
			
			selectedPlayer = ply
		end
		
		menu.playerList:AddItem( entry )
	end
	
	if ( !selectedPlayer or !IsValid( selectedPlayer ) ) then
		selectedPlayer = LocalPlayer()
	end
	selectedPlayer.observerListItem:SetHighlight( true )
end

concommand.Add( "observer_menu", function()
	if ( LocalPlayer():IsAdmin() and ( !menu or !IsValid( menu ) ) ) then
		createMenu()
	end
end )

// Server feedback
usermessage.Hook( "OB_Error", function( um )
	Derma_Message( um:ReadString(), "Error", "Ok" )
end )

// Capture receive code
usermessage.Hook( "OB_Info", function( um )
	captureEnt = um:ReadEntity()
	captureWidth = um:ReadShort()
	captureHeight = um:ReadShort()
	expectedData = um:ReadLong()
	captureDensity = um:ReadShort()
	
	data = ""
	
	menu.progress:SetProgress( 0 )
	menu.progress:SetVisible( true )
end )

local function encodeByte( p )
	if ( p < 6 ) then p = 6 elseif ( p == 34 ) then p = 35 end
	return string.char( p )
end

local function decodeByte( p )
	return string.byte( p )
end

usermessage.Hook( "OB_Data", function( um )
	data = data .. um:ReadString()
	
	if ( #data == expectedData ) then
		local i, newData = 1, {}
		
		for x = 1, captureWidth do
			newData[x] = {}
			for y = 1, captureHeight do
				newData[x][y] = { r = decodeByte( data:sub( i, i ) ), g = decodeByte( data:sub( i+1, i+1 ) ), b = decodeByte( data:sub( i+2, i+2 ) ) }
				i = i + 3
			end
		end
		
		data = newData
		dirty = true
		
		expectedData = false
		if ( menu.progress ) then menu.progress:SetVisible( false ) menu.capture:SetDisabled( false ) end
	else
		if ( menu.progress ) then menu.progress:SetProgress( #data / expectedData * 100 ) end
	end
end )

usermessage.Hook( "OB_CaptureCancelled", function( um )
	expectedData = false
	if ( menu.progress ) then menu.progress:SetVisible( false ) menu.capture:SetDisabled( false ) end
	
	print( "Server said capture was cancelled!" )
end )

// Capture code
local capture, density, data, index, receivingPlayer

hook.Add( "Tick", "OBSendHook", function()
	if ( data ) then
		if ( !IsValid( receivingPlayer ) ) then
			print( "Player receiving from me left, stopping transmission!" )
			data = nil
			return
		end
		
		for i = 1, umsgsPerTick do
			local raw, b1, b2 = ""
			for i = index, math.min( index + 199, #data ) do
				raw = raw .. encodeByte( data[i] )
				index = index + 1
			end
			RunConsoleCommand( "observer_capturedata", raw )
			
			if ( index > #data ) then
				data = nil
				return
			end
		end
	end
end )


// HUDDrawScoreboard is called after every HUD element is drawn, so that's what we want
hook.Add( "HUDDrawScoreBoard", "OBCaptureHook", function()
	if ( capture ) then
		capture = false
		render.CapturePixels()
		
		local i = 1
		for x = 0, ScrW()-1, density do
			for y = 0, ScrH()-1, density do
				data[i], data[i+1], data[i+2] = render.ReadPixel( x, y )
				i = i + 3
			end
		end
	end
end )

usermessage.Hook( "OB_Capture", function( um )
	density = um:ReadShort()
	receivingPlayer = um:ReadEntity()
	capture = true
	data = {}
	index = 1
	
	RunConsoleCommand( "observer_captureinfo", ScrW(), ScrH() )
end )